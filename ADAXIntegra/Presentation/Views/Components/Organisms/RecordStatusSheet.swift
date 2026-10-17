//
//  RecordStatusSheet.swift
//  ADAXIntegra
//
//  Created by Cristhian Viery Maida Suarez on 15/10/26.
//

import SwiftUI

struct RecordStatusSheet: View {
  @ObservedObject var viewModel: RecordStatusViewModel
  @Environment(\.dismiss) private var dismiss

  let externalName: String

  // Local selection; starts on the current status.
  @State private var selected: RecordStatus

  init(viewModel: RecordStatusViewModel, externalName: String) {
    self.viewModel = viewModel
    self.externalName = externalName
    _selected = State(initialValue: viewModel.currentStatus)
  }

  var body: some View {
    VStack(spacing: 20) {
      VStack(spacing: 6) {
        Text("Cambiar estatus")
          .font(.system(size: 22, weight: .bold))
          .foregroundStyle(Color("OnBackground"))

        Text(externalName.isEmpty ? "Expediente" : "Expediente de \(externalName)")
          .font(.system(size: 14))
          .foregroundStyle(Color("InsideTextAndIcons"))
      }
      .padding(.top, 20)

      VStack(spacing: 12) {
        ForEach(RecordStatus.allCases, id: \.self) { status in
          Button {
            viewModel.errorMessage = nil
            selected = status
          } label: {
            HStack(spacing: 12) {
              Circle()
                .fill(status.color)
                .frame(width: 12, height: 12)

              Text(status.label)
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(Color("OnBackground"))

              Spacer()

              ZStack {
                Circle()
                  .strokeBorder(Color("PrimaryAdax"), lineWidth: 2)
                  .frame(width: 24, height: 24)
                if selected == status {
                  Circle()
                    .fill(Color("PrimaryAdax"))
                    .frame(width: 14, height: 14)
                }
              }
            }
            .padding()
            .background(
              RoundedRectangle(cornerRadius: 12, style: .continuous)
                .stroke(Color("InsideTextAndIcons").opacity(0.3), lineWidth: 1)
            )
          }
        }
      }

      Text("Solo puedes avanzar un paso o regresar a revisión.")
        .font(.system(size: 13))
        .foregroundStyle(Color("InsideTextAndIcons"))
        .multilineTextAlignment(.center)

      if let error = viewModel.errorMessage {
        Text(error)
          .font(.system(size: 13, weight: .medium))
          .foregroundStyle(Color("Error"))
          .multilineTextAlignment(.center)
      }

      Spacer()

      HStack(spacing: 12) {
        Button {
          dismiss()
        } label: {
          Text("Cancelar")
            .font(.system(size: 16, weight: .bold))
            .foregroundStyle(Color("PrimaryAdax"))
            .frame(maxWidth: .infinity)
            .padding()
            .background(
              RoundedRectangle(cornerRadius: 12, style: .continuous)
                .stroke(Color("PrimaryAdax"), lineWidth: 1.5)
            )
        }

        Button {
          Task {
            await viewModel.updateStatus(to: selected)
            if viewModel.errorMessage == nil {
              dismiss()
            }
          }
        } label: {
          Text("Guardar")
            .font(.system(size: 16, weight: .bold))
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(
              RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color("PrimaryAdax"))
            )
        }
        .disabled(selected == viewModel.currentStatus || viewModel.isUpdating)
      }
    }
    .padding()
    .presentationDetents([.height(560)])
    .presentationDragIndicator(.visible)
  }
}
