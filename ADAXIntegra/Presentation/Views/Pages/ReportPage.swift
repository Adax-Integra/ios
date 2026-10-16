//
//  ReportPage.swift
//  ADAXIntegra
//
//  Created by armando fuentes on 15/10/26.
//

import SwiftUI

struct ReportPage: View {
  @StateObject private var viewModel: ReportViewModel

  init(viewModel: ReportViewModel) {
    _viewModel = StateObject(wrappedValue: viewModel)
  }

  var body: some View {
    VStack(alignment: .leading, spacing: 16) {
      Text("Reportes")
        .font(.system(size: 22, weight: .bold))
      Text("Obtén el reporte de los casos")
        .font(.system(size: 15, weight: .medium))
        .foregroundColor(Color("OnBackgroundColor"))

      ReportRangeForm(
        startDate: $viewModel.startDate,
        endDate: $viewModel.endDate,
        onSelectPreset: viewModel.applyPreset
      )
      .padding(.top, 16)

      Spacer()

      PrimaryButton(
        title: viewModel.isLoading ? "Generando..." : "Generar reporte",
        isDisabled: viewModel.isLoading
      ) {
        Task { await viewModel.generateReport() }
      }
    }
    .padding(16)
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    .background(Color("BackgroundColor"))
    .alert("Algo salió mal", isPresented: $viewModel.showAlert) {
      Button("Entendido", role: .cancel) {}
    } message: {
      Text(viewModel.messageAlert)
    }
    .sheet(isPresented: $viewModel.isShowingShareSheet) {
      if let url = viewModel.downloadedFileURL {
        ShareSheet(url: url)
      }
    }
  }
}
