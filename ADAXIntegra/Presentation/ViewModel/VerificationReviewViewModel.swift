//
//  VerificationReviewViewModel.swift
//  ADAXIntegra
//
//  Created by Cristhian Viery Maida Suarez on 17/10/26.
//

import Combine
import Foundation

// B-02: staff reviews the documents of an external user and approves or rejects
@MainActor
final class VerificationReviewViewModel: ObservableObject {
  @Published private(set) var isLoading = false
  @Published private(set) var isSubmitting = false
  @Published private(set) var hasIdentity = false
  @Published private(set) var hasProof = false
  @Published private(set) var didFinish = false
  @Published private(set) var decidedStatus: VerificationStatus?
  @Published var errorMessage: String?
  @Published var downloadedFileURL: URL?
  @Published var isShowingShareSheet = false
  @Published var isShowingPreview = false

  private var identityUrl: String?
  private var proofUrl: String?

  private let userId: String
  private let documentsRepository: DocumentsRepository
  private let reviewUseCase: ReviewVerificationUseCaseProtocol

  init(
    userId: String,
    documentsRepository: DocumentsRepository? = nil,
    reviewUseCase: ReviewVerificationUseCaseProtocol? = nil
  ) {
    self.userId = userId
    self.documentsRepository = documentsRepository ?? RemoteDocumentsRepository()
    self.reviewUseCase =
      reviewUseCase
      ?? ReviewVerificationUseCase(dataRepository: RemoteVerificationReviewRepository())
  }

  func load() async {
    isLoading = true
    errorMessage = nil
    do {
      let documents = try await documentsRepository.getStaffDocuments(for: userId)
      identityUrl = documents.identityDocument?.url
      proofUrl = documents.proofOfAddress?.url
      hasIdentity = identityUrl != nil
      hasProof = proofUrl != nil
    } catch {
      errorMessage = "No se pudieron cargar los documentos."
    }
    isLoading = false
  }

  func previewIdentity() async {
    await openFile(from: identityUrl, name: "comprobante_identidad", preview: true)
  }

  func previewProof() async {
    await openFile(from: proofUrl, name: "comprobante_domicilio", preview: true)
  }

  func downloadIdentity() async {
    await openFile(from: identityUrl, name: "comprobante_identidad", preview: false)
  }

  func downloadProof() async {
    await openFile(from: proofUrl, name: "comprobante_domicilio", preview: false)
  }

  private func openFile(from url: String?, name: String, preview: Bool) async {
    guard let url else { return }
    do {
      downloadedFileURL = try await documentsRepository.downloadDocument(
        from: url, fileName: name
      )
      if preview {
        isShowingPreview = true
      } else {
        isShowingShareSheet = true
      }
    } catch {
      errorMessage = "No se pudo abrir el documento."
    }
  }

  func approve() async {
    await submit(.verificado, reason: nil)
  }

  func reject(reason: String) async {
    let trimmed = reason.trimmingCharacters(in: .whitespacesAndNewlines)
    await submit(.noVerificado, reason: trimmed.isEmpty ? nil : trimmed)
  }

  private func submit(_ status: VerificationStatus, reason: String?) async {
    isSubmitting = true
    errorMessage = nil
    do {
      _ = try await reviewUseCase.review(userId: userId, status: status, reason: reason)
      decidedStatus = status
      didFinish = true
    } catch {
      handle(error)
    }
    isSubmitting = false
  }

  private func handle(_ error: Error) {
    guard case APIError.server(let statusCode, _) = error else {
      errorMessage = "No pudimos guardar la decisión. Revisa tu conexión e intenta de nuevo."
      return
    }

    switch statusCode {
    case 409: errorMessage = "Esta cuenta ya no está en revisión."
    case 403: errorMessage = "No tienes permiso para revisar esta cuenta."
    case 404: errorMessage = "La cuenta de la externa no está disponible."
    default: errorMessage = "No pudimos guardar la decisión. Intenta de nuevo más tarde."
    }
  }
}
