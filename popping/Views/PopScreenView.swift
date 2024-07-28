//
//  PopScreenView.swift
//  popping
//
//  Created by Loup Martineau on 13/07/2024.
//

import SwiftUI

struct PopScreenView: View {
    
    @EnvironmentObject var popping: PoppingModel
    
    var body: some View {
        ZStack {
            
            Rectangle()
                .fill(Color.mouikyColorAzurBlue)
        
            VStack(spacing:0) {
                Spacer()
                
                // Test Only ([+] set a test environnement variable to display debug items ?)
                Button("Check Values", systemImage: "arrow.up") {
                    popping.checkValues()
                }
                .foregroundStyle(.mouikyColorAzurBlueDarker1)
                .font(.caption2)
                .frame(maxWidth: .infinity, alignment: .trailing)
                
                Text(popping.inputMode.rawValue)
                    .font(.caption2)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                // --------------------------------------------------------------------------
                
                Text(displayedExpressionLine)
                    .padding()
                    .lineLimit(1)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .overlay(
                        RoundedRectangle(cornerRadius: 22.0)
                            .stroke(lineWidth:  2.5)
                            .foregroundColor(Color.mouikyColorAzurBlueDarker1)
                    )
                Text(displayedResultLine)
                    .font(.title)
                    .padding()
                    .lineLimit(1)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .overlay(
                        RoundedRectangle(cornerRadius: 22.0)
                            .stroke(lineWidth:  2.5)
                            .foregroundColor(Color.mouikyColorAzurBlueDarker1)
                    )
                Spacer()
            }
        }
    }
    
    // MARK: - Private methods
    
//    private func displayingResultLine() -> String {
//        guard !popping.isError else { return "ERROR" }
//        guard !(popping.resultLine.isEmpty && popping.inputMode == .left) else {
//            print("Empty and LEFt Case") // [+] to del
//            return "0"
//        }
//        guard !(popping.resultLine.isEmpty && (popping.inputMode == .rightFirst || popping.inputMode == .mathOperator)) else {
//            print("Empty and Right Case") // [+] to del
//            return popping.getLeftOperandResult
//        }
//        
//        return popping.resultLine
//    }
    
    
    
}

#Preview {
    PopScreenView()
        .environmentObject(PoppingModel())
}
