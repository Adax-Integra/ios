//
//  HelperText.swift
//  ADAXIntegra
//
//  Created by Nicolas Bravo Miguel on 06/10/26.
//


import SwiftUI

// Small tex shown under the field as a hit of the error

struct HelperText: View {
    let text: String
    var isError: Bool = false
    
    
    var body: some View {
        Text(text.uppercased())
            .font(.system(size: 10, weight: .medium))
            .foregroundColor(isError ? Color("Error") : .secondary)
            .padding(.leading, 4)
    }
}

#Preview {
    VStack(alignment: .leading, spacing: 12) {
        HelperText(text: "La contraseña debe de ser de 8 caracteres como mínimo")
        HelperText(text: "Las contraseñas no coinciden", isError: true)
    }
    .padding()
    .background(Color("Background"))
}
