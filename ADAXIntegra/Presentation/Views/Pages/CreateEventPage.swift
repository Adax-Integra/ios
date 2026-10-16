//
//  CreateEventPage.swift
//  ADAXIntegra
//
//  Created by Paco Arreola on 15/10/26.
//

import SwiftUI

struct CreateEventPage: View {
  @Environment(\.dismiss) private var dismiss
  @StateObject private var viewModel = CreateEventViewModel()

  var body: some View {
    ZStack {
      Color("Background").ignoresSafeArea()

      ScrollView {
        VStack(alignment: .leading, spacing: 16) {
          PageHeader(
            title: "Nuevo evento",
            backAction: { dismiss() }
          )

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
            title: viewModel.isSaving ? "Guardando..." : "Guardar evento",
            isDisabled: viewModel.isSaving,
            action: {
              dismissKeyboard()
              Task { await viewModel.createEvent() }
            }
          )
          .padding(.top, 8)
        }
        .padding()
      }
      .scrollDismissesKeyboard(.interactively)
    }
    .navigationBarBackButtonHidden(true)
    .task { await viewModel.loadCountries() }
    .alert("Atención", isPresented: showError) {
      Button("Aceptar", role: .cancel) {}
    } message: {
      Text(viewModel.errorMessage ?? "")
    }
    .alert("Evento creado", isPresented: $viewModel.eventCreated) {
      Button("Entendido") { dismiss() }
    } message: {
      Text(successMessage)
    }
  }

  // The event is saved even if its picture fails, so the user only gets a warning
  private var successMessage: String {
    viewModel.imageUploadFailed
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

#Preview {
  NavigationStack {
    CreateEventPage()
  }
}
