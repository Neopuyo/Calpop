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
    func memoryKeyPressed(_ key: PopData.PopKey)
    var isEmpty: Bool { get }
}

struct MemoItem {
    var exp:String = ""
    var result: String = ""
}


// MARK: - WIP: READY FOR FURTHER IMPLEMENTATION

class PopMemoryHandler : PopMemoryDelegate {
    
    private(set) var memoryStock: [MemoItem] = memorySampleData // []
    private var currentMemoryIndex: Int = 0
    
    static let memorySampleData : [MemoItem] = [
        MemoItem(exp: "1 + 2", result: "3"),
        MemoItem(exp: "200", result: "200"),
        MemoItem(exp: "100 - 10 - 1 - 5 - 9", result: "75"),
    ]
    
    var isEmpty: Bool { memoryStock.isEmpty }
    
    func memoryKeyPressed(_ key: PopData.PopKey) {
        
        switch (key) {
            
        case .keyMmenu:
            checkMemory()
            
        default:
            print("Memory key [\(key.rawValue)] not handled yet 🦔")
        }
    }
    
    
    
    // MARK: - CHECK VALUE
    private func checkMemory() {
        guard !memoryStock.isEmpty else { print("Memory stock is empty."); return }
        print("[Memory stock]")
        for item in memoryStock {
            print("'\(item.exp)' = '\(item.result)'")
        }
    }

}
