//
//  RegisterExternalPage.swift
//  ADAXIntegra
//
//  Created by Cristhian Viery Maida Suarez on 24/09/26.
//

import SwiftUI

struct RegisterExternalPage: View {
  @StateObject private var viewModel = RegisterExternalViewModel()
  @State private var showDateSheet = false
  @State private var sheetDate = Date()

  var onBack: () -> Void = {}

  var body: some View {
    if viewModel.didSucceed {
      RegisterConfirmationView(
        recordNumber: viewModel.result?.recordNumber,
        onDone: onBack
      )
    } else {
      formContent
    }
    
    private var formContent: some View {
        ZStack {
            Color("Background").ignoresSafeArea()
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {
                    PageHeader(title: "Registrar expediente", backAction: onBack)
                    profileSection
                    addressSection
                    
                    PrimaryButton(
                        title: "Guardar expediente",
                        isDisabled: viewModel.isSubmitting,
                        action: { Task { await viewModel.submit() } }
                    )
                    .frame(maxWidth: .infinity, minHeight: 52, maxHeight: 52)
                    .padding(.top, 8)
                }
                .padding(20)
            }
        }
        .task {
            await viewModel.loadCountries()
        }
        .toast(
            isPresented: $viewModel.showErrorToast,
            message: viewModel.errorMessage ?? ""
        )
    }
    
    private var profileSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            LabeledTextField(
                title: "Nombre(s)",
                placeholder: "Escribe el nombre...",
                maxLength: 30,
                errorMessage: viewModel.nameError,
                text: $viewModel.name
            )
            
