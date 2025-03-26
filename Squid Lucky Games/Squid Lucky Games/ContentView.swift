//
//  ContentView.swift
//  Squid Lucky Games
//
//  Created by Dias Atudinov on 24.03.2025.
//

import SwiftUI

// Типы фигур
enum PieceType {
    case none
    case king
    case defender
    case attacker
}

enum AttackerSide: String {
    case squareFigureSL, triangleFigureSL, umbrellaFigureSL, CirecleFigureSL
}

enum Player: String {
    case attacker = "Атакующие"
    case defender = "Защитники"
}

struct Piece {
    var type: PieceType
    var attackerSide: AttackerSide? = nil
}

// Модель игрового состояния
class GameViewModel: ObservableObject {
    @Published var board: [[Piece]] = Array(
        repeating: Array(repeating: Piece(type: .none), count: 11),
        count: 11
    )
    @Published var selectedCell: (row: Int, col: Int)? = nil
    @Published var gameOver: Bool = false
    @Published var gameResult: String = ""
    @Published var currentPlayer: Player = .attacker
    
    init() {
        setupBoard()
    }
    
    func resetGame() {
        gameOver = false
        gameResult = ""
        selectedCell = nil
        currentPlayer = .attacker
        setupBoard()
    }
    
    func isCorner(row: Int, col: Int) -> Bool {
        return (row == 0 && col == 0) ||
        (row == 0 && col == 10) ||
        (row == 10 && col == 0) ||
        (row == 10 && col == 10)
    }
    
    func setupBoard() {
        // Reset board
        board = Array(
            repeating: Array(repeating: Piece(type: .none), count: 11),
            count: 11
        )
        let center = 5
        // Place king at center.
        board[center][center] = Piece(type: .king)
        
        // Setup defenders (they use the default defender appearance).
        let defenders: [(Int, Int)] = [
            (center - 1, center), (center + 1, center),
            (center, center - 1), (center, center + 1),
            (center - 1, center - 1), (center - 1, center + 1),
            (center + 1, center - 1), (center + 1, center + 1),
            (center - 2, center), (center + 2, center),
            (center, center - 2), (center, center + 2)
        ]
        for pos in defenders {
            if isCorner(row: pos.0, col: pos.1) { continue }
            board[pos.0][pos.1] = Piece(type: .defender)
        }
        
        // Setup attackers on the board edges.
        // We assign an attackerSide based on the attacker's position.
        let attackersPositions: [(Int, Int)] = [
            // Top edge – facing down (south)
            (0, 3), (0, 4), (0, 5), (0, 6), (0, 7),
            // Bottom edge – facing up (north)
            (10, 3), (10, 4), (10, 5), (10, 6), (10, 7),
            // Left edge – facing right (east)
            (3, 0), (4, 0), (5, 0), (6, 0), (7, 0),
            // Right edge – facing left (west)
            (3, 10), (4, 10), (5, 10), (6, 10), (7, 10),
            // Additional positions:
            (1, 5),  // near top -> south
            (5, 1),  // near left -> east
            (9, 5),  // near bottom -> north
            (5, 9)   // near right -> west
        ]
        for pos in attackersPositions {
            if isCorner(row: pos.0, col: pos.1) { continue }
            let side: AttackerSide
            if pos.0 == 0 || pos.0 == 1 {
                side = .triangleFigureSL
            } else if pos.0 == 10 || pos.0 == 9 {
                side = .squareFigureSL
            } else if pos.1 == 0 || pos.1 == 1 {
                side = .CirecleFigureSL
            } else if pos.1 == 10 || pos.1 == 9 {
                side = .umbrellaFigureSL
            } else {
                side = .triangleFigureSL // default fallback
            }
            board[pos.0][pos.1] = Piece(type: .attacker, attackerSide: side)
        }
    }
    
    // ... [the rest of your game logic remains the same,
    // but remember to work with Piece instead of PieceType]
    
    func isPieceBelongsToCurrentPlayer(_ piece: Piece) -> Bool {
        switch currentPlayer {
        case .attacker:
            return piece.type == .attacker
        case .defender:
            return piece.type == .defender || piece.type == .king
        }
    }
    
