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
                HStack(alignment: .center, spacing: 60) {
                    Text("Score: \n \(viewModel.score)")
                        .font(.title2)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.white)
                        .bold()
                    Text("Highest Score: \n \(viewModel.highScore)")
                        .font(.title2)
                        .foregroundStyle(.white)
                        .multilineTextAlignment(.center)
                        .bold()
                }.padding()
                
                
                //MARK: - Game Grid
                GeometryReader { geometry in
                    let cellSize = min(geometry.size.width / CGFloat(Constants.columns),
                                       geometry.size.height / CGFloat(Constants.rows))
                    
                    VStack(spacing: 1) {
                        ForEach(0..<Constants.rows, id: \.self) { row in
                            HStack(spacing: 1) {
                                ForEach(0..<Constants.columns, id: \.self) { col in
                                    
                                    let color = viewModel.colorAt(row: row, col: col)
                                    Rectangle()
                                        .foregroundColor(color ?? .black.opacity(0.1))
                                        .frame(width: cellSize, height: cellSize)
                                        .border(Color.gray.opacity(0.3), width: 0.5)
                                }
                            }
                        }
                    }
                    .frame(width: cellSize * CGFloat(Constants.columns),
                           height: cellSize * CGFloat(Constants.rows))
                    .background(Color.black)
                }
                .aspectRatio(CGFloat(Constants.columns) / CGFloat(Constants.rows), contentMode: .fit)
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
