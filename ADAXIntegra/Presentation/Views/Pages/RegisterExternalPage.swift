//
//  RegisterExternalPage.swift
//  ADAXIntegra
//
//  Created by Cristhian Viery Maida Suarez on 24/09/26.
//

import SwiftUI

struct RegisterExternalPage: View {
    @StateObject private var viewModel = RegisterExternalViewModel()
    @State private var showDatePicker = false
    
    var onBack: () -> Void = {}
    
    var body: some View {
        if viewModel.didSucceed {
            RegisterConfirmationView(
                recordId: viewModel.result?.recordId,
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
                    PageHeader(title: "Registrar externa", backAction: onBack)
                    profileSection
                    addressSection
                    
                    PrimaryButton(
                        title: "Guardar",
                        isDisabled: !viewModel.isValid || viewModel.isSubmitting,
                        action: { Task { await viewModel.submit() } }
                    )
                    .frame(maxWidth: .infinity, minHeight: 52, maxHeight: 52)
                    .padding(.top, 8)
                    
                    if let errorMessage = viewModel.errorMessage {
                        Text(errorMessage)
                            .font(.system(size: 14))
                            .foregroundStyle(Color("Error"))
                    }
                }
                .padding(20)
            }
        }
    }
    
    private var profileSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            LabeledTextField(
                title: "Nombre",
                placeholder: "Escribe el nombre...",
                maxLength: 30,
                text: $viewModel.name
            )
            
            LabeledTextField(
                title: "Apellido(s)",
                placeholder: "Escribe el/los apellido(s)...",
                maxLength: 30,
                text: $viewModel.lastName
            )
            
            LabeledTextField(
                title: "Email",
                placeholder: "correo@ejemplo.com",
                keyboardType: .emailAddress,
                text: $viewModel.email
            )
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled()
            
            birthDateField
            
            PhoneField(countryCode: $viewModel.countryCode, phone: $viewModel.phone)
        }
    }
    
    private var birthDateField: some View {
        VStack(alignment: .leading, spacing: 6) {
            FieldLabel("Fecha de nacimiento")
            
            SurfaceCard {
                Button {
                    withAnimation { showDatePicker.toggle() }
                } label: {
                    HStack {
                        Text(birthDateText)
                            .foregroundStyle(Color("OnBackground"))
                        Spacer()
                        Image(systemName: "calendar")
                            .foregroundStyle(Color("InsideTextAndIcons"))
                    }
                    .padding(.horizontal, 14)
                    .frame(height: 50)
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
            }
            if showDatePicker {
                DatePicker(
                    "",
                    selection: $viewModel.birthDate,
                    displayedComponents: .date
                )
                .datePickerStyle(.graphical)
                .labelsHidden()
                .tint(Color("PrimaryAdax"))
                .padding(.top, 4)
            }
        }
    }
    
    private var birthDateText: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "es_MX")
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter.string(from: viewModel.birthDate)
    }
    
    private var addressSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Dirección")
                .font(.system(size: 20, weight: .bold))
                .foregroundStyle(Color("OnBackground"))
            
            LabeledTextField(
                title: "Calle y número",
                placeholder: "Av. Insurgentes Sur 1234",
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
                text: $viewModel.neighborhood
            )
            
            LabeledTextField(
                title: "Código postal",
                placeholder: "00000",
                keyboardType: .numberPad,
                maxLength: 5,
                text: $viewModel.zipCode
            )
            
            Dropdown(
                title: "País",
                prompt: "Selecciona un país",
                options: viewModel.countries.map(\.name),
                maxVisibleOptions: 5,
                selection: $viewModel.country
            )
            
            Dropdown(
                title: "Estado",
                prompt: "Selecciona un estado",
                options: viewModel.stateOptions,
                maxVisibleOptions: 5,
                selection: $viewModel.state
            )
            .onChange(of: viewModel.country) { _, _ in
                viewModel.state = nil
            }
            
            LabeledTextField(
                title: "Ciudad / Municipio",
                placeholder: "Ciudad o municipio...",
                text: $viewModel.city
            )
        }
    }
}

#Preview {
    RegisterExternalPage()
}

