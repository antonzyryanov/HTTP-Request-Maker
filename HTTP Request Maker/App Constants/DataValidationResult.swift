//
//  DataValidationResult.swift
//  HTTP Request Maker
//
//  Created by Anton Zyryanov on 17.06.2025.
//

import Foundation

enum DataValidationResult {
    case success(PossibleDataTransferTypes)
    case failure(String)
}
