//
//  EventDetailCard.swift
//  ADAXIntegra
//
//  Created by Oscar Alexander Vilchis Soto on 15/10/26.
//
import SwiftUI

// Image on top and the white card with the sections of the event
struct EventDetailCard: View {
  let event: EventListItem

  var body: some View {
    SurfaceCard(cornerRadius: 24) {
      VStack(alignment: .leading, spacing: 0) {
        EventCoverImage(url: event.imageURL, height: 180)

        VStack(alignment: .leading, spacing: 20) {
          EventDetailSection(
            title: "Fecha y hora",
            text: "\(event.detailDateString) · \(event.timeRangeString)",
            systemImage: "clock"
          )

          if let place = event.detailPlaceString {
            EventDetailSection(
              title: "Lugar / modalidad", text: place, systemImage: "mappin.and.ellipse")
          }

          if let description = event.description, !description.isEmpty {
            EventDetailSection(title: "Descripción", text: description)
          }

          if let notes = event.displayNotes {
            EventDetailSection(title: "Notas", text: notes)
          }
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
      }
      .clipShape(RoundedRectangle(cornerRadius: 24))
    }
  }
}

#Preview {
  ZStack {
    Color("Background").ignoresSafeArea()
    EventDetailCard(
      event: EventListItem(
        id: "1", title: "Reunión de equipo - Seguimiento de casos",
        description: "Revisión semanal de avance de casos activos.",
        startsAt: "2026-09-03T16:00:00+00:00", endsAt: "2026-09-03T17:30:00+00:00",
        modality: "Presencial", location: "Oficinas ADAX", imageUrl: nil,
        notes: "Confirmar asistencia con al menos un día de anticipación.")
    )
    .padding()
  }
}
