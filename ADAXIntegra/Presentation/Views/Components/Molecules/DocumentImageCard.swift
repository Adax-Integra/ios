//
//  DocumentImageCard.swift
//  ADAXIntegra
//
//  Created by Eduardo Hernández Alonso on 16/09/26.
//

// Use PDFKit to preview when the user uploads a .pdf
import PDFKit
import SwiftUI

struct DocumentImageCard: View {
  // Signed URL of the saved document
  let url: String?
  // File the user just picked, it is shown instead of the saved document
  var pickedFile: DocumentFile? = nil
  var height: CGFloat = 280
  var cornerRadius: CGFloat = 28
  // Called when the saved document fails to load, so the caller can fetch a new signed URL
  var onLoadFailure: (() async -> Void)? = nil

  // Last URL already retried, so a broken URL does not retry forever
  @State private var retriedUrl: String?

  // Image of the picked file, or the first page when it is a PDF
  @State private var pickedPreview: UIImage?

  // Changes when the user picks another file, to build its preview again
  private var pickedID: String {
    "\(pickedFile?.fileName ?? "")|\(pickedFile?.data.count ?? 0)"
  }

  var body: some View {
    SurfaceCard(
      cornerRadius: cornerRadius,
      borderColor: Color("PrimaryAdax"),
      borderWidth: 3,
      showsShadow: false
    ) {
      content
        .padding(.horizontal, 24)
        .padding(.vertical, 16)
        .frame(maxWidth: .infinity)
        .frame(height: height)
    }
    .task(id: pickedID) {
      pickedPreview = pickedFile.flatMap { Self.makePreview(from: $0.data) }
    }
  }

  /*
   ViewBuilder lets you return a different view when a if/else
   happens. Without it the we would need to return a single view
   every time.
  */
  @ViewBuilder
  private var content: some View {
    if pickedFile != nil {
      if let pickedPreview {
        Image(uiImage: pickedPreview)
          .resizable()
          .scaledToFit()
      } else {
        documentIcon
      }
    } else if let url = url.flatMap(URL.init(string:)) {
      // The signed URL is loaded directly, a PDF cannot be drawn so it falls to the icon
      // TODO: Incorporate PDF download when getting the signed url.
      AsyncImage(url: url) { phase in
        switch phase {
        case .success(let image):
          image
            .resizable()
            .scaledToFit()
        case .failure:
          documentIcon
            .task { await retryOnce(failedUrl: url.absoluteString) }
        default:
          ProgressView()
        }
      }
    } else {
      documentIcon
    }
  }

  // Asks for a fresh URL one time per failed URL
  private func retryOnce(failedUrl: String) async {
    guard retriedUrl != failedUrl else { return }
    retriedUrl = failedUrl
    await onLoadFailure?()
  }

  private var documentIcon: some View {
    Image(systemName: "doc.text")
      .resizable()
      .scaledToFit()
      .frame(width: 80, height: 80)
      .foregroundColor(Color("InsideTextAndIcons").opacity(0.6))
  }

  // An image is shown as it is and a PDF shows its first page
  private static func makePreview(from data: Data) -> UIImage? {
    if let image = UIImage(data: data) {
      return image
    }
    if let page = PDFDocument(data: data)?.page(at: 0) {
      return page.thumbnail(of: CGSize(width: 600, height: 840), for: .mediaBox)
    }
    return nil
  }
}

#Preview {
  ZStack {
    Color("Background").ignoresSafeArea()

    DocumentImageCard(url: nil)
      .padding()
  }
}
