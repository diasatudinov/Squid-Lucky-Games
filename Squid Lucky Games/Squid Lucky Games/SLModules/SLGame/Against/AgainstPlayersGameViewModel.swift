import SwiftUI
import AVFoundation

class AgainstPlayersGameViewModel: ObservableObject {
    @Published var board: [[Piece]] = Array(
        repeating: Array(repeating: Piece(type: .none), count: 11),
        count: 11
    )
    @Published var selectedCell: (row: Int, col: Int)? = nil
    @Published var gameOver: Bool = false
    @Published var gameResult: String = ""
    @Published var currentPlayer: Player = .defender
    @Published var isDefenderWin = false
    
    @Published var timeRemaining: Int = 30
    var turnDuration = 30
    var timer: Timer? = nil
    var audioPlayer: AVAudioPlayer?
    
    let settingsVM = SettingsViewModelSL()

    
    init() {
        setupBoard()
        startTurnTimer()
    }
    
    func resetGame() {
        gameOver = false
        isDefenderWin = false
        gameResult = ""
        selectedCell = nil
        currentPlayer = .defender
        setupBoard()
        startTurnTimer()
    }
    
    func playTapSound() {
        if settingsVM.soundEnabled {
            guard let url = Bundle.main.url(forResource: "clickSoundSL", withExtension: "mp3") else { return }
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer?.play()
            } catch {
                print("Ошибка воспроизведения звука: \(error)")
            }
        }
    }
    
    func startTurnTimer() {
           // Останавливаем предыдущий таймер, если он есть
           timer?.invalidate()
           timeRemaining = turnDuration
           timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
               guard let self = self else { return }
               if self.timeRemaining > 0 {
                   self.timeRemaining -= 1
               } else {
                   timer.invalidate()
                   self.timer = nil
                   // Если время закончилось, автоматически переключаем ход
                   self.switchTurn()
               }
           }
       }
       
       // Остановка таймера
       func stopTurnTimer() {
           timer?.invalidate()
           timer = nil
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

        playTapSound()
        
        // If the king moved to a corner, handle victory.
        if movingPiece.type == .king && isCorner(row: to.0, col: to.1) {
            gameOver = true
            isDefenderWin = true
            gameResult = "Defenders win! The king has escaped."
            SLUser.shared.updateUserBirds(for: 2000)
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
        
        if currentPlayer == .attacker {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.performAIMove()
            }
        }
        
        startTurnTimer()
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
                        isDefenderWin = false
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
    
    // MARK: AI Moves
    func availableAIMoves() -> [((Int, Int), (Int, Int))] {
            var moves: [((Int, Int), (Int, Int))] = []
            // Перебираем все клетки
            for row in 0..<11 {
                for col in 0..<11 {
                    let piece = board[row][col]
                    if piece.type == .attacker {
                        // Для каждой атакующей фигуры ищем возможные ходы по 4 направлениям
                        let directions = [(0, 1), (1, 0), (0, -1), (-1, 0)]
                        for direction in directions {
                            var newRow = row + direction.0
                            var newCol = col + direction.1
                            while isValid(row: newRow, col: newCol) && board[newRow][newCol].type == .none {
                                // Если клетка угловая – разрешаем ход только для короля, поэтому пропускаем
                                if isCorner(row: newRow, col: newCol) { break }
                                // Если путь свободен, добавляем ход
                                if isPathClear(from: (row, col), to: (newRow, newCol)) {
                                    moves.append(((row, col), (newRow, newCol)))
                                }
                                newRow += direction.0
                                newCol += direction.1
                            }
                        }
                    }
                }
            }
            return moves
        }
        
        func performAIMove() {
            let moves = availableAIMoves()
            guard moves.count > 0 else { return }
            // Выбираем случайный ход
            let move = moves.randomElement()!
            movePiece(from: move.0, to: move.1)
        }
}
