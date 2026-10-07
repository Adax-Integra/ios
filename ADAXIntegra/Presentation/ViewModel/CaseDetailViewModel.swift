//
//  CaseDetailViewModel.swift
//  ADAXIntegra
//
//  Created by Oscar Alexander Vilchis Soto on 02/10/26.
//
//  ViewModel for US V-11  case detail screen and close case action
//

import Foundation
import Combine

// we make sure that the UI updates happen ina safety environment on the mai thread
@MainActor
final class CaseDetailViewModel: ObservableObject {
    //Published Properties (UI State) (case detail holds the full casedetails to display, is loading indicates
    //wheter the data is being fetched and error Message stores various error messages to show feedback on UI, as well as the toast molecule to express a message of succes or error
    @Published var caseDetail: CaseDetail?
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var showToast = false
    @Published var toastMessage = ""
    
    // Published Properties for US B-02 casecomments
    @Published private(set) var comments: [Comment] = []
    @Published var newCommentText: String = ""
    @Published private(set) var isLoadingComments = false
    @Published private(set) var isSendingComment = false
    
    
    private let caseId: String
    private let getCaseDetailUseCase: GetCaseDetailUseCaseProtocol
    private let closeCaseUseCase: CloseCaseUseCaseProtocol
    
    // B-02 case comment UseCases Dependencies
    private let getCommentsUseCase: GetCaseCommentsUseCaseProtocol
    private let createCommentUseCase: CreateCommentUseCaseProtocol
    private let deleteCommentUseCase: DeleteCommentUseCaseProtocol

    // Initializes the view model with a case ID and dependencies
        init(
        caseId: String,
        repository: CaseRepository = RemoteCaseRepository(),
        commentRepository: CommentRepository = RemoteCommentRepository()
    ) {
        self.caseId = caseId
        self.getCaseDetailUseCase = GetCaseDetailUseCase(repository: repository)
        self.closeCaseUseCase = CloseCaseUseCase(repository: repository)
       self.getCommentsUseCase = GetCaseCommentsUseCase(repository: commentRepository)
                self.createCommentUseCase = CreateCommentUseCase(repository: commentRepository)
                self.deleteCommentUseCase = DeleteCommentUseCase(repository: commentRepository)
    }
    // Asynchronously fetches case details and updates UI state variables
    func loadCase() async {
        isLoading = true
        errorMessage = nil
        do {
            caseDetail = try await getCaseDetailUseCase.execute(caseId: caseId)
        } catch {
            errorMessage = "No se pudo cargar el detalle del caso."
        }
        isLoading = false
    }
    // Triggers the process to close the case
    func closeCase() async {
        do {
            let success = try await closeCaseUseCase.execute(caseId: caseId)
            if success {
                toastMessage = "El caso se cerró correctamente."
                showToast = true
                await loadCase()
            }
        } catch {
            toastMessage = "No se pudo cerrar el caso. Es posible que ya esté cerrado."
            showToast = true
        }
    }
// Comments Actions (US B-02)
    
    // Loads comments attached to this case
    func loadComments() async {
        isLoadingComments = true
        do {
            self.comments = try await getCommentsUseCase.execute(caseId: caseId, limit: 50)
        } catch {
            print("Error loading comments: \(error.localizedDescription)")
        }
        isLoadingComments = false
    }

    // Creates and sends a new comment for this case
    func sendComment() async {
        let text = newCommentText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else { return }

        isSendingComment = true
        do {
            let createdComment = try await createCommentUseCase.execute(caseId: caseId, content: text)
            // Insert at index 0 so the user sees their new comment immediately at top
            self.comments.insert(createdComment, at: 0)
            self.newCommentText = ""
        } catch {
            toastMessage = "No se pudo publicar el comentario."
            showToast = true
        }
        isSendingComment = false
    }

    // Deletes a comment created by the user
    func deleteComment(_ comment: Comment) async {
        do {
            try await deleteCommentUseCase.execute(commentId: comment.id)
            self.comments.removeAll { $0.id == comment.id }
            toastMessage = "Comentario eliminado."
            showToast = true
        } catch {
            toastMessage = "No se pudo eliminar el comentario."
            showToast = true
        }
    }
}
