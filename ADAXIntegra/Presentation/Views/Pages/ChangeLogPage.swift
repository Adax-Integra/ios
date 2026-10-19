//
//  ChangeLogPage.swift
//  ADAXIntegra
//
//  Created by Cristhian Viery Maida Suarez on 05/10/26.
//
// Added the whole functionality (frontend) to the log page Oscar Alexender Vilchis Soto on 18/10/2026.

import SwiftUI

// General page for US v-06 where the admin consults the activity log of the app
struct ChangeLogPage: View {
  @StateObject private var viewModel = ChangeLogViewModel()
  @State private var isShowingFilter = false

  var body: some View {
    ZStack {
      Color("Background").ignoresSafeArea()

      VStack(spacing: 16) {
        searchAndFilter

        content
      }
      .padding(.horizontal, 16)
      .padding(.top, 8)
    }
    // Native iOS back button and centered title
    .navigationTitle("Bitácora de cambios")
    .navigationBarTitleDisplayMode(.inline)
    // Loads the first page when the screen appears
    .task { await viewModel.refresh() }
    .sheet(isPresented: $isShowingFilter) {
      ChangeLogFilterSheet(
        initialStart: viewModel.startDate,
        initialEnd: viewModel.endDate,
        onApply: { start, end in
          Task { await viewModel.applyFilter(start: start, end: end) }
        },
        onClear: {
          Task { await viewModel.clearFilter() }
        }
      )
      .presentationDetents([.height(440)])
      .presentationDragIndicator(.visible)
    }
  }

  private var searchAndFilter: some View {
    HStack(spacing: 12) {
      // Shared search bar of the app (searches over the logs already loaded).
      SearchBarInterna(
        fieldHeight: 40,
        placeholder: "Buscar por palabra clave",
        text: $viewModel.searchText
      )

      // Opens the date range filter
      Button {
        isShowingFilter = true
      } label: {
        HStack(spacing: 6) {
          Text("Filtrar")
            .font(.system(size: 16, weight: .bold))
          // Small dot to show that a date filter is active
          if viewModel.hasActiveFilter {
            Circle().fill(Color("PrimaryAdax")).frame(width: 8, height: 8)
          }
        }
        .foregroundColor(Color("PrimaryAdax"))
        .padding(.horizontal, 20)
        .frame(height: 52)
        .overlay(
          RoundedRectangle(cornerRadius: 12, style: .continuous)
            .stroke(Color("PrimaryAdax"), lineWidth: 1.5)
        )
      }
    }
  }

  @ViewBuilder
  private var content: some View {
    if viewModel.logs.isEmpty && viewModel.isLoading {
      Spacer()
      ProgressView()
      Spacer()
    } else if let message = viewModel.errorMessage, viewModel.logs.isEmpty {
      stateMessage(icon: "exclamationmark.triangle", text: message, showRetry: true)
    } else if viewModel.sections.isEmpty {
      stateMessage(
        icon: "clock.arrow.circlepath",
        text: viewModel.logs.isEmpty
          ? "No hay movimientos registrados."
          : "No se encontraron movimientos con esa búsqueda.",
        showRetry: false
      )
    } else {
      timeline
    }
  }

  private var timeline: some View {
    ScrollView {
      LazyVStack(alignment: .leading, spacing: 0) {
        ForEach(viewModel.sections) { section in
          // Day header only today and yesterday for any changes inmediatos( no sé como escribirlo en inglés)
          Text(section.title)
            .font(.system(size: 14, weight: .semibold))
            .foregroundColor(Color("InsideTextAndIcons"))
            .padding(.top, 12)
            .padding(.bottom, 6)

          ForEach(section.items) { log in
            ActivityLogTimelineRow(log: log)
              // Asks for the next page when the last row appears
              .task { await viewModel.loadMoreIfNeeded(currentItem: log) }
          }
        }

        if viewModel.isLoading {
          ProgressView()
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
        } else if let message = viewModel.errorMessage {
          Text(message)
            .font(.system(size: 13))
            .foregroundColor(.red)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
        }
      }
      .padding(.bottom, 24)
    }
    .refreshable { await viewModel.refresh() }
  }

  // Centered message used for the error and empty states
  private func stateMessage(icon: String, text: String, showRetry: Bool) -> some View {
    VStack(spacing: 12) {
      Spacer()
      Image(systemName: icon)
        .font(.system(size: 44))
        .foregroundStyle(Color("IconColor"))
      Text(text)
        .font(.system(size: 15))
        .foregroundStyle(Color("IconColor"))
        .multilineTextAlignment(.center)
        .padding(.horizontal, 32)
      if showRetry {
        Button("Reintentar") { Task { await viewModel.refresh() } }
          .font(.system(size: 15, weight: .semibold))
          .foregroundColor(Color("PrimaryAdax"))
      }
      Spacer()
    }
    .frame(maxWidth: .infinity)
  }
}

