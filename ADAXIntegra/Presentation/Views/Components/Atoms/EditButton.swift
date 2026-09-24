//
//  EditButton.swift
//
//
//  Created by Oscar Alexander Vilchis Soto on 24/09/26.
// Circular edit button  (redirects to US to edit the info of a case)for US v-11

import SwiftUI

struct EditButton: View {
  let action: () -> Void
  var body: some View {
    Button(action: action) {
      Image(systemName: "pencil")
        .font(.system(size: 24, weight: .bold))
        .foregroundColor(.white)
        .frame(width: 56, height: 56)
        .background(Color("PrimaryAdax"))
        .clipShape(Circle())
        .shadow(color: .black.opacity(0.3), radius: 6, x: 0, y: 4)
    }
    .buttonStyle(.plain)

  }
}

#Preview {
  ZStack {
    Color(UIColor.systemGray6).ignoresSafeArea()
    EditButton {
      print("Edit tapped")
    }
  }
}
