//
//  TetrisViewModel.swift
//  TetrisGame
//
//  Created by Tatiana on 25/05/25.
//

import SwiftUI
import Combine

enum Constants {
    static let rows = 20
    static let columns = 10
    static let tickInterval: TimeInterval = 0.5
    static let scorePerLine = 100
}

class TetrisViewModel: ObservableObject {
    @Published var grid: [[Color?]] = Array(repeating: Array(repeating: nil, count: Constants.columns), count: Constants.rows)
    @Published var currentPiece: TetrisPiece?
    @Published var score = 0
    @Published var isGameOver = false
    @Published var highScore: Int = UserDefaults.standard.integer(forKey: "HighestScore")

    private let allShapes = TetrisShapeType.allCases
    
    private var timer: AnyCancellable?

    init() {}

    func startGame() {
        grid = emptyGrid()
        score = 0
        isGameOver = false
        spawnNewPiece()
        startTimer()
    }

    func startTimer() {
        timer?.cancel()
        timer = Timer.publish(every: 0.5, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.gameTick()
            }
    }

    func stopTimer() {
        timer?.cancel()
        timer = nil
    }

    func spawnNewPiece() {
        guard let type = allShapes.randomElement() else { return }
        let piece = TetrisPiece.create(from: type)
        if canPlace(piece: piece) {
            currentPiece = piece
        } else {
            //Game Over
            isGameOver = true
            stopTimer()
            currentPiece = nil
        }
    }

    func gameTick() {
        guard var piece = currentPiece else { return }
        piece.position.row += 1
        if canPlace(piece: piece) {
            currentPiece = piece
        } else {
            lockPiece()
            clearFullLines()
            spawnNewPiece()
        }
    }

    func canPlace(piece: TetrisPiece) -> Bool {
        for row in 0..<piece.shape.count {
            for column in 0..<piece.shape[row].count {
                if piece.shape[row][column] == 1 {
                    let row = piece.position.row + row
                    let col = piece.position.col + column
                    if row < 0 || row >= Constants.rows || col < 0 || col >= Constants.columns {
                        return false
                    }
                    if grid[row][col] != nil {
                        return false
                    }
                }
            }
        }
        return true
    }

    func lockPiece() {
        guard let piece = currentPiece else { return }
        for row in 0..<piece.shape.count {
            for column in 0..<piece.shape[row].count {
                if piece.shape[row][column] == 1 {
                    let row = piece.position.row + row
                    let col = piece.position.col + column
                    if row >= 0 && row < Constants.rows &&
                        col >= 0 && col < Constants.columns {
                        grid[row][col] = piece.color
                    }
                }
            }
        }
        currentPiece = nil
    }

    func clearFullLines() {
        var newGrid: [[Color?]] = []
        var clearedLines = 0

        for row in grid {
            if row.allSatisfy({ $0 != nil }) {
                clearedLines += 1
            } else {
                newGrid.append(row)
            }
        }

        for _ in 0..<clearedLines {
            newGrid.insert(Array(repeating: nil, count: Constants.columns), at: 0)
        }

        if clearedLines > 0 {
            updateScore(by: clearedLines)
        }
        
        grid = newGrid
    }

    
    //MARK: - Movement
    
    func moveLeft() {
        tryMoving { $0.position.col -= 1 }
    }

    func moveRight() {
        tryMoving { $0.position.col += 1 }
    }

    private func tryMoving(_ transform: (inout TetrisPiece) -> Void) {
        guard var piece = currentPiece else { return }
        transform(&piece)
        if canPlace(piece: piece) {
            currentPiece = piece
        }
    }
    
    //Dropping
    func drop() {
        guard var piece = currentPiece else { return }
        while true {
            piece.position.row += 1
            if !canPlace(piece: piece) {
                piece.position.row -= 1
                currentPiece = piece
                lockPiece()
                clearFullLines()
                spawnNewPiece()
                break
            }
        }
    }
    
    //MARK: - Rotation
    func rotate() {
        guard let piece = currentPiece else { return }
        let rotatedPiece = piece.rotated()
        if canPlace(piece: rotatedPiece) {
            currentPiece = rotatedPiece
        }
    }

    //MARK: - Score
    
    private func updateScore(by linesCleared: Int) {
        score += linesCleared * Constants.scorePerLine
        
        if score > highScore {
            highScore = score
            UserDefaults.standard.set(highScore, forKey: "HighestScore")
        }
    }
    
    //MARK: - Coloring
    func colorAt(row: Int, col: Int) -> Color? {
        // Check if current piece occupies this cell
        if let piece = currentPiece {
            for r in 0..<piece.shape.count {
                for c in 0..<piece.shape[r].count {
                    if piece.shape[r][c] == 1 {
                        let pr = piece.position.row + r
                        let pc = piece.position.col + c
                        if pr == row && pc == col {
                            return piece.color
                        }
                    }
                }
            }
        }
        return grid[row][col]
    }
    
    //Sets up empty grid
    private func emptyGrid() -> [[Color?]] {
        Array(repeating: Array(repeating: nil, count: Constants.columns), count: Constants.rows)
    }
}
