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
        .sheet(isPresented: $showDateSheet) {
            dateSheet
        }
    }
    
    private func formatDateInput(_ text: String) -> String {
        let digits = String(text.filter(\.isNumber).prefix(8))
        var result = ""
        for (i, ch) in digits.enumerated() {
            if i == 2 || i == 4 { result.append("/") }
            result.append(ch)
        }
        return result
    }
    
    private var dateSheet: some View {
        NavigationStack {
            VStack {
                DatePicker("", selection: $sheetDate, in: ...Date(), displayedComponents: .date)
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

#Preview {
    RegisterExternalPage()
}

