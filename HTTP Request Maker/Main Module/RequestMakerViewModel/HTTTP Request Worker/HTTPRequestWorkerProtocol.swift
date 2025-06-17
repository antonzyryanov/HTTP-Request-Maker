//
//  HTTPRequestWorkerProtocol.swift
//  HTTP Request Maker
//
//  Created by Anton Zyryanov on 17.06.2025.
//

import Foundation

protocol HTTPRequestWorkerProtocol: AnyObject {
    func performRequestWith(model: RequestOutputModelProtocol, completion: @escaping (Result<Data, Error>) -> Void)
}
