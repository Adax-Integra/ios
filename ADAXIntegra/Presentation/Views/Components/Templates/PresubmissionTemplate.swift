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

  // Form values and the error message of each field
  @Binding var form: PreSubmissionModel
  var errors = PreSubmissionErrors()

  // First name
  var firstNameTitle: String = "Nombre"
  var firstNamePlaceholder: String = "Escribe tu nombre..."

  // Last name
  var lastNameTitle: String = "Apellido(s)"
  var lastNamePlaceholder: String = "Escribe tu(s) apellido(s)..."

  // Birth date
  var birthDateTitle: String = "Fecha de nacimiento"
  var birthDatePlaceholder: String = "Selecciona tu fecha..."

  // Phone
  var phoneTitle: String = "Teléfono celular"
  var phonePlaceholder: String = "Tu número aquí..."

  // Address line 1
  var addressLine1Title: String = "Dirección línea 1"
  var addressLine1Placeholder: String = "Calle y número..."

  // Address line 2
  var addressLine2Title: String = "Dirección línea 2"
  var addressLine2Placeholder: String = "Interior..."

  // Neighborhood
  var neighborhoodTitle: String = "Colonia"
  var neighborhoodPlaceholder: String = "Escribe tu colonia..."

  // Zip code
  var zipCodeTitle: String = "Código postal"
  var zipCodePlaceholder: String = "Tu código postal..."

  // Country / State
  var countryTitle: String = "País"
  var countryPrompt: String = "Selecciona tu país..."
  var countries: [Country]

  var stateTitle: String = "Estado"
  var statePrompt: String = "Selecciona tu estado..."

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
    Country.first(name: form.country ?? "", in: countries)?.stateNames ?? []
  }

  // Municipality
  var municipalityTitle: String = "Ciudad / Municipio"
  var municipalityPlaceholder: String = "Tu ciudad o municipio aquí..."

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

      /*
       A ScrollView cannot scroll by itself from code. ScrollViewReader gives us
       the proxy, which we use to scroll back to the top when the user presses "No"
      */
      ScrollViewReader { proxy in
        ScrollView(showsIndicators: false) {
          VStack(alignment: .leading, spacing: sectionSpacing) {
            PageHeader(title: title, backAction: onBack)
              // The id is what proxy.scrollTo looks for to know where to scroll
              .id(Self.topAnchor)

            formFields
              .disabled(!isEditing)
              .allowsHitTesting(isEditing)

            ConfirmationActions(
              prompt: confirmationPrompt,
              onConfirm: onConfirm,
              // The proxy only exists inside ScrollViewReader, so it is passed to the function
              onDismiss: { unlockForEditing(scrollingWith: proxy) },
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
  }

  // Form fields
  private var formFields: some View {
    VStack(alignment: .leading, spacing: sectionSpacing) {
      LabeledTextField(
        title: firstNameTitle,
        placeholder: firstNamePlaceholder,
        errorMessage: errors.firstName,
        text: $form.firstName
      )

      LabeledTextField(
        title: lastNameTitle,
        placeholder: lastNamePlaceholder,
        errorMessage: errors.lastName,
        text: $form.lastName
      )

      DateEntry(
        title: birthDateTitle,
        placeholder: birthDatePlaceholder,
        errorMessage: errors.birthDate,
        date: $form.birthDate
      )

      PhoneField(
        title: phoneTitle,
        placeholder: phonePlaceholder,
        countryCodes: phoneCountryCodes,
        errorMessage: errors.phone,
        countryCode: $form.countryCode,
        phone: $form.phone
      )

      LabeledTextField(
        title: addressLine1Title,
        placeholder: addressLine1Placeholder,
        errorMessage: errors.addressLine1,
        text: $form.addressLine1
      )

      // Optional, so it never shows an error
      LabeledTextField(
        title: addressLine2Title,
        placeholder: addressLine2Placeholder,
        text: $form.addressLine2
      )

      LabeledTextField(
        title: neighborhoodTitle,
        placeholder: neighborhoodPlaceholder,
        errorMessage: errors.neighborhood,
        text: $form.neighborhood
      )

      LabeledTextField(
        title: zipCodeTitle,
        placeholder: zipCodePlaceholder,
        keyboardType: .numberPad,
        maxLength: 5,
        errorMessage: errors.zipCode,
        text: Binding(
          get: { form.zipCode },
          set: { form.zipCode = $0.filter(\.isNumber) }
        )
      )

      Dropdown(
        title: countryTitle,
        prompt: countryPrompt,
        options: countryOptions,
        maxVisibleOptions: 5,
        selection: $form.country
      )

      Dropdown(
        title: stateTitle,
        prompt: statePrompt,
        options: stateOptions,
        maxVisibleOptions: 5,
        // The states come from the country, so there are none until one is picked
        isDisabled: stateOptions.isEmpty,
        selection: $form.state
      )
      /*
       Clear the state only when the user picks
       a country whose states do not include it.
      */
      .onChange(of: form.country) { _, newCountry in
        guard isEditing else { return }
        let names = Country.first(name: newCountry ?? "", in: countries)?.stateNames ?? []
        if let state = form.state, names.contains(state) { return }
        form.state = nil
      }

      LabeledTextField(
        title: municipalityTitle,
        placeholder: municipalityPlaceholder,
        errorMessage: errors.municipality,
        text: $form.municipality
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

  // Id of the header, the scroll target to bring the user back to the first field
  private static let topAnchor = "presubmission-top"

  /*
   Unlocks the fields when the user says the information is not correct
   and scrolls to the top so editing starts from the first field
  */
  private func unlockForEditing(scrollingWith proxy: ScrollViewProxy) {
    isEditing = true
    /*
     Without the proxy the form would stay where the user was, usually at the bottom
     next to the buttons, and the first field would be out of sight
    */
    withAnimation { proxy.scrollTo(Self.topAnchor, anchor: .top) }
    onDismiss()
  }
}

#Preview {
  PresubmissionTemplate(
    onBack: { print("Back") },
    form: .constant(PreSubmissionModel()),
    countries: [],
    onConfirm: { print("Terminar") },
    onDismiss: { print("No") }
  )
}
