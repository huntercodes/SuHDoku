//
//  StatsScreen.swift
//  SuHDoku
//
//  Created by hunter downey on 2/11/22.
//

import SwiftUI

struct StatsScreen: View {
    @ObservedObject var dataHandler = DataHandler()
    
    // View detailing statistics of puzzles completed by user
    var body: some View {
        VStack {
            List {
                Section(header: Text("Easy Difficulty")) {
                    StatsDetail(label: "Games Completed", statValue: dataHandler.easyGamesCompleted)
                    StatsDetail(label: "Total Puzzle Time", statValue: dataHandler.easyTotalPuzzleTime)
                    StatsDetail(label: "Average Puzzle Time", statValue: dataHandler.easyAveragePuzzleTime)
                    StatsDetail(label: "Fastest Puzzle Time", statValue: dataHandler.easyFastestPuzzleTime)
                }
                .font(Font.custom("Petahja-Italic", size: 28))
                .foregroundColor(Color("mainColor6"))
                
                Section(header: Text("Medium Difficulty")) {
                    StatsDetail(label: "Games Completed", statValue: dataHandler.mediumGamesCompleted)
                    StatsDetail(label: "Total Puzzle Time", statValue: dataHandler.mediumTotalPuzzleTime)
                    StatsDetail(label: "Average Puzzle Time", statValue: dataHandler.mediumAveragePuzzleTime)
                    StatsDetail(label: "Fastest Puzzle Time", statValue: dataHandler.mediumFastestPuzzleTime)
                }
                .font(Font.custom("Petahja-Italic", size: 28))
                .foregroundColor(Color("mainColor5"))
                
                Section(header: Text("Hard Difficulty")) {
                    StatsDetail(label: "Games Completed", statValue: dataHandler.hardGamesCompleted)
                    StatsDetail(label: "Total Puzzle Time", statValue: dataHandler.hardTotalPuzzleTime)
                    StatsDetail(label: "Average Puzzle Time", statValue: dataHandler.hardAveragePuzzleTime)
                    StatsDetail(label: "Fastest Puzzle Time", statValue: dataHandler.hardFastestPuzzleTime)
                }
                .font(Font.custom("Petahja-Italic", size: 28))
                .foregroundColor(Color("mainColor4"))
                
                Section(header: Text("All Difficulties")) {
                    StatsDetail(label: "Games Completed", statValue: dataHandler.allGamesCompleted)
                    StatsDetail(label: "Total Puzzle Time", statValue: dataHandler.allTotalPuzzleTime)
                }
                .font(Font.custom("Petahja-Italic", size: 28))
                .foregroundColor(Color("mainColor6"))
            }
            .onAppear(perform: {
                self.dataHandler.updateStats()
            })
            
            .navigationTitle("Stats")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct StatsScreen_Previews: PreviewProvider {
    static var previews: some View {
        StatsScreen()
    }
}
