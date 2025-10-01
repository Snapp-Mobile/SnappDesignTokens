//
//  String+Extensions.swift
//
//  Created by Volodymyr Voiko on 04.03.2025.
//

import SnappDesignTokens
import Foundation

extension String {
    private struct Box<T: Decodable>: Decodable {
        let wrapped: T
    }

    func decodeTokenOfType(
        _ type: TokenType,
        wrapInParenthesis: Bool = false
    )
        throws -> Token
    {
        let value = wrapInParenthesis ? "\"\(self)\"" : self
        let json = """
            { "$type": "\(type.rawValue)", "$value": \(value) }
            """
        return try json.decode()
    }

    func decode<T: Decodable>(tryBoxed: Bool = true) throws -> T {
        guard let data = data(using: .utf8) else {
            throw DecodingError.dataCorrupted(
                DecodingError.Context(
                    codingPath: [],
                    debugDescription: "Failed to convert string to data"
                )
            )
        }
        do {
            return try dtcgJSONDecoder.decode(T.self, from: data)
        } catch {
            guard tryBoxed else { throw error }
            let box: Box<T> = try "{\"wrapped\": \(self)}".decode(
                tryBoxed: false
            )
            return box.wrapped
        }
    }

    static func encode<T: Encodable>(_ object: T) throws -> String {
        let data = try dtcgJSONEncoder.encode(object)
        guard let string = String(data: data, encoding: .utf8) else {
            throw EncodingError.invalidValue(
                self,
                .init(
                    codingPath: [],
                    debugDescription: "Failed to convert data to string"
                )
            )
        }
        return string
    }

    static func jsonString(from object: [String: [String: String]])
        -> String?
    {
        guard
            let data = try? JSONSerialization.data(
                withJSONObject: object,
                options: [.prettyPrinted]
            ),
            let string = String(data: data, encoding: .utf8)
        else {
            return nil
        }
        return string
    }

    func prettyPrintJSON() -> String {
        guard let jsonData = data(using: .utf8) else {
            return "Invalid JSON"
        }
        return jsonData.prettyPrintJSON()
    }
}
