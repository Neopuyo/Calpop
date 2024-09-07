//
//  MemoryStockMenuView.swift
//  popping
//
//  Created by Loup Martineau on 31/08/2024.
//

import SwiftUI

struct MemoryStockMenuView: View {
    

    @EnvironmentObject var popping: PoppingModel
    @State private var nextSelected: MemoItem?
    
    
    
    var body: some View {
        VStack {
           
            List {
                ForEach(popping.displayedMemoryStock) { memoItem in
                    MemoryItemCellView(
                        nextSelected: $nextSelected,
                        memoItem: memoItem,
                        isCurrent: isCurrent(memoItem)
                    ) { memoItem in
                        nextSelected = memoItem
                    }
                }.onDelete(perform: { indexSet in
                    popping.memoryAction(.delete(indexSet))
                })
                
                    
            }
            
            
            
            
            
            
            
            
            // MARK : - temporary
            Spacer()
            HStack() {
                Spacer()
                Button("", systemImage: "xmark.circle", role: .cancel) {
                    popping.showMemoryPannel.toggle()
                }
              
                Spacer()
                
                Button("", systemImage: "checkmark.circle", role: nil) {
                    if let toSelect = nextSelected, toSelect != popping.currentMemoryItem {
                        popping.memoryAction(.select(toSelect))
                    }
                    popping.showMemoryPannel.toggle()
                }
                Spacer()
                
            }.font(.title)
            
            Text("Next Selected Memo item : \(nextSelected?.result ?? "nil")")
                .font(.caption)
            
        }
    }
    
    private func isCurrent(_ memoItem: MemoItem) -> Bool {
        guard let current = popping.currentMemoryItem else { return false }
        return memoItem == current
    }
}

#Preview {
    MemoryStockMenuView()
        .environmentObject(PoppingModel.previewSampleData)
}
