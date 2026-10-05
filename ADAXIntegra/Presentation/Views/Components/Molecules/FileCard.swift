//
//  FileCard.swift
//  ADAXIntegra
//
//  Created by Eduardo Hernández Alonso on 22/09/26.
//

import SwiftUI

/*
 Molecule that composes a "FieldLabel" + optional
 "InfoButton" with a "DocumentImageCard".
*/
struct FileCard: View {
  let title: String
  // Signed URL of the saved document
  let url: String?
  // File the user just picked, it is shown instead of the saved document
  var pickedFile: DocumentFile? = nil

  var height: CGFloat = 280
  var cornerRadius: CGFloat = 28
  var infoAction: (() -> Void)? = nil
  // When it is set, tapping the card opens the file picker
  var onPick: ((DocumentFile) -> Void)? = nil
  // Called with a message when the picked file cannot be read
  var onPickError: ((String) -> Void)? = nil
  // Called when the saved document fails to load, to refresh its signed URL
  var onLoadFailure: (() async -> Void)? = nil

  var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      HStack(spacing: 6) {
        FieldLabel(title)

        if let infoAction {
          InfoButton(size: 16, action: infoAction)
            /*
             Collapse the InfoButton's 44pt target down to the
             label's height so this row is the same size with or without
             an info button.
            */
          .padding(.vertical, -12)
            .padding(.horizontal, -12)
        }

        Spacer()
      }

      DocumentImageCard(
        url: url,
        pickedFile: pickedFile,
        height: height,
        cornerRadius: cornerRadius,
        onLoadFailure: onLoadFailure
      )
      .modifier(DocumentFilePicker(onPick: onPick, onError: onPickError))
    }
    .frame(maxWidth: .infinity, alignment: .leading)
  }
}

#Preview {
  ZStack {
    Color("Background").ignoresSafeArea()

    VStack(spacing: 20) {
      FileCard(
        title: "Comprobante de domicilio",
        url: nil
      )

      FileCard(
        title: "Identificación oficial",
        url: nil,
        infoAction: { print("Info tapped") }
      )
    }
    .padding()
  }
}