    func movePiece(from: (Int, Int), to: (Int, Int)) {
        // For brevity, the same validations are applied.
        if board[to.0][to.1].type != .none { return }
        if isCorner(row: to.0, col: to.1) {
            if board[from.0][from.1].type != .king { return }
        }
        if from.0 != to.0 && from.1 != to.1 { return }
        if !isPathClear(from: from, to: to) { return }
        
        let movingPiece = board[from.0][from.1]
        if !isPieceBelongsToCurrentPlayer(movingPiece) { return }
        
        board[from.0][from.1] = Piece(type: .none)
        board[to.0][to.1] = movingPiece

        // If the king moved to a corner, handle victory.
        if movingPiece.type == .king && isCorner(row: to.0, col: to.1) {
            gameOver = true
            gameResult = "Defenders win! The king has escaped."
            return
        }

        // Check for captures around the destination.
        checkCaptures(around: to, movingPiece: movingPiece)
        // Check if the king is captured.
        checkKingCapture()
        // Switch turn if the game is not over.
        if !gameOver {
            switchTurn()
        }
    }
    
    func switchTurn() {
        currentPlayer = currentPlayer == .attacker ? .defender : .attacker
    }
    
    func isPathClear(from: (Int, Int), to: (Int, Int)) -> Bool {
        if from.0 == to.0 {
            let range = from.1 < to.1 ? (from.1 + 1)..<to.1 : (to.1 + 1)..<from.1
            for col in range {
                if board[from.0][col].type != .none { return false }
            }
        } else if from.1 == to.1 {
            let range = from.0 < to.0 ? (from.0 + 1)..<to.0 : (to.0 + 1)..<from.0
            for row in range {
                if board[row][from.1].type != .none { return false }
            }
        }
        return true
    }
    
    // Capture logic for regular pieces
    func checkCaptures(around pos: (Int, Int), movingPiece: Piece) {
        // Four cardinal directions: right, down, left, up
        let directions = [(0, 1), (1, 0), (0, -1), (-1, 0)]
        for direction in directions {
            let enemyRow = pos.0 + direction.0
            let enemyCol = pos.1 + direction.1
            let allyRow = enemyRow + direction.0
            let allyCol = enemyCol + direction.1
            
            // Ensure both positions are within board limits.
            if isValid(row: enemyRow, col: enemyCol) && isValid(row: allyRow, col: allyCol) {
                let enemyPiece = board[enemyRow][enemyCol]
                // Check if the enemy piece exists, is not none, is not the king,
                // and does not belong to the same side as the moving piece.
                if enemyPiece.type != .none &&
                    enemyPiece.type != movingPiece.type &&
                    enemyPiece.type != .king {
                    let allyPiece = board[allyRow][allyCol]
                    // If the cell beyond the enemy piece is either occupied by a friendly piece,
                    // is the king, or is a corner cell (which counts as a barrier), remove the enemy.
                    if allyPiece.type == movingPiece.type || allyPiece.type == .king || isCorner(row: allyRow, col: allyCol) {
                        board[enemyRow][enemyCol] = Piece(type: .none)
                    }
                }
            }
        }
    }
    
    // Capture logic for the king piece
    func checkKingCapture() {
        // Find the king's position on the board.
        for row in 0..<11 {
            for col in 0..<11 {
                if board[row][col].type == .king {
                    let directions = [(0, 1), (1, 0), (0, -1), (-1, 0)]
                    var surroundCount = 0
                    for direction in directions {
                        let adjRow = row + direction.0
                        let adjCol = col + direction.1
                        // If the adjacent cell is off the board, count it as a barrier.
                        if !isValid(row: adjRow, col: adjCol) {
                            surroundCount += 1
                        }
                        // Otherwise, if the adjacent cell is occupied by an attacker or is a corner cell, count it.
                        else if board[adjRow][adjCol].type == .attacker || isCorner(row: adjRow, col: adjCol) {
                            surroundCount += 1
                        }
                    }
                    // Determine how many sides need to be blocked.
                    let required = isOnEdge(row: row, col: col) ? 3 : 4
                    if surroundCount >= required {
                        gameOver = true
                        gameResult = "Attackers win! King captured."
                    }
                    return // Once the king is found and evaluated, exit.
                }
            }
        }
    }
    
