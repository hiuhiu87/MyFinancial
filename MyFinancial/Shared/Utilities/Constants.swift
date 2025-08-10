//
//  Constants.swift
//  MyFinancial
//
//  Created by NMH on 20/7/25.
//

import Alamofire
import Combine
import Foundation

// MARK: - Network Error Types
enum NetworkError: Error, LocalizedError {
    case invalidURL
    case noData
    case decodingError(Error)
    case serverError(Int)
    case networkFailure(Error)
    case unauthorized
    case forbidden
    case notFound
    case timeout
    case unknown

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .noData:
            return "No data received"
        case .decodingError(let error):
            return "Decoding error: \(error.localizedDescription)"
        case .serverError(let code):
            return "Server error with code: \(code)"
        case .networkFailure(let error):
            return "Network failure: \(error.localizedDescription)"
        case .unauthorized:
            return "Unauthorized access"
        case .forbidden:
            return "Forbidden access"
        case .notFound:
            return "Resource not found"
        case .timeout:
            return "Request timeout"
        case .unknown:
            return "Unknown error occurred"
        }
    }
}

// MARK: - HTTP Method Extension
extension HTTPMethod {
    static let patch = HTTPMethod(rawValue: "PATCH")
}

// MARK: - Request Configuration Protocol
protocol RequestConfigurable {
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: HTTPHeaders? { get }
    var parameters: Parameters? { get }
    var encoding: ParameterEncoding { get }
    var timeout: TimeInterval { get }
}

// MARK: - Default Request Configuration
extension RequestConfigurable {
    var baseURL: String { "https://api.example.com" }
    var headers: HTTPHeaders? { nil }
    var parameters: Parameters? { nil }
    var encoding: ParameterEncoding { JSONEncoding.default }
    var timeout: TimeInterval { 30.0 }
}

// MARK: - Base Request Class
class BaseRequest: ObservableObject {

    // MARK: - Properties
    private let session: Session
    @Published var isLoading = false
    @Published var error: NetworkError?

    // MARK: - Initialization
    init(session: Session = AF) {
        self.session = session
        configureSession()
    }

