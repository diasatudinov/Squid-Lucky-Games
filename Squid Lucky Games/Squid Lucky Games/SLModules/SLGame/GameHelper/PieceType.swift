//
//  PieceType.swift
//  Squid Lucky Games
//
//  Created by Dias Atudinov on 27.03.2025.
//
import SwiftUI

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
                .frame(width: SLDeviceInfo.shared.deviceType == .pad ? 60:30, height: SLDeviceInfo.shared.deviceType == .pad ? 60:30)
                .border(Color.appPurple, width: SLDeviceInfo.shared.deviceType == .pad ? 4:2)
            
            // For attackers, show the proper image; for others, fallback to a circle.
            if piece.type == .attacker, let side = piece.attackerSide {
                Image("\(side.rawValue)")
                    .resizable()
                    .frame(width: SLDeviceInfo.shared.deviceType == .pad ? 40:20, height: SLDeviceInfo.shared.deviceType == .pad ? 40:20)
            } else if piece.type == .defender {
                Image(.attackerFigureSL)
                    .resizable()
                    .frame(width: SLDeviceInfo.shared.deviceType == .pad ? 40:20, height: SLDeviceInfo.shared.deviceType == .pad ? 40:20)
            } else if piece.type == .king {
                Image(.kingFigureSL)
                    .resizable()
                    .frame(width: SLDeviceInfo.shared.deviceType == .pad ? 40:20, height: SLDeviceInfo.shared.deviceType == .pad ? 40:20)
            } else if piece.type != .none {
                Circle()
                    .fill(colorForPiece(piece.type))
                    .frame(width: SLDeviceInfo.shared.deviceType == .pad ? 40:20, height: SLDeviceInfo.shared.deviceType == .pad ? 40:20)
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
