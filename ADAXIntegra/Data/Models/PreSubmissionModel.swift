//
//  PreSubmissionModel.swift
//  ADAXIntegra
//
//  Created by Eduardo Hernández Alonso on 03/10/26.
//

import Foundation

/*
 Fields of the "Verificar información" form.
 Equatable is a protocol used to compare two instances of a type,
 meaning you can use "==" and "!=" operators.
 Documents are display-only, so they are not part of the form.
*/
struct PreSubmissionModel: Equatable {
  var firstName: String = ""
  var lastName: String = ""
  var birthDate: Date?
  var countryCode: String? = "+52"
  var phone: String = ""
  var addressLine1: String = ""
  var addressLine2: String = ""
  var neighborhood: String = ""
  var zipCode: String = ""
  var country: String?
  var state: String?
  var municipality: String = ""
}

// Error message of each required field, null when the field is valid
struct PreSubmissionErrors {
  var firstName: String?
  var lastName: String?
  var birthDate: String?
  var phone: String?
  var addressLine1: String?
  var neighborhood: String?
  var zipCode: String?
  var municipality: String?

  // True when every field is valid
  var isEmpty: Bool {
    [firstName, lastName, birthDate, phone, addressLine1, neighborhood, zipCode, municipality]
      .allSatisfy { $0 == nil }
  }
}
