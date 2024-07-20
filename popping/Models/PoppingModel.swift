//
//  PoppingModel.swift
//  popping
//
//  Created by Loup Martineau on 13/07/2024.
//

import SwiftUI
import Expression

class PoppingModel: ObservableObject {
    
    @Published var inputLine: String = ""
    @Published var result: Double = 0.0
    @Published var isError: Bool = false
    
    func keyPressed(_ key: PopData.PopKey) {
        switch key.kind {
        case .digit, .math:
            digitOrMathPressed(key)
            
        case .special:
            specialPressed(key)
            
        default:
            print("🌵 [\(key.kind.rawValue)] key not handled yet")
        }
    }
    
    
    private func digitOrMathPressed(_ key: PopData.PopKey) {
        guard key != .keyResult else {
            evaluateExpression()
            return
        }
        inputLine.append(key.stringvalue)
    }
    
    
    private func specialPressed(_ key: PopData.PopKey) {
        switch key {
        case .keyClear:
            inputLine = ""
            result = 0.0
        case .keyClearEntry:
            inputLine = ""
        case .keyDelete:
            guard !inputLine.isEmpty else { return }
            inputLine.remove(at: inputLine.index(before: inputLine.endIndex))
            
        default:
            print("CONTINUE IMPLEMENTING THIS")
        }
    }
    
    /// Obj-C func can't be try catch easily
    private func evaluateExpression() {
        guard !inputLine.isEmpty else { return }
        let formatedInput: String = formatInputBeforeEvaluate(inputLine)
        let expression : Expression = Expression(formatedInput)
        do {
            let expressionResult: Double = try expression.evaluate()
            result = expressionResult
        } catch {
            print("ERROR EVALUATING")
            print(error.localizedDescription)
        }
    }
    
    private func formatInputBeforeEvaluate(_ input:String) -> String {
        let input = input.replacingOccurrences(of: "x", with: "*")
        return input
    }
    
    
}



