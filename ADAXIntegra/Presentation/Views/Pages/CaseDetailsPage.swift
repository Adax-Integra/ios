//
//  CaseDetailsPage.swift
//  ADAXIntegra
//
//  Created by Oscar Alexander Vilchis Soto on 02/10/26.
//
// General page for US v-11 Get Case details, where an internal user can see de details of a particular case and may close the case 

import SwiftUI

struct CaseDetailsPage: View {
    @State private var showCloseModal = false
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            CaseDetailsTemplate(
                caseNumber: "2026-0847-C2",
                status: "Abierto",
                onBack: {
                    dismiss()
                },
                content: {
                    RecordCaseSummary(
                        userName: "María García López",
                        recordId: "EXP-2024-1024",
                        lastModified: "20/Mar/2024",
                        createdAt: "10/Ene/2024",
                        onEditTapped: { print("Edit tapped") }
                    )
                    
                    CaseInfoCard(
                      //  violenceType: "Acoso cibernético",
                      //  location: "San Juan del Río",
                        hasLawyer: true
                    )
                    
                    CaseDescriptionCard(
                        description: "Se realizó la segunda sesión de acompañamiento psicológico. La beneficiaria muestra avances en el manejo de ansiedad. Se recomienda continuar con sesiones semanales."
                    )
                },
                bottomActions: {
                    CloseCaseAction(
                        onCloseCaseTapped: {
                            withAnimation { showCloseModal = true }
                        },
                        onCancelTapped: {
                            dismiss()
                        }
                    )
                }
            )

            if showCloseModal {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation { showCloseModal = false }
                    }
                
                CloseCase(
                    onConfirm: {
                        print("Llamada al backend para cerrar caso")
                        withAnimation { showCloseModal = false }
                    },
                    onCancel: {
                        withAnimation { showCloseModal = false }
                    }
                )
            }
        }
    }
}

#Preview {
    CaseDetailsPage()
}
