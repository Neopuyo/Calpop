//
//  PopScreenView.swift
//  popping
//
//  Created by Loup Martineau on 13/07/2024.
//

import SwiftUI

struct PopScreenView: View {
    
    @Binding var inputLine: String
    
    var body: some View {
        ZStack {
            
            Rectangle()
                .fill(Color.mouikyColorAzurBlue)
        
            VStack(spacing:0) {
                Spacer()
                Text(inputLine)
                    .lineLimit(1)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                Spacer()
            }
        }
    }
}

#Preview {
    PopScreenView(inputLine: .constant("1+1"))
}
