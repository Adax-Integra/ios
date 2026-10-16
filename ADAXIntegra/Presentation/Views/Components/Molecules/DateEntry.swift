//
//  DateEntry.swift
//  ADAXIntegra
//
//  Created by Eduardo Hernández Alonso on 01/10/26.
//

import SwiftUI

// Molecule for date, opens the system date picker.
struct DateEntry: View {
  var title: String = "Fecha"
  var placeholder: String = "Selecciona tu fecha..."

  var customWidth: CGFloat = .infinity
  var customHeight: CGFloat = 50

  var errorMessage: String? = nil

  @Binding var date: Date?

  @State private var isPresented = false
  @State private var sheetDate = Date()

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
          .onTapGesture {
            sheetDate = date ?? Date()
            isPresented = true
          }
      }

      if let errorMessage {
        FieldErrorLabel(errorMessage)
      }
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .sheet(isPresented: $isPresented) {
      NavigationStack {
        VStack {
          DatePicker("", selection: $sheetDate, displayedComponents: .date)
            .datePickerStyle(.graphical)
            .labelsHidden()
            .tint(Color("PrimaryAdax"))
            .padding()
          Spacer()
        }
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
          ToolbarItem(placement: .cancellationAction) {
            Button("Cancelar") { isPresented = false }
          }
          ToolbarItem(placement: .confirmationAction) {
            Button("Listo") {
              date = sheetDate
              isPresented = false
            }
            .fontWeight(.semibold)
          }
        }
      }
      .tint(Color("PrimaryAdax"))
      .presentationDetents([.medium])
    }
  }
}

#Preview {
  ZStack {
    Color("Background").ignoresSafeArea()

    VStack(spacing: 16) {
      DateEntry(date: .constant(nil))

      DateEntry(
        date: .constant(
          Calendar.current.date(from: DateComponents(year: 1994, month: 6, day: 15))
        )
      )

      DateEntry(
        errorMessage: "Este campo es obligatorio.",
        date: .constant(nil)
      )
    }
    .padding()
  }
}
