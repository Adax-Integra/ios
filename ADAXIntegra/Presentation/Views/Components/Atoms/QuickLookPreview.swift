//
//  QuickLookPreview.swift
//  ADAXIntegra
//
//  Created by Cristhian Viery Maida Suarez on 19/10/26.
//

import QuickLook
import SwiftUI

// Previews a local file (image or PDF) inside the app with QuickLook.
// QuickLook also has a built-in share button, so the file can still be saved.
struct QuickLookPreview: UIViewControllerRepresentable {
  let url: URL

  func makeUIViewController(context: Context) -> UINavigationController {
    let controller = QLPreviewController()
    controller.dataSource = context.coordinator
    return UINavigationController(rootViewController: controller)
  }

  func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {}

  func makeCoordinator() -> Coordinator { Coordinator(url: url) }

  final class Coordinator: NSObject, QLPreviewControllerDataSource {
    let url: URL
    init(url: URL) { self.url = url }

    func numberOfPreviewItems(in controller: QLPreviewController) -> Int { 1 }

    func previewController(
      _ controller: QLPreviewController, previewItemAt index: Int
    ) -> QLPreviewItem {
      url as QLPreviewItem
    }
  }
}
