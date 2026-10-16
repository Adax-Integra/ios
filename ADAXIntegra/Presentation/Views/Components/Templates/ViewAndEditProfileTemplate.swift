//
//  ViewAndEditProfileTemplate.swift
//  ADAXIntegra
//
//  Created by Eduardo Hernández Alonso on 15/10/26.
//

import SwiftUI

/*
 Template for the profile screen, the fields unlock when the user taps edit
 Address fields are only shown to external users
 */
struct ViewAndEditProfileTemplate: View {
  @Binding var name: String
  @Binding var lastName: String
  @Binding var countryCode: String?
  @Binding var phone: String
  @Binding var country: String?
  @Binding var state: String?
  @Binding var municipality: String

  var showsAddress: Bool
  var countryCodes: [String] = ["+52", "+1"]
  var countries: [String] = []
  var states: [String] = []

  var isEditing: Bool
  var isSaving: Bool = false

  let editAction: () -> Void
  let cancelAction: () -> Void
  let saveAction: () -> Void

  var body: some View {
    ZStack {
      Color("Background")
        .ignoresSafeArea()

      ScrollView {
        VStack(alignment: .leading, spacing: 20) {
          LabeledTextField(title: "Nombre", placeholder: "Escribe aquí...", text: $name)

          LabeledTextField(
            title: "Apellidos", placeholder: "Escribe aquí...", text: $lastName)

          PhoneField(
            countryCodes: countryCodes,
            countryCode: $countryCode,
            phone: $phone
          )

          if showsAddress {
            Dropdown(
              title: "País",
              prompt: "Selecciona tu país",
              options: countries,
              selection: $country
            )

            Dropdown(
              title: "Estado",
              prompt: "Selecciona tu estado",
              options: states,
              selection: $state
            )

            LabeledTextField(
              title: "Municipio", placeholder: "Escribe aquí...", text: $municipality)
          }
        }
        .disabled(!isEditing)
        .animation(.easeInOut(duration: 0.2), value: isEditing)
        .padding(.horizontal, 24)
        .padding(.vertical, 20)
      }
      .safeAreaInset(edge: .bottom) {
        if isEditing {
          PrimaryButton(
            title: "Guardar cambios",
            isDisabled: isSaving,
            action: saveAction
          )
          .padding(.horizontal, 24)
          .padding(.bottom, 16)
        }
      }
    }
    .ignoresSafeArea(.keyboard, edges: .bottom)
    .navigationTitle("Tu Perfil")
    .toolbar {
      ToolbarItem(placement: .topBarTrailing) {
        Button(action: isEditing ? cancelAction : editAction) {
          Image(systemName: isEditing ? "xmark" : "square.and.pencil")
            .foregroundColor(Color("OnBackground"))
        }
      }
    }
  }
}

#Preview("Externa") {
  NavigationStack {
    ViewAndEditProfileTemplate(
      name: .constant("Ana"),
      lastName: .constant("López"),
      countryCode: .constant("+52"),
      phone: .constant("4461253367"),
      country: .constant("México"),
      state: .constant(nil),
      municipality: .constant(""),
      showsAddress: true,
      countries: ["México"],
      states: ["Querétaro", "Jalisco"],
      isEditing: false,
      editAction: {},
      cancelAction: {},
      saveAction: {}
    )
  }
}

#Preview("Interna") {
  NavigationStack {
    ViewAndEditProfileTemplate(
      name: .constant(""),
      lastName: .constant(""),
      countryCode: .constant("+52"),
      phone: .constant(""),
      country: .constant(nil),
      state: .constant(nil),
      municipality: .constant(""),
      showsAddress: false,
      isEditing: true,
      editAction: {},
      cancelAction: {},
      saveAction: {}
    )
  }
}
