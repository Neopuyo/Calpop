//
//  PoppingModel.swift
//  popping
//
//  Created by Loup Martineau on 13/07/2024.
//

import SwiftUI



class PoppingModel: ObservableObject {
    
    @Published var displayedExpressionLine: String = ""
    @Published var displayedNextMathOperator: PopData.MathOperator? = nil
    @Published var displayedResultLine: String = ""
    @Published var displayedInputMode:PopData.InputMode = .left
    @Published var isMemory: Bool = false
    
    private var popComputer: PopComputer
    
    
    init() {
        self.popComputer = PopComputer()
        self.bindComputerDisplayCallbacks(computer: self.popComputer)
    }
    
    
    func keyPressed(_ key: PopData.PopKey) {
        popComputer.keyPressed(key)
    }
    
    private func displayExpressionLine()
    {
        displayedExpressionLine = popComputer.refreshedExpressionLine
    }
    
    private func displayResultLine() {
        guard let line = popComputer.refreshedResultLine else { return }
        displayedResultLine = line
    }
    
    private func displayNextMathOperator() {
        displayedNextMathOperator = popComputer.refreshedNextMathOperator
    }
    
    private func displayInputMode() {
        displayedInputMode = popComputer.refreshedInputMode
    }

    // MARK: ON INIT
    private func bindComputerDisplayCallbacks(computer: PopComputer) {
        computer.displayExpLine = displayExpressionLine
        computer.displayResultLine = displayResultLine
        computer.displayNextMathOperator = displayNextMathOperator
        computer.displayInputMode = displayInputMode
    }
    
    // MARK: SAMPLE DATA
    static var previewSampleData: PoppingModel {
        let sample = PoppingModel()
        sample.displayedExpressionLine = "188 + 35"
        sample.displayedResultLine = "223.0"
        return sample
    }
    
    // MARK: DEBUG SHORTHAND
    func checkValues() {
        popComputer.checkValues()
    }
    
}