            LabeledTextField(
                title: "Apellido(s)",
                placeholder: "Escribe el/los apellido(s)...",
                maxLength: 30,
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
            
            PhoneField(
                countryCodes: Country.dialCodes(in: viewModel.countries),
                countryCode: $viewModel.countryCode,
                phone: $viewModel.phone)
            birthDateField
        }
    }
  }

  private var profileSection: some View {
    VStack(alignment: .leading, spacing: 16) {
      LabeledTextField(
        title: "Nombre(s)",
        placeholder: "Escribe el nombre...",
        maxLength: 30,
        errorMessage: viewModel.nameError,
        text: $viewModel.name
      )

      LabeledTextField(
        title: "Apellido(s)",
        placeholder: "Escribe el/los apellido(s)...",
        maxLength: 30,
        errorMessage: viewModel.lastNameError,
        text: $viewModel.lastName
      )

      LabeledTextField(
        title: "Email",
        placeholder: "correo@ejemplo.com",
        keyboardType: .emailAddress,
        errorMessage: viewModel.emailError,
        text: $viewModel.email
      )
      .textInputAutocapitalization(.never)
      .autocorrectionDisabled()

      PhoneField(countryCode: $viewModel.countryCode, phone: $viewModel.phone)
      birthDateField
    }
  }

  private var birthDateField: some View {
    VStack(alignment: .leading, spacing: 6) {
      FieldLabel("Fecha de Nacimiento")

      SurfaceCard(
        borderColor: viewModel.birthDateError != nil ? Color("Error") : nil,
        borderWidth: viewModel.birthDateError != nil ? 1 : 0
      ) {
        HStack {
          TextField("dd/mm/aaaa", text: $viewModel.birthDateInput)
            .keyboardType(.numberPad)
            .foregroundStyle(Color("OnBackground"))
            .onChange(of: viewModel.birthDateInput) { _, newValue in
              viewModel.birthDateInput = formatDateInput(newValue)
            }

          Button {
            sheetDate = viewModel.birthDate ?? Date()
            showDateSheet = true
          } label: {
            Image(systemName: "calendar")
              .foregroundStyle(Color("PrimaryAdax"))
          }
          .buttonStyle(.plain)
        }
        .padding(.horizontal, 14)
        .frame(height: 50)
      }

      if let error = viewModel.birthDateError {
        FieldErrorLabel(error)
      }
    }
    
    private var dateSheet: some View {
        NavigationStack {
            VStack {
                DatePicker("", selection: $sheetDate, in: ...maxBirthDate, displayedComponents: .date)
                    .datePickerStyle(.graphical)
                    .labelsHidden()
                    .tint(Color("PrimaryAdax"))
                    .padding()
                Spacer()
            }
            .navigationTitle("Fecha de nacimiento")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") { showDateSheet = false }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Listo") {
                        viewModel.setBirthDate(sheetDate)
                        showDateSheet = false
                    }
                    .fontWeight(.semibold)
                }
            }
        }
        .tint(Color("PrimaryAdax"))
        .presentationDetents([.medium])
    }
    
    private var maxBirthDate: Date {
        Calendar.current.date(byAdding: .year, value: -18, to: Date()) ?? Date()
    }
    
    private var addressSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Dirección")
                .font(.system(size: 20, weight: .bold))
                .foregroundStyle(Color("OnBackground"))
            
            VStack(alignment: .leading, spacing: 6) {
                SearchableDropdown(
                    title: "País",
                    prompt: "Selecciona un país",
                    options: viewModel.countries.map(\.nameEs),
                    selection: $viewModel.country
                )
                if let error = viewModel.countryError {
                    FieldErrorLabel(error)
                }
            }
            
            VStack(alignment: .leading, spacing: 6) {
                SearchableDropdown(
                    title: "Estado",
                    prompt: viewModel.country == nil ? "Primero elige un país" : "Selecciona un estado",
                    options: viewModel.stateOptions,
                    selection: $viewModel.state
                )
                .disabled(viewModel.country == nil)
                .onChange(of: viewModel.country) { _, _ in
                    viewModel.state = nil
                }
                if let error = viewModel.stateError {
                    FieldErrorLabel(error)
                }
            }
            
            LabeledTextField(
                title: "Municipio/Localidad",
                placeholder: "Municipio o localidad...",
                errorMessage: viewModel.municipalityError,
                text: $viewModel.municipality
            )
        }
      }
    }
    .tint(Color("PrimaryAdax"))
    .presentationDetents([.medium])
  }

  private var addressSection: some View {
    VStack(alignment: .leading, spacing: 16) {
      Text("Dirección")
        .font(.system(size: 20, weight: .bold))
        .foregroundStyle(Color("OnBackground"))

      LabeledTextField(
        title: "Calle y número",
        placeholder: "Av. Insurgentes Sur 1234",
        errorMessage: viewModel.addressLine1Error,
        text: $viewModel.addressLine1
      )

      LabeledTextField(
        title: "Interior / depto (opcional)",
        placeholder: "Interior 203N",
        text: $viewModel.addressLine2
      )

      LabeledTextField(
        title: "Colonia",
        placeholder: "Colonia...",
        errorMessage: viewModel.neighborhoodError,
        text: $viewModel.neighborhood
      )

      LabeledTextField(
        title: "Código postal",
        placeholder: "00000",
        keyboardType: .numberPad,
        maxLength: 5,
        errorMessage: viewModel.zipCodeError,
        text: $viewModel.zipCode
      )

      VStack(alignment: .leading, spacing: 6) {
        SearchableDropdown(
          title: "País",
          prompt: "Selecciona un país",
          options: viewModel.countries.map(\.nameEs),
          selection: $viewModel.country
        )
        if let error = viewModel.countryError {
          FieldErrorLabel(error)
        }
      }

      VStack(alignment: .leading, spacing: 6) {
        SearchableDropdown(
          title: "Estado",
          prompt: viewModel.country == nil ? "Primero elige un país" : "Selecciona un estado",
          options: viewModel.stateOptions,
          selection: $viewModel.state
        )
        .disabled(viewModel.country == nil)
        .onChange(of: viewModel.country) { _, _ in
          viewModel.state = nil
        }
        if let error = viewModel.stateError {
          FieldErrorLabel(error)
        }
      }

      LabeledTextField(
        title: "Ciudad / Municipio",
        placeholder: "Ciudad o municipio...",
        errorMessage: viewModel.cityError,
        text: $viewModel.city
      )
    }
  }
}

#Preview {
  RegisterExternalPage()
}
