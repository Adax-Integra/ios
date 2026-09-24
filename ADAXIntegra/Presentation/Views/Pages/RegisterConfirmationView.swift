//
//  RegisterConfirmationView.swift
//  ADAXIntegra
//
//  Created by Cristhian Viery Maida Suarez on 24/09/26.
//

import SwiftUI

struct RegisterConfirmationView: View {
    var recordId: String?
    var onDone: () -> Void
    
    var body: some View {
        ZStack {
            Color("Background").ignoresSafeArea()
            
            VStack(spacing: 20) {
                Spacer()
                
                ZStack {
                    Circle()
                        .fill(Color("PrimaryAdax"))
                        .frame(width: 140, height: 140)
                    Image(systemName: "checkmark")
                        .font(.system(size: 57, weight: .bold))
                        .foregroundStyle(.white)
                }
                
                Text("¡Usuaria registrada correctamente!")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(Color("OnBackground"))
                
                Text("El expediente se creó correctamente. Se envió una contraseña temporal al correo de la externa")
                    .font(.system(size: 15))
                    .foregroundStyle(Color("InsideTextAndIcons"))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
                
                if let recordId {
                    Text("Folio del expediente: \(recordId)")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(Color("InsideTextAndIcons"))
                }
                
                Spacer()
                
                PrimaryButton(title: "Listo", isDisabled: false, action: onDone)
                    .frame(maxWidth: .infinity, minHeight: 52, maxHeight: 52)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 24)
            }
        }
    }
}

#Preview {
    RegisterConfirmationView(recordId: "c1e7234c-dc8a-492a", onDone: {})
}
