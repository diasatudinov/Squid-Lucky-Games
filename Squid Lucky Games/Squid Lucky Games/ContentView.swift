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

// Модель игрового состояния
class GameViewModel: ObservableObject {
    // Игровое поле 11x11, каждая клетка хранит тип фигуры
    @Published var board: [[PieceType]] = Array(
        repeating: Array(repeating: .none, count: 11),
        count: 11
    )
    // Выбранная клетка (если игрок выбирает фигуру для хода)
    @Published var selectedCell: (row: Int, col: Int)? = nil
    // Флаг окончания игры (можно расширять логику побед/поражений)
    @Published var gameOver: Bool = false
    @Published var gameResult: String = ""
    
    init() {
        setupBoard()
    }
    
    // Начальная расстановка фигур
    func setupBoard() {
        // Сброс поля
        board = Array(
            repeating: Array(repeating: .none, count: 11),
            count: 11
        )
        let center = 5
        // Размещаем короля в центре
        board[center][center] = .king
        
        // Расстановка 12 защитников вокруг короля (вокруг центральной клетки)
        let defenders: [(Int, Int)] = [
            (center - 1, center), (center + 1, center),
            (center, center - 1), (center, center + 1),
            (center - 1, center - 1), (center - 1, center + 1),
            (center + 1, center - 1), (center + 1, center + 1),
            (center - 2, center), (center + 2, center),
            (center, center - 2), (center, center + 2)
        ]
        for pos in defenders {
            board[pos.0][pos.1] = .defender
        }
        
        // Расстановка 24 атакующих по краям. Здесь приведён один из вариантов начальной расстановки.
        let attackers: [(Int, Int)] = [
            // Верхняя сторона
            (0, 3), (0, 4), (0, 5), (0, 6), (0, 7),
            // Нижняя сторона
            (10, 3), (10, 4), (10, 5), (10, 6), (10, 7),
            // Левая сторона
            (3, 0), (4, 0), (5, 0), (6, 0), (7, 0),
            // Правая сторона
            (3, 10), (4, 10), (5, 10), (6, 10), (7, 10),
            // Дополнительные позиции
            (1, 5), (5, 1), (9, 5), (5, 9)
        ]
        for pos in attackers {
            board[pos.0][pos.1] = .attacker
        }
    }
    
    // Перемещение фигуры с клетки "from" на клетку "to"
    func movePiece(from: (Int, Int), to: (Int, Int)) {
        // Если ходу не соответствует логика (не по прямой), отменяем
        if from.0 != to.0 && from.1 != to.1 { return }
        // Проверка, что по пути нет других фигур
        if !isPathClear(from: from, to: to) { return }
        
        let movingPiece = board[from.0][from.1]
        // Перемещаем фигуру
        board[from.0][from.1] = .none
        board[to.0][to.1] = movingPiece
        
        // После хода проверяем захваты фигур
        checkCaptures(around: to, movingPiece: movingPiece)
        // Отдельно проверяем, не захвачен ли король
        checkKingCapture()
    }
    
    // Проверка, что между from и to нет фигур
    func isPathClear(from: (Int, Int), to: (Int, Int)) -> Bool {
        if from.0 == to.0 {
            // Горизонтальное движение
            let range = from.1 < to.1 ? (from.1 + 1)..<to.1 : (to.1 + 1)..<from.1
            for col in range {
                if board[from.0][col] != .none {
                    return false
                }
            }
        } else if from.1 == to.1 {
            // Вертикальное движение
            let range = from.0 < to.0 ? (from.0 + 1)..<to.0 : (to.0 + 1)..<from.0
            for row in range {
                if board[row][from.1] != .none {
                    return false
                }
            }
        }
        return true
    }
    
