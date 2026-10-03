//
//  ExpedientesListPage.swift
//  ADAXIntegra
//
//  Created by armando fuentes on 03/10/26.
//

import SwiftUI

struct ExpedientesListPage: View {
  var body: some View {
    RecordsPageInterna()
          .toolbar(.hidden, for: .navigationBar)
  }
}
