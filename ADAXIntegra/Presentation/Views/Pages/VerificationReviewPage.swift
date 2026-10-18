//
//  VerificationReviewPage.swift
//  ADAXIntegra
//
//  Created by Cristhian Viery Maida Suarez on 17/10/26.
//

import SwiftUI

// B-02: staff reviews the identity documents and approves or rejects the account
struct VerificationReviewPage: View {
  @StateObject private var viewModel: VerificationReviewViewModel
  @Environment(\.dismiss) private var dismiss

  @State private var isRejecting = false
  @State private var rejectReason = ""

  // Called after a decision so the detail can refresh the status
  let onDecision: (VerificationStatus) -> Void

  init(userId: String, onDecision: @escaping (VerificationStatus) -> Void = { _ in }) {
    _viewModel = StateObject(wrappedValue: VerificationReviewViewModel(userId: userId))
    self.onDecision = onDecision
  }

  var body: some View {
    ZStack {
      Color("Background").ignoresSafeArea()

      ScrollView(showsIndicators: false) {
        VStack(alignment: .leading, spacing: 20) {
          infoBanner
          documentsSection
          decisionSection
        }
        .padding(20)
      }

      if viewModel.isSubmitting {
        Color.black.opacity(0.15).ignoresSafeArea()
          .overlay { ProgressView() }
      }
    }
    .navigationTitle("Revisar verificación")
    .navigationBarTitleDisplayMode(.inline)
    .task { await viewModel.load() }
    .onChange(of: viewModel.didFinish) { _, finished in
      if finished {
          onDecision(viewModel.decidedStatus ?? .enRevision)
        dismiss()
      }
    }
    .sheet(isPresented: $viewModel.isShowingShareSheet) {
      if let url = viewModel.downloadedFileURL {
        ShareSheet(url: url)
      }
    }
    .alert(
      "Aviso",
      isPresented: Binding(
        get: { viewModel.errorMessage != nil },
        set: { if !$0 { viewModel.errorMessage = nil } }
      )
    ) {
      Button("Aceptar", role: .cancel) {}
    } message: {
      Text(viewModel.errorMessage ?? "")
    }
  }

  private var infoBanner: some View {
    HStack(alignment: .top, spacing: 10) {
      Image(systemName: "info.circle")
        .foregroundColor(Color("PrimaryAdax"))
      Text(
        "Revisa los comprobantes de la externa y aprueba o rechaza su verificación. La decisión queda en la bitácora y se le avisa por correo."
      )
      .font(.system(size: 13))
      .foregroundColor(Color("OnBackground"))
    }
    .padding(14)
    .frame(maxWidth: .infinity, alignment: .leading)
    .background(
      RoundedRectangle(cornerRadius: 12, style: .continuous)
        .fill(Color("PrimaryAdax").opacity(0.08))
    )
  }

  private var documentsSection: some View {
    SurfaceCard {
      VStack(alignment: .leading, spacing: 14) {
        Text("Documentos")
          .font(.system(size: 16, weight: .bold))
          .foregroundColor(Color("OnBackground"))

        if viewModel.isLoading {
          ProgressView().frame(maxWidth: .infinity).padding(.vertical, 8)
        } else {
          documentRow(
            title: "Comprobante de identidad",
            hasDocument: viewModel.hasIdentity,
            action: { Task { await viewModel.downloadIdentity() } }
          )
          Divider()
          documentRow(
            title: "Comprobante de domicilio",
            hasDocument: viewModel.hasProof,
            action: { Task { await viewModel.downloadProof() } }
          )
        }
      }
      .padding(20)
      .frame(maxWidth: .infinity, alignment: .leading)
    }
  }

  private func documentRow(
    title: String, hasDocument: Bool, action: @escaping () -> Void
  ) -> some View {
    HStack(spacing: 12) {
      Image(systemName: "doc.text")
        .foregroundColor(Color("PrimaryAdax"))
      Text(title)
        .font(.system(size: 15))
        .foregroundColor(Color("OnBackground"))
      Spacer()
      if hasDocument {
        Button(action: action) {
          Label("Ver", systemImage: "arrow.down.circle")
            .font(.system(size: 14, weight: .semibold))
            .foregroundColor(Color("PrimaryAdax"))
        }
        .buttonStyle(.plain)
      } else {
        Text("Sin documento")
          .font(.system(size: 13))
          .foregroundColor(Color("InsideTextAndIcons"))
      }
    }
  }

  @ViewBuilder
  private var decisionSection: some View {
    if isRejecting {
      VStack(alignment: .leading, spacing: 12) {
        Text("Motivo del rechazo (opcional)")
          .font(.system(size: 15, weight: .semibold))
          .foregroundColor(Color("OnBackground"))

        LabeledTextField(
          title: "",
          placeholder: "Describe por qué se rechazan los documentos...",
          customHeight: 100,
          maxLength: 500,
          text: $rejectReason
        )

        FormActions(
          primaryTitle: "Confirmar rechazo",
          secondaryTitle: "Cancelar",
          isPrimaryDisabled: viewModel.isSubmitting,
          onPrimary: { Task { await viewModel.reject(reason: rejectReason) } },
          onSecondary: { isRejecting = false }
        )
      }
    } else {
      VStack(spacing: 12) {
        PrimaryButton(
          customHeight: 20,
          title: "Aprobar verificación",
          isDisabled: viewModel.isSubmitting
        ) {
          Task { await viewModel.approve() }
        }

        SecondaryButton(
          customHeight: 20,
          title: "Rechazar",
          isDisabled: viewModel.isSubmitting
        ) {
          isRejecting = true
        }
      }
    }
  }
}