    // MARK: - Session Configuration
    private func configureSession() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        configuration.timeoutIntervalForResource = 60
        configuration.requestCachePolicy = .useProtocolCachePolicy
    }

    // MARK: - Generic Request Method with Codable Response
    func request<T: Codable>(
        _ config: RequestConfigurable,
        responseType: T.Type,
        completion: @escaping (Result<T, NetworkError>) -> Void
    ) {
        guard let url = URL(string: config.baseURL + config.path) else {
            completion(.failure(.invalidURL))
            return
        }

        DispatchQueue.main.async {
            self.isLoading = true
            self.error = nil
        }

        session.request(
            url,
            method: config.method,
            parameters: config.parameters,
            encoding: config.encoding,
            headers: config.headers
        )
        .validate()
        .responseDecodable(of: T.self) { [weak self] response in
            DispatchQueue.main.async {
                self?.isLoading = false

                switch response.result {
                case .success(let data):
                    completion(.success(data))

                case .failure(let error):
                    let networkError = self?.handleAlamofireError(
                        error,
                        response: response.response
                    )
                    self?.error = networkError
                    completion(.failure(networkError ?? .unknown))
                }
            }
        }
    }

    // MARK: - Async/Await Request Method
    @MainActor
    func request<T: Codable>(
        _ config: RequestConfigurable,
        responseType: T.Type
    ) async throws -> T {
        guard let url = URL(string: config.baseURL + config.path) else {
            throw NetworkError.invalidURL
        }

        isLoading = true
        error = nil

        defer {
            isLoading = false
        }

        do {
            let response = try await session.request(
                url,
                method: config.method,
                parameters: config.parameters,
                encoding: config.encoding,
                headers: config.headers
            )
            .validate()
            .serializingDecodable(T.self)
            .value

            return response

        } catch {
            let networkError = handleAlamofireError(
                error as? AFError,
                response: nil
            )
            self.error = networkError
            throw networkError
        }
    }

    // MARK: - Combine Publisher Request Method
    func requestPublisher<T: Codable>(
        _ config: RequestConfigurable,
        responseType: T.Type
    ) -> AnyPublisher<T, NetworkError> {
        guard let url = URL(string: config.baseURL + config.path) else {
            return Fail(error: NetworkError.invalidURL)
                .eraseToAnyPublisher()
        }

        DispatchQueue.main.async {
            self.isLoading = true
            self.error = nil
        }

        return session.request(
            url,
            method: config.method,
            parameters: config.parameters,
            encoding: config.encoding,
            headers: config.headers
        )
        .validate()
        .publishDecodable(type: T.self)
        .value()
        .mapError { [weak self] error in
            let networkError =
                self?.handleAlamofireError(error as? AFError, response: nil)
                ?? .unknown
            DispatchQueue.main.async {
                self?.isLoading = false
                self?.error = networkError
            }
            return networkError
        }
        .handleEvents(
            receiveOutput: { [weak self] _ in
                DispatchQueue.main.async {
                    self?.isLoading = false
                }
            }
        )
        .eraseToAnyPublisher()
    }

    // MARK: - Raw Data Request Method
    func requestData(
        _ config: RequestConfigurable,
        completion: @escaping (Result<Data, NetworkError>) -> Void
    ) {
        guard let url = URL(string: config.baseURL + config.path) else {
            completion(.failure(.invalidURL))
            return
        }

        DispatchQueue.main.async {
            self.isLoading = true
            self.error = nil
        }

        session.request(
            url,
            method: config.method,
            parameters: config.parameters,
            encoding: config.encoding,
            headers: config.headers
        )
        .validate()
        .responseData { [weak self] response in
            DispatchQueue.main.async {
                self?.isLoading = false

                switch response.result {
                case .success(let data):
                    completion(.success(data))

                case .failure(let error):
                    let networkError = self?.handleAlamofireError(
                        error,
                        response: response.response
                    )
                    self?.error = networkError
                    completion(.failure(networkError ?? .unknown))
                }
            }
        }
    }

    // MARK: - Upload Request Method
    func upload<T: Codable>(
        _ config: RequestConfigurable,
        data: Data,
        responseType: T.Type,
        completion: @escaping (Result<T, NetworkError>) -> Void
    ) {
        guard let url = URL(string: config.baseURL + config.path) else {
            completion(.failure(.invalidURL))
            return
        }

        DispatchQueue.main.async {
            self.isLoading = true
            self.error = nil
        }

        session.upload(
            data,
            to: url,
            method: config.method,
            headers: config.headers
        )
        .validate()
        .responseDecodable(of: T.self) { [weak self] response in
            DispatchQueue.main.async {
                self?.isLoading = false

                switch response.result {
                case .success(let data):
                    completion(.success(data))

                case .failure(let error):
                    let networkError = self?.handleAlamofireError(
                        error,
                        response: response.response
                    )
                    self?.error = networkError
                    completion(.failure(networkError ?? .unknown))
                }
            }
        }
    }

    // MARK: - Error Handling
    private func handleAlamofireError(
        _ error: AFError?,
        response: HTTPURLResponse?
    ) -> NetworkError {
        guard let afError = error else {
            return .unknown
        }

        switch afError {
        case .invalidURL:
            return .invalidURL

        case .responseValidationFailed(let reason):
            switch reason {
            case .unacceptableStatusCode(let code):
                return handleHTTPStatusCode(code)
            default:
                return .serverError(response?.statusCode ?? 0)
            }

        case .responseSerializationFailed(let reason):
            switch reason {
            case .decodingFailed(let error):
                return .decodingError(error)
            case .inputDataNilOrZeroLength:
                return .noData
            default:
                return .decodingError(afError)
            }

        case .sessionTaskFailed(let error):
            if (error as NSError).code == NSURLErrorTimedOut {
                return .timeout
            }
            return .networkFailure(error)

        default:
            return .networkFailure(afError)
        }
    }

    private func handleHTTPStatusCode(_ code: Int) -> NetworkError {
        switch code {
        case 401:
            return .unauthorized
        case 403:
            return .forbidden
        case 404:
            return .notFound
        case 408:
            return .timeout
        case 500...599:
            return .serverError(code)
        default:
            return .serverError(code)
        }
    }

    // MARK: - Cancel All Requests
    func cancelAllRequests() {
        session.cancelAllRequests()
    }
}
