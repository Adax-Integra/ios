//
//  APIProtocol.swift
//  ADAXIntegra
//
//  Created by armando fuentes on 23/09/26.
//
import Alamofire
import Foundation

enum APIError: Error {
  case requestFailed(String)
}

struct APIProtocol {
  // Adds the session token to every request when the user is logged in
  private static var authHeaders: HTTPHeaders {
    guard let token = APIConfig.token else { return [] }
    return [.authorization(bearerToken: token)]
  }

  static func get<T: Decodable>(
    _ path: String,
    as type: T.Type
  ) async throws -> T {
    return try await withCheckedThrowingContinuation { continuation in
      AF.request(APIConfig.baseURL + path, headers: authHeaders)
        .validate()
        .responseDecodable(of: T.self) { response in
          switch response.result {
          case .success(let value):
            continuation.resume(returning: value)
          case .failure(let error):
            continuation.resume(throwing: APIError.requestFailed(error.localizedDescription))
          }
        }
    }
  }

  static func post<Body: Encodable, T: Decodable>(
    _ path: String,
    body: Body,
    as type: T.Type
  ) async throws -> T {
    return try await withCheckedThrowingContinuation { continuation in
      AF.request(
        APIConfig.baseURL + path,
        method: .post,
        parameters: body,
        encoder: JSONParameterEncoder.default,
        headers: authHeaders
      )
      .validate()
      .responseDecodable(of: T.self) { response in
        switch response.result {
        case .success(let value):
          continuation.resume(returning: value)
        case .failure(let error):
          continuation.resume(throwing: APIError.requestFailed(error.localizedDescription))
        }
      }
    }
  }

  static func put<Body: Encodable, T: Decodable>(
    _ path: String,
    body: Body,
    as type: T.Type
  ) async throws -> T {
    return try await withCheckedThrowingContinuation { continuation in
      AF.request(
        APIConfig.baseURL + path,
        method: .put,
        parameters: body,
        encoder: JSONParameterEncoder.default
      )
      .validate()
      .responseDecodable(of: T.self) { response in
        switch response.result {
        case .success(let value):
          continuation.resume(returning: value)
        case .failure(let error):
          continuation.resume(throwing: APIError.requestFailed(error.localizedDescription))
        }
      }
    }
  }

  static func upload<T: Decodable>(
    _ path: String, data: Data, name: String, fileName: String, mimeType: String, as type: T.Type
  ) async throws -> T {
    try await withCheckedThrowingContinuation { continuation in
      AF.upload(
        multipartFormData: { form in
          form.append(data, withName: name, fileName: fileName, mimeType: mimeType)
        },
        to: APIConfig.baseURL + path
      )
      .validate()
      .responseDecodable(of: T.self) { response in
        switch response.result {
        case .success(let value):
          continuation.resume(returning: value)
        case .failure(let error):
          continuation.resume(throwing: APIError.requestFailed(error.localizedDescription))
        }
      }
    }
  }
}
