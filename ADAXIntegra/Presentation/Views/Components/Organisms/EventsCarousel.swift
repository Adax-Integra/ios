import SwiftUI

// The title and every card open the full events list
struct EventsCarousel: View {
  @ObservedObject var viewModel: EventsViewModel

  private let areaHeight: CGFloat = 200
  private let screenPadding: CGFloat = 20

  var body: some View {
    VStack(alignment: .leading, spacing: 12) {
      NavigationLink {
        EventsListPage()
      } label: {
        HStack(spacing: 6) {
          Text("Eventos")
            .font(.title2.bold())
          Image(systemName: "chevron.right")
            .font(.subheadline.weight(.semibold))
        }
        .foregroundColor(Color("OnBackground"))
      }
      .buttonStyle(.plain)

      content
        .frame(height: areaHeight, alignment: .top)
    }
  }

  @ViewBuilder
  private var content: some View {
    if viewModel.isLoading && viewModel.events.isEmpty {
      ProgressView()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
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
      .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    } else if viewModel.events.isEmpty {
      Text("No hay eventos este mes.")
        .font(.subheadline)
        .foregroundStyle(.secondary)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    } else {
      ScrollView(.horizontal, showsIndicators: false) {
        LazyHStack(spacing: 12) {
          ForEach(viewModel.events) { event in
            NavigationLink {
              EventsListPage()
            } label: {
              EventCard(event: event)
            }
            .buttonStyle(.plain)
          }
        }
        .padding(.horizontal, screenPadding)
        .padding(.vertical, 4)
      }
      .padding(.horizontal, -screenPadding)
    }
  }
}
