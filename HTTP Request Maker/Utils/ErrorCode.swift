//
//  ErrorCode.swift
//  HTTP Request Maker
//
//  Created by Anton Zyryanov on 18.06.2025.
//

import Foundation

extension Error {
    var errorCode:Int? {
        return (self as NSError).code
    }
}
