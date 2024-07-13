//
//  PoppingModel.swift
//  popping
//
//  Created by Loup Martineau on 13/07/2024.
//

import SwiftUI


class PoppingModel: ObservableObject {
    
    @Published var inputLine: String = "input line demo"
    
    
    func keyPressed(_ key: PopData.PopKey) {
        switch key.kind {
        case .digit:
            digitPressed(key)
        default:
            print("Key of kind [\(key.kind.rawValue)] not handled yet")
        }
    }
    
    
    private func digitPressed(_ key: PopData.PopKey) {
        inputLine.append(key.symbol)
    }
    
    
    
}



