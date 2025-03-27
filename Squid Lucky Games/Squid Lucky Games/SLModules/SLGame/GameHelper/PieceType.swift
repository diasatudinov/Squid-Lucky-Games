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