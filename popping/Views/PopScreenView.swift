//
//  PopScreenView.swift
//  popping
//
//  Created by Loup Martineau on 13/07/2024.
//

import SwiftUI

struct PopScreenView: View {
    
    @EnvironmentObject var popping: PoppingModel
    
    let ratio: CGFloat
    
    var body: some View {
        ZStack {
            
            RoundedRectangle(cornerRadius: 8.0)
                .fill(
                    LinearGradient(colors: [Color.screenGradientStart, Color.screenGradientEnd], 
                                   startPoint: UnitPoint(x: 1.0, y: 0.0),
                                   endPoint: UnitPoint(x: 0.0, y: 1.0)
                                  )
                    )
                    
        
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
                
                HStack {
                    Text(popping.displayedExpressionLine)
                        .padding()
                        .font(.system(size: 25 * ratio , design: .rounded))
                        .foregroundStyle(Color.white)
                    Text(displayingNextMathOperator())
                        .font(.system(size: 25 * ratio , design: .rounded))
                        .foregroundStyle(Color.memoryButton)
                        .padding()
                }
                    .lineLimit(1)
                    .frame(maxWidth: .infinity, alignment: .trailing)
//                    .overlay(
//                        RoundedRectangle(cornerRadius: 22.0)
//                            .stroke(lineWidth:  2.5)
//                            .foregroundColor(Color.mouikyColorAzurBlueDarker1)
//                    )
               
                Text(displayingResultLine())
                    .font(.system(size: 90 * ratio , design: .default))
                    .padding()
                    .lineLimit(1)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .foregroundStyle(Color.white)
//                    .overlay(
//                        RoundedRectangle(cornerRadius: 22.0)
//                            .stroke(lineWidth:  2.5)
//                            .foregroundColor(Color.mouikyColorAzurBlueDarker1)
//                        )
                Spacer()
            }
        }
    }

    
    // MARK: - Private methods
    private func displayingResultLine() -> String {
        guard !popping.isError else { return "ERROR" }
        guard !popping.displayedResultLine.isEmpty else {
            print("displayedResultLine is empty : display 0.0")
            return "0.0"
        }
        return popping.displayedResultLine
    }
    
    private func displayingNextMathOperator() -> String {
        guard !popping.isError else { return "" }
        guard let nextMathOp = popping.displayedNextMathOperator else { return "" }
        return nextMathOp.expSymbol
    }
    
    
    
}

@available(iOS 17, *)
#Preview(traits: .fixedLayout(width: 396, height: 286)) {
    PopScreenView(ratio: 1.0)
        .environmentObject(PoppingModel.previewSampleData)
}
