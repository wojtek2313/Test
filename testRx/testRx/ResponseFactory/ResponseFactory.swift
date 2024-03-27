//
//  ResponseManager.swift
//  testRx
//
//  Created by Wojciech Kulas on 26/03/2024.
//

import Foundation

// MARK: - Protocol Definition

protocol ResponseFactoryProtocol {
    func create() -> [String: Double]
}

// MARK: - Class Definition

class ResponseFactory: ResponseFactoryProtocol {
    // MARK: - Public Methods
    
    public func create() -> [String: Double] {
        var dictionary: [String: Double] = [:]
        guard let url = Bundle.main.url(forResource: "response", withExtension: "json") else { return dictionary }
        do {
            let data = try Data(contentsOf: url)
            let object = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
            guard let data = object?["quotes"] as? [String: Double] else { return dictionary }
            dictionary = data
        } catch {
            print("error: \(error)")
        }
        return dictionary
    }
}
