//
//  ExternalProfileFormModel.swift
//  ADAXIntegra
//
//  Created by Gerardo Martínez Carbajal on 05/10/26.
//

import Foundation

// Editable fields of the G-07 form. Name, last name and birth date are not here
// since the associate asked them to be kept as fixed
struct ExternalProfileFormModel: Equatable {
  var email: String = ""
  var countryCode: String? = "+52"
  var phone: String = ""
  var country: String?
  var state: String?
  var municipality: String = ""
}

// One row of the confirmation sheet: what a field had and what it will have
struct ExternalProfileChange: Identifiable {
  let label: String
  let oldValue: String
  let newValue: String

  var id: String { label }
}
