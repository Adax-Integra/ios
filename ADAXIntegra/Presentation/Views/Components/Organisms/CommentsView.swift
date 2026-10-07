//
//  CommentsView.swift
//  ADAXIntegra
//
//  Created by Oscar Alexander Vilchis Soto on 07/10/26.
//



import SwiftUI

struct CommentsView: View {
    @ObservedObject var viewModel: CaseDetailViewModel
    @Environment(\.dismiss) private var dismiss

    private let maxCharacterLimit = 250

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Comments List
                ScrollView {
                    LazyVStack(spacing: 12) {
                        if viewModel.comments.isEmpty && !viewModel.isLoadingComments {
                            Text("Aún no hay comentarios en este caso.")
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                                .italic()
                                .padding(.top, 40)
                        } else {
                            ForEach(viewModel.comments) { comment in
                                CommentRow(
                                    comment: comment,
                                    onDeleteTapped: {
                                        Task {
                                            await viewModel.deleteComment(comment)
                                        }
                                    }
                                )
                            }
                        }
                    }
                    .padding(16)
                }

                Divider()

                // Creation Form Box
                VStack(alignment: .trailing, spacing: 8) {
                    TextEditor(text: $viewModel.newCommentText)
                        .frame(height: 80)
                        .padding(8)
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                        )
                        .onChange(of: viewModel.newCommentText) { newValue in
                            if newValue.count > maxCharacterLimit {
                                viewModel.newCommentText = String(newValue.prefix(maxCharacterLimit))
                            }
                        }

                    // Character Counter
                    Text("\(viewModel.newCommentText.count)/\(maxCharacterLimit)")
                        .font(.system(size: 11))
                        .foregroundColor(viewModel.newCommentText.count >= maxCharacterLimit ? .red : .gray)

                    // Guardar Comentario Button
                    Button(action: {
                        Task {
                            await viewModel.sendComment()
                        }
                    }) {
                        HStack {
                            if viewModel.isSendingComment {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            } else {
                                Image(systemName: "checkmark.circle.fill")
                                Text("Guardar comentario")
                                    .font(.system(size: 14, weight: .bold))
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 44)
                        .background(
                            viewModel.newCommentText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                            ? Color.gray.opacity(0.4)
                            : Color("PrimaryAdax")
                        )
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    .disabled(viewModel.newCommentText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || viewModel.isSendingComment)
                }
                .padding(16)
                .background(Color.white)
            }
            .navigationTitle("Comentarios")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cerrar") {
                        dismiss()
                    }
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Color("PrimaryAdax"))
                }
            }
        }
    }
}
