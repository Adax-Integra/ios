//
//  DateButton.swift
//  ADAXIntegra
//
//  Created by Eduardo Hernández Alonso on 01/10/26.
//

import SwiftUI

// Molecule for date, opens the system date picker.
struct DateButton: View {
  var title: String = "Fecha"
  var placeholder: String = "Selecciona tu fecha..."

  var customWidth: CGFloat = .infinity
  var customHeight: CGFloat = 50

  var errorMessage: String? = nil

  @Binding var date: Date?

  @State private var isPresented = false

  private var selection: Binding<Date> {
    Binding(
      get: { date ?? Date() },
      set: { date = $0 }
    )
  }

  private var label: String {
    date?.formatted(date: .numeric, time: .omitted) ?? placeholder
  }

  var body: some View {
    VStack(alignment: .leading, spacing: 6) {
      if !title.isEmpty {
        FieldLabel(title)
      }

      SurfaceCard(
        borderColor: errorMessage != nil ? Color("Error") : nil,
        borderWidth: errorMessage != nil ? 1 : 0
      ) {
        // Not a Button: a disabled Button is dimmed by SwiftUI and the date looked grayer
        // than the other fields when the form is locked
        Text(label)
          .font(.system(size: 16, weight: .regular))
          .foregroundColor(
            date == nil
              ? Color("InsideTextAndIcons").opacity(0.6)
              : Color("OnBackground")
          )
          .padding(.horizontal, 18)
          .frame(
            maxWidth: customWidth,
            minHeight: customHeight,
            maxHeight: customHeight,
            alignment: .leading
          )
          .contentShape(Rectangle())
          .onTapGesture { isPresented = true }
      }

      if let errorMessage {
        FieldErrorLabel(errorMessage)
      }
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .sheet(isPresented: $isPresented) {
      DatePicker(title, selection: selection, displayedComponents: .date)
        .datePickerStyle(.graphical)
        .labelsHidden()
        .padding()
        .presentationDetents([.medium])
        .presentationDragIndicator(.visible)
    }
  }
}

#Preview {
  ZStack {
    Color("Background").ignoresSafeArea()

    VStack(spacing: 16) {
      DateButton(date: .constant(nil))

      DateButton(
        date: .constant(
          Calendar.current.date(from: DateComponents(year: 1994, month: 6, day: 15))
        )
      )

      DateButton(
        errorMessage: "Este campo es obligatorio.",
        date: .constant(nil)
      )
    }
    .padding()
  }
}
