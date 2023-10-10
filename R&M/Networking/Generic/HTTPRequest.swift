//
//  HTTPRequest.swift
//
//
//  Created by Thais Rodríguez on 11/5/23.
//

import Foundation

public enum BeConnectedError: Error, LocalizedError {
    case invalidURL
    case noData
    case invalidResponse
    case statusCode(_ statusCode: Int)
    case decodingFailed
    case other(Error)

    var errorTitle: String {
        return "Error"
    }

    public var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .noData:
            return "There is no data"
        case .invalidResponse:
            return "Invalid response"
        case let .statusCode(statusCode):
            return "Bad response with status code: \(statusCode)"
        case .decodingFailed:
            return "Invalid data - Error decoding data from server"
        case let .other(error):
            return "Unknown error: \(error)"
        }
    }
}

public protocol HTTPRequest {
    func run<Model: Decodable>(_ endpoint: Endpoint) async throws -> Model
    func getJSONFromLocalFile<T: Decodable>(fileName: String, bundle: Bundle) async throws -> T
}

public extension HTTPRequest {
    func run<Model: Decodable>(_ endpoint: Endpoint) async throws -> Model {
        let response: (data: Data, response: URLResponse) = try await response(endpoint: endpoint)
        return try decode(data: response.data, url: endpoint.urlRequest.url?.absoluteString)
    }
    
    func run<Model: Decodable>(_ request: URLRequest) async throws -> Model {
        let response: (data: Data, response: URLResponse) = try await response(request: request)
        return try decode(data: response.data, url: request.url?.absoluteString)
    }

    private func response(request: URLRequest) async throws -> (data: Data, response: URLResponse) {
        do {
            return try await URLSession.shared.data(for: request)
        } catch {
            dump(error, name: "⛔️⛔️⛔️ Request response error ⛔️⛔️⛔️")
            throw BeConnectedError.other(error)
        }
    }

    private func response(endpoint: Endpoint) async throws -> (data: Data, response: URLResponse) {
        do {
            return try await URLSession.shared.data(for: endpoint.urlRequest)
        } catch {
            dump(error, name: "⛔️⛔️⛔️ Request response error ⛔️⛔️⛔️")
            throw BeConnectedError.other(error)
        }
    }

    private func decode<Model: Decodable>(data: Data, url: String?) throws -> Model {
        do {
            printDataReceived(from: url, data: data)
            let decodedData: Model = try data.decodeDataTo()
            return decodedData
        } catch let decodingError {
            dump(decodingError, name: "⛔️⛔️⛔️ Error decoding object at \(url ?? "NO URL") ⛔️⛔️⛔️")
            throw BeConnectedError.decodingFailed
        }
    }

    func getJSONFromLocalFile<T: Decodable>(fileName: String, bundle: Bundle = .main) throws -> T {
        printRequestedData(from: fileName)

        guard let path = bundle.path(forResource: fileName, ofType: "json") else {
            throw BeConnectedError.invalidURL
        }

        guard let fileContent = FileManager.default.contents(atPath: path) else {
            throw BeConnectedError.decodingFailed
        }

        printDataReceived(from: fileName, data: fileContent)

        return try decode(data: fileContent, url: fileName)
    }

    private func printRequestedData(from url: String?) {
        print("🕊🕊🕊 Requested data from:", url ?? "NO URL", "🕊🕊🕊")
    }

    private func printDataReceived(from url: String?, data: Data) {
        print("🪵🪵🪵\nRequest \(url ?? "NO URL") response:\n\(data.prettyPrintedJSONString)\n🪵🪵🪵")
    }
}

extension Data {
    private static let decoder = JSONDecoder()

    func decodeDataTo<T: Decodable>(dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .iso8601, keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys) throws -> T {
        Self.decoder.dateDecodingStrategy = dateDecodingStrategy
        Self.decoder.keyDecodingStrategy = keyDecodingStrategy
        return try Self.decoder.decode(T.self, from: self)
    }

    var prettyPrintedJSONString: NSString {
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
              let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else { return "" }

        return prettyPrintedString
    }
}
