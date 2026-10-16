//
//  ViewAndEditProfilePage.swift
//  ADAXIntegra
//
//  Created by Eduardo Hernández Alonso on 15/10/26.
//

import SwiftUI

// R-04: the logged-in user views and edits their own profile
struct ViewAndEditProfilePage: View {
  @StateObject private var viewModel: ViewAndEditProfileViewModel

  init(userId: String?, roles: [String]) {
    _viewModel = StateObject(
      wrappedValue: ViewAndEditProfileViewModel(userId: userId, roles: roles))
  }

  var body: some View {
    ZStack {
      if viewModel.isLoading {
        Color("Background").ignoresSafeArea()
        ProgressView()
      } else {
        ViewAndEditProfileTemplate(
          name: $viewModel.form.name,
          lastName: $viewModel.form.lastName,
          countryCode: $viewModel.form.countryCode,
          phone: $viewModel.form.phone,
          country: $viewModel.form.country,
          state: $viewModel.form.state,
          municipality: $viewModel.form.municipality,
          showsAddress: viewModel.showsAddress,
          countryCodes: viewModel.countryCodes,
          countries: viewModel.countryOptions,
          states: viewModel.stateOptions,
          isEditing: viewModel.isEditing,
          isSaving: viewModel.isSaving,
          editAction: viewModel.startEditing,
          cancelAction: viewModel.cancelEditing,
          saveAction: { Task { await viewModel.save() } }
        )
      }
    }
    .task { await viewModel.load() }
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

#Preview {
  NavigationStack {
    ViewAndEditProfilePage(userId: nil, roles: ["external"])
  }
}
