//
//  DocumentFilePicker.swift
//  ADAXIntegra
//
//  Created by Eduardo Hernández Alonso on 02/10/26.
//

import SwiftUI
// Use to add allowed file types in the func body
import UniformTypeIdentifiers

/*
 Tapping the view opens the native iOS file picker so the user can choose
 a file stored on the iPhone. The backend accepts PDF, JPEG or PNG.
 It returns the file as a DocumentFile.
*/
struct DocumentFilePicker: ViewModifier {
  // When it returns null the view stays read-only.
  var onPick: ((DocumentFile) -> Void)?
  // Called with a message when the file cannot be opened or read
  var onError: ((String) -> Void)? = nil

  @State private var showFiles = false

  func body(content: Content) -> some View {
    content
      .contentShape(Rectangle())
      .onTapGesture {
        if onPick != nil { showFiles = true }
      }
      .accessibilityAddTraits(onPick != nil ? .isButton : [])
      .fileImporter(
        isPresented: $showFiles,
        allowedContentTypes: [.pdf, .jpeg, .png]
      ) { result in
        switch result {
        case .success(let url):
          deliver(fileAt: url)
        case .failure(let error):
          // Closing the picker is not an error
          if (error as? CocoaError)?.code != .userCancelled {
            onError?(Self.readErrorMessage)
          }
        }
      }
  }

  private static let readErrorMessage = "No se pudo abrir el archivo seleccionado."

  private func deliver(fileAt url: URL) {
    // Files outside the app need security-scoped access to be read
    let accessing = url.startAccessingSecurityScopedResource()
    let data = try? Data(contentsOf: url)
    if accessing { url.stopAccessingSecurityScopedResource() }
    guard let data else {
      onError?(Self.readErrorMessage)
      return
    }

    // The backend needs to know the type of file it receives
    let mimeType: String
    switch url.pathExtension.lowercased() {
    case "pdf": mimeType = "application/pdf"
    case "png": mimeType = "image/png"
    default: mimeType = "image/jpeg"
    }
    onPick?(DocumentFile(data: data, fileName: url.lastPathComponent, mimeType: mimeType))
  }
}
