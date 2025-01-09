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
        self.exp = expFormated
        self.result = result
    }
    
    private var expFormated : String { exp.last == "." ? exp + "0" : exp }
    
    init(exp:String) throws {
        self.exp = cleanDotTerminated(exp)
        let expression : NumericExpression = Expression(self.exp)
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
        print("computeResult called exp: \(self.expFormated)")
        let expression : NumericExpression = Expression(expFormated)
        do {
            let expressionResult: Double = try expression.evaluate()
            self.result = String(expressionResult)
            print("computeResult ended result: \(self.result)")
        } catch {
            self.result = "ErrorResult"
        }
    }
    
    private func cleanDotTerminated(_ exp: String) -> String {
        exp.last == "." ? exp + "0" : exp
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
