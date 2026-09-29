//
//  CaseForm.swift
//  ADAXIntegra
//
//  Created by Gerardo Martínez Carbajal on 23/09/26.
//

import SwiftUI

// Organism with the three fields of a new case. It holds no state:
// the values live in NewCaseViewModel and arrive as bindings
struct CaseForm: View {
  @Binding var caseDescription: String
  @Binding var helpDetails: String
  @Binding var hasExternalSupport: Bool

  let onExternalSupportInfoTapped: () -> Void

  var body: some View {
    VStack(alignment: .leading, spacing: 20) {
      LabeledTextField(
        title: "Descripción del caso",
        placeholder: "Escribe la descripción de tu caso aquí...",
        customHeight: 150,
        maxLength: CaseFieldLimits.maxCharacters,
        text: $caseDescription
      )

      LabeledTextField(
        title: "¿Qué ayuda esperas recibir?",
        placeholder: "Cuéntanos qué tipo de ayuda esperas recibir...",
        customHeight: 120,
        maxLength: CaseFieldLimits.maxHelpDetailsCharacters,
        text: $helpDetails
      )

      HStack(spacing: 0) {
        FieldLabel("¿Cuentas con apoyo externo?")
        InfoButton(size: 16, action: onExternalSupportInfoTapped)
        Spacer()
        Toggle("", isOn: $hasExternalSupport)
          .labelsHidden()
          .tint(Color("PrimaryAdax"))
      }
    }
  }
}

#Preview {
  ZStack {
    Color("Background").ignoresSafeArea()

    CaseForm(
      caseDescription: .constant(""),
      helpDetails: .constant(""),
      hasExternalSupport: .constant(false),
      onExternalSupportInfoTapped: {}
    )
    .padding()
  }
}
