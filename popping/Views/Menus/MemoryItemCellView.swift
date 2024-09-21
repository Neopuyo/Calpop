//
//  MemoryItemCellView.swift
//  popping
//
//  Created by Loup Martineau on 31/08/2024.
//

import SwiftUI

struct MemoryItemCellView: View {

    let height: Double
    let memoItem: MemoItem
    let isActive: Bool
    let isTap: (MemoItem) -> ()
    
    private var ratio: Double { height / 35.0 }
    
    var body: some View {
        HStack {
            Text(memoItem.exp)
                .lineLimit(1)
                .truncationMode(.middle)
            Spacer()
            Text(memoItem.result)
                .fontWeight(.bold)
                .lineLimit(1)
                .truncationMode(.tail)
        }
        .padding(.horizontal)
        .frame(minHeight: height)
        .background(isActive ? Color.menuBlue : Color.menuBlue.opacity(0.25))
        .onTapGesture {
            isTap(memoItem)
        }
        .clipShape(
            RoundedRectangle(cornerRadius: ratio * 8, style: .continuous)
        )
        .overlay(
            ZStack {
                RoundedRectangle(cornerRadius: ratio * 12, style: .continuous)
                    .stroke(Color.specialBlue, lineWidth: ratio * 1)
                
                RoundedRectangle(cornerRadius: 2.5, style: .continuous)
                    .fill(isActive ? Color.mathBlue : Color.mathBlue.opacity(0.25))
                    .frame(width: ratio * 3, height: ratio * 20)
                    .position(CGPoint(x: 0, y: height * 0.5))
                
            }
        )
        
    }
}



@available(iOS 17, *)
#Preview("isActive", traits: .fixedLayout(width: 300, height: 80)) {
    MemoryItemCellView(height: 45, memoItem: MemoItem(exp: "25 + 25", result: "50"), isActive: true) { memo in
        print("memo item tapped")
    }
}

@available(iOS 17, *)
#Preview("!isActive", traits: .fixedLayout(width: 300, height: 80)) {
    MemoryItemCellView(height: 45, memoItem: MemoItem(exp: "25 + 25", result: "50"), isActive: false) { memo in
        print("memo item tapped")
    }
}
