//
//  IdentityDocumentsViewModel.swift
//  ADAXIntegra
//
//  Created by Eduardo Hernández Alonso on 17/10/26.
//

import Combine
import Foundation

// R-06: shows, uploads and downloads the identity documents of the external user
@MainActor
final class IdentityDocumentsViewModel: ObservableObject {
  @Published private(set) var isLoading = false
  // Documents already saved in the backend
  @Published private(set) var uploaded: Set<DocumentKind> = []
  // Documents being sent, so their picker shows a spinner
  @Published private(set) var uploading: Set<DocumentKind> = []
  @Published var errorMessage: String?
  // Confirms an upload with the "SuccessPage"
  @Published var successMessage = ""
  @Published var isShowingSuccess = false
  // File written to disk so the share sheet can save it
  @Published var downloadedFileURL: URL?
  @Published var isShowingShareSheet = false

  private let userId: String?
  private let uploadDocumentUseCase: UploadDocumentUseCaseProtocol
  private let getDocumentsUseCase: GetDocumentsUseCaseProtocol
  // Signed URLs of the saved documents, they expire after 15 minutes
  private var signedUrls: [DocumentKind: String] = [:]

  init(
    userId: String?,
    uploadDocumentUseCase: UploadDocumentUseCaseProtocol? = nil,
    getDocumentsUseCase: GetDocumentsUseCaseProtocol? = nil
  ) {
    self.userId = userId
    self.uploadDocumentUseCase =
      uploadDocumentUseCase ?? UploadDocumentUseCase(dataRepository: RemoteDocumentsRepository())
    self.getDocumentsUseCase =
      getDocumentsUseCase ?? GetDocumentsUseCase(dataRepository: RemoteDocumentsRepository())
  }

  // The backend does not keep the original name, and every picture is sent as JPEG
  static func fileName(for kind: DocumentKind) -> String {
    switch kind {
    case .identity: "comprobante-identidad.jpg"
    case .proofOfAddress: "comprobante-domicilio.jpg"
    }
  }

  // Name used in the toast, the same as the title of its section
  private static func title(for kind: DocumentKind) -> String {
    switch kind {
    case .identity: "Comprobante de identidad"
    case .proofOfAddress: "Comprobante de domicilio"
    }
  }

  func isUploaded(_ kind: DocumentKind) -> Bool {
    uploaded.contains(kind)
  }

  func isUploading(_ kind: DocumentKind) -> Bool {
    uploading.contains(kind)
  }

  func load() async {
    guard let userId else { return }
    isLoading = true
    defer { isLoading = false }

    do {
      apply(try await getDocumentsUseCase.getDocuments(for: userId))
    } catch {
      handle(error, fallback: "No se pudieron cargar tus documentos. Intenta de nuevo.")
    }
  }

  // Called by the view when the user picks a picture, it is uploaded right away.
  // Uploading again replaces the saved document, the backend never deletes it
  func select(_ file: DocumentFile, for kind: DocumentKind) async {
    if file.isTooLarge {
      errorMessage = "El documento no debe pesar más de 5 MB."
      return
    }
    guard let userId else {
      errorMessage = "Tu sesión expiró. Vuelve a iniciar sesión."
      return
    }

    uploading.insert(kind)
    defer { uploading.remove(kind) }
    let isReplacing = uploaded.contains(kind)

    do {
      let saved = try await uploadDocumentUseCase.uploadDocument(file, kind: kind, for: userId)
      uploaded.insert(kind)
      signedUrls[kind] =
        kind == .identity ? saved.identityDocumentUrl : saved.proofOfAddressUrl
      successMessage =
        "\(Self.title(for: kind)) se \(isReplacing ? "actualizó" : "subió") correctamente."
      isShowingSuccess = true
    } catch {
      handle(error, fallback: "No se pudo subir el documento. Intenta de nuevo.")
    }
  }

  func download(_ kind: DocumentKind) async {
    do {
      downloadedFileURL = try await downloadFile(kind)
      isShowingShareSheet = true
    } catch {
      errorMessage = "No se pudo descargar el documento. Intenta de nuevo."
    }
  }

  // A signed URL lasts 15 minutes, so when it fails a fresh one is asked one time
  private func downloadFile(_ kind: DocumentKind) async throws -> URL {
    let fileName = Self.fileName(for: kind)
    if let url = signedUrls[kind],
      let file = try? await getDocumentsUseCase.downloadDocument(from: url, fileName: fileName)
    {
      return file
    }

    guard let userId else { throw URLError(.userAuthenticationRequired) }
    apply(try await getDocumentsUseCase.getDocuments(for: userId))
    guard let url = signedUrls[kind] else { throw URLError(.fileDoesNotExist) }
    return try await getDocumentsUseCase.downloadDocument(from: url, fileName: fileName)
  }

  private func apply(_ documents: SavedDocuments) {
    apply(documents.identityDocument, for: .identity)
    apply(documents.proofOfAddress, for: .proofOfAddress)
  }

  private func apply(_ document: SavedDocument?, for kind: DocumentKind) {
    if let document {
      uploaded.insert(kind)
      signedUrls[kind] = document.url
    } else {
      uploaded.remove(kind)
      signedUrls[kind] = nil
    }
  }

  private func handle(_ error: Error, fallback: String) {
    guard case let APIError.server(statusCode, _) = error else {
      errorMessage = "No se pudo conectar con el servidor. Intenta de nuevo."
      return
    }

    switch statusCode {
    case 400:
      errorMessage = "El documento debe ser PNG o JPG de máximo 5 MB."
    case 401:
      errorMessage = "Tu sesión expiró. Vuelve a iniciar sesión."
    case 429:
      errorMessage = "Hiciste demasiados intentos. Intenta más tarde."
    default:
      errorMessage = fallback
    }
  }
}
