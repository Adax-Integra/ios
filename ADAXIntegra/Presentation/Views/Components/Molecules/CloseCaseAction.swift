//
//  CloseCaseAction.swift
//
//  Created by Oscar Alexander Vilchis Soto on 01/10/26.
//
// Molecule that states wether a user wants to close the case in particular or cancel and go back to records

import SwiftUI

struct CloseCaseAction: View {
    let onCloseCaseTapped: () -> Void
    let onCancelTapped: () -> Void

    var body: some View {
        HStack(spacing: 16) {
            PrimaryButton(
                    customWidth: 150,
                    customHeight: 23,
                    title: "Cerrar Caso",
                    isDisabled: false,
                    action: onCloseCaseTapped
                )
            
            SecondaryButton(
                customWidth: 163,
                customHeight: 50,
                title: "Cancelar",
                isDisabled: false,
                action: onCancelTapped
            )
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 16) 
    }
}

#Preview {
    ZStack {
        Color(UIColor.systemGray6).ignoresSafeArea()
        
        CloseCaseAction(
            onCloseCaseTapped: { print("Abrir modal de confirmación") },
            onCancelTapped: { print("Regresar a expedientes") }
        )
    }
}
