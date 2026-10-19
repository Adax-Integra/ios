//
//  AddCollaboratorPage.swift
//  ADAXIntegra
//
//  Created by Nicolas Bravo Miguel on 07/10/26.
//

import SwiftUI

// Page where the admin registers a new collaborator
struct AddCollaboratorPage: View {
  @Environment(\.dismiss) private var dismiss
  @StateObject private var viewModel = AddCollaboratorViewModel()

  var body: some View {
    ZStack {
      Color("Background").ignoresSafeArea()

      ScrollView(showsIndicators: false) {
        VStack(alignment: .leading, spacing: 20) {
          AddCollaboratorForm(
            firstName: $viewModel.firstName,
            lastName: $viewModel.lastName,
            email: $viewModel.email,
            password: $viewModel.password,
            confirmPassword: $viewModel.confirmPassword,
            countryCode: $viewModel.countryCode,
            phone: $viewModel.phone,
            countryCodes: viewModel.countryCodes,
            nameError: viewModel.fieldErrors[.name],
            lastNameError: viewModel.fieldErrors[.lastName],
            emailError: viewModel.fieldErrors[.email],
            passwordError: viewModel.fieldErrors[.password],
            confirmPasswordError: viewModel.fieldErrors[.confirmPassword],
            phoneError: viewModel.fieldErrors[.phone]
          )

          PrimaryButton(
            customHeight: 20,
            title: viewModel.isSaving ? "Guardando..." : "Guardar",
            isDisabled: viewModel.isSaveDisabled
          ) {
            Task { await viewModel.save() }
          }
          .padding(.top, 8)
        }
        .padding(20)
      }
      // hides the keyboard when the user scrolls
      .scrollDismissesKeyboard(.interactively)
    }
    .navigationTitle("Agregar colaboradora")
    // closes the keyboard when tapping outside the fields
    .dismissKeyboardOnTap()
    // Error that does not belong to a single field (no connection, expired session...)
    .alert("No se pudo guardar", isPresented: showGeneralError) {
      Button("Aceptar", role: .cancel) {}
    } message: {
      Text(viewModel.generalError ?? "")
    }
    // After creating the collaborator, "Aceptar" goes back to the management page
    .alert("Colaboradora agregada", isPresented: showSuccess) {
      Button("Aceptar", role: .cancel) { dismiss() }
    } message: {
      Text(viewModel.successMessage ?? "")
    }
    // loads the phone codes when the page opens
    .task {
      await viewModel.loadCountryCodes()
    }
  }

  // Shows the alert while there is a general error and clears the message when it is closed
  private var showGeneralError: Binding<Bool> {
    Binding(
      get: { viewModel.generalError != nil },
      set: { if !$0 { viewModel.generalError = nil } }
    )
  }

  // Shows the alert while there is a success message and clears the message when it is closed
  private var showSuccess: Binding<Bool> {
    Binding(
      get: { viewModel.successMessage != nil },
      set: { if !$0 { viewModel.successMessage = nil } }
    )
  }
}

#Preview {
  NavigationStack {
    AddCollaboratorPage()
  }
}
