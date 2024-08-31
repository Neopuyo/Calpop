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

enum PopMemoryAction {
    case select(MemoItem)
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

struct MemoItem: Identifiable, Equatable, Hashable {
    let id: UUID = UUID()
    
    var exp: String = ""
    var result: String = ""
}


// MARK: - WIP: READY FOR FURTHER IMPLEMENTATION

class PopMemoryHandler : PopMemoryDelegate {
    
    private(set) var memoryStock: [MemoItem] {
        didSet { displayMemoryStock() }
    }
    private(set) var currentMemoryItem: MemoItem? {
        didSet { displayMemoryCurrent() }
    }
    
    var displayMemoryStock: () -> () = {}
    var displayMemoryCurrent: () -> () = {}
    
    init() {
        self.memoryStock = PopMemoryHandler.memorySampleData // [!] only for first tests
        self.currentMemoryItem = PopMemoryHandler.memorySampleData.first // [!] only for first tests
    }
    
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
    
    func memoryAction(_ action : PopMemoryAction) {
        switch (action) {
        case .select(let memoItem):
            selectMemoryItem(memoItem)
        }
        
    }
    
    private func selectMemoryItem(_ memoItem: MemoItem) {
        currentMemoryItem = memoItem
    }
    
    
    // MARK: - CHECK VALUE
    private func checkMemory() {
        guard !memoryStock.isEmpty else { print("Memory stock is empty."); return }
        print("[Memory stock]")
        for item in memoryStock {
            print("[\(item == currentMemoryItem ? "*" : " ")]", terminator: " ")
            print("'\(item.exp)' = '\(item.result)'")
        }
    }

}
