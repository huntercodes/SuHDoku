//
//  GameView.swift
//  SuHDoku
//
//  Created by hunter downey on 2/11/22.
//

import SwiftUI
import GoogleMobileAds

struct GameView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Binding var selectedPuzzleDifficulty: PuzzleMode?
    @Binding var canResume: Bool
    
    private var fullScreenAd: InterstitialAdView?
    
    @ObservedObject var gm: GameManager
    @ObservedObject var gt: GameTimer
    var puzzleMode: PuzzleMode
    
    init(puzzleMode: PuzzleMode, canResume: Binding<Bool>, selectedPuzzleDifficulty: Binding<PuzzleMode?>) {
        self.puzzleMode = puzzleMode
        self._selectedPuzzleDifficulty = selectedPuzzleDifficulty
        self._canResume = canResume
        fullScreenAd = InterstitialAdView()
        
        // Resume puzzle by retrieving stored data from DataHandler
        if self.puzzleMode == .resume {
            let dataHandler = DataHandler()
            let puzzleData = dataHandler.resumeGame()
            self.gm = GameManager(puzzleMode: puzzleData.1, puzzle: puzzleData.0)
            self.gt = GameTimer(secondsElapsed: puzzleData.2)
        }
        
        // Start a new puzzle
        else {
            self.gm = GameManager(puzzleMode: puzzleMode)
            self.gt = GameTimer()
        }
    }
    
    // Complete view of a sudoku puzzle, including back button, timer, board, and command bar
    var body: some View {
        GameLayout()
            .environmentObject(self.gm)
            .environmentObject(self.gt)
        
            // Actions to perform is view has already been initialized
            .onAppear(perform: {
                
                // Resume puzzle by retrieving stored data from DataHandler
                if self.puzzleMode == .resume {
                    let dataHandler = DataHandler()
                    let puzzleData = dataHandler.resumeGame()
                    self.gm.setPuzzle(puzzle: puzzleData.0)
                    self.gm.setDifficulty(puzzleMode: puzzleData.1)
                    self.gt.setTime(time: puzzleData.2)
                }
                
                // Start a new puzzle and reset timer
                else {
                    self.gm.resetPuzzle()
                    self.gt.setTime(time: 0)
                }
                
                // Update the timer appearance and start the timer
                self.gt.updateTimeElapsed()
                self.gt.start()
            })
        
            // Actions to perform when a puzzle is successfully finished
            .onChange(of: self.gm.puzzleFinished) { status in
                if status {
                    
                    // Stop the timer and reset puzzle status
                    self.gt.stop()
                    self.gm.setPuzzleFinished(status: false)
                    
                    // Update overall puzzle stats based on puzzle difficulty and completion time
                    let dataHandler = DataHandler()
                    dataHandler.saveStats(difficulty: self.gm.getDifficulty(), time: self.gt.getTime())
                    self.canResume = false
                    
                    // Exit the current view
                    self.presentationMode.wrappedValue.dismiss()
                    self.fullScreenAd?.showAd()
                }
            }
        
            // Start the puzzle timer when the view becomes active
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
                self.gt.start()
            }
        
            // Pause the puzzle timer when the view is no longer active
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
                self.gt.stop()
            }
            .padding(10)
            .navigationBarBackButtonHidden(true)
        
            // Populate navigation bar with back button and puzzle timer
            .navigationBarItems(
                
            // Back button uses to save puzzle state for later resumption and exit the current view
            leading: Button(action: {
                self.gt.stop()
                    
                let dataHandler = DataHandler()
                dataHandler.saveGame(puzzle: self.gm.getPuzzle(), difficulty: self.gm.getDifficulty(), time: self.gt.getTime())
                    
                self.selectedPuzzleDifficulty = .menu
                self.canResume = true
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "arrow.left")
                    .foregroundColor(Color("regularTextColor"))
            },
                
            // Puzzle timer
            trailing: TimerLabel().environmentObject(self.gt)
            )
    }
}

struct GameView_Previews: PreviewProvider {
    @State static var selectedPuzzleDifficulty: PuzzleMode? = .easy
    @State static var canResume = false
    static var previews: some View {
        GameView(puzzleMode: PuzzleMode.easy, canResume: $canResume, selectedPuzzleDifficulty: $selectedPuzzleDifficulty)
            .environmentObject(PreferencesManager())
    }
}
