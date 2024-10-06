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
    
    let heightRatio: Double
    
    var body: some View {
        VStack {
            // HEADER
            Rectangle()                
                .fill(Color.mathBlue)
                .frame(height: 80 * heightRatio)

            // MEMORY LIST
            List {
                ForEach(popping.displayedMemoryStock) { memoItem in
                    MemoryItemCellView(
                        height: 45 * heightRatio,
                        memoItem: memoItem,
                        isActive: isActive(memoItem)
                    ) { memoItem in
                        nextSelected = memoItem
                    }
                }
                .onDelete(perform: { indexSet in
                    popping.memoryAction(.delete(indexSet))
                })
                .listRowInsets(EdgeInsets.init(top: 5, leading: 10, bottom: 5, trailing: 10))
                .listRowSeparator(.hidden)
            }
            .listStyle(.plain)
            

            // MARK : - [!] dirty temporary
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
                
            }
            .padding(.vertical)
            .background(Color.specialBlue)
            .foregroundColor(Color.whiteToBlack)
            .font(.largeTitle)
            
        }
        .ignoresSafeArea()
    }
    
    // WIP CONTINUE HERE : try move isActive logic to have simpler cell / style view
    private func isActive(_ memoItem: MemoItem) -> Bool {
        if nextSelected != nil {
          return nextSelected == memoItem
        }
        guard let current = popping.currentMemoryItem else { return false }
        return memoItem == current
    }
}

@available(iOS 17, *)
#Preview(traits: .fixedLayout(width: 430, height: 932)) {
    MemoryStockMenuView(heightRatio: 1.0)
        .environmentObject(PoppingModel.previewSampleData)
}
