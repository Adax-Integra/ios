//
//  RecordsPageInterna.swift
//  ADAXIntegra
//
//  Created by Cristhian Viery Maida Suarez on 02/10/26.
//

import SwiftUI

struct RecordsPageInterna: View {
  @StateObject private var viewModel = RecordsViewModel()
  @State private var showRegister = false
  @Environment(\.dismiss) private var dismiss

  var body: some View {
    ListPageTemplate {
      PageHeader(title: "Expedientes", backAction: { dismiss() })
    } toolbar: {
      toolbar
    } content: {
      content
    }
    .task(id: viewModel.searchText) {
      try? await Task.sleep(for: .milliseconds(300))
      guard !Task.isCancelled else { return }
      await viewModel.refresh()
    }
    .onChange(of: viewModel.hasOpenCasesFilter) { _, _ in
      Task { await viewModel.refresh() }
    }
    .onChange(of: viewModel.statusFilter) { _, _ in
      Task { await viewModel.refresh() }
    }
    .refreshable {
      await viewModel.refresh()
    }
    .fullScreenCover(isPresented: $showRegister) {
      RegisterExternalPage(onBack: {
        showRegister = false
        Task { await viewModel.refresh() }
      })
    }
  }

  private var toolbar: some View {
    VStack(spacing: 12) {
      SearchBarInterna(placeholder: "Buscar expediente...", text: $viewModel.searchText)

      HStack(spacing: 12) {
        Menu {
          Button("Todos") { viewModel.hasOpenCasesFilter = nil }
          Button("Con casos") { viewModel.hasOpenCasesFilter = true }
          Button("Sin casos") { viewModel.hasOpenCasesFilter = false }
        } label: {
          FilterChip(title: casesFilterText)
        }

        Menu {
          Button("Todos") { viewModel.statusFilter = nil }
          Button("Sin empezar") { viewModel.statusFilter = "SIN_EMPEZAR" }
          Button("En revisión") { viewModel.statusFilter = "EN_REVISION" }
          Button("En seguimiento") { viewModel.statusFilter = "EN_SEGUIMIENTO" }
          Button("Completado") { viewModel.statusFilter = "COMPLETADO" }
        } label: {
          FilterChip(title: statusFilterText)
        }

        if hasActiveFilters {
          Button {
            viewModel.searchText = ""
            viewModel.hasOpenCasesFilter = nil
            viewModel.statusFilter = nil
          } label: {
            HStack(spacing: 4) {
              Image(systemName: "xmark.circle.fill")
              Text("Limpiar")
            }
            .font(.system(size: 13, weight: .semibold))
            .foregroundStyle(Color("PrimaryAdax"))
          }
          .buttonStyle(.plain)
        }

        Spacer()
      }

      IconTextPrimaryButton(
        systemName: "plus",
        title: "Registrar expediente",
        isDisabled: false
      ) {
        showRegister = true
      }
    }
  }

  @ViewBuilder
  private var content: some View {
    if viewModel.isLoading && viewModel.records.isEmpty {
      ProgressView()
        .frame(maxWidth: .infinity)
        .padding()
    } else if let error = viewModel.errorMessage {
      Text(error)
        .foregroundStyle(.secondary)
        .padding()
    } else if viewModel.records.isEmpty {
      Text("No hay expedientes disponibles")
        .foregroundStyle(.secondary)
        .padding()
    } else {
      ForEach(viewModel.records) { item in
        NavigationLink {
          RecordDetailPage(externalID: item.userId)
        } label: {
          RecordCardInterna(item: item)
        }
        .buttonStyle(.plain)
        .task {
          await viewModel.loadMoreIfNeeded(currentItem: item)
        }
      }

      if viewModel.isLoading {
        ProgressView()
          .frame(maxWidth: .infinity)
          .padding(.vertical, 8)
      }
    }
  }

  private var casesFilterText: String {
    switch viewModel.hasOpenCasesFilter {
    case .some(true): return "Con casos"
    case .some(false): return "Sin casos"
    case .none: return "Casos"
    }
  }

  private var statusFilterText: String {
    guard let code = viewModel.statusFilter, let status = RecordStatus(rawValue: code) else {
      return "Estatus"
    }
    return status.label
  }

  private var hasActiveFilters: Bool {
    !viewModel.searchText.isEmpty
      || viewModel.hasOpenCasesFilter != nil
      || viewModel.statusFilter != nil
  }
}

#Preview {
  RecordsPageInterna()
}
