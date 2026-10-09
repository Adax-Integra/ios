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
  var addressLine1: String = ""
  var addressLine2: String = ""
  var neighborhood: String = ""
  var zipCode: String = ""
  var country: String?
  var state: String?
  var city: String = ""
}

// Error message of each field, nil when the field is valid
struct ExternalProfileFormErrors {
  var email: String?
  var phone: String?
  var addressLine1: String?
  var neighborhood: String?
  var zipCode: String?
  var state: String?
  var city: String?
  var reason: String?

  var isEmpty: Bool {
    [email, phone, addressLine1, neighborhood, zipCode, state, city, reason]
      .allSatisfy { $0 == nil }
  }
}

// One row of the confirmation sheet: what a field had and what it will have
struct ExternalProfileChange: Identifiable {
  let label: String
  let oldValue: String
  let newValue: String

  var id: String { label }
}
