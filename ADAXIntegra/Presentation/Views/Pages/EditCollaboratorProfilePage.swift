//
//  EditCollaboratorProfilePage.swift
//  ADAXIntegra
//
//  Created by Cristhian Viery Maida Suarez on 17/10/26.
//

import SwiftUI

struct EditCollaboratorProfilePage: View {
  @StateObject private var viewModel: EditCollaboratorProfileViewModel
  @Environment(\.dismiss) private var dismiss
  private let onSaved: () -> Void

  init(userId: String, onSaved: @escaping () -> Void = {}) {
    _viewModel = StateObject(wrappedValue: EditCollaboratorProfileViewModel(userId: userId))
    self.onSaved = onSaved
  }

  var body: some View {
    ZStack {
      Color("Background").ignoresSafeArea()

      ScrollView(showsIndicators: false) {
        VStack(alignment: .leading, spacing: 20) {
          Text("\(viewModel.displayName) - Colaboradora")
            .font(.subheadline)
            .foregroundColor(Color("OnBackground").opacity(0.7))

          content
        }
        .padding(20)
      }
      // hides the keyboard when the user scrolls
      .scrollDismissesKeyboard(.interactively)
    }
    .navigationTitle("Editar datos")
    // closes the keyboard when tapping outside the fields
    .dismissKeyboardOnTap()
    .task { await viewModel.load() }
    .overlay {
      if viewModel.isSaving {
        Color.black.opacity(0.15)
          .ignoresSafeArea()
          .overlay { ProgressView() }
      }
    }
    .onChange(of: viewModel.didSave) { _, saved in
      if saved {
        onSaved()
        dismiss()
      }
    }
    .onChange(of: viewModel.wantsDismiss) { _, leave in
      if leave { dismiss() }
    }

    .sheet(isPresented: $viewModel.isShowingConfirmation) {
      confirmationSheet
        .presentationDetents([.medium, .large])
        .presentationBackground(Color(.systemBackground))
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

  @ViewBuilder
  private var content: some View {
    if viewModel.isLoading {
      ProgressView()
        .frame(maxWidth: .infinity)
        .padding(.vertical, 24)
    } else if let message = viewModel.loadErrorMessage {
      errorCard(message) { Task { await viewModel.load() } }
    } else {
      form
    }
  }

  private var form: some View {
    VStack(alignment: .leading, spacing: 20) {
      infoBanner

      VStack(alignment: .leading, spacing: 16) {
        sectionTitle("Datos de la colaboradora")

        LabeledTextField(
          title: "Nombre(s)",
          placeholder: "Nombre(s)...",
          errorMessage: viewModel.nameError,
          text: $viewModel.name
        )

        LabeledTextField(
          title: "Apellidos",
          placeholder: "Apellidos...",
          errorMessage: viewModel.lastNameError,
          text: $viewModel.lastName
        )

        LabeledTextField(
          title: "Correo electrónico",
          placeholder: "correo@ejemplo.com",
          keyboardType: .emailAddress,
          errorMessage: viewModel.emailError,
          text: $viewModel.email
        )
        .textInputAutocapitalization(.never)
        .autocorrectionDisabled()
      }

      FormActions(
        primaryTitle: "Guardar",
        secondaryTitle: "Cancelar",
        isPrimaryDisabled: viewModel.isSaving || !viewModel.hasChanges,
        onPrimary: viewModel.onSaveTapped,
        onSecondary: { dismiss() }
      )
      .padding(.top, 12)
    }
  }

  private var infoBanner: some View {
    HStack(alignment: .top, spacing: 10) {
      Image(systemName: "info.circle")
        .foregroundColor(Color("PrimaryAdax"))

      Text(
        "Cada cambio queda registrado en la bitácora y se le avisa a la colaboradora por correo electrónico."
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

  private var confirmationSheet: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: 20) {
        Text("Confirmar cambios")
          .font(.system(size: 22, weight: .bold))
          .foregroundColor(Color("OnBackground"))

        Text("Revisa los cambios antes de guardar. Quedan registrados en la bitácora.")
          .font(.system(size: 14))
          .foregroundColor(Color("InsideTextAndIcons"))

        VStack(spacing: 12) {
          ForEach(viewModel.changes) { change in
            VStack(alignment: .leading, spacing: 6) {
              Text(change.label)
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(Color("OnBackground"))

              HStack(spacing: 8) {
                Text(change.oldValue)
                  .foregroundColor(Color("InsideTextAndIcons"))
                  .strikethrough()

                Image(systemName: "arrow.right")
                  .font(.system(size: 12))
                  .foregroundColor(Color("InsideTextAndIcons"))

                Text(change.newValue)
                  .fontWeight(.semibold)
                  .foregroundColor(Color("OnBackground"))
              }
              .font(.system(size: 14))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(14)
            .background(
              RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color("PrimaryAdax").opacity(0.06))
            )
          }
        }

        if viewModel.emailChanged {
          Text("Se enviará un aviso al correo anterior y al nuevo, sin mostrar los datos.")
            .font(.system(size: 13))
            .foregroundColor(Color("InsideTextAndIcons"))
        }

        FormActions(
          primaryTitle: "Confirmar",
          secondaryTitle: "Cancelar",
          isPrimaryDisabled: viewModel.isSaving,
          onPrimary: { Task { await viewModel.confirm() } },
          onSecondary: { viewModel.isShowingConfirmation = false }
        )
        .padding(.top, 8)
      }
      .padding(24)
    }
  }

  private func sectionTitle(_ title: String) -> some View {
    Text(title)
      .font(.system(size: 20, weight: .bold))
  }

  private func errorCard(_ message: String, retry: @escaping () -> Void) -> some View {
    VStack(spacing: 12) {
      Image(systemName: "exclamationmark.circle")
        .font(.system(size: 28))
        .foregroundColor(Color("Error"))

      Text("No se pudo cargar")
        .font(.system(size: 16, weight: .semibold))
        .foregroundColor(Color("OnBackground"))

      Text(message)
        .font(.system(size: 14))
        .foregroundColor(Color("InsideTextAndIcons"))
        .multilineTextAlignment(.center)

      SecondaryButton(customHeight: 20, title: "Reintentar", isDisabled: false, action: retry)
    }
    .padding(24)
    .frame(maxWidth: .infinity)
    .background(
      RoundedRectangle(cornerRadius: 16, style: .continuous).fill(Color.white)
    )
  }
}

#Preview {
  NavigationStack {
    EditCollaboratorProfilePage(userId: "00000000-0000-4000-8000-000000000000")
  }
}