    // Проверка захвата фигур вокруг клетки, куда переместилась фигура.
    // Если фигура оказывается между двумя враждебными – удаляем её.
    func checkCaptures(around pos: (Int, Int), movingPiece: PieceType) {
        let directions = [(0,1), (1,0), (0,-1), (-1,0)]
        for direction in directions {
            let enemyRow = pos.0 + direction.0
            let enemyCol = pos.1 + direction.1
            let allyRow = enemyRow + direction.0
            let allyCol = enemyCol + direction.1
            if isValid(row: enemyRow, col: enemyCol) && isValid(row: allyRow, col: allyCol) {
                let enemyPiece = board[enemyRow][enemyCol]
                // Если встречается фигура, отличная от пустой, короля и своей же, то проверяем захват
                if enemyPiece != .none &&
                   enemyPiece != movingPiece &&
                   enemyPiece != .king {
                    // Если за вражеской фигурой находится союзник или король – захватываем
                    if board[allyRow][allyCol] == movingPiece || board[allyRow][allyCol] == .king {
                        board[enemyRow][enemyCol] = .none
                    }
                }
            }
        }
    }
    
    // Проверка захвата короля: он считается захваченным, если со всех сторон (или с трёх, если у края) клеток находятся атакующие или край поля
    func checkKingCapture() {
        for row in 0..<11 {
            for col in 0..<11 {
                if board[row][col] == .king {
                    let directions = [(0,1), (1,0), (0,-1), (-1,0)]
                    var surroundCount = 0
                    for direction in directions {
                        let adjRow = row + direction.0
                        let adjCol = col + direction.1
                        if !isValid(row: adjRow, col: adjCol) {
                            // Если клетка за пределами доски – считаем как "окружена"
                            surroundCount += 1
                        } else if board[adjRow][adjCol] == .attacker {
                            surroundCount += 1
                        }
                    }
                    // Если король находится у края, требуется окружение с трёх сторон, иначе – со всех четырёх
                    let required = isOnEdge(row: row, col: col) ? 3 : 4
                    if surroundCount >= required {
                        gameOver = true
                        gameResult = "Атакующие победили! Король захвачен."
                    }
                    return
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
    var piece: PieceType
    var isSelected: Bool = false
    var body: some View {
        ZStack {
            Rectangle()
                .fill(isSelected ? Color.green.opacity(0.3) : Color.white)
                .frame(width: 30, height: 30)
                .border(Color.black)
            if piece != .none {
                Circle()
                    .fill(colorForPiece(piece))
                    .frame(width: 20, height: 20)
            }
        }
    }
    
    func colorForPiece(_ piece: PieceType) -> Color {
        switch piece {
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
        VStack {
            Text("Игра: Хнефатафл")
                .font(.title)
                .padding()
            VStack(spacing: 0){
                // Игровое поле 11x11
                ForEach(0..<11, id: \.self) { row in
                    HStack(spacing: 0) {
                        ForEach(0..<11, id: \.self) { col in
                            CellView(
                                piece: viewModel.board[row][col],
                                isSelected: viewModel.selectedCell?.row == row && viewModel.selectedCell?.col == col
                            )
                            .onTapGesture {
                                cellTapped(row: row, col: col)
                            }
                        }
                    }
                }
               
            }//.frame(width: 330, height: 330)
            // Кнопка "Сдаться"
            Button("Сдаться") {
                viewModel.gameOver = true
                viewModel.gameResult = "Игрок сдался. Атакующие победили."
            }
            .padding()
            .font(.headline)
            
            // Сообщение об окончании игры
            if viewModel.gameOver {
                Text(viewModel.gameResult)
                    .font(.title2)
                    .padding()
            }
        }
    }
    
    // Обработка нажатия на клетку:
    // Если не выбрана фигура – выбираем её (если там не пусто).
    // Если уже выбрана – пытаемся переместить на нажатую клетку.
    func cellTapped(row: Int, col: Int) {
        if viewModel.gameOver { return }
        
        if let selected = viewModel.selectedCell {
            // Если нажата другая клетка, пробуем сделать ход
            viewModel.movePiece(from: selected, to: (row, col))
            viewModel.selectedCell = nil
        } else {
            // Если клетка не пуста – выбираем фигуру
            if viewModel.board[row][col] != .none {
                viewModel.selectedCell = (row, col)
            }
        }
    }
}

#Preview {
    ContentView()
}
