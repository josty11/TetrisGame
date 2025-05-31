# Tetris Game

A simple Tetris game built entirely with **SwiftUI**.  
The goal of this project was to create a clean, minimalistic implementation of the classic game with lightweight visuals and no external dependencies.

---

## Features

- Basic Tetris logic: piece movement, rotation, line clearing
- Score tracking and persistent **high score**
- Game over detection and restart option
- Clean and readable code following Swift best practices

---

## Getting Started

1. Open the project in **Xcode 15+**
2. Run it on an iOS simulator or device
3. Tap the buttons on the screen to control the piece (move left/right, rotate, or drop)

---

## Structure

- `TetrisViewModel.swift`: Handles game logic, state, scoring, and timing
- `TetrisPiece.swift`: Represents the falling block and its rotation logic
- `TetrisGameView.swift`: Main game interface using a grid of colored squares

---

## Goals

This was a learning project meant to:
- Explore game logic in SwiftUI without using game engines
- Practice clean architecture and observable view models
- Keep everything lightweight and readable
