//
//  TetrisViewModel.swift
//  TetrisGame
//
//  Created by Tatiana on 25/05/25.
//

import SwiftUI
import Combine

struct TetrisPiece {
    var shape: [[Int]]
    var position: (row: Int, col: Int)
    var color: Color
}

class TetrisViewModel: ObservableObject {
    static let rows = 20
    static let columns = 10

    @Published var grid: [[Color?]] = Array(repeating: Array(repeating: nil, count: columns), count: rows)
    @Published var currentPiece: TetrisPiece?
    @Published var score = 0

    private var timer: AnyCancellable?

    init() {}

    func startGame() {
        grid = Array(repeating: Array(repeating: nil, count: TetrisViewModel.columns), count: TetrisViewModel.rows)
        score = 0
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
        let pieces = [
            // I
            ([[1, 1, 1, 1]], Color.cyan),
            // O
            ([[1, 1],
              [1, 1]], Color.yellow),
            // T
            ([[0, 1, 0],
              [1, 1, 1]], Color.purple),
            // L
            ([[1, 0],
              [1, 0],
              [1, 1]], Color.orange),
            // J
            ([[0, 1],
              [0, 1],
              [1, 1]], Color.blue),
            // Z
            ([[1, 1, 0],
              [0, 1, 1]], Color.red),
            // S
            ([[0, 1, 1],
              [1, 1, 0]], Color.green)
        ]
        let random = pieces.randomElement()!
        let shape = random.0
        let color = random.1

        let piece = TetrisPiece(
            shape: shape,
            position: (row: 0, col: (TetrisViewModel.columns - shape[0].count) / 2),
            color: color
        )
        if canPlace(piece: piece) {
            currentPiece = piece
        } else {
            // Game Over
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
        for r in 0..<piece.shape.count {
            for c in 0..<piece.shape[r].count {
                if piece.shape[r][c] == 1 {
                    let row = piece.position.row + r
                    let col = piece.position.col + c
                    if row < 0 || row >= TetrisViewModel.rows || col < 0 || col >= TetrisViewModel.columns {
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
        for r in 0..<piece.shape.count {
            for c in 0..<piece.shape[r].count {
                if piece.shape[r][c] == 1 {
                    let row = piece.position.row + r
                    let col = piece.position.col + c
                    if row >= 0 && row < TetrisViewModel.rows &&
                        col >= 0 && col < TetrisViewModel.columns {
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
            newGrid.insert(Array(repeating: nil, count: TetrisViewModel.columns), at: 0)
        }

        grid = newGrid
        score += clearedLines * 100
    }

    func moveLeft() {
        guard var piece = currentPiece else { return }
        piece.position.col -= 1
        if canPlace(piece: piece) {
            currentPiece = piece
        }
    }

    func moveRight() {
        guard var piece = currentPiece else { return }
        piece.position.col += 1
        if canPlace(piece: piece) {
            currentPiece = piece
        }
    }

    func rotate() {
        guard var piece = currentPiece else { return }
        let rotated = rotateShape(piece.shape)
        let newPiece = TetrisPiece(shape: rotated, position: piece.position, color: piece.color)
        if canPlace(piece: newPiece) {
            currentPiece = newPiece
        }
    }

    private func rotateShape(_ shape: [[Int]]) -> [[Int]] {
        let rows = shape.count
        let cols = shape[0].count
        var rotated = Array(repeating: Array(repeating: 0, count: rows), count: cols)

        for r in 0..<rows {
            for c in 0..<cols {
                rotated[c][rows - 1 - r] = shape[r][c]
            }
        }
        return rotated
    }

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
}
