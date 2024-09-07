//
//  PopMemory.swift
//  popping
//
//  Created by Loup Martineau on 13/08/2024.
//

import Foundation


enum PopMemoryAction {
    case select(MemoItem)
    case delete(IndexSet)
    case add(String, PopMemoryAction.Method)
    case create(String, PopMemoryAction.Method)
    case clear
    
    enum Method {
        case add, substract
    }
}

enum PopMemoryError: Error {
    case unknown
    case computeResultFailed
}

extension PopMemoryError: CustomStringConvertible {
    public var description: String {
        switch self {
        case .unknown:                  "unknown PopMemoryError occured"
        case .computeResultFailed:      "computing result of memoItem failed"
        }
    }
}

protocol PopMemoryDelegate {
    func memoryKeyPressed(_ key: PopData.PopKey)
    var isEmpty: Bool { get }
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
        self.memoryStock = []  // = PopMemoryHandler.memorySampleData // [!] only for first tests
        self.currentMemoryItem = nil  // = PopMemoryHandler.memorySampleData.first // [!] only for first tests
    }
    
    static let memorySampleData : [MemoItem] = [
        MemoItem(exp: "1 + 2", result: "3"),
        MemoItem(exp: "200", result: "200"),
        MemoItem(exp: "100 - 10 - 1 - 5 - 9", result: "75"),
    ]
    
    var isEmpty: Bool { memoryStock.isEmpty }
    
    
    // [?] Utilité ?
    func memoryKeyPressed(_ key: PopData.PopKey) {
        
        switch (key) {
            
        case .keyMmenu:
            checkMemory()
            
        case .keyMplus, .keyMminus, .keyMC, .keyMR, .keyMS:
            print("Memory key [\(key.rawValue)] touched")
            
        default:
            print("Error key [\(key.rawValue)] is not a memory one")
        }
    }
    
    func memoryAction(_ action : PopMemoryAction) {
        switch (action) {
        case .select(let memoItem):
            selectMemoryItem(memoItem)
            
        case .delete(let indexSet):
            deleteMemoryItem(at: indexSet)
            
        case .add(let expString, let method):
            addMemoryItem(with: expString, method: method)
            
        case .create(let expString, let method):
            createMemoryItem(with: expString, method: method)
            
        case.clear:
            clearMemory()
        }
        
    }
    
    private func selectMemoryItem(_ memoItem: MemoItem) {
        currentMemoryItem = memoItem
    }
    
    private func deleteMemoryItem(at indexSet: IndexSet) {
        var needChangeCurrent = false
        if let currentIndex = memoryStock.firstIndex(where: { $0 == currentMemoryItem }) {
            if indexSet.contains(currentIndex) {
                needChangeCurrent = true
            }
        }
        memoryStock.remove(atOffsets: indexSet)
        if needChangeCurrent {
            currentMemoryItem = memoryStock.first
        }
    }
    
    private func addMemoryItem(with expString: String, method : PopMemoryAction.Method) {
        currentMemoryItem == nil ? createMemoryItem(with: expString, method: method) 
                                 : appendToCurrentMemoryItem(with: expString, method: method)
    }
    
    private func createMemoryItem(with expString: String, method : PopMemoryAction.Method) {
        let signedExp: String = (method == .add || expString == "0") ? expString : "-\(expString)"
        do {
            let newItem = try MemoItem(exp:signedExp)
            memoryStock.append(newItem)
            currentMemoryItem = newItem
        } catch {
            print("createMemoryItem failed") // [+][?] handle better error
        }
    }
    
    private func appendToCurrentMemoryItem(with expString: String, method : PopMemoryAction.Method) {
        guard currentMemoryItem != nil else { print("appendToCurrentMemoryItem : No current item"); return }  // [+][?] Should never happen
        currentMemoryItem?.appendExp(with: expString, method: method)
        
        // CONTINUE HERE WIP ISSUE after APPEND, Mmenu show wrong data ....
        print("after Append -> currentMemoryItem = \(currentMemoryItem?.result ?? "nil")")
    }
    
    private func clearMemory() {
        memoryStock.removeAll()
        currentMemoryItem = nil
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
