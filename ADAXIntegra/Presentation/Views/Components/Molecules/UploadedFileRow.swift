//
//  UploadedFileRow.swift
//  ADAXIntegra
//
//  Created by Eduardo Hernández Alonso on 17/10/26.
//

import SwiftUI

// Molecule that shows the name of an uploaded file with buttons to download or replace it
struct UploadedFileRow: View {
  let fileName: String
  let onDownload: () -> Void
  let onReplace: () -> Void

  var body: some View {
    SurfaceCard {
      HStack(spacing: 12) {
        Icon(size: 22, color: Color("PrimaryAdax"), systemName: "doc.text")

        Text(fileName)
          .font(.system(size: 15, weight: .medium))
          .foregroundColor(Color("OnBackground"))
          .lineLimit(1)
          .truncationMode(.middle)

        Spacer(minLength: 0)

        Button(action: onDownload) {
          Icon(size: 20, color: Color("PrimaryAdax"), systemName: "arrow.down.circle")
            .frame(width: 44, height: 44)
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Descargar \(fileName)")

        Button(action: onReplace) {
          Icon(size: 20, color: Color("PrimaryAdax"), systemName: "arrow.triangle.2.circlepath")
            .frame(width: 44, height: 44)
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Reemplazar \(fileName)")
      }
      .padding(.leading, 16)
      .padding(.trailing, 4)
      .padding(.vertical, 4)
    }
  }
}

#Preview {
  ZStack {
    Color("Background").ignoresSafeArea()

    UploadedFileRow(
      fileName: "comprobante-identidad.jpg",
      onDownload: {},
      onReplace: {}
    )
    .padding()
  }
}
