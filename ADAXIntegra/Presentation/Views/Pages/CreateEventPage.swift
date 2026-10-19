//
//  CreateEventPage.swift
//  ADAXIntegra
//
//  Created by Paco Arreola on 15/10/26.
//

import SwiftUI

struct CreateEventPage: View {
  @Environment(\.dismiss) private var dismiss
  @StateObject private var viewModel: CreateEventViewModel

  private let event: EventListItem?
  private let onSaved: (() -> Void)?

  init(event: EventListItem? = nil, onSaved: (() -> Void)? = nil) {
    self.event = event
    self.onSaved = onSaved
    _viewModel = StateObject(wrappedValue: CreateEventViewModel(event: event))
  }

  var body: some View {
    ZStack {
      Color("Background").ignoresSafeArea()

      ScrollView {
        VStack(alignment: .leading, spacing: 16) {
          // The list does not send the picture file, so the saved one is only shown
          if let event {
            FieldLabel("Imagen actual")
            EventCoverImage(url: event.imageURL, height: 160)
              .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
          }

          CreateEventForm(
            title: $viewModel.title,
            startDate: $viewModel.startDate,
            endDate: $viewModel.endDate,
            startTime: $viewModel.startTime,
            endTime: $viewModel.endTime,
            modality: $viewModel.modality,
            location: $viewModel.location,
            link: $viewModel.link,
            countryCode: $viewModel.countryCode,
            phone: $viewModel.phone,
            description: $viewModel.description,
            notes: $viewModel.notes,
            image: viewModel.image,
            onPickImage: { viewModel.selectImage($0) },
            onImageError: { viewModel.errorMessage = $0 },
            countryCodes: viewModel.countryCodes,
            titleError: viewModel.titleError,
            startDateError: viewModel.startDateError,
            endDateError: viewModel.endDateError,
            startTimeError: viewModel.startTimeError,
            endTimeError: viewModel.endTimeError,
            locationError: viewModel.locationError,
            linkError: viewModel.linkError,
            phoneError: viewModel.phoneError,
            descriptionError: viewModel.descriptionError
          )

          PrimaryButton(
            title: buttonTitle,
            isDisabled: viewModel.isSaving,
            action: {
              dismissKeyboard()
              Task { await viewModel.saveEvent() }
            }
          )
          .padding(.top, 8)
        }
        .padding()
      }
      .scrollDismissesKeyboard(.interactively)
    }
    .navigationTitle(viewModel.isEditing ? "Editar evento" : "Nuevo evento")
    // dismisses the keyboard when tapping outside the fields
    .dismissKeyboardOnTap()
    .task { await viewModel.loadCountries() }
    .alert("Atención", isPresented: showError) {
      Button("Aceptar", role: .cancel) {}
    } message: {
      Text(viewModel.errorMessage ?? "")
    }
    // E-04 and E-02: creating and editing show the same success page
    .successScreen(
      isPresented: $viewModel.eventSaved,
      title: viewModel.isEditing ? "¡Evento actualizado!" : "¡Evento creado!",
      message: successMessage,
      onContinue: {
        onSaved?()
        dismiss()
      }
    )
  }

  private var buttonTitle: String {
    if viewModel.isSaving {
      return "Guardando..."
    }
    return viewModel.isEditing ? "Guardar cambios" : "Guardar evento"
  }

  // The event is saved even if its picture fails, so the user only gets a warning
  private var successMessage: String {
    if viewModel.isEditing {
      return viewModel.imageUploadFailed
        ? "Los cambios se guardaron, pero no se pudo subir la imagen."
        : "Los cambios ya aparecen en el calendario."
    }
    return viewModel.imageUploadFailed
      ? "El evento ha sido registrado exitosamente, pero no se pudo subir la imagen."
      : "El evento ha sido registrado exitosamente."
  }

  // Shows the alert while there is an error and clears it when it is closed
  private var showError: Binding<Bool> {
    Binding(
      get: { viewModel.errorMessage != nil },
      set: { if !$0 { viewModel.errorMessage = nil } }
    )
  }

  // Closes the keyboard before saving
  private func dismissKeyboard() {
    UIApplication.shared.sendAction(
      #selector(UIResponder.resignFirstResponder),
      to: nil,
      from: nil,
      for: nil
    )
  }
}

#Preview("Nuevo") {
  NavigationStack {
    CreateEventPage()
  }
}

#Preview("Editar") {
  NavigationStack {
    CreateEventPage(
      event: EventListItem(
        id: "preview-event",
        title: "Taller de derechos laborales",
        description: "Sesión informativa para personas trabajadoras.",
        startsAt: "2026-11-20T16:00:00Z",
        endsAt: "2026-11-20T18:00:00Z",
        modality: "Presencial",
        location: "Centro comunitario, Querétaro",
        imageUrl: nil,
        notes: "Llevar identificación.",
        link: "https://adaxdigitales.com",
        phone: "+524421234567"
      )
    )
  }
}
