//
//  Utility.swift
//  MagicApp
//
//  Created by Tuan IT. Hoang Anh on 25/07/2022.
//

import Foundation

public struct Utility {
    public static func getMessageFromBE(error: Error) -> String {
        if let error = error as? ExpectingAPIError,
           let data = error.data,
           let bodyString = String(data: data, encoding: .utf8),
           let message = Utility.convertToDictionary(text: bodyString) {
            return (message["title"] as? String) ?? (message["message"] as? String) ?? error.localizedDescription
        } else {
            return error.localizedDescription
        }
    }
    
    public static func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
}
