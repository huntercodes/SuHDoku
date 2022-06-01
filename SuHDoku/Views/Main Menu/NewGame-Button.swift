//
//  NewGame-Button.swift
//  SuHDoku
//
//  Created by hunter downey on 2/10/22.
//

import SwiftUI

struct NewGameButton: View {
    @State var showDifficultySelection: Bool = false
    @Binding var selectedPuzzleDifficulty: PuzzleMode?
    
    // Button to start a new game and select puzzle difficulty
    var body: some View {
        Button(action: {
            
            // Toggle difficulty selection dialog
            self.showDifficultySelection.toggle()
        }) {
            HStack {
                Text("Start New Puzzle")
                    .font(Font.custom("Petahja-Regular", size: 28))
                    .frame(maxWidth: 150, maxHeight: .infinity)
                    .foregroundColor(Color("regularTextColor"))
                    .background(RoundedRectangle(cornerRadius: 10)
                        .fill(Color("mainColor1"))
                        .frame(height: 55)
                    )
                    .overlay(RoundedRectangle(cornerRadius: 10)
                        .stroke(Color("regularTextColor"))
                        .frame(height: 55)
                    )
                
                Spacer()
                    .frame(maxWidth: 120)
                
                Image(systemName: "plus")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .foregroundColor(Color("regularTextColor"))
                    .background(RoundedRectangle(cornerRadius: 10)
                        .fill(Color("mainColor1"))
                        .frame(width: 55, height: 55)
                    )
                    .overlay(RoundedRectangle(cornerRadius: 10)
                        .stroke(Color("regularTextColor"))
                        .frame(width: 55, height: 55)
                    )
            }
            .frame(minWidth: 360)
        }
        .confirmationDialog("Select a Difficulty", isPresented: self.$showDifficultySelection) {
            Button("Easy") {
                self.selectedPuzzleDifficulty = PuzzleMode.easy
            }
            Button("Medium") {
                self.selectedPuzzleDifficulty = PuzzleMode.medium
            }
            Button("Hard") {
                self.selectedPuzzleDifficulty = PuzzleMode.hard
            }
        }
        .background(Ellipse()
            .fill(Color("mainColor2"))
            .frame(maxHeight: 120)
            .aspectRatio(2, contentMode: .fill)
            .frame(maxHeight: 120)
        )
        .overlay(Ellipse()
            .stroke(Color("regularTextColor"))
            .frame(maxHeight: 120)
            .aspectRatio(2, contentMode: .fill)
            .frame(maxHeight: 120)
        )
    }
}

struct MainMenuButton_Previews: PreviewProvider {
    @State static var selectedPuzzleDifficulty: PuzzleMode? = PuzzleMode.menu
    static var previews: some View {
        NewGameButton(selectedPuzzleDifficulty: $selectedPuzzleDifficulty)
            .preferredColorScheme(.light)
            
            
    }
}
