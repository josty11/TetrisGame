//
//  TetrisPiece.swift
//  TetrisGame
//
//  Created by Tatiana on 29/05/25.
//

import SwiftUI

struct TetrisPiece {
    var shape: [[Int]]
    var position: (row: Int, col: Int)
    var color: Color
    
    static func create(from type: TetrisShapeType) -> TetrisPiece {
        let shape = type.shape
        let initialCol = (Constants.columns - shape[0].count) / 2
        return TetrisPiece(
            shape: shape,
            position: (row: 0, col: initialCol),
            color: type.color
        )
    }
    
    func rotated() -> TetrisPiece {
        let rows = shape.count
        let cols = shape[0].count
        var newShape = Array(repeating: Array(repeating: 0, count: rows), count: cols)
        for r in 0..<rows {
            for c in 0..<cols {
                newShape[c][rows - 1 - r] = shape[r][c]
            }
        }
        return TetrisPiece(shape: newShape, position: position, color: color)
    }
}

enum TetrisShapeType: CaseIterable {
    case i, o, t, l, j, z, s

    var color: Color {
        switch self {
        case .i: return .cyan
        case .o: return .yellow
        case .t: return .purple
        case .l: return .orange
        case .j: return .blue
        case .z: return .red
        case .s: return .green
        }
    }

    var shape: [[Int]] {
        switch self {
        case .i: return [[1, 1, 1, 1]]
        case .o: return [[1, 1], [1, 1]]
        case .t: return [[0, 1, 0], [1, 1, 1]]
        case .l: return [[1, 0], [1, 0], [1, 1]]
        case .j: return [[0, 1], [0, 1], [1, 1]]
        case .z: return [[1, 1, 0], [0, 1, 1]]
        case .s: return [[0, 1, 1], [1, 1, 0]]
        }
    }
}
