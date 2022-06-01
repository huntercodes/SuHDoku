//
//  GameTimer.swift
//  SuHDoku
//
//  Created by hunter downey on 2/10/22.
//

import Foundation

// Object used to handle timing of a sudoku puzzle
class GameTimer: ObservableObject {
    var timer: Timer?
    var timerActive: Bool
    @Published var secondsElapsed: Int
    @Published var timeElapsed: String
    
    init(secondsElapsed: Int = 0) {
        self.secondsElapsed = secondsElapsed
        self.timeElapsed = "00:00:00"
        self.timerActive = false
        
        self.updateTimeElapsed()
    }
    
    // Start the timer if not already active
    func start() {
        if !self.timerActive {
            self.timerActive = true
            
            self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
                self.secondsElapsed += 1
                self.updateTimeElapsed()
            }
        }
    }
    
    // Stop the timer
    func stop() {
        self.timer?.invalidate()
        self.timerActive = false
    }
    
    // Set the current time
    func setTime(time: Int) {
        self.secondsElapsed = time
    }
    
    // Get the current time
    func getTime() -> Int {
        return self.secondsElapsed
    }
    
    // Update the time label by converting time in seconds to time in hours:minutes:seconds
    func updateTimeElapsed() {
        let hours: Int = self.secondsElapsed / 3600
        let minutes: Int = (self.secondsElapsed % 3600) / 60
        let seconds: Int = self.secondsElapsed % 60
        
        if hours == 0 { self.timeElapsed = String(format: "%02d:%02d", minutes, seconds) }
        else { self.timeElapsed = String(format: "%02d:%02d:%02d", hours, minutes, seconds) }
    }
}
