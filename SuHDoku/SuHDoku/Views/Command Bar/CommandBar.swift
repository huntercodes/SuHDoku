//
//  CommandBar.swift
//  SuHDoku
//
//  Created by hunter downey on 2/10/22.
//

import SwiftUI

struct CommandBar: View {
    @EnvironmentObject var gm: GameManager
    
    // A view that combines the tool bar and number bar into a single entity
    var body: some View {
        VStack() {
            ToolBar()
            NumberBar()
        }
    }
}

struct CommandBar_Previews: PreviewProvider {
    static var previews: some View {
        CommandBar()
            .environmentObject(GameManager(puzzleMode: PuzzleMode.easy))
    }
}
