//
//  CaseDetail.swift
//  ADAXIntegra
//  Created by Oscar Alexander Vilchis Soto on 02/10/26.
//  Entity for US V-11 full case detail
//  Decodes the backend's RAW response directly into camelCase Swift properties
//

import Foundation

/// Represents the complete details of a case decoded directly from the backend JSON response.
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
    let user: CaseDetailUser
    let steps: [CaseDetailStep]
    let helps: [CaseDetailHelp]
    let violenceTypes: [CaseDetailViolenceType]

    private enum CodingKeys: String, CodingKey {
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

    private enum RecordCodingKeys: String, CodingKey {
        case user
    }
    // Custom initializer to handle custom decoding logic and fallbacks
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        caseId = try container.decode(String.self, forKey: .caseId)
        caseNumber = try container.decodeIfPresent(String.self, forKey: .caseNumber)
        writtenDescription = try container.decodeIfPresent(String.self, forKey: .writtenDescription)
        writtenHelpsWanted = try container.decodeIfPresent(String.self, forKey: .writtenHelpsWanted)
        hasLawyer = try container.decodeIfPresent(Bool.self, forKey: .hasLawyer) ?? false
        state = try container.decode(String.self, forKey: .state)
        recordId = try container.decodeIfPresent(String.self, forKey: .recordId)
        createdAt = try container.decodeIfPresent(String.self, forKey: .createdAt)
        updatedAt = try container.decodeIfPresent(String.self, forKey: .updatedAt)

        let recordContainer = try? container.nestedContainer(keyedBy: RecordCodingKeys.self, forKey: .record)
        user = try recordContainer?.decode(CaseDetailUser.self, forKey: .user)
            ?? CaseDetailUser(userId: nil, name: nil, lastName: nil)

        steps = try container.decodeIfPresent([CaseDetailStep].self, forKey: .caseSteps) ?? []

        // helps with "unwraping" the case_violence/case_help arrive info when tey arrive like json because of backend so the app only deals with the inner content
        let violenceWrappers = try container.decodeIfPresent([CaseDetailViolenceWrapper].self, forKey: .caseViolence) ?? []
        violenceTypes = violenceWrappers.map { $0.violenceTypes }

        let helpWrappers = try container.decodeIfPresent([CaseDetailHelpWrapper].self, forKey: .caseHelp) ?? []
        helps = helpWrappers.map { $0.helpTypes }
    }
}

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
// Represents a step/stage associated with the case.
struct CaseDetailStep: Decodable, Identifiable {
    let caseStepId: String?
    let stepNumber: Int?
    let status: String?

    enum CodingKeys: String, CodingKey {
        case caseStepId = "case_step_id"
        case stepNumber = "step_number"
        case status
    }

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

private struct CaseDetailHelpWrapper: Decodable {
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

private struct CaseDetailViolenceWrapper: Decodable {
    let violenceTypes: CaseDetailViolenceType

    enum CodingKeys: String, CodingKey {
        case violenceTypes = "violence_types"
    }
}

// Represents the response model for closing a case (PATCH /cases/:caseId/close)
// Decodes automatically using standard camelCase since backend formats this specific endpoint
struct CloseCaseResult: Decodable {
    let caseId: String
    let state: String
    let updatedAt: String
}
