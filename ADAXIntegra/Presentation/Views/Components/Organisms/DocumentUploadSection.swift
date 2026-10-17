//
//  DocumentUploadSection.swift
//  ADAXIntegra
//
//  Created by Eduardo Hernández Alonso on 17/10/26.
//

import SwiftUI

// Once a document is uploaded the picker is replaced by an "UploadedFileRow".
struct DocumentUploadSection: View {
  let title: String
  let note: String
  // Name given to the picture sent to the backend, it is also the name the user sees
  let fileName: String
  let isUploaded: Bool
  // While the document is being sent the picker is locked and shows a spinner
  var isUploading: Bool = false
  let onPick: (DocumentFile) -> Void
  var onPickError: ((String) -> Void)? = nil
  let onDownload: () -> Void

  @State private var isShowingNote = false
  // The saved document stays until the new one is uploaded
  @State private var isReplacing = false

  var body: some View {
    VStack(alignment: .leading, spacing: 6) {
      HStack(spacing: 6) {
        FieldLabel(title)

        InfoButton(size: 16) { isShowingNote = true }
          // Same as FileCard: keeps the row at the label's height
          .padding(.vertical, -12)
          .padding(.horizontal, -12)
      }

      if isUploaded && !isReplacing {
        UploadedFileRow(
          fileName: fileName,
          onDownload: onDownload,
          onReplace: { isReplacing = true }
        )
      } else {
        ImagePickerField(
          title: "",
          image: nil,
          onPick: onPick,
          onError: onPickError,
          placeholder: "Agregar documento",
          hint: "PNG o JPG (máx. 5 MB)",
          fileName: fileName
        )
        .disabled(isUploading)
        .overlay {
          if isUploading { ProgressView() }
        }

        if isReplacing && !isUploading {
          Button("Cancelar") { isReplacing = false }
            .font(.system(size: 15, weight: .semibold))
            .foregroundColor(Color("PrimaryAdax"))
            .frame(maxWidth: .infinity)
            .padding(.top, 4)
        }
      }
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    // When the upload ends, success or not, the saved document is shown again
    .onChange(of: isUploading) { _, uploading in
      if !uploading { isReplacing = false }
    }
    .alert(title, isPresented: $isShowingNote) {
      Button("Entendido", role: .cancel) {}
    } message: {
      Text(note)
    }
  }
}

#Preview {
  ZStack {
    Color("Background").ignoresSafeArea()

    VStack(spacing: 32) {
      DocumentUploadSection(
        title: "Comprobante de identidad",
        note: "Puedes usar tu INE, pasaporte o cualquier documento que compruebe tu identidad",
        fileName: "comprobante-identidad.jpg",
        isUploaded: false,
        onPick: { _ in },
        onDownload: {}
      )

      DocumentUploadSection(
        title: "Comprobante de domicilio",
        note: "Usa un comprobante de domicilio que contenga tu dirección de vivienda",
        fileName: "comprobante-domicilio.jpg",
        isUploaded: true,
        onPick: { _ in },
        onDownload: {}
      )
    }
    .padding()
  }
}
