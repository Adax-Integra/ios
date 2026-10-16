//
//  VerificationBanner.swift
//  ADAXIntegra
//
//  Created by Cristhian Viery Maida Suarez on 16/10/26.
//

import SwiftUI

struct VerificationBanner: View {
    let status: VerificationStatus
    let onUpload: () -> Void
    
    var body: some View {
        SurfaceCard(cornerRadius: 20, borderColor: status.color.opacity(0.4), borderWidth: 1) {
            VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 10) {
                    Image(systemName: status.icon)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundStyle(status.color)
                    
                    Text(title)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(Color("OnBackground"))
                }
                
                Text(message)
                    .font(.system(size: 14))
                    .foregroundStyle(Color("InsideTextAndIcons"))
                    .fixedSize(horizontal: false, vertical: true)
                
                if status == .noVerificado {
                    PrimaryButton(title: "Subir documentos", isDisabled: false) {
                        onUpload()
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(16)
        }
    }
    
    private var title: String {
        switch status {
        case .noVerificado: return "Verifica tu identidad"
        case .enRevision: return "Documentos en revisión"
        case .verificado: return "Cuenta verificada"
        
        }
    }
    
    private var message: String {
        switch status {
        case .noVerificado:
            return "Tu cuenta aún no está verificada. Sube tu identificación (INE) y tu comprobante de domicilio para poder crear tu caso."
        case .enRevision:
            return "Recibimos tus documentos y están en revisión. Te avisaremos cuando tu cuenta quede verificada."
        case .verificado:
            return "Tu identidad ya fue verificada."
        }
    }
}
