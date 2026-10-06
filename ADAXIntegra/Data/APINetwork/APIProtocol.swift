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
  // The backend answered with an error status (400, 403, 404, 409, ...)
  case server(statusCode: Int, message: String?)
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

  // G-07: Unlike the other methods, it keeps the status code so
  // the ViewModel can tell a duplicated email (409) from other errors
  static func patch<Body: Encodable, T: Decodable>(
    _ path: String,
    body: Body,
    as type: T.Type
  ) async throws -> T {
    return try await withCheckedThrowingContinuation { continuation in
      AF.request(
        APIConfig.baseURL + path,
        method: .patch,
        parameters: body,
        encoder: JSONParameterEncoder.default,
        headers: authHeaders
      )
      .validate()
      .responseDecodable(of: T.self) { response in
        switch response.result {
        case .success(let value): continuation.resume(returning: value)
        case .failure(let error):
          if let statusCode = response.response?.statusCode, statusCode >= 400 {
            let message = response.data.flatMap {
              try? JSONDecoder().decode(APIErrorBody.self, from: $0)
            }?.error
            continuation.resume(throwing: APIError.server(statusCode: statusCode, message: message))
          } else {
            continuation.resume(throwing: APIError.requestFailed(error.localizedDescription))
          }
        }
      }
    }
  }

  // PUT that sends text fields and files in one multipart request.
  static func putMultipart<T: Decodable>(
    _ path: String,
    fields: [String: String],
    files: [String: DocumentFile],
    as type: T.Type
  ) async throws -> T {
    try await withCheckedThrowingContinuation { continuation in
      AF.upload(
        multipartFormData: { form in
          for (name, value) in fields {
            form.append(Data(value.utf8), withName: name)
          }
          for (name, file) in files {
            form.append(
              file.data, withName: name, fileName: file.fileName, mimeType: file.mimeType)
          }
        },
        to: APIConfig.baseURL + path,
        method: .put,
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
}
