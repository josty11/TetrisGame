//
//  ContentView.swift
//  TetrisGame
//
//  Created by Tatiana on 25/05/25.
//

import SwiftUI

struct TetrisGameView: View {
    @StateObject private var viewModel = TetrisViewModel()

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 10) {
                Text("Score: \(viewModel.score)")
                    .font(.title2)
                    .foregroundStyle(.white)
                    .bold()
                
                //MARK: - Game Grid
                GeometryReader { geometry in
                    let cellSize = min(geometry.size.width / CGFloat(TetrisViewModel.columns),
                                       geometry.size.height / CGFloat(TetrisViewModel.rows))
                    
                    VStack(spacing: 1) {
                        ForEach(0..<TetrisViewModel.rows, id: \.self) { row in
                            HStack(spacing: 1) {
                                ForEach(0..<TetrisViewModel.columns, id: \.self) { col in
                                    
                                    let color = viewModel.colorAt(row: row, col: col)
                                    Rectangle()
                                        .foregroundColor(color ?? .black.opacity(0.1))
                                        .frame(width: cellSize, height: cellSize)
                                        .border(Color.gray.opacity(0.3), width: 0.5)
                                }
                            }
                        }
                    }
                    .frame(width: cellSize * CGFloat(TetrisViewModel.columns),
                           height: cellSize * CGFloat(TetrisViewModel.rows))
                    .background(Color.black)
                }
                .aspectRatio(CGFloat(TetrisViewModel.columns) / CGFloat(TetrisViewModel.rows), contentMode: .fit)
                .padding(.top, 20)
                
                //MARK: - Controls
                HStack(spacing: 20) {
                    Button {
                        viewModel.moveLeft()
                    } label: {
                        Image("arrow-left").resizable().frame(width: 50, height: 50)
                    }.foregroundStyle(.white)

                    Button {
                        viewModel.rotate()
                    } label: {
                        Image("arrow-rotate").resizable().frame(width: 50, height: 50)
                    }.foregroundStyle(.white)
                
                    Button {
                        viewModel.moveRight()
                    } label: {
                        Image("arrow-right").resizable().frame(width: 50, height: 50)
                    }.foregroundStyle(.white)
                    
                    Button {
                        viewModel.drop()
                    } label: {
                        Image("arrow-down").resizable().frame(width: 50, height: 50)
                    }.foregroundStyle(.white)
                }
                .font(.largeTitle)
                .padding(.top)
                
                // Start Game Button
                if viewModel.currentPiece == nil {
                    Button("Start Game") {
                        viewModel.startGame()
                    }
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .padding(.top, 10)
                }
            }
        }
    }
}

#Preview {
    TetrisGameView()
}
