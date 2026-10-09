//
//  NumberBadge.swift
//  ADAXIntegra
//
//  Created by Paco Arreola on 02/10/26.
//

import SwiftUI

// Circle with a number, used to list the privacy notice sections
struct NumberBadge: View {
  let number: Int
  var size: CGFloat = 36

  var body: some View {
    Text("\(number)")
      .font(.system(size: 15, weight: .semibold))
      .foregroundColor(Color("PrimaryAdax"))
      .frame(width: size, height: size)
      .background(Color("SecondaryAdax"))
      .clipShape(Circle())
  }
}

#Preview {
  NumberBadge(number: 1)
}
