//
//  CreateEventForm.swift
//  ADAXIntegra
//
//  Created by Paco Arreola on 15/10/26.
//

import SwiftUI

struct CreateEventForm: View {
  @Binding var title: String
  @Binding var startDate: Date?
  @Binding var endDate: Date?
  @Binding var startTime: Date?
  @Binding var endTime: Date?
  @Binding var modality: String?
  @Binding var location: String
  @Binding var link: String
  @Binding var countryCode: String?
  @Binding var phone: String
  @Binding var description: String
  @Binding var notes: String

  let image: DocumentFile?
  let onPickImage: (DocumentFile) -> Void
  var onImageError: ((String) -> Void)? = nil

  var modalities: [String] = ["Presencial", "Virtual", "Mixto"]
  var countryCodes: [String] = ["+52"]

  var titleError: String? = nil
  var startDateError: String? = nil
  var endDateError: String? = nil
  var startTimeError: String? = nil
  var endTimeError: String? = nil
  var locationError: String? = nil
  var linkError: String? = nil
  var phoneError: String? = nil
  var descriptionError: String? = nil
  var notesError: String? = nil
  var imageError: String? = nil

  // The backend only requires the place for in-person events
  private var locationTitle: String {
    modality == "Presencial" ? "Lugar" : "Lugar (opcional)"
  }

  var body: some View {
    VStack(alignment: .leading, spacing: 16) {
      LabeledTextField(
        title: "Título del evento",
        placeholder: "Ej. Reunión de equipo",
        maxLength: 150,
        errorMessage: titleError,
        text: $title
      )

      HStack(alignment: .top, spacing: 16) {
        DateEntry(
          title: "Fecha inicio",
          placeholder: "Fecha",
          errorMessage: startDateError,
          date: $startDate
        )

        DateEntry(
          title: "Fecha fin",
          placeholder: "Fecha",
          errorMessage: endDateError,
          date: $endDate
        )
      }

      HStack(alignment: .top, spacing: 16) {
        TimeEntry(
          title: "Hora inicio",
          placeholder: "Hora",
          errorMessage: startTimeError,
          time: $startTime
        )

        TimeEntry(
          title: "Hora fin",
          placeholder: "Hora",
          errorMessage: endTimeError,
          time: $endTime
        )
      }

      Dropdown(
        title: "Modalidad",
        prompt: "Selecciona la modalidad",
        options: modalities,
        selection: $modality
      )

      LabeledTextField(
        title: locationTitle,
        placeholder: "Ej. Oficinas ADAX",
        maxLength: 200,
        errorMessage: locationError,
        text: $location
      )

      LabeledTextField(
        title: "Link (opcional)",
        placeholder: "https://meet.google.com/...",
        keyboardType: .URL,
        maxLength: 500,
        errorMessage: linkError,
        text: $link
      )

      PhoneField(
        title: "Teléfono (opcional)",
        placeholder: "55 1234 5678",
        countryCodes: countryCodes,
        countryCodeWidth: 120,
        errorMessage: phoneError,
        countryCode: $countryCode,
        phone: $phone
      )

      LabeledTextField(
        title: "Descripción",
        placeholder: "Describe el evento...",
        customHeight: 120,
        maxLength: 2000,
        errorMessage: descriptionError,
        text: $description
      )

      LabeledTextField(
        title: "Notas (opcional)",
        placeholder: "Escribe notas adicionales...",
        customHeight: 90,
        maxLength: 1000,
        errorMessage: notesError,
        text: $notes
      )

      ImagePickerField(
        title: "Imagen del evento (opcional)",
        image: image,
        errorMessage: imageError,
        onPick: onPickImage,
        onError: onImageError
      )
    }
  }
}

#Preview {
  @Previewable @State var modality: String? = "Presencial"
  @Previewable @State var countryCode: String? = "+52"

  ScrollView {
    CreateEventForm(
      title: .constant("Reunión de equipo - Seguimiento de casos"),
      startDate: .constant(Date()),
      endDate: .constant(Date()),
      startTime: .constant(nil),
      endTime: .constant(nil),
      modality: $modality,
      location: .constant("Oficinas ADAX"),
      link: .constant(""),
      countryCode: $countryCode,
      phone: .constant(""),
      description: .constant("Revisión semanal de avance de casos activos."),
      notes: .constant(""),
      image: nil,
      onPickImage: { _ in },
      endTimeError: "La hora de fin debe ser posterior a la de inicio."
    )
    .padding(20)
  }
  .background(Color("Background"))
}
