//
//  APIProtocol.swift
//  ADAXIntegra
//
//  Created by armando fuentes on 23/09/26.
//
import Alamofire
import Foundation

enum APIError: Error {
    // The backend answered with an error status (no connection, timeout, decoding issue)
  case requestFailed(String)
    // The backend answered with an error status (400, 401, 409...) and its body
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

  // Function patch that performs an asynchronous HTTP PATCH request without a body, we recieve the path, the decodable response type and we return the decoded model instance of type
  static func patch<T: Decodable>(
    _ path: String,
    as type: T.Type
  ) async throws -> T {
    return try await withCheckedThrowingContinuation { continuation in
      AF.request(
        APIConfig.baseURL + path,
        method: .patch,
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
    // Function delete that performs an asynchronous HTTP DELETE request implementes for us B-02 (deletes a comment)
      static func delete(_ path: String) async throws {
        return try await withCheckedThrowingContinuation { continuation in
          AF.request(
            APIConfig.baseURL + path,
            method: .delete,
            headers: authHeaders
          )
          .validate()
          .response { response in
            switch response.result {
            case .success:
              continuation.resume()
            case .failure(let error):
              continuation.resume(throwing: mapError(error, response: response.response, data: response.data))
            }
          }
        }
      }
}
