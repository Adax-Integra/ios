//
//  EventsListPage.swift
//  ADAXIntegra
//
//  Created by Oscar Alexander Vilchis Soto on 15/10/26.
//
import SwiftUI

// Events list page for US e-01 with every active event, same for internal and external users
struct EventsListPage: View {
  @Environment(\.dismiss) private var dismiss
  @StateObject private var viewModel = EventsViewModel(scope: .all)

  var body: some View {
    ZStack {
      Color("Background").ignoresSafeArea()

      ScrollView {
        VStack(alignment: .leading, spacing: 16) {
          PageHeader(
            title: "Eventos",
            backAction: { dismiss() },
            subtitle: "Conoce los eventos de la asociación"
          )

          content
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
      }
      .refreshable {
        await viewModel.loadEvents()
      }
    }
    .navigationBarBackButtonHidden(true)
    .task {
      await viewModel.loadEvents()
    }
  }

  @ViewBuilder
  private var content: some View {
    if viewModel.isLoading && viewModel.events.isEmpty {
      ProgressView()
        .frame(maxWidth: .infinity)
        .padding()
    } else if let error = viewModel.errorMessage, viewModel.events.isEmpty {
      VStack(alignment: .leading, spacing: 8) {
        Text(error)
          .font(.subheadline)
          .foregroundStyle(.secondary)

        Button("Reintentar") {
          Task { await viewModel.loadEvents() }
        }
        .foregroundColor(Color("PrimaryAdax"))
      }
    } else if viewModel.events.isEmpty {
      Text("No hay eventos por ahora.")
        .font(.subheadline)
        .foregroundStyle(.secondary)
    } else {
      LazyVStack(spacing: 16) {
        ForEach(viewModel.events) { event in
          EventListCard(event: event)
        }
      }
    }
  }
}

#Preview {
  NavigationStack {
    EventsListPage()
  }
}

