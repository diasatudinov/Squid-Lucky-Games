//
//  TwoPlayersView.swift
//  Squid Lucky Games
//
//  Created by Dias Atudinov on 27.03.2025.
//


import SwiftUI

struct AgainstPlayersView: View {
    @Environment(\.presentationMode) var presentationMode

    @StateObject var viewModel = AgainstPlayersGameViewModel()
    @ObservedObject var shopVM: ShopViewModelSL
    var body: some View {
        ZStack {
            VStack {
                Spacer()
            HStack(spacing: 50) {
                VStack {
                    Image(.defendersIconSL)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120)
                    Image(viewModel.currentPlayer == .defender ? .yourTurnText: .waitText)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120, height: 20)
                    
                    Spacer()
                    
                    HStack {
                        Image(.timerIconSL)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 80)
                        
                        ZStack {
                            Image(.timerBgSL)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 80)
                        }
                    }
                    
                }
                
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
                    .overlay {
                        Rectangle()
                        .stroke(Color.appPurple, lineWidth: 12)
                    }
                
                VStack {
                    Image(.attackersIconSL)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120, height: 120)
                    Image(viewModel.currentPlayer == .attacker ? .yourTurnText: .waitText)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120, height: 20)
                    Spacer()
                    Button{
                        viewModel.gameOver = true
                        viewModel.gameResult = "Surrendered. \(viewModel.currentPlayer == .attacker ? "Defenders" : "Attackers") win."
                    } label: {
                       
                        Image(.surrenderIconSL)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100)
                    }
                    
                    
                    Button {
                        //viewModel.resetGame()
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        
                        Image(.restartGameIconSL)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100)
                    }
                    
                }
            }
                Spacer()
        }
            
            if viewModel.gameOver {
                
                ZStack {
                    Image(.gameOverBg)
                        .resizable()
                        .scaledToFill()
                        .ignoresSafeArea()
                        .scaleEffect(x: viewModel.isDefenderWin ? 1 : -1, y: 1)
                    
                    HStack {
                        Spacer()
                        VStack {
                            if !viewModel.isDefenderWin {
                                Image(.loseIconSL)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 250)
                                Image(.tryAgainIconSL)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 250)
                            } else {
                                Image(.winIconSL)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 250)
                                Image(.bonusIconSL)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 250)
                            }
                        }
                        Spacer()
                        VStack {
                            Spacer()
                            Button {
                                viewModel.resetGame()
                            } label: {
                                Image(.restartIconSL)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 100)
                            }
                            
                            Button {
                                presentationMode.wrappedValue.dismiss()
                            } label: {
                                Image(.menuIconSL)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 100)
                            }
                        }
                        Spacer()
                        VStack {
                            if viewModel.isDefenderWin {
                                Image(.loseIconSL)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 250)
                                Image(.tryAgainIconSL)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 250)
                            } else {
                                Image(.winIconSL)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 250)
                                Image(.bonusIconSL)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 250)
                            }
                        }
                        Spacer()
                    }
                    
                }
            }
        }.background(
            ZStack {
                Image(.menuViewBgSL)
                    .resizable()
                    .edgesIgnoringSafeArea(.all)
                    .scaledToFill()
            }
            
        )
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
    AgainstPlayersView(shopVM: ShopViewModelSL())
}
