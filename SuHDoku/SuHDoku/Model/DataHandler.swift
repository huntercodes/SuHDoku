//
//  DataHandler.swift
//  SuHDoku
//
//  Created by hunter downey on 2/10/22.
//

import Foundation

// Object used to handle the majority of application's interactions with stored data, including puzzle seeds, resumed puzzle state, and statistics
class DataHandler: ObservableObject {
    
    // Values used by the statistics view for number of completed puzzles
    @Published var easyGamesCompleted: String = "0"
    @Published var mediumGamesCompleted: String = "0"
    @Published var hardGamesCompleted: String = "0"
    @Published var allGamesCompleted: String = "0"
    
    // Values used by the statistics view for duration of completed puzzles
    @Published var easyTotalPuzzleTime: String = "00:00:00"
    @Published var mediumTotalPuzzleTime: String = "00:00:00"
    @Published var hardTotalPuzzleTime: String = "00:00:00"
    @Published var allTotalPuzzleTime: String = "00:00:00"
    
    // Values used by the statistics view for average puzzle duration
    @Published var easyAveragePuzzleTime: String = "00:00:00"
    @Published var mediumAveragePuzzleTime: String = "00:00:00"
    @Published var hardAveragePuzzleTime: String = "00:00:00"
    
    // Values used by the statistics view for fastest puzzle durations
    @Published var easyFastestPuzzleTime: String = "00:00:00"
    @Published var mediumFastestPuzzleTime: String = "00:00:00"
    @Published var hardFastestPuzzleTime: String = "00:00:00"
    
    // Retrieve a new puzzle from storage
    func readPuzzleFromFile(puzzleFile: String) -> [[Int]] {
        do {
            let fileURL = Bundle.main.url(forResource: puzzleFile, withExtension: "txt")
            
            let puzzleStrings:String? = try String(contentsOf: fileURL!)
            let puzzleBoards = puzzleStrings?.split(separator: "\n")
            
            let numberOfPuzzles = (puzzleBoards?.count)!
            let puzzleNumber = Int(arc4random_uniform(UInt32(numberOfPuzzles)))
            
            var puzzleString = String(puzzleBoards![puzzleNumber])
            let puzzleBoard = self.decodeBoard(encoded: &puzzleString)
            
            return puzzleBoard
        }
        catch { fatalError() }
    }
    
    // Save a puzzle state for later resumption
    func saveGame(puzzle: Puzzle, difficulty: PuzzleMode, time: Int) {
        do {
            let encoder = JSONEncoder()
            let encodedPuzzle = try encoder.encode(puzzle)
            let encodedDifficulty = try encoder.encode(difficulty)
            
            let defaults = UserDefaults.standard
            defaults.set(true, forKey: "canResumePuzzle")
            defaults.set(encodedPuzzle, forKey: "resumePuzzle")
            defaults.set(encodedDifficulty, forKey: "resumeDifficulty")
            defaults.set(time, forKey: "resumeTime")
        }
        catch { fatalError() }
    }
    
    // Save statistics for a completed puzzle, including difficulty and duration
    func saveStats(difficulty: PuzzleMode, time: Int) {
        let defaults = UserDefaults.standard
        let gamesCompletedKey: String
        let totalPuzzleTimeKey: String
        let fastestPuzzleTimeKey: String
        
        // Select appropriate storage keys based on puzzle difficulty
        if difficulty == PuzzleMode.easy {
            gamesCompletedKey = "easyGamesCompleted"
            totalPuzzleTimeKey = "easyTotalPuzzleTime"
            fastestPuzzleTimeKey = "easyFastestPuzzleTime"
        }
        else if difficulty == PuzzleMode.medium {
            gamesCompletedKey = "mediumGamesCompleted"
            totalPuzzleTimeKey = "mediumTotalPuzzleTime"
            fastestPuzzleTimeKey = "mediumFastestPuzzleTime"
        }
        else if difficulty == PuzzleMode.hard {
            gamesCompletedKey = "hardGamesCompleted"
            totalPuzzleTimeKey = "hardTotalPuzzleTime"
            fastestPuzzleTimeKey = "hardFastestPuzzleTime"
        }
        else { fatalError() }
        
        // Get current statistics for selected difficulty
        var gamesCompleted: Int = defaults.integer(forKey: gamesCompletedKey)
        var totalPuzzleTime:Int = defaults.integer(forKey: totalPuzzleTimeKey)
        var fastestPuzzleTime: Int = defaults.integer(forKey: fastestPuzzleTimeKey)
        
        // Update statistics based on the completed puzzle
        gamesCompleted += 1
        totalPuzzleTime += time
        if time < fastestPuzzleTime { fastestPuzzleTime = time }
        
        // Save the updated statistics to storage
        defaults.set(gamesCompleted, forKey: gamesCompletedKey)
        defaults.set(totalPuzzleTime, forKey: totalPuzzleTimeKey)
        defaults.set(fastestPuzzleTime, forKey: fastestPuzzleTimeKey)
        defaults.set(false, forKey: "canResumePuzzle")
    }
    
