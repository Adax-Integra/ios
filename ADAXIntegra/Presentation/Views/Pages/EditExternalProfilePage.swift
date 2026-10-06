//
//  EditExternalProfilePage.swift
//  ADAXIntegra
//
//  Created by Gerardo Martínez Carbajal on 06/10/26.
//

import SwiftUI

// G-07: form where the admin edits the email, phone and address of an external user
struct EditExternalProfilePage: View {
  @ObservedObject var viewModel: ExternalProfileViewModel

  var body: some View {
    ZStack {
      Color("Background").ignoresSafeArea()

      ScrollView(showsIndicators: false) {
        VStack(alignment: .leading, spacing: 20) {
          PageHeader(
            title: "Editar datos",
            backAction: viewModel.cancelEditing,
            subtitle: "\(viewModel.displayName) - Externa"
          )

          infoBanner

          ProfileSectionCard(title: "Datos de registro", isLocked: true) {
            InfoRow(label: "Nombre(s)", value: viewModel.display(viewModel.profile?.profile?.name))
            InfoRow(
              label: "Apellido", value: viewModel.display(viewModel.profile?.profile?.lastName))
            InfoRow(
              label: "Fecha de nacimiento",
              value: viewModel.display(viewModel.profile?.profile?.birthDate))
          }

          contactSection
          addressSection
          changeSection

          FormActions(
            primaryTitle: "Guardar",
            secondaryTitle: "Cancelar",
            isPrimaryDisabled: !viewModel.canSave,
            onPrimary: viewModel.onSaveTapped,
            onSecondary: viewModel.cancelEditing
          )
          .padding(.top, 12)

          if !viewModel.canSave {
            Text(
              "Para guardar haz al menos un cambio, escribe el motivo y confirma la autorización."
            )
            .font(.system(size: 12))
            .foregroundColor(Color("InsideTextAndIcons"))
          }
        }
        .padding(20)
      }
    }
    .toolbar(.hidden, for: .navigationBar)
    .sheet(isPresented: $viewModel.isShowingConfirmation) {
      ChangesSummarySheet(
        externalName: viewModel.displayName,
        changes: viewModel.changes,
        reason: viewModel.trimmedReason,
        noticeText: viewModel.noticeText,
        isSaving: viewModel.isSaving,
        onConfirm: { Task { await viewModel.confirm() } },
        onCancel: { viewModel.isShowingConfirmation = false }
      )
      .presentationDetents([.large])
      .presentationBackground(Color(.systemBackground))
    }
    .overlay {
      // The backdrop absorbs taps so nothing can be passed while saving
      if viewModel.isSaving {
        Color.black.opacity(0.15)
          .ignoresSafeArea()
          .overlay { ProgressView() }
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
        "Cada cambio queda registrado en la bitácora y se le avisa a la externa por correo electrónico."
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

  private var contactSection: some View {
    VStack(alignment: .leading, spacing: 16) {
      sectionTitle("Contacto")

      LabeledTextField(
        title: "Correo electrónico",
        placeholder: "correo@ejemplo.com",
        keyboardType: .emailAddress,
        errorMessage: viewModel.errors.email,
        text: $viewModel.form.email
      )
      .textInputAutocapitalization(.never)
      .autocorrectionDisabled()

      PhoneField(
        errorMessage: viewModel.errors.phone,
        countryCode: $viewModel.form.countryCode,
        phone: $viewModel.form.phone
      )
    }
  }

  //Same fields and order as the "Registrar exerna" form
  private var addressSection: some View {
    VStack(alignment: .leading, spacing: 16) {
      sectionTitle("Domicilio")

      LabeledTextField(
        title: "Calle y número",
        placeholder: "Av. Insurgentes Sur 1234",
        errorMessage: viewModel.errors.addressLine1,
        text: $viewModel.form.addressLine1
      )

      LabeledTextField(
        title: "Interior / depto (opcional)",
        placeholder: "Interior 203N",
        text: $viewModel.form.addressLine2
      )

      LabeledTextField(
        title: "Colonia",
        placeholder: "Colonia...",
        errorMessage: viewModel.errors.neighborhood,
        text: $viewModel.form.neighborhood
      )

      LabeledTextField(
        title: "Código postal",
        placeholder: "00000",
        keyboardType: .numberPad,
        maxLength: 5,
        errorMessage: viewModel.errors.zipCode,
        text: $viewModel.form.zipCode
      )

      SearchableDropdown(
        title: "País",
        prompt: "Selecciona un país",
        options: viewModel.countryOptions,
        selection: countryBinding
      )

      VStack(alignment: .leading, spacing: 6) {
        SearchableDropdown(
          title: "Estado",
          prompt: viewModel.form.country == nil ? "Primero elige un país" : "Selecciona un estado",
          options: viewModel.stateOptions,
          selection: $viewModel.form.state
        )
        .disabled(viewModel.form.country == nil)

        if let error = viewModel.errors.state {
          FieldErrorLabel(error)
        }
      }

      LabeledTextField(
        title: "Ciudad / Municipio",
        placeholder: "Ciudad o municipio...",
        errorMessage: viewModel.errors.city,
        text: $viewModel.form.city
      )

    }
  }

  private var changeSection: some View {
    VStack(alignment: .leading, spacing: 16) {
      sectionTitle("Registro del cambio")

      VStack(alignment: .leading, spacing: 0) {
        VStack(alignment: .trailing, spacing: 6) {
          LabeledTextField(
            title: "Motivo del cambio",
            placeholder: "Describe por qué se modificaron los datos...",
            customHeight: 110,
            maxLength: ExternalProfileViewModel.maxReasonLength,
            errorMessage: viewModel.errors.reason,
            text: $viewModel.reason
          )

          Text("\(viewModel.reason.count) / \(ExternalProfileViewModel.maxReasonLength)")
            .font(.system(size: 12))
            .foregroundColor(Color("InsideTextAndIcons"))
        }

        HStack(alignment: .top, spacing: 8) {
          Checkbox(isChecked: $viewModel.hasConsent)

          VStack(alignment: .leading, spacing: 4) {
            Text("La externa autorizó este cambio")
              .font(.system(size: 15, weight: .semibold))
              .foregroundColor(Color("OnBackground"))

            Text("Confirmo que la externa dio su consentimiento para modificar sus datos.")
              .font(.system(size: 12))
              .foregroundColor(Color("InsideTextAndIcons"))
          }
          .padding(.top, 12)
          .frame(maxWidth: .infinity, alignment: .leading)
        }
      }
    }
  }

  // Changing the country clears the state, done in the ViewModel instead of
  // an onChange so it does not run when the saved data is loaded
  private var countryBinding: Binding<String?> {
    Binding(
      get: { viewModel.form.country },
      set: { viewModel.selectCountry($0) }
    )
  }

  private func sectionTitle(_ title: String) -> some View {
    Text(title)
      .font(.system(size: 20, weight: .bold))
  }
}

#Preview {
  NavigationStack {
    EditExternalProfilePage(
      viewModel: ExternalProfileViewModel(userId: "00000000-0000-4000-8000-000000000000"))
  }
}
