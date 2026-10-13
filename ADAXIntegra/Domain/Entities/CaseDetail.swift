//
//  CaseDetail.swift
//  ADAXIntegra
//  Created by Oscar Alexander Vilchis Soto on 02/10/26.
//  Entity for US V-11 full case detail
//  Decodes the backend's RAW response directly into camelCase Swift properties
//
import Foundation

// Full detail of a single case, as returned by GET /cases/:caseId
// the backend sends the raw information, so each property below corresponds to the exact snake_case key returned by Supabase

struct CaseDetail: Decodable {
  let caseId: String
  let caseNumber: String?
  let writtenDescription: String?
  let writtenHelpsWanted: String?
  let hasLawyer: Bool
  let state: String
  let recordId: String?
  let createdAt: String?
  let updatedAt: String?

  // Raw nested shapes as they arrive in the JSON
  let record: CaseDetailRecord
  let caseSteps: [CaseDetailStep]
  let caseViolence: [CaseDetailViolenceWrapper]
  let caseHelp: [CaseDetailHelpWrapper]

  enum CodingKeys: String, CodingKey {
    case caseId = "case_id"
    case caseNumber = "case_number"
    case writtenDescription = "written_description"
    case writtenHelpsWanted = "written_helps_wanted"
    case hasLawyer = "has_lawyer"
    case state
    case recordId = "record_id"
    case createdAt = "created_at"
    case updatedAt = "updated_at"
    case record
    case caseSteps = "case_steps"
    case caseViolence = "case_violence"
    case caseHelp = "case_help"
  }

  // we unwrap supabase join structure so  we "help" the View and ViewModel by not letting them deal with raw JSON structure
  var user: CaseDetailUser { record.user }
  var steps: [CaseDetailStep] { caseSteps }
  var helps: [CaseDetailHelp] { caseHelp.map { $0.helpTypes } }
  var violenceTypes: [CaseDetailViolenceType] { caseViolence.map { $0.violenceTypes } }
}

// Intermediate container as the backend nests the external user info
struct CaseDetailRecord: Decodable {
  let user: CaseDetailUser
}

// Basic info about the external who the case belongs to
struct CaseDetailUser: Decodable {
  let userId: String?
  let name: String?
  let lastName: String?

  enum CodingKeys: String, CodingKey {
    case userId = "user_id"
    case name
    case lastName = "last_name"
  }
}

struct CaseDetailStep: Decodable, Identifiable {
  let caseStepId: String?
  let stepNumber: Int?
  let status: String?

  enum CodingKeys: String, CodingKey {
    case caseStepId = "case_step_id"
    case stepNumber = "step_number"
    case status
  }

  // identifiable needs a non-optional id for ForEach/List to work so  this fallback
  // avoids a crash if it's ever missing the caseStepId
  var id: String { caseStepId ?? UUID().uuidString }
}

struct CaseDetailHelp: Decodable, Identifiable {
  let helpId: String?
  let description: String?

  enum CodingKeys: String, CodingKey {
    case helpId = "help_id"
    case description
  }

  var id: String { helpId ?? UUID().uuidString }
}

// Supabase returns each help item as { "help_types": {...} } This wrapper matches that structure so Swift  can decode it into  CaseDetailHelp
struct CaseDetailHelpWrapper: Decodable {
  let helpTypes: CaseDetailHelp

  enum CodingKeys: String, CodingKey {
    case helpTypes = "help_types"
  }
}

struct CaseDetailViolenceType: Decodable, Identifiable {
  let violenceId: String?
  let description: String?
  let severity: Int?

  enum CodingKeys: String, CodingKey {
    case violenceId = "violence_id"
    case description
    case severity
  }

  var id: String { violenceId ?? UUID().uuidString }
}

// Same thing as CaseDetailHelpWrapper but for  "case_violence"
struct CaseDetailViolenceWrapper: Decodable {
  let violenceTypes: CaseDetailViolenceType

  enum CodingKeys: String, CodingKey {
    case violenceTypes = "violence_types"
  }
}

// Response from PATCH /cases/:caseId/close  but is the contrary of CaseDetail because
// this endpoint is in  camelCase
struct CloseCaseResult: Decodable {
  let caseId: String
  let state: String
  let updatedAt: String
}
