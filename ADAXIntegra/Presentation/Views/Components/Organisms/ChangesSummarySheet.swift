//
//  ChangesSummarySheet.swift
//  ADAXIntegra
//
//  Created by Gerardo Martínez Carbajal on 06/10/26.
//

import SwiftUI

// Organism shown before saving (G-07): only the fields that changed,
// and the notice the external user will receive
struct ChangesSummarySheet: View {
  let externalName: String
  let changes: [ExternalProfileChange]
  let reason: String
  let noticeText: String
  let isSaving: Bool
  let onConfirm: () -> Void
  let onCancel: () -> Void

  var body: some View {
    ScrollView(showsIndicators: false) {
      VStack(alignment: .leading, spacing: 18) {
        VStack(alignment: .leading, spacing: 4) {
          Text("Confirmar cambios")
            .font(.system(size: 22, weight: .bold))
            .foregroundColor(Color("OnBackground"))

          Text("Revisa los datos de \(externalName) antes de guardar.")
            .font(.system(size: 14))
            .foregroundColor(Color("InsideTextAndIcons"))
        }

        VStack(spacing: 10) {
          ForEach(changes) { change in
            ChangeRow(change: change)
          }
        }

        VStack(alignment: .leading, spacing: 6) {
          Text("MOTIVO")
            .font(.system(size: 12, weight: .semibold))
            .foregroundColor(Color("OnBackground"))

          Text(reason)
            .font(.system(size: 15))
            .foregroundColor(Color("OnBackground"))
        }

        Label("La externa autorizó este cambio", systemImage: "checkmark")
          .font(.system(size: 13))
          .foregroundColor(Color("InsideTextAndIcons"))

        Label(noticeText, systemImage: "envelope")
          .font(.system(size: 13))
          .foregroundColor(Color("InsideTextAndIcons"))

        VStack(spacing: 10) {
          PrimaryButton(
            customHeight: 20,
            title: "Confirmar y guardar",
            isDisabled: isSaving,
            action: onConfirm
          )

          SecondaryButton(
            title: "Regresar a editar",
            isDisabled: isSaving,
            action: onCancel
          )
        }
      }
      .padding(20)
      .padding(.top, 8)
    }
  }
}

#Preview {
  ChangesSummarySheet(
    externalName: "Sandra Pérez Ruiz",
    changes: [
      ExternalProfileChange(
        label: "Teléfono celular", oldValue: "+52 442 123 4567", newValue: "+52 442 987 6543"),
      ExternalProfileChange(label: "Colonia", oldValue: "Centro", newValue: "Jurica"),
    ],
    reason: "La usuaria se mudó y cambió de número de teléfono.",
    noticeText: "Se enviará un aviso a sp.ruiz@hotmail.com sin mostrar los datos nuevos.",
    isSaving: false,
    onConfirm: {},
    onCancel: {}
  )
}
