//
//  PresubmissionTemplate.swift
//  ADAXIntegra
//
//  Created by Eduardo Hernández Alonso on 22/09/26.
//

import SwiftUI

// Template for the "Verificar información"
struct PresubmissionTemplate: View {
  // Header
  var title: String = "Verificar información"
  var onBack: () -> Void

  // First name
  var firstNameTitle: String = "Nombre"
  var firstNamePlaceholder: String = "Escribe tu nombre..."
  @Binding var firstName: String
  var firstNameError: String? = nil

  // Last name
  var lastNameTitle: String = "Apellido(s)"
  var lastNamePlaceholder: String = "Escribe tu(s) apellido(s)..."
  @Binding var lastName: String
  var lastNameError: String? = nil

  // Birth date
  var birthDateTitle: String = "Fecha de nacimiento"
  var birthDatePlaceholder: String = "Selecciona tu fecha..."
  @Binding var birthDate: Date?
  var birthDateError: String? = nil

  // Phone
  var phoneTitle: String = "Teléfono celular"
  var phonePlaceholder: String = "Tu número aquí..."
  @Binding var countryCode: String?
  @Binding var phone: String
  var phoneError: String? = nil

  // Address line 1
  var addressLine1Title: String = "Dirección línea 1"
  var addressLine1Placeholder: String = "Calle y número..."
  @Binding var addressLine1: String
  var addressLine1Error: String? = nil

  // Address line 2
  var addressLine2Title: String = "Dirección línea 2"
  var addressLine2Placeholder: String = "Interior..."
  @Binding var addressLine2: String
  var addressLine2Error: String? = nil

  // Neighborhood
  var neighborhoodTitle: String = "Colonia"
  var neighborhoodPlaceholder: String = "Escribe tu colonia..."
  @Binding var neighborhood: String
  var neighborhoodError: String? = nil

  // Zip code
  var zipCodeTitle: String = "Código postal"
  var zipCodePlaceholder: String = "Tu código postal..."
  @Binding var zipCode: String
  var zipCodeError: String? = nil

  // Country / State
  var countryTitle: String = "País"
  var countryPrompt: String = "Opción Seleccionada"
  var countries: [Country]
  @Binding var country: String?

  var stateTitle: String = "Estado"
  var statePrompt: String = "Opción Seleccionada"
  @Binding var state: String?

  // Phone codes come from the country catalog
  private var phoneCountryCodes: [String] {
    Country.dialCodes(in: countries)
  }

  private var countryOptions: [String] {
    countries.map(\.nameEs)
  }

  /*
   State options are the Spanish names of the selected country's states.
  */
  private var stateOptions: [String] {
    Country.first(name: country ?? "", in: countries)?.stateNames ?? []
  }

  // Municipality
  var municipalityTitle: String = "Ciudad / Municipio"
  var municipalityPlaceholder: String = "Tu ciudad o municipio aquí..."
  @Binding var municipality: String
  var municipalityError: String? = nil

  // Documents
  var officialIdTitle: String = "Identificación oficial"
  var officialIdUrl: String? = nil
  var officialIdFile: DocumentFile? = nil
  var onOfficialIdInfo: (() -> Void)? = nil
  var onOfficialIdPick: ((DocumentFile) -> Void)? = nil

  var proofOfAddressTitle: String = "Comprobante de domicilio"
  var proofOfAddressUrl: String? = nil
  var proofOfAddressFile: DocumentFile? = nil
  var onProofOfAddressInfo: (() -> Void)? = nil
  var onProofOfAddressPick: ((DocumentFile) -> Void)? = nil

  // Called with a message when a picked file cannot be read
  var onDocumentPickError: ((String) -> Void)? = nil

  // Called when a saved document fails to load, to refresh the signed URLs
  var onDocumentLoadFailure: (() async -> Void)? = nil

  // Confirmation
  var confirmationPrompt: String = "¿Esta información esta correcta y actualizada?"
  var confirmTitle: String = "Sí"
  var dismissTitle: String = "No"
  var doneTitle: String = "Terminar"
  var isConfirmationDisabled: Bool = false
  var onConfirm: () -> Void
  var onDismiss: () -> Void

  // Starts locked
  @State private var isEditing = false

  // Layout
  var horizontalPadding: CGFloat = 20
  var sectionSpacing: CGFloat = 20
  var bottomActionsSpacing: CGFloat = 24

