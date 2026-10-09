//
//  FormActions
//  ADAXIntegra
//
//  Created by Nicolas Bravo Miguel on 01/10/26.
//

import SwiftUI

struct FormActions: View {
  var primaryTitle: String = "Guardar"
  var secondaryTitle: String = "Cancelar"
  var isPrimaryDisabled: Bool = false
  var onPrimary: () -> Void
  var onSecondary: () -> Void

  var body: some View {
    HStack(spacing: 12) {
      PrimaryButton(
        customHeight: 20, title: primaryTitle, isDisabled: isPrimaryDisabled, action: onPrimary)

      SecondaryButton(
        customHeight: 20, title: secondaryTitle, isDisabled: false, action: onSecondary)
    }
  }
}

#Preview {
  VStack(spacing: 24) {
    FormActions(
      onPrimary: { print("Guardar") },
      onSecondary: { print("Cancelar") }
    )
  }
  .padding()
  .background(Color("Background"))
}
