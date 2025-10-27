import Foundation
import Combine

enum ApiModel { }

protocol WebRepository {
    var session: URLSession { get }
    var baseURL: String { get }
}

extension WebRepository {
    func call<Value, Decoder>(
        endpoint: APICall,
        decoder: Decoder = JSONDecoder(),
        httpCodes: HTTPCodes = .success
    ) async throws -> Value
    where Value: Decodable, Decoder: TopLevelDecoder, Decoder.Input == Data {

        let request = try endpoint.urlRequest(baseURL: baseURL)
        
        logger.logNetwork("API request started", url: request.url?.absoluteString, method: request.httpMethod)
        
        let (data, response) = try await session.data(for: request)
        
        guard let code = (response as? HTTPURLResponse)?.statusCode else {
            logger.error("Unexpected response format", category: "Network")
            throw APIError.unexpectedResponse
        }
        
        guard httpCodes.contains(code) else {
            logger.warning("HTTP error code: \(code)", category: "Network", 
                metadata: ["statusCode": code, "url": request.url?.absoluteString ?? "unknown"])
            throw APIError.httpCode(code)
        }
        
        logger.info("API request successful", category: "Network", 
            metadata: ["statusCode": code, "dataSize": data.count])
        
        do {
            return try decoder.decode(Value.self, from: data)
        } catch {
            logger.error("Failed to decode response", category: "Network", 
                metadata: ["error": error.localizedDescription])
            throw APIError.unexpectedResponse
        }
    }
}

// MARK: - APICall

protocol APICall {
    var path: String { get }
    var method: String { get }
    var headers: [String: String]? { get }
    func body() throws -> Data?
}

enum APIError: Swift.Error, Equatable {
    case invalidURL
    case httpCode(HTTPCode)
    case unexpectedResponse
    case imageDeserialization
}

extension APIError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidURL: return "Invalid URL"
        case let .httpCode(code): return "Unexpected HTTP code: \(code)"
        case .unexpectedResponse: return "Unexpected response from the server"
        case .imageDeserialization: return "Cannot deserialize image from Data"
        }
    }
}

extension APICall {
    func urlRequest(baseURL: String) throws -> URLRequest {
        guard let url = URL(string: baseURL + path) else {
            throw APIError.invalidURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.allHTTPHeaderFields = headers
        request.httpBody = try body()
        return request
    }
}

typealias HTTPCode = Int
typealias HTTPCodes = Range<HTTPCode>

extension HTTPCodes {
    static let success = 200 ..< 300
}
