//
//  CloseCase.swift
//
//  Created by Oscar Alexander Vilchis Soto on 01/10/26.
//
// Popup alert abpout closing a case for US v-11

import SwiftUI

struct CloseCase: View {
    let onConfirm: () -> Void
    let onCancel: () -> Void

    var body: some View {
        VStack(spacing: 24) {
            ZStack {
                Circle()
                    .fill(Color("PrimaryAdax"))
                    .frame(width: 80, height: 80)
                
                Image(systemName: "exclamationmark")
                    .font(.system(size: 40, weight: .bold))
                    .foregroundColor(.white)
            }
            .padding(.top, 8)
            
            VStack(spacing: 12) {
                Text("¿Deseas cerrar este caso?")
                    .font(.system(size: 20, weight: .bold))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.primary)
                
                Text("El caso dejará de mostrarse cómo\nabierto.")
                    .font(.system(size: 14))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.gray)
            }
            
            // We call the buttons for primary and secondary button atom
            HStack(spacing: 12) {
                PrimaryButton(
                    customWidth: 280,
                    customHeight: 20,
                    title: "Sí, cerrar",
                    isDisabled: false,
                    action: onConfirm
                )
                
                SecondaryButton(
                    customWidth: 280,
                    customHeight: 48,
                    title: "Cancelar",
                    isDisabled: false,
                    action: onCancel
                )
            }
            .padding(.top, 8)
        }
        .padding(24)
        .background(Color.white)
        .cornerRadius(24)
        .shadow(color: .black.opacity(0.15), radius: 10, x: 0, y: 4)
        .padding(.horizontal, 32)
    }
}

#Preview {
    ZStack {
        Color.black.opacity(0.4).ignoresSafeArea()
        
        CloseCase(
            onConfirm: { print("Confirmar tap") },
            onCancel: { print("Cancelar tap") }
        )
    }
}
