//
//  TimeEntry.swift
//  ADAXIntegra
//
//  Created by Paco Arreola on 15/10/26.
//

import SwiftUI

// Molecule for time, opens the system time picker.
struct TimeEntry: View {
  var title: String = "Hora"
  var placeholder: String = "Selecciona la hora..."

  var customWidth: CGFloat = .infinity
  var customHeight: CGFloat = 50

  var errorMessage: String? = nil

  @Binding var time: Date?

  @State private var isPresented = false

  private var selection: Binding<Date> {
    Binding(
      get: { time ?? Date() },
      set: { time = $0 }
    )
  }

  private var label: String {
    time?.formatted(date: .omitted, time: .shortened) ?? placeholder
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
        HStack {
          Text(label)
            .font(.system(size: 16, weight: .regular))
            .foregroundColor(
              time == nil
                ? Color("InsideTextAndIcons").opacity(0.6)
                : Color("OnBackground")
            )

          Spacer()

          Icon(systemName: "clock")
        }
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
      DatePicker(title, selection: selection, displayedComponents: .hourAndMinute)
        .datePickerStyle(.wheel)
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
      HStack(spacing: 16) {
        TimeEntry(
          title: "Hora inicio",
          time: .constant(Calendar.current.date(from: DateComponents(hour: 10, minute: 0)))
        )
        TimeEntry(
          title: "Hora fin",
          time: .constant(Calendar.current.date(from: DateComponents(hour: 11, minute: 30)))
        )
      }

      TimeEntry(time: .constant(nil))

      TimeEntry(
        errorMessage: "Este campo es obligatorio.",
        time: .constant(nil)
      )
    }
    .padding()
  }
}
