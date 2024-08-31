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
    @Published var clearEntryAvailable: Bool = false
    
    @Published var displayedMemoryStock: [MemoItem]
    @Published var currentMemoryItem: MemoItem?
    @Published var showMemoryPannel: Bool = false
    
    
    private var popComputer: PopComputer
    
    
    init() {
        self.popComputer = PopComputer()
        self.displayedMemoryStock = self.popComputer.refreshedMemoryStock
        self.currentMemoryItem = self.popComputer.refreshedCurrentMemoryItem
        self.bindComputerDisplayCallbacks(computer: self.popComputer)
    }
    
    
    func keyPressed(_ key: PopData.PopKey) {
        popComputer.keyPressed(key)
    }

    func memoryAction(_ action : PopMemoryAction) {
        popComputer.memoryAction(action)
    }
    
    private func displayExpressionLine()
    {
        displayedExpressionLine = popComputer.refreshedExpressionLine
        clearEntryAvailable = popComputer.clearEntryAvailable
    }
    
    private func displayResultLine() {
        guard let line = popComputer.refreshedResultLine else { return }
        displayedResultLine = line
        clearEntryAvailable = popComputer.clearEntryAvailable
    }
    
    private func displayNextMathOperator() {
        displayedNextMathOperator = popComputer.refreshedNextMathOperator
    }
    
    private func displayInputMode() {
        displayedInputMode = popComputer.refreshedInputMode
    }
    
    private func displayMemoryStock() {
        displayedMemoryStock = popComputer.refreshedMemoryStock
    }
    
    private func displayMemoryCurrent() {
        currentMemoryItem = popComputer.refreshedCurrentMemoryItem
    }
    
    private func toogleMemoryPannel() {
        showMemoryPannel.toggle()
    }
    

    // MARK: ON INIT
    private func bindComputerDisplayCallbacks(computer: PopComputer) {
        computer.displayExpLine = displayExpressionLine
        computer.displayResultLine = displayResultLine
        computer.displayNextMathOperator = displayNextMathOperator
        computer.displayInputMode = displayInputMode
        computer.displayMemoryStock = displayMemoryStock
        computer.displayMemoryCurrent = displayMemoryCurrent
        computer.toogleMemoryPannel = toogleMemoryPannel
    }
    // [?][+] need deinit to make sure clean is done ?
    
    // MARK: SAMPLE DATA
    static var previewSampleData: PoppingModel {
        let sample = PoppingModel()
        sample.displayedExpressionLine = "634 + 85"
        sample.displayedResultLine = "719"
        return sample
    }
    
    // MARK: DEBUG SHORTHAND
    func checkValues() {
        popComputer.checkValues()
    }
    
}



