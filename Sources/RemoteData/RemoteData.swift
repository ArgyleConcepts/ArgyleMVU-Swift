//
//  RemoteData.swift
//  RemoteData
//
//  Created by David Cyman on 4/3/23.
//

import Foundation

public enum RemoteData<Element> {
    
    case notAsked
    case loading
    case success(Element)
    case failure(Error)
    
    // MARK: Properties
    
    public var valueOrNil: Element? {
        switch self {
        case .success(let value):
            return value
        case .notAsked, .loading, .failure:
            return nil
        }
    }
    
    public var isSuccess: Bool {
        switch self {
        case .success:
            return true
        case .notAsked, .loading, .failure:
            return false
        }
    }
    
    // MARK: Init
    
    public init(result: Result<Element, Error>) {
        switch result {
        case .success(let value):
            self = .success(value)
        case .failure(let error):
            self = .failure(error)
        }
    }
    
}
