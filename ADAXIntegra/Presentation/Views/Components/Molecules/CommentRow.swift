//
//  CommentRow.swift
//  ADAXIntegra
//
//  Created by Oscar Alexander Vilchis Soto on 07/10/26.
//
//  Molecule representing a single comment item card (US B-02).
//

import SwiftUI

struct CommentRow: View {
    let comment: Comment
    let onDeleteTapped: (() -> Void)?

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                // User icon and full name
                Image(systemName: "person.circle.fill")
                    .foregroundColor(Color("PrimaryAdax"))
                    .font(.system(size: 18))

                Text(comment.author?.fullName ?? "Usuario")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.primary)

                Spacer()

                // Time label
                if let time = comment.timeSent {
                    Text(comment.formattedTime)
                        .font(.system(size: 11))
                        .foregroundColor(.gray)
                }

                // Delete button
                if let onDelete = onDeleteTapped {
                    Button(action: onDelete) {
                        Image(systemName: "trash")
                            .font(.system(size: 12))
                            .foregroundColor(.red.opacity(0.7))
                    }
                    .padding(.leading, 4)
                }
            }

            // Comment text body
            Text(comment.content ?? "")
                .font(.system(size: 14))
                .foregroundColor(Color.primary.opacity(0.85))
                .lineSpacing(3)
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(UIColor.systemGray6).opacity(0.5))
        .cornerRadius(12)
    }
}

#Preview {
    CommentRow(
        comment: Comment(
            id: "1",
            caseId: "c1",
            content: "Se le brindó asesoría jurídica inicial y se agendó cita para seguimiento.",
            timeSent: "Hace 2 días",
            author: CommentAuthor(userId: "u1", name: "Lic. María", lastName: "González")
        ),
        onDeleteTapped: { print("Delete tapped") }
    )
    .padding()
}
