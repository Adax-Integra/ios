//
//  EventDetailPage.swift
//  ADAXIntegra
//
//  Created by Oscar Alexander Vilchis Soto on 15/10/26.
//
import SwiftUI

// Detail of one event, opened from the events list
struct EventDetailPage: View {
    @Environment(\.dismiss) private var dismiss
    let event: EventListItem
    
    var body: some View {
        ZStack {
            Color("Background").ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 0) {
                BackButton { dismiss() }
                    .padding(.horizontal, 20)
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        
                        HStack(spacing: 12) {
                            Image(systemName: "calendar")
                                .font(.title3)
                                .foregroundColor(.white)
                                .frame(width: 48, height: 48)
                                .background(Color("PrimaryAdax"), in: Circle())
                                .accessibilityHidden(true)
                            
                            Text(event.title)
                                .font(.subheadline)
                                .foregroundColor(Color("OnBackground"))
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        
                        EventDetailCard(event: event)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                }
            }
            .navigationBarBackButtonHidden(true)
            .toolbar(.hidden, for: .navigationBar)
        }
    }
}

    #Preview {
        NavigationStack {
            EventDetailPage(
                event: EventListItem(
                    id: "1", title: "ADAX Reu",
                    description: "Reunion para todas las integrantes ADAX",
                    startsAt: "2026-09-03T16:00:00+00:00", endsAt: "2026-09-03T17:30:00+00:00",
                    modality: "Presencial", location: "Oficinas ADAX", imageUrl: nil,
                    notes: "Confirmar asistencia con al menos un día de anticipación.")
            )
        }
}

