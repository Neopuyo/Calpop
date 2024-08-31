//
//  MemoryItemCellView.swift
//  popping
//
//  Created by Loup Martineau on 31/08/2024.
//

import SwiftUI

struct MemoryItemCellView: View {
    
    @EnvironmentObject var popping: PoppingModel
    @Binding var nextSelected: MemoItem?
    
    let memoItem: MemoItem
    let isCurrent: Bool
    let isTap: (MemoItem) -> ()
    
    var body: some View {
        HStack {
            Text(memoItem.exp)
            Spacer()
            Text(memoItem.result)
                .fontWeight(.bold)
        }
        .background(isActive ? Color.specialBlue : Color.whiteToBlack)
        .onTapGesture {
            isTap(memoItem)
        }
    }
    
    
    private var isActive: Bool {
        if nextSelected != nil {
          return nextSelected == memoItem
        }
        guard let current = popping.currentMemoryItem else { return false }
        return memoItem == current
    }
}

@available(iOS 17, *)
#Preview("isActive", traits: .fixedLayout(width: 300, height: 80)) {
    MemoryItemCellView(nextSelected: .constant(nil), memoItem: MemoItem(exp: "25 + 25", result: "50"), isCurrent: true) { memo in
        print("memo item tapped")
    }
    .environmentObject(PoppingModel.previewSampleData)
}

@available(iOS 17, *)
#Preview("!isActive", traits: .fixedLayout(width: 300, height: 80)) {
    MemoryItemCellView(nextSelected: .constant(nil), memoItem: MemoItem(exp: "25 + 25", result: "50"), isCurrent: false) { memo in
        print("memo item tapped")
    }
    .environmentObject(PoppingModel.previewSampleData)
}
