//
//  APIResponse.swift
//  ADAXIntegra
//
//  Created by armando fuentes on 23/09/26.
//

// backend response is: { success: true, data: [...] }
struct APIResponse<T: Decodable>: Decodable {
  let success: Bool
  let data: T
}

// Error body sent by the backend: { success: false, error: "..." }
nonisolated struct APIErrorBody: Decodable {
  let error: String?
}
