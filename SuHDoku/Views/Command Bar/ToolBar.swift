//
//  ToolBar.swift
//  SuHDoku
//
//  Created by hunter downey on 2/10/22.
//

import SwiftUI

struct ToolBar: View {
    @EnvironmentObject var gm: GameManager
    
    // A bar containing a button for each tool available in sudoku
    var body: some View {
        let labels = ["Undo", "Redo" , "Pencil", "Erase"]
        
        HStack() {
            ForEach(0..<labels.count, id: \.self) { i in
                ToolInput(label: labels[i], buttonAction: ToolInputAction(rawValue: i)!)
                    .frame(minWidth: 0, maxWidth: .infinity,
                           minHeight: 0, maxHeight: .infinity)
                    .aspectRatio(2, contentMode: .fit)
                
            }
        }
    }
}

struct ToolBar_Previews: PreviewProvider {
    static var previews: some View {
        ToolBar()
            .environmentObject(GameManager(puzzleMode: PuzzleMode.easy))
    }
}
