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
    // The backend answered with an error status (no connection, timeout, decoding issue)
    case server(statusCode: Int, data: Data?)
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
            continuation.resume(throwing: mapError(error, response: response.response, data: response.data))
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
            continuation.resume(throwing: mapError(error, response: response.response, data: response.data))
        }
      }
    }
  }
    // Keeps the backend status code and body when the server answers with an error,so screens can show messages like: This email has already been registered
    private static func mapError(_ error: AFError, response: HTTPURLResponse?, data: Data?) -> APIError {
        if let statusCode = response?.statusCode, !(200..<300).contains(statusCode) {
            return .server(statusCode: statusCode, data: data)
        }
        return .requestFailed(error.localizedDescription)
    }
}
