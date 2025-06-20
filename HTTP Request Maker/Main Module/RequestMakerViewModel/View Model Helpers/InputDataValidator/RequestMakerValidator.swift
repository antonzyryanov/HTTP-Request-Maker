//
//  RequestMakerInputDataValidator.swift
//  HTTP Request Maker
//
//  Created by Anton Zyryanov on 17.06.2025.
//

import Foundation

class RequestMakerInputDataValidator {
    func urlValidated(urlString: String?) -> Bool {
        if urlString == nil { return false }
        if let url = urlString, url == "" {
            return false
        }
        let urlRegEx = "((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+"
        return NSPredicate(format: "SELF MATCHES %@", urlRegEx).evaluate(with: urlString)
    }
    
    func validate(_ stringData: String, as stringDataType: String?) -> DataValidationResult {
        guard let type = stringDataType else {
            return .failure("Data type not specified. Possible Types: \'Int\',\'String\',\'JSON-array\',\'JSON-object\'")
        }
        switch type {
        case "Int":
            return Int(stringData) != nil ? .success(.Int) : .failure("Data type not specified. Possible Types: \'Int\',\'String\',\'JSON-array\',\'JSON-object\'")
        case "String":
            return .success(.String)
        case "JSON-array":
            if let data = stringData.data(using: .utf8) {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [Any] {
                        return .success(.JSONArray)
                    }
                } catch {
                    return .failure("Data type not specified. Possible Types: \'Int\',\'String\',\'JSON-array\',\'JSON-object\'")
                }
            }
            return .failure("Data type not specified. Possible Types: \'Int\',\'String\',\'JSON-array\',\'JSON-object\'")
        case "JSON-object":
            if let data = stringData.data(using: .utf8) {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        return .success(.JSON)
                    }
                } catch {
                    return .failure("Data type not specified. Possible Types: \'Int\',\'String\',\'JSON-array\',\'JSON-object\'")
                }
            }
            return .failure("Data type not specified. Possible Types: \'Int\',\'String\',\'JSON-array\',\'JSON-object\'")
        default:
            return .failure("Data type not specified. Possible Types: \'Int\',\'String\',\'JSON-array\',\'JSON-object\'")
        }
    }
    
}
