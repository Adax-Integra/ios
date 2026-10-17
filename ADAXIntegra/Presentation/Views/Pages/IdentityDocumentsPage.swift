//
//  IdentityDocumentsPage.swift
//  ADAXIntegra
//
//  Created by Eduardo Hernández Alonso on 17/10/26.
//

import SwiftUI

// R-06: the external user uploads, downloads or replaces their proof of identity and proof of address
struct IdentityDocumentsPage: View {
  @StateObject private var viewModel: IdentityDocumentsViewModel

  init(userId: String?) {
    _viewModel = StateObject(wrappedValue: IdentityDocumentsViewModel(userId: userId))
  }

  var body: some View {
    ZStack {
      Color("Background").ignoresSafeArea()

      // The boxes wait for the saved documents, so an uploaded one never shows as empty
      if viewModel.isLoading {
        ProgressView()
      } else {
        ScrollView(showsIndicators: false) {
          VStack(alignment: .leading, spacing: 32) {
            DocumentUploadSection(
              title: "Comprobante de identidad",
              note:
                "Puedes usar tu INE, pasaporte o cualquier documento que compruebe tu identidad",
              fileName: IdentityDocumentsViewModel.fileName(for: .identity),
              isUploaded: viewModel.isUploaded(.identity),
              isUploading: viewModel.isUploading(.identity),
              onPick: { file in Task { await viewModel.select(file, for: .identity) } },
              onPickError: { viewModel.errorMessage = $0 },
              onDownload: { Task { await viewModel.download(.identity) } }
            )

            DocumentUploadSection(
              title: "Comprobante de domicilio",
              note: "Usa un comprobante de domicilio que contenga tu dirección de vivienda",
              fileName: IdentityDocumentsViewModel.fileName(for: .proofOfAddress),
              isUploaded: viewModel.isUploaded(.proofOfAddress),
              isUploading: viewModel.isUploading(.proofOfAddress),
              onPick: { file in Task { await viewModel.select(file, for: .proofOfAddress) } },
              onPickError: { viewModel.errorMessage = $0 },
              onDownload: { Task { await viewModel.download(.proofOfAddress) } }
            )
          }
          .padding(20)
        }
      }
    }
    .navigationTitle("Documentos de Identidad")
    .task { await viewModel.load() }
    .alert(
      "Aviso",
      isPresented: Binding(
        get: { viewModel.errorMessage != nil },
        set: { if !$0 { viewModel.errorMessage = nil } }
      )
    ) {
      Button("Aceptar", role: .cancel) {}
    } message: {
      Text(viewModel.errorMessage ?? "")
    }
    .sheet(isPresented: $viewModel.isShowingShareSheet) {
      if let url = viewModel.downloadedFileURL {
        ShareSheet(url: url)
      }
    }
  }
}

#Preview {
  NavigationStack {
    IdentityDocumentsPage(userId: nil)
  }
}
