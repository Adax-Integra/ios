//
//  CaseCommentsSection.swift
//  ADAXIntegra
//
//  Created by Oscar Alexander Vilchis Soto on 07/10/26.
//
//  Organism  containing comment list and input creation bar for US B-02.
//
//
//  CaseCommentsSection.swift
//  ADAXIntegra
//

import SwiftUI

struct CaseCommentsSection: View {
    @ObservedObject var viewModel: CaseDetailViewModel
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 12) {
                // Header: Title + Badge + Chevron Icon
                HStack {
                    Text("Comentarios del caso")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.primary)

                    Spacer()

                    if viewModel.isLoadingComments {
                        ProgressView()
                            .scaleEffect(0.8)
                    } else {
                        Text("\(viewModel.comments.count)")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(Color("PrimaryAdax"))
                            .padding(.horizontal, 8)
                            .padding(.vertical, 2)
                            .background(Color("PrimaryAdax").opacity(0.1))
                            .clipShape(Capsule())
                    }

                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.gray)
                }

                // Show only the LAST/LATEST comment as preview
                if let lastComment = viewModel.comments.first {
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text(lastComment.author?.fullName ?? "Usuario")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(.primary)

                            Spacer()

                            if let time = lastComment.timeSent {
                                Text(lastComment.formattedTime)
                                    .font(.system(size: 10))
                                    .foregroundColor(.gray)
                            }
                        }

                        Text(lastComment.content ?? "")
                            .font(.system(size: 13))
                            .foregroundColor(Color.primary.opacity(0.75))
                            .lineLimit(2)
                    }
                    .padding(10)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(UIColor.systemGray6).opacity(0.6))
                    .cornerRadius(8)
                } else if !viewModel.isLoadingComments {
                    Text("No hay comentarios registrados. Toca para agregar uno.")
                        .font(.system(size: 13))
                        .foregroundColor(.gray)
                        .italic()
                }
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