  var body: some View {
    ZStack {
      Color("Background").ignoresSafeArea()

      ScrollView(showsIndicators: false) {
        VStack(alignment: .leading, spacing: sectionSpacing) {
          PageHeader(title: title, backAction: onBack)

          formFields
            .disabled(!isEditing)
            .allowsHitTesting(isEditing)

          ConfirmationActions(
            prompt: confirmationPrompt,
            onConfirm: onConfirm,
            onDismiss: unlockForEditing,
            confirmTitle: isEditing ? doneTitle : confirmTitle,
            dismissTitle: dismissTitle,
            showsPrompt: !isEditing,
            showsDismiss: !isEditing,
            isDisabled: isConfirmationDisabled
          )
          .padding(.top, bottomActionsSpacing - sectionSpacing)
        }
        .padding(.horizontal, horizontalPadding)
        .padding(.vertical, 16)
      }
    }
  }

  // Form fields
  private var formFields: some View {
    VStack(alignment: .leading, spacing: sectionSpacing) {
      LabeledTextField(
        title: firstNameTitle,
        placeholder: firstNamePlaceholder,
        errorMessage: firstNameError,
        text: $firstName
      )

      LabeledTextField(
        title: lastNameTitle,
        placeholder: lastNamePlaceholder,
        errorMessage: lastNameError,
        text: $lastName
      )

      DateButton(
        title: birthDateTitle,
        placeholder: birthDatePlaceholder,
        errorMessage: birthDateError,
        date: $birthDate
      )

      PhoneField(
        title: phoneTitle,
        placeholder: phonePlaceholder,
        countryCodes: phoneCountryCodes,
        errorMessage: phoneError,
        countryCode: $countryCode,
        phone: $phone
      )

      LabeledTextField(
        title: addressLine1Title,
        placeholder: addressLine1Placeholder,
        errorMessage: addressLine1Error,
        text: $addressLine1
      )

      LabeledTextField(
        title: addressLine2Title,
        placeholder: addressLine2Placeholder,
        errorMessage: addressLine2Error,
        text: $addressLine2
      )

      LabeledTextField(
        title: neighborhoodTitle,
        placeholder: neighborhoodPlaceholder,
        errorMessage: neighborhoodError,
        text: $neighborhood
      )

      LabeledTextField(
        title: zipCodeTitle,
        placeholder: zipCodePlaceholder,
        errorMessage: zipCodeError,
        text: $zipCode
      )

      Dropdown(
        title: countryTitle,
        prompt: countryPrompt,
        options: countryOptions,
        maxVisibleOptions: 5,
        selection: $country
      )

      Dropdown(
        title: stateTitle,
        prompt: statePrompt,
        options: stateOptions,
        maxVisibleOptions: 5,
        selection: $state
      )
      /*
       Clear the state only when the user picks
       a country whose states do not include it.
      */
      .onChange(of: country) { _, newCountry in
        guard isEditing else { return }
        let names = Country.first(name: newCountry ?? "", in: countries)?.stateNames ?? []
        if let state, names.contains(state) { return }
        state = nil
      }

      LabeledTextField(
        title: municipalityTitle,
        placeholder: municipalityPlaceholder,
        errorMessage: municipalityError,
        text: $municipality
      )

      FileCard(
        title: officialIdTitle,
        url: officialIdUrl,
        pickedFile: officialIdFile,
        infoAction: onOfficialIdInfo,
        onPick: onOfficialIdPick,
        onPickError: onDocumentPickError,
        onLoadFailure: onDocumentLoadFailure
      )

      FileCard(
        title: proofOfAddressTitle,
        url: proofOfAddressUrl,
        pickedFile: proofOfAddressFile,
        infoAction: onProofOfAddressInfo,
        onPick: onProofOfAddressPick,
        onPickError: onDocumentPickError,
        onLoadFailure: onDocumentLoadFailure
      )
    }
  }

  // Unlocks the fields when the user says the information is not correct
  private func unlockForEditing() {
    isEditing = true
    onDismiss()
  }
}

#Preview {
  PresubmissionTemplate(
    onBack: { print("Back") },
    firstName: .constant(""),
    lastName: .constant(""),
    birthDate: .constant(nil),
    countryCode: .constant("+52"),
    phone: .constant(""),
    addressLine1: .constant(""),
    addressLine2: .constant(""),
    neighborhood: .constant(""),
    zipCode: .constant(""),
    countries: [],
    country: .constant(nil),
    state: .constant(nil),
    municipality: .constant(""),
    onConfirm: { print("Terminar") },
    onDismiss: { print("No") }
  )
}
