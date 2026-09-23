//
//  PresubmissionTemplate.swift
//  ADAXIntegra
//
//  Created by Eduardo Hernández Alonso on 22/09/26.
//

import SwiftUI

// Template for the "Verificar información" screen. Composes the following
// molecules into a scrollable layout:
//   - "PageHeader"          (title + back button)
//   - "LabeledTextField"    (first name)
//   - "LabeledTextField"    (last name)
//   - "PhoneField"          (country code + phone)
//   - "Dropdown"            (country)
//   - "Dropdown"            (state)
//   - "LabeledTextField"    (municipality)
//   - "FileCard"            (official ID)
//   - "FileCard"            (proof of address)
//   - "ConfirmationActions" (prompt + Sí / No buttons)
//
// Fields and document actions start locked. Only the back button and the
// Sí / No confirmation stay tappable. Tapping "No" unlocks the form so the
// user can correct the information. The confirm button then becomes
// "Terminar". Finishing the pre-submission tell us  whether any field actually
// changed, so the caller can skip an update when the data is the same as when
// the screen appeared.
//
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
  var lastNamePlaceholder: String = "Escribe tu apellido(s)..."
  @Binding var lastName: String
  var lastNameError: String? = nil

  // Phone
  var phoneTitle: String = "Teléfono celular"
  var phonePlaceholder: String = "Tu número aquí..."
  var countryCodes: [String] = ["+52", "+1"]
  @Binding var countryCode: String?
  @Binding var phone: String
  var phoneError: String? = nil

  // Country / State
  //
  // The "Estado" dropdown is driven by the currently selected country: its
  // options are the "states" array of the matching "Country" entry in
  // "countries". Defaults to the full "Country.all" catalog
  var countryTitle: String = "País"
  var countryPrompt: String = "Opción Seleccionada"
  var countries: [Country] = Country.all
  @Binding var country: String?

  var stateTitle: String = "Estado"
  var statePrompt: String = "Opción Seleccionada"
  @Binding var state: String?

  // State options are the states of the selected country
  private var stateOptions: [String] {
    Country.first(named: country ?? "", in: countries)?.states ?? []
  }

  // Municipality
  var municipalityTitle: String = "Ciudad / Municipio"
  var municipalityPlaceholder: String = "Tu texto aquí..."
  @Binding var municipality: String
  var municipalityError: String? = nil

  // Documents
  var officialIdTitle: String = "Identificación oficial"
  var officialIdImage: Image
  var onOfficialIdInfo: (() -> Void)? = nil

  var proofOfAddressTitle: String = "Comprobante de domicilio"
  var proofOfAddressImage: Image
  var onProofOfAddressInfo: (() -> Void)? = nil

  // Confirmation
  var confirmationPrompt: String = "¿Esta información esta correcta y actualizada?"
  var confirmTitle: String = "Sí"
  var dismissTitle: String = "No"
  var doneTitle: String = "Terminar"
  var isConfirmationDisabled: Bool = false
  // Called when the user finishes. "hasChanges" is false when every field
  // still matches the values shown on appear, including a "Terminar" tap
  // after opening edit mode and changing nothing.
  var onConfirm: (_ hasChanges: Bool) -> Void
  var onDismiss: () -> Void

  // Starts locked. "No" changes this so the user can edit the reviewed data.
  @State private var isEditing = false
  // Compared on confirm so an unchanged review
  // does not look like an update.
  @State private var original: ReviewedInfo?

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
            onConfirm: finishReview,
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
    .onAppear(perform: captureOriginalIfNeeded)
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

      PhoneField(
        title: phoneTitle,
        placeholder: phonePlaceholder,
        countryCodes: countryCodes,
        errorMessage: phoneError,
        countryCode: $countryCode,
        phone: $phone
      )

      Dropdown(
        title: countryTitle,
        prompt: countryPrompt,
        options: countries.map(\.name),
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
      // Watches country binding and calls the closure when the value changes.
      // The two parameters (_, _) are the old and new values, respectively.
      // We don't need to use the old value, so we use _ as a placeholder.
      .onChange(of: country) { _, _ in
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
        image: officialIdImage,
        infoAction: onOfficialIdInfo
      )

      FileCard(
        title: proofOfAddressTitle,
        image: proofOfAddressImage,
        infoAction: onProofOfAddressInfo
      )
    }
  }

  // Current information
  private var currentInfo: ReviewedInfo {
    ReviewedInfo(
      firstName: firstName,
      lastName: lastName,
      countryCode: countryCode,
      phone: phone,
      country: country,
      state: state,
      municipality: municipality
    )
  }

  // Functions to manage the editing state and the review process
  private var hasChanges: Bool {
    guard let original else { return false }
    return original != currentInfo
  }

  private func captureOriginalIfNeeded() {
    guard original == nil else { return }
    original = currentInfo
  }

  private func unlockForEditing() {
    isEditing = true
    onDismiss()
  }

  private func finishReview() {
    onConfirm(hasChanges)
  }
}

// Create a copy of the reviewed fields. Documents are display-only on this screen,
// so they are not part of the comparison.
// Equatable is used to compare the original and current information.
private struct ReviewedInfo: Equatable {
  var firstName: String
  var lastName: String
  var countryCode: String?
  var phone: String
  var country: String?
  var state: String?
  var municipality: String
}

#Preview {
  PresubmissionTemplate(
    onBack: { print("Back") },
    firstName: .constant(""),
    lastName: .constant(""),
    countryCode: .constant("+52"),
    phone: .constant(""),
    country: .constant(nil),
    state: .constant(nil),
    municipality: .constant(""),
    officialIdImage: Image("placeholderImage"),
    proofOfAddressImage: Image("placeholderImage"),
    onConfirm: { hasChanges in print(hasChanges ? "Terminar, con cambios" : "Sin cambios") },
    onDismiss: { print("No") }
  )
}
