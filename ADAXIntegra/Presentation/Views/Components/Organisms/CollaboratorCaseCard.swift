//
//  CollaboratorCaseCard.swift
//  ADAXIntegra
//
//  Created by Oscar Alexander Vilchis Soto on 17/10/26.
//
// Organism that displays the cases assigned to a collaborator


import SwiftUI

struct CollaboratorCaseCard: View {
    let caseNumber: String
    let externalName: String
    let violenceText: String
    let stateText: String
    let isOpen: Bool
    let updatedAtText: String

    private var statusColor: Color {
        isOpen
            ? Color("StatusCompleted")
            : Color("InsideTextAndIcons")
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {

            // Case number and status
            HStack(alignment: .center) {
                Text(caseNumber)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(Color("OnBackground"))

                Spacer(minLength: 8)

                statusBadge
            }

            // External  name
            Text(externalName)
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(Color("OnBackground"))
                .fixedSize(horizontal: false, vertical: true)

            // Violence types
            HStack(alignment: .top, spacing: 6) {
                Image(systemName: "exclamationmark.shield")
                    .frame(width: 16)

                Text("Violencia: \(violenceText)")
                    .fixedSize(horizontal: false, vertical: true)
            }
            .font(.system(size: 13))
            .foregroundStyle(Color("InsideTextAndIcons"))

            // Last update
            HStack(spacing: 6) {
                Image(systemName: "clock")

                Text("Última actualización: \(updatedAtText)")
                    .fixedSize(horizontal: false, vertical: true)
            }
            .font(.system(size: 13))
            .foregroundStyle(Color("InsideTextAndIcons"))
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color.white)
                .shadow(
                    color: Color.black.opacity(0.07),
                    radius: 6,
                    x: 0,
                    y: 3
                )
        )
    }

    // Status badge
    private var statusBadge: some View {
        Text(stateText)
            .font(.system(size: 12, weight: .semibold))
            .foregroundStyle(
                isOpen ? Color("OnBackground") : .white
            )
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(
                Capsule()
                    .fill(
                        isOpen
                            ? statusColor.opacity(0.2)
                            : statusColor
                    )
            )
            .fixedSize()
    }
}

#Preview {
    ZStack {
        Color("Background")
            .ignoresSafeArea()

        VStack(spacing: 16) {
            CollaboratorCaseCard(
                caseNumber: "#########",
                externalName: "#########",
                violenceText: "#########",
                stateText: "Abierto",
                isOpen: true,
                updatedAtText: "########"
            )

            CollaboratorCaseCard(
                caseNumber: "#########",
                externalName: "#####",
                violenceText: "#######",
                stateText: "##########",
                isOpen: false,
                updatedAtText: "######"
            )
        }
        .padding()
    }
}
