//
//  Data+Extensions.swift
//
//  Created by Oleksii Kolomiiets on 05.03.2025.
//

import Foundation

extension Data {
    func prettyPrintJSON() -> String {
        guard let jsonObject = try? JSONSerialization.jsonObject(with: self, options: []),
              let jsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: [.prettyPrinted, .sortedKeys]),
              let jsonString = String(data: jsonData, encoding: .utf8) else {
            return "Invalid JSON"
        }
        return jsonString
    }
}