// Filter with the date range
private struct ChangeLogFilterSheet: View {
  @Environment(\.dismiss) private var dismiss

  @State private var startDate: Date
  @State private var endDate: Date
  @State private var errorMessage: String?

  let onApply: (Date, Date) -> Void
  let onClear: () -> Void

  init(
    initialStart: Date?,
    initialEnd: Date?,
    onApply: @escaping (Date, Date) -> Void,
    onClear: @escaping () -> Void
  ) {
    // Starts with the active filter, or with "this month" if there is none
    let defaultRange = ReportPresets.thisMonth.range()
    _startDate = State(initialValue: initialStart ?? defaultRange.start)
    _endDate = State(initialValue: initialEnd ?? defaultRange.end)
    self.onApply = onApply
    self.onClear = onClear
  }

  var body: some View {
    ZStack {
      Color("Background").ignoresSafeArea()

      VStack(alignment: .leading, spacing: 16) {
        Text("Filtrar por fecha")
          .font(.system(size: 20, weight: .bold))
          .foregroundColor(Color("OnBackground"))

        Text("Selecciona un rango predeterminado o selecciona uno más específico")
          .font(.system(size: 15, weight: .medium))
          .foregroundColor(Color("OnBackground"))

        // Quick filters: white by default, purple when they match the selected dates
        ScrollView(.horizontal, showsIndicators: false) {
          HStack(spacing: 8) {
            ForEach(ReportPresets.allCases, id: \.self) { preset in
              ChangeLogPresetChip(
                title: preset.title,
                isSelected: isSelected(preset)
              ) {
                let range = preset.range()
                startDate = range.start
                endDate = range.end
                errorMessage = nil
              }
            }
          }
        }

        DateEntry(title: "Fecha de inicio", date: asOptional($startDate))
        DateEntry(title: "Fecha de fin", date: asOptional($endDate))

        if let errorMessage {
          Text(errorMessage)
            .font(.system(size: 13))
            .foregroundColor(.red)
        }

        // Both buttons side by side at the bottom of the sheet
        HStack(spacing: 12) {
          Button {
            onClear()
            dismiss()
          } label: {
            Text("Quitar filtro")
              .font(.system(size: 16, weight: .bold))
              .foregroundColor(Color("PrimaryAdax"))
              .frame(maxWidth: .infinity)
              .frame(height: 52)
              .overlay(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                  .stroke(Color("PrimaryAdax"), lineWidth: 1.5))
          }

          Button {
            apply()
          } label: {
            Text("Aplicar filtro")
              .font(.system(size: 16, weight: .bold))
              .foregroundColor(.white)
              .frame(maxWidth: .infinity)
              .frame(height: 52)
              .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                  .fill(Color("PrimaryAdax")))
          }
        }
        .padding(.top, 4)
      }
      .padding(.horizontal, 20)
      .padding(.top, 28)
      .padding(.bottom, 16)
      // Keeps the content at the top
      .frame(maxHeight: .infinity, alignment: .top)
    }
  }

  // A chip is selected when the dates on screen are exactly the range of that preset
  // If the user edits a date by hand, the chip is deselected by itself
  private func isSelected(_ preset: ReportPresets) -> Bool {
    let calendar = Calendar.current
    let range = preset.range()
    return calendar.isDate(startDate, inSameDayAs: range.start)
      && calendar.isDate(endDate, inSameDayAs: range.end)
  }

  private func asOptional(_ date: Binding<Date>) -> Binding<Date?> {
    Binding(
      get: { date.wrappedValue },
      set: { newValue in
        if let newValue { date.wrappedValue = newValue }
      }
    )
  }

  // Same rule as the backend so the end date cannot be before the start date
  private func apply() {
    let calendar = Calendar.current
    if calendar.startOfDay(for: endDate) < calendar.startOfDay(for: startDate) {
      errorMessage = "La fecha de fin no puede ser anterior a la de inicio."
      return
    }
    onApply(startDate, endDate)
    dismiss()
  }
}

// Quick filter chip of this sheet white when is "normal" and then changes
//to purple when selected
private struct ChangeLogPresetChip: View {
  let title: String
  let isSelected: Bool
  let action: () -> Void

  var body: some View {
    Button(action: action) {
      Text(title)
        .font(.system(size: 15, weight: .semibold))
        .foregroundColor(isSelected ? .white : Color("PrimaryAdax"))
        .padding(.horizontal, 18)
        .padding(.vertical, 10)
        .background(
          Capsule().fill(isSelected ? Color("PrimaryAdax") : Color.white)
        )
    }
    .buttonStyle(.plain)
  }
}
#Preview {
  // Wrapped in a NavigationStack so the native bar shows in the preview
  NavigationStack {
    ChangeLogPage()
  }
}
