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
                    
        
            VStack(alignment: .trailing, spacing:0) {
                
                
                // Test Only ([+] set a test environnement variable to display debug items ?)
//                Button("Check Values", systemImage: "arrow.up") {
//                    popping.checkValues()
//                }
//                .foregroundStyle(.specialBlue)
//                .font(.caption2)
//                .frame(maxWidth: .infinity, alignment: .trailing)
//                .padding(.trailing)
//                
//                Text(popping.displayedInputMode.rawValue)
//                    .foregroundStyle(.specialBlue)
//                    .font(.caption2)
//                    .frame(maxWidth: .infinity, alignment: .trailing)
//                    .padding(.trailing)
                // ------------------------------------------------------------
                
                HStack(spacing:0) {
                    Button(action: {
                        print("UNI : \("􀆈".unicodeScalars.map { $0.value })")
                        print("\(String(1048968, radix: 16))")
                    }, label: {
                        Image(systemName: "slider.horizontal.3")
                            .frame(width: 53 * ratio, height: 53 * ratio, alignment: .center)
                    })
                    Spacer()
                    Button(action: {}, label: {
                        Image(systemName: "clock.arrow.circlepath")
                            .frame(width: 53 * ratio, height: 53 * ratio, alignment: .center)
                    })
                }
                .font(.system(size: 25.0 * ratio, weight: .semibold))
                .foregroundColor(Color.white)
                
                Spacer()
                    .frame(maxWidth: .infinity)
                
                // Put a " " instead of empty string to fix height
                Text(displayingExpLine)
                    .font(.system(size: 25 * ratio , design: .rounded))
                    .foregroundStyle(Color.white)
                    .lineLimit(1)
                    .allowsTightening(false)
                    .frame(height: 50 * ratio, alignment: .trailing)

                Spacer()
                    .frame(height: 5 * ratio)
               
                Text(displayingResultLine)
                    .font(.system(size: 90 * ratio , design: .default))
                    .lineLimit(1)
                    .frame(height: 75 * ratio, alignment: .trailing)
                    .foregroundStyle(Color.white)

            }
            .padding(20.0 * ratio)
        }
    }

    
    // MARK: - Private methods
    private var displayingResultLine: String {
        guard !popping.displayedResultLine.isEmpty else {
            print("displayedResultLine is empty : display 0.0")
            return "0.0"
        }
        return popping.displayedResultLine
    }
    
//    private func displayingNextMathOperator() -> String {
//        guard let nextMathOp = popping.displayedNextMathOperator else { return "" }
//        return nextMathOp.computeSymbol
//    }
    
    private var displayingExpLine: String {
        guard !popping.displayedExpressionLine.isEmpty else { return "" }
        switch (popping.displayedInputMode) {
        case .mathOperatorNext:
            return "\(makeReadable(popping.displayedExpressionLine)) ="
        default:
            return makeReadable(popping.displayedExpressionLine)
        }
    }
    
    // [+] Todo : use a model and/or extend String type
    private func makeReadable(_ line: String) -> String {
        var readableLine:String = line
        readableLine = replaceSymbols(readableLine)
        readableLine = replacePowFunction(readableLine)
        return readableLine
    }
    
    private func replacePowFunction(_ line: String) -> String {
        var line = line
        let pattern = "pow\\((.*?), 2\\)"
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: [])
            var range = NSRange(location: 0, length: line.utf16.count)
            while let match = regex.firstMatch(in: line, options: [], range: range) {
                line = regex.stringByReplacingMatches(in: line, options: [], range: match.range, withTemplate: "pow2($1)")
                range = NSRange(location: 0, length: line.utf16.count)
            }
            return line
        } catch {
            return line
        }
    }
    
    private func replaceSymbols(_ line:String) -> String {
        let line = line.replacingOccurrences(of: "+", with: PopData.MathOperator.scalarPlus)
            .replacingOccurrences(of: "- ", with: "\(PopData.MathOperator.scalarMinus) ")
            .replacingOccurrences(of: "/", with: PopData.MathOperator.scalarDivide)
            .replacingOccurrences(of: "*", with: PopData.MathOperator.scalarMultiply)
        return line
    }
    
    
    
}

@available(iOS 17, *)
#Preview(traits: .fixedLayout(width: 396, height: 286)) {
    PopScreenView(ratio: 1.0)
        .environmentObject(PoppingModel.previewSampleData)
}
