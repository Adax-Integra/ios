import SwiftUI

// Card of the homepage carousel 
struct EventCard: View {
  let event: Event
  var width: CGFloat = 160
  var height: CGFloat = 192

  var body: some View {
    SurfaceCard(cornerRadius: 20) {
      VStack(alignment: .leading, spacing: 0) {
        EventCoverImage(url: event.imageURL, height: 80)
          .overlay(alignment: .topLeading) {
            EventDateBadge(day: event.dayString, month: event.monthString)
              .padding(8)
          }

        VStack(alignment: .leading, spacing: 3) {
          Text(event.title)
            .font(.footnote.bold())
            .foregroundColor(Color("OnBackground"))
            .lineLimit(2)

          if let description = event.description, !description.isEmpty {
            Text(description)
              .font(.caption2)
              .foregroundColor(Color("SecondaryAdax"))
              .lineLimit(1)
          }

          Spacer(minLength: 0)

          if let place = event.displayLocation {
            Label(place, systemImage: "mappin.and.ellipse")
              .font(.caption2)
              .foregroundColor(Color("SecondaryAdax"))
              .lineLimit(1)
          }

          Text(event.longDateString)
            .font(.caption2)
            .foregroundColor(Color("OnBackground").opacity(0.7))
            .lineLimit(1)
        }
        .padding(10)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
      }
      .frame(width: width, height: height, alignment: .top)
      .clipShape(RoundedRectangle(cornerRadius: 20))
    }
  }
}

#Preview {
  ZStack {
    Color("Background").ignoresSafeArea()
    EventCard(
      event: Event(
        id: "1", title: "Marcha por nuestros derechos",
        description: "Alza tu voz, no estás sola.",
        startsAt: "2026-10-25T18:00:00+00:00",
        endsAt: "2026-10-25T20:00:00+00:00",
        modality: "Presencial", location: "Plaza de la Constitución",
        imageUrl: nil)
    )
  }
}
