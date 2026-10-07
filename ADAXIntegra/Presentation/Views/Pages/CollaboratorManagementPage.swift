//
//  CollaboratorManagementPage.swift
//  ADAXIntegra
//
//  Created by Nicolas Bravo Miguel on 01/10/26.
//

import SwiftUI

struct CollaboratorManagementPage: View {

  @Environment(\.dismiss) private var dismiss
  @StateObject private var viewModel = CollaboratorManagementViewModel()

  var body: some View {
    ZStack {
      Color("Background").ignoresSafeArea()

      VStack(spacing: 16) {
        PageHeader(
          title: "Gestión de Colaboradoras",
          backAction: { dismiss() },
          subtitle: "Administra las cuentas de colaboradoras"
        )

        // Opens form isted of navegation
        Button {
          viewModel.openForm()
        } label: {
          MenuRow(
            icon: "person.badge.plus",
            title: "Agregar colaboradora",
            subtitle: "Registra una nueva cuenta"
          )
        }
        .buttonStyle(.plain)

        Spacer()
      }

      .padding()

      if viewModel.isFormVisible {
        Color.black.opacity(0.5)
          .ignoresSafeArea()

        ScrollView {
          AddCollaboratiorForm(
            firstName: $viewModel.firstName,
            lastName: $viewModel.lastName,
            email: $viewModel.email,
            password: $viewModel.password,
            phone: $viewModel.phone,
            isSaveDisabled: viewModel.isSaveDisabled,
            saveTitle: viewModel.isSaving ? "Guardando..." : "Guardar",
            nameError: viewModel.fieldErrors[.name],
            lastNameError: viewModel.fieldErrors[.lastName],
            emailError: viewModel.fieldErrors[.email],
            passwordError: viewModel.fieldErrors[.password],
            phoneError: viewModel.fieldErrors[.phone],
            onSave: {
              Task { await viewModel.save() }
            },
            onCancel: { viewModel.cancelForm() }
          )

          .padding()
        }
        .scrollBounceBehavior(.basedOnSize)
        .transition(.opacity)
      }
    }
    .animation(.easeInOut(duration: 0.2), value: viewModel.isFormVisible)
    .navigationBarBackButtonHidden(true)
    // error for all the the possible fields
    .alert("No se pudo guardar", isPresented: showGeneralError) {
      Button("Aceptar", role: .cancel) {}
    } message: {
      Text(viewModel.generalError ?? "")
    }
    // Confirmation after creating a collaborator
    .alert("Colaboradora agregada", isPresented: showSuccess) {
      Button("Aceptar", role: .cancel) {}
    } message: {
      Text(viewModel.successMessage ?? "")
    }
  }

  // shos alerts while there is a general error and clears the form when it is closed

  private var showGeneralError: Binding<Bool> {
    Binding(
      get: { viewModel.generalError != nil },
      set: { if !$0 { viewModel.generalError = nil } }
    )
  }

  // Show alert while there´s a success message and clears the form when it is closed

  private var showSuccess: Binding<Bool> {
    Binding(
      get: { viewModel.successMessage != nil },
      set: { if !$0 { viewModel.successMessage = nil } }
    )
  }
}

#Preview {
  CollaboratorManagementPage()
}
