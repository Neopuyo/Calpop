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
                Text(popping.inputLine)
                    .padding()
                    .lineLimit(1)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .overlay(
                        RoundedRectangle(cornerRadius: 22.0)
                            .stroke(lineWidth:  2.5)
                            .foregroundColor(Color.mouikyColorAzurBlueDarker1)
                    )
                Text(popping.isError ? "ERROR" : String(popping.result))
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
}

#Preview {
    PopScreenView()
        .environmentObject(PoppingModel())
}
