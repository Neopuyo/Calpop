//
//  PopMemory.swift
//  popping
//
//  Created by Loup Martineau on 13/08/2024.
//

import Foundation


enum PopMemoryError: Error {
    case unknown
}

extension PopMemoryError: CustomStringConvertible {
    public var description: String {
        switch self {
        case .unknown: "unknown PopMemoryError occured"
        }
    }
}

protocol PopMemoryDelegate {
    func isMemoryEmpty() -> Bool
}


// MARK: - WIP: READY FOR FURTHER IMPLEMENTATION

class PopMemoryHandler : PopMemoryDelegate {
    
    func memoryKeyPressed(_ key: PopData.PopKey) {
        print("Memory key [\(key.rawValue)] not handled yet 🦔")
    }
    
    func isMemoryEmpty() -> Bool {
        return true
    }
}