    func isOnEdge(row: Int, col: Int) -> Bool {
        return row == 0 || row == 10 || col == 0 || col == 10
    }
    
    func isValid(row: Int, col: Int) -> Bool {
        return row >= 0 && row < 11 && col >= 0 && col < 11
    }
}

// Представление отдельной клетки
struct CellView: View {
    var row: Int
    var col: Int
    var piece: Piece
    var isSelected: Bool = false
    var isCorner: Bool {
        return (row == 0 && col == 0) ||
        (row == 0 && col == 10) ||
        (row == 10 && col == 0) ||
        (row == 10 && col == 10)
    }
    var body: some View {
        ZStack {
            Rectangle()
                .fill(isCorner ? Color.purple.opacity(0.5) : (isSelected ? Color.green.opacity(0.3) : Color.clear))
                .frame(width: 30, height: 30)
                .border(Color.appPurple, width: 2)
            
            // For attackers, show the proper image; for others, fallback to a circle.
            if piece.type == .attacker, let side = piece.attackerSide {
                Image("\(side.rawValue)")
                    .resizable()
                    .frame(width: 20, height: 20)
            } else if piece.type == .defender {
                Image(.attackerFigureSL)
                    .resizable()
                    .frame(width: 20, height: 20)
            } else if piece.type == .king {
                Image(.kingFigureSL)
                    .resizable()
                    .frame(width: 20, height: 20)
            } else if piece.type != .none {
                Circle()
                    .fill(colorForPiece(piece.type))
                    .frame(width: 20, height: 20)
            }
        }
    }
    
    func colorForPiece(_ type: PieceType) -> Color {
        switch type {
        case .king:
            return .yellow
        case .defender:
            return .blue
        case .attacker:
            return .red
        default:
            return .clear
        }
    }
}

// Главное представление игры
struct ContentView: View {
    @StateObject var viewModel = GameViewModel()
       
       var body: some View {
           VStack(spacing: 10) {
               Text("Hnefatafl Game")
                   .font(.title)
                   .padding(.top)
               
               Text("Turn: \(viewModel.currentPlayer.rawValue)")
                   .font(.headline)
               
               ZStack {
                   Color.black
                   GeometryReader { geometry in
                       Path { path in
                           path.move(to: .zero)
                           path.addLine(to: CGPoint(x: geometry.size.width, y: geometry.size.height))
                           path.move(to: CGPoint(x: geometry.size.width, y: 0))
                           path.addLine(to: CGPoint(x: 0, y: geometry.size.height))
                       }
                       .stroke(Color.appPurple, lineWidth: 3)
                   }.frame(width: 270, height: 270)
                   
                   VStack(spacing: 0) {
                       ForEach(0..<11, id: \.self) { row in
                           HStack(spacing: 0) {
                               ForEach(0..<11, id: \.self) { col in
                                   CellView(
                                       row: row,
                                       col: col,
                                       piece: viewModel.board[row][col],
                                       isSelected: viewModel.selectedCell?.row == row && viewModel.selectedCell?.col == col
                                   )
                                   .onTapGesture {
                                       cellTapped(row: row, col: col)
                                   }
                               }
                           }
                       }
                   }
                 
               }.frame(width: 330, height: 330)
               
               HStack {
                   Button("Surrender") {
                       viewModel.gameOver = true
                       viewModel.gameResult = "Surrendered. \(viewModel.currentPlayer == .attacker ? "Defenders" : "Attackers") win."
                   }
                   .padding()
                   .font(.headline)
                   
                   Button("Restart") {
                       viewModel.resetGame()
                   }
                   .padding()
                   .font(.headline)
               }
               
               if viewModel.gameOver {
                   Text(viewModel.gameResult)
                       .font(.title2)
                       .padding()
               }
           }
       }
       
       func cellTapped(row: Int, col: Int) {
           if viewModel.gameOver { return }
           
           if let selected = viewModel.selectedCell {
               viewModel.movePiece(from: selected, to: (row, col))
               viewModel.selectedCell = nil
           } else {
               if viewModel.board[row][col].type != .none &&
                   viewModel.isPieceBelongsToCurrentPlayer(viewModel.board[row][col]) {
                   viewModel.selectedCell = (row, col)
               }
           }
       }
   }
#Preview {
    ContentView()
}
