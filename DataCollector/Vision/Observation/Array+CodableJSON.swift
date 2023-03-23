//
//  Array+CodableJSON.swift
//  DataCollector
//
//  Created by standard on 3/23/23.
//

import Foundation

extension Array where Element: Codable {
    func toJSON() throws -> String {
        let jsonEncoder = JSONEncoder()
        let jsonData = try jsonEncoder.encode(self)
        guard let jsonString = String(data: jsonData, encoding: .utf8) else {
            throw NSError(domain: "Unable to encode JSON string from data", code: 0, userInfo: nil)
        }
        return jsonString
    }
}
