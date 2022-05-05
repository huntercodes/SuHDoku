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
                
                Spacer()
                    .frame(maxWidth: 150)
                
                Image(systemName: "plus")
                    .resizable()
                    .frame(width: 70, height: 70)
                    .foregroundColor(Color("regularTextColor"))
            }
            .padding(15)
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
        .cornerRadius(15)
        .background(RoundedRectangle(cornerRadius: 15).fill(Color("mainColor1")))
        .overlay(RoundedRectangle(cornerRadius: 15).stroke(Color("regularTextColor")))
    }
}

struct MainMenuButton_Previews: PreviewProvider {
    @State static var selectedPuzzleDifficulty: PuzzleMode? = PuzzleMode.menu
    static var previews: some View {
        NewGameButton(selectedPuzzleDifficulty: $selectedPuzzleDifficulty)
    }
}
