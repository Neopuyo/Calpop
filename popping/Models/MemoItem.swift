//
//  MemoItem.swift
//  popping
//
//  Created by Loup Martineau on 07/09/2024.
//

import Foundation
import Expression

class MemoItem {
    
    let id: UUID = UUID()
    
    private(set) var exp: String = "" {
        didSet { computeResult() }
    }
    private(set) var result: String = ""
    
    init(exp: String, result:String) {
        self.exp = exp
        self.result = result
    }
    
    init(exp:String) throws {
        self.exp = exp
        let expression : Expression = Expression(exp)
        do {
            let expressionResult: Double = try expression.evaluate()
            self.result = String(expressionResult)
        } catch {
            throw PopMemoryError.computeResultFailed
        }
    }

    func appendExp(with addon:String, method: PopMemoryAction.Method) {
        exp += method == .add ? " + \(addon)" : " - \(addon)"
    }
    
    private func computeResult() {
        print("computeResult called exp: \(self.exp)")
        let expression : Expression = Expression(exp)
        do {
            let expressionResult: Double = try expression.evaluate()
            self.result = String(expressionResult)
            print("computeResult ended result: \(self.result)")
        } catch {
            self.result = "ErrorResult"
        }
    }
}

extension MemoItem : Equatable, Hashable, Identifiable {
    
    // Hashable protocol requirement
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    // Equatable protocol requirement
    static func == (lhs: MemoItem, rhs: MemoItem) -> Bool {
        return lhs.id == rhs.id
    }
}
