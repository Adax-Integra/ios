//
//  PreSubmissionPage.swift
//  ADAXIntegra
//
//  Created by Eduardo Hernández Alonso on 02/10/26.
//

import SwiftUI

// Connects PresubmissionTemplate with PreSubmissionViewModel
struct PreSubmissionPage: View {
  @StateObject var viewModel: PreSubmissionViewModel
  var onBack: () -> Void = {}

  var body: some View {
    PresubmissionTemplate(
      onBack: onBack,
      firstName: $viewModel.firstName,
      firstNameError: viewModel.firstNameError,
      lastName: $viewModel.lastName,
      lastNameError: viewModel.lastNameError,
      birthDate: $viewModel.birthDate,
      birthDateError: viewModel.birthDateError,
      countryCode: $viewModel.countryCode,
      phone: $viewModel.phone,
      phoneError: viewModel.phoneError,
      addressLine1: $viewModel.addressLine1,
      addressLine1Error: viewModel.addressLine1Error,
      addressLine2: $viewModel.addressLine2,
      neighborhood: $viewModel.neighborhood,
      neighborhoodError: viewModel.neighborhoodError,
      zipCode: $viewModel.zipCode,
      zipCodeError: viewModel.zipCodeError,
      countries: viewModel.countries,
      country: $viewModel.country,
      state: $viewModel.state,
      municipality: $viewModel.municipality,
      municipalityError: viewModel.municipalityError,
      officialIdUrl: viewModel.identityDocumentUrl,
      officialIdFile: viewModel.newIdentityDocument,
      onOfficialIdPick: { viewModel.selectDocument($0, for: .identity) },
      proofOfAddressUrl: viewModel.proofOfAddressUrl,
      proofOfAddressFile: viewModel.newProofOfAddress,
      onProofOfAddressPick: { viewModel.selectDocument($0, for: .proofOfAddress) },
      onDocumentPickError: { viewModel.errorMessage = $0 },
      onDocumentLoadFailure: { await viewModel.refreshDocumentUrls() },
      isConfirmationDisabled: viewModel.isLoading,
      onConfirm: viewModel.confirm,
      onDismiss: viewModel.startEditing
    )
    // Loads the catalog and the saved information when the screen appears
    .task { await viewModel.load() }
    .overlay {
      // The backdrop absorbs taps so nothing can be pressed while loading
      if viewModel.isLoading {
        Color.black.opacity(0.15)
          .ignoresSafeArea()
          .overlay { ProgressView() }
      }
    }
    // Confirms the save and then sends the user to onFinish
    .alert("Listo", isPresented: $viewModel.isShowingSuccess) {
      Button("Aceptar") { viewModel.acknowledgeSuccess() }
    } message: {
      Text("Información actualizada correctamente.")
    }
    // Shows the load and save errors, and clears the message when closed
    .alert(
      "Aviso",
      isPresented: Binding(
        get: { viewModel.errorMessage != nil },
        set: { if !$0 { viewModel.errorMessage = nil } }
      )
    ) {
      Button("Aceptar", role: .cancel) {}
    } message: {
      Text(viewModel.errorMessage ?? "")
    }
  }
}
