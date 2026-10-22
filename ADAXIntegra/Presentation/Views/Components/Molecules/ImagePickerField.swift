//
//  ImagePickerField.swift
//  ADAXIntegra
//
//  Created by Paco Arreola on 15/10/26.
//

import PhotosUI
import SwiftUI
import UniformTypeIdentifiers

// Molecule to pick a picture from the photo library or the Files app.
// It is always delivered as JPEG because the backend only accepts JPEG or PNG
struct ImagePickerField: View {
  var title: String = "Imagen"
  let image: DocumentFile?
  var errorMessage: String? = nil
  let onPick: (DocumentFile) -> Void
  var onError: ((String) -> Void)? = nil
  var placeholder: String = "Agregar imagen"
  var hint: String = "PNG o JPG · máx. 5 MB"
  // Name given to the JPEG sent to the backend
  var fileName: String = "event-image.jpg"

  @State private var selectedItem: PhotosPickerItem? = nil
  @State private var showPhotos = false
  @State private var showFiles = false

  private static let readErrorMessage = "No se pudo abrir la imagen seleccionada."

  var body: some View {
    VStack(alignment: .leading, spacing: 6) {
      if !title.isEmpty {
        FieldLabel(title)
      }

      Menu {
        Button("Fototeca", systemImage: "photo.on.rectangle") { showPhotos = true }
        Button("Archivos", systemImage: "folder") { showFiles = true }
      } label: {
        content
          .frame(maxWidth: .infinity, minHeight: 150)
          .background(Color("PrimaryAdax").opacity(0.08))
          .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
          .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
              .strokeBorder(
                errorMessage != nil ? Color("Error") : Color("PrimaryAdax"),
                style: StrokeStyle(lineWidth: 1.5, dash: [6])
              )
          )
      }

      if let errorMessage {
        FieldErrorLabel(errorMessage)
      }
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .photosPicker(isPresented: $showPhotos, selection: $selectedItem, matching: .images)
    .fileImporter(isPresented: $showFiles, allowedContentTypes: [.jpeg, .png]) { result in
      switch result {
      case .success(let url):
        loadFile(at: url)
      case .failure(let error):
        // Closing the picker is not an error
        if (error as? CocoaError)?.code != .userCancelled {
          onError?(Self.readErrorMessage)
        }
      }
    }
    .onChange(of: selectedItem) { _, newItem in
      guard let newItem else { return }
      Task { await loadPhoto(newItem) }
    }
  }

  @ViewBuilder
  private var content: some View {
    if let image, let uiImage = UIImage(data: image.data) {
      Image(uiImage: uiImage)
        .resizable()
        .scaledToFill()
        .frame(minWidth: 0, maxWidth: .infinity)
        .frame(height: 180)
        .clipped()
    } else {
      VStack(spacing: 6) {
        Icon(size: 28, color: Color("PrimaryAdax"), systemName: "arrow.up.square")

        Text(placeholder)
          .font(.system(size: 16, weight: .semibold))
          .foregroundColor(Color("PrimaryAdax"))

        Text(hint)
          .font(.system(size: 13))
          .foregroundColor(Color("InsideTextAndIcons"))
          .multilineTextAlignment(.center)
      }
      .padding(.vertical, 24)
      .padding(.horizontal, 16)
    }
  }

  private func loadPhoto(_ item: PhotosPickerItem) async {
    guard let data = try? await item.loadTransferable(type: Data.self) else {
      onError?(Self.readErrorMessage)
      return
    }
    deliver(data)
  }

  private func loadFile(at url: URL) {
    // Files outside the app need security-scoped access to be read
    let accessing = url.startAccessingSecurityScopedResource()
    let data = try? Data(contentsOf: url)
    if accessing { url.stopAccessingSecurityScopedResource() }
    guard let data else {
      onError?(Self.readErrorMessage)
      return
    }
    deliver(data)
  }

  // Gallery photos are usually HEIC, so every picture is converted to JPEG before sending it
  private func deliver(_ data: Data) {
    guard let jpeg = UIImage(data: data)?.jpegData(compressionQuality: 0.8) else {
      onError?(Self.readErrorMessage)
      return
    }
    onPick(DocumentFile(data: jpeg, fileName: fileName, mimeType: "image/jpeg"))
  }
}

#Preview {
  ZStack {
    Color("Background").ignoresSafeArea()

    VStack(spacing: 16) {
      ImagePickerField(title: "Imagen del evento", image: nil, onPick: { _ in })

      ImagePickerField(
        title: "Imagen del evento",
        image: nil,
        errorMessage: "La imagen supera los 5 MB.",
        onPick: { _ in }
      )
    }
    .padding()
  }
}