    // Update the statistics values used by the statistics view
    func updateStats() {
        let defaults = UserDefaults.standard
        
        let numberEasyGames: Int = defaults.integer(forKey: "easyGamesCompleted")
        let numberMediumGames: Int = defaults.integer(forKey: "mediumGamesCompleted")
        let numberHardGames: Int = defaults.integer(forKey: "hardGamesCompleted")
        let numberAllGames = numberEasyGames + numberMediumGames + numberHardGames
        
        let totalTimeEasyGames: Int = defaults.integer(forKey: "easyTotalPuzzleTime")
        let totalTimeMediumGames: Int = defaults.integer(forKey: "mediumTotalPuzzleTime")
        let totalTimeHardGames: Int = defaults.integer(forKey: "hardTotalPuzzleTime")
        let totalTimeAllGames: Int = totalTimeEasyGames + totalTimeMediumGames + totalTimeHardGames
        
        let averageTimeEasyGames: Int = numberEasyGames == 0 ? 0 : totalTimeEasyGames / numberEasyGames
        let averageTimeMediumGames: Int = numberMediumGames == 0 ? 0 : totalTimeMediumGames / numberMediumGames
        let averageTimeHardGames: Int = numberHardGames == 0 ? 0 : totalTimeHardGames / numberHardGames
        
        let fastestTimeEasyGames: Int = defaults.integer(forKey: "easyFastestPuzzleTime")
        let fastestTimeMediumGames: Int = defaults.integer(forKey: "mediumFastestPuzzleTime")
        let fastestTimeHardGames: Int = defaults.integer(forKey: "hardFastestPuzzleTime")
        
        self.easyGamesCompleted  = String(numberEasyGames)
        self.mediumGamesCompleted = String(numberMediumGames)
        self.hardGamesCompleted = String(numberHardGames)
        self.allGamesCompleted = String(numberAllGames)
        
        self.easyTotalPuzzleTime = self.formatTime(time: totalTimeEasyGames)
        self.mediumTotalPuzzleTime = self.formatTime(time: totalTimeMediumGames)
        self.hardTotalPuzzleTime = self.formatTime(time: totalTimeHardGames)
        self.allTotalPuzzleTime = self.formatTime(time: totalTimeAllGames)
        
        let noPuzzlesCompletedMessage = "No Puzzles Completed"
        if numberEasyGames == 0 {
            self.easyAveragePuzzleTime = noPuzzlesCompletedMessage
            self.easyFastestPuzzleTime = noPuzzlesCompletedMessage
        }
        else {
            self.easyAveragePuzzleTime = self.formatTime(time: averageTimeEasyGames)
            self.easyFastestPuzzleTime = self.formatTime(time: fastestTimeEasyGames)
        }
        
        if numberMediumGames == 0 {
            self.mediumAveragePuzzleTime = noPuzzlesCompletedMessage
            self.mediumFastestPuzzleTime = noPuzzlesCompletedMessage
        }
        else {
            self.mediumAveragePuzzleTime = self.formatTime(time: averageTimeMediumGames)
            self.mediumFastestPuzzleTime = self.formatTime(time: fastestTimeMediumGames)
        }
        
        if numberHardGames == 0 {
            self.hardAveragePuzzleTime = noPuzzlesCompletedMessage
            self.hardFastestPuzzleTime = noPuzzlesCompletedMessage
        }
        else {
            self.hardAveragePuzzleTime = self.formatTime(time: averageTimeHardGames)
            self.hardFastestPuzzleTime = self.formatTime(time: fastestTimeHardGames)
        }
    }
    
    // Retrieve a paused puzzle from storage for resumption
    func resumeGame() -> (Puzzle, PuzzleMode, Int) {
        do {
            let defaults = UserDefaults.standard
            let puzzleEncoded = defaults.object(forKey: "resumePuzzle") as! Data
            let difficultyEncoded = defaults.object(forKey: "resumeDifficulty") as! Data
            let time = defaults.integer(forKey: "resumeTime")
            
            let decoder = JSONDecoder()
            let puzzle = try decoder.decode(Puzzle.self, from: puzzleEncoded)
            let difficulty = try decoder.decode(PuzzleMode.self, from: difficultyEncoded)
            return (puzzle, difficulty, time)
        }
        catch { fatalError() }
    }
    
    // Translate a sudoku puzzle seed into a useable sudoku puzzle
    private func decodeBoard(encoded:inout String) -> [[Int]] {
        var decodedBoard = [[Int]]()
        var seedTranslator = [Int:Int]()
        var numberSet = [1,2,3,4,5,6,7,8,9]
        let rows = encoded.split(separator: "|")
        
        for row in rows {
            let columnsString = row.split(separator: " ")
            var columnInt = [Int]()
            for number in columnsString {
                columnInt.append(Int(number)!)
            }
            decodedBoard.append(columnInt)
        }
        
        for seedNumber in stride(from: -1, through: -9, by: -1) {
            let index = Int(arc4random_uniform(UInt32(numberSet.count)))
            seedTranslator[seedNumber] = numberSet[index]
            numberSet = numberSet.filter { $0 != numberSet[index] }
        }
        
        for x in 0...8 {
            for y in 0...8 {
                if decodedBoard[x][y] != 0 { decodedBoard[x][y] = seedTranslator[decodedBoard[x][y]]! }
            }
        }
        
        return decodedBoard
    }
    
    // Convert time in seconds to time in hours:minutes:seconds
    private func formatTime(time: Int) -> String {
        let hours: Int = time / 3600
        let minutes: Int = (time % 3600) / 60
        let seconds: Int = time % 60
        
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}
