import SwiftUI

struct TwoPlayersView: View {
    @Environment(\.presentationMode) var presentationMode

    @StateObject var viewModel = TwoPlayersGameViewModel()
    @ObservedObject var shopVM: ShopViewModelSL
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                HStack(spacing:SLDeviceInfo.shared.deviceType == .pad ? 25:50) {
                VStack {
                    Image(.defendersIconSL)
                        .resizable()
                        .scaledToFit()
                        .frame(width: SLDeviceInfo.shared.deviceType == .pad ? 240:120)
                    Image(viewModel.currentPlayer == .defender ? .yourTurnText: .waitText)
                        .resizable()
                        .scaledToFit()
                        .frame(width: SLDeviceInfo.shared.deviceType == .pad ? 240:120, height: SLDeviceInfo.shared.deviceType == .pad ? 40:20)
                    
                    Spacer()
                    
                    HStack {
                        Image(.timerIconSL)
                            .resizable()
                            .scaledToFit()
                            .frame(height: SLDeviceInfo.shared.deviceType == .pad ? 120:80)
                        
                        ZStack {
                            Image(.timerBgSL)
                                .resizable()
                                .scaledToFit()
                                .frame(height: SLDeviceInfo.shared.deviceType == .pad ? 160:80)
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
                    }.frame(width: SLDeviceInfo.shared.deviceType == .pad ? 540:270, height: SLDeviceInfo.shared.deviceType == .pad ? 540:270)
                    
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
                    
                }.frame(width: SLDeviceInfo.shared.deviceType == .pad ? 660:330, height: SLDeviceInfo.shared.deviceType == .pad ? 660:330)
                    .overlay {
                        Rectangle()
                            .stroke(Color.appPurple, lineWidth: SLDeviceInfo.shared.deviceType == .pad ? 24:12)
                    }
                
                VStack {
                    Image(.attackersIconSL)
                        .resizable()
                        .scaledToFit()
                        .frame(width: SLDeviceInfo.shared.deviceType == .pad ? 240:120, height: SLDeviceInfo.shared.deviceType == .pad ? 240:120)
                    Image(viewModel.currentPlayer == .attacker ? .yourTurnText: .waitText)
                        .resizable()
                        .scaledToFit()
                        .frame(width: SLDeviceInfo.shared.deviceType == .pad ? 240:120, height: SLDeviceInfo.shared.deviceType == .pad ? 40:20)
                    Spacer()
                    Button{
                        viewModel.gameOver = true
                        viewModel.gameResult = "Surrendered. \(viewModel.currentPlayer == .attacker ? "Defenders" : "Attackers") win."
                    } label: {
                       
                        Image(.surrenderIconSL)
                            .resizable()
                            .scaledToFit()
                            .frame(width: SLDeviceInfo.shared.deviceType == .pad ? 200:100)
                    }
                    
                    
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        
                        Image(.restartGameIconSL)
                            .resizable()
                            .scaledToFit()
                            .frame(width: SLDeviceInfo.shared.deviceType == .pad ? 200:100)
                    }
                    
                }
            }
                
        }
            
            if viewModel.gameOver {
                
                ZStack {
                    Image(.gameOverBg)
                        .resizable()
                        .ignoresSafeArea()
                        .scaledToFill()
                        .scaleEffect(x: viewModel.isDefenderWin ? 1 : -1, y: 1)
                    
                    HStack {
                        Spacer()
                        VStack {
                            if !viewModel.isDefenderWin {
                                Image(.loseIconSL)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: SLDeviceInfo.shared.deviceType == .pad ? 400:250)
                                Image(.tryAgainIconSL)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: SLDeviceInfo.shared.deviceType == .pad ? 400:250)
                            } else {
                                Image(.winIconSL)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: SLDeviceInfo.shared.deviceType == .pad ? 400:250)
                                Image(.bonusIconSL)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: SLDeviceInfo.shared.deviceType == .pad ? 400:250)
                            }
                        }
                        //Spacer()
                        VStack {
                            Spacer()
                            Button {
                                viewModel.resetGame()
                            } label: {
                                Image(.restartIconSL)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: SLDeviceInfo.shared.deviceType == .pad ? 200:100)
                            }
                            
                            Button {
                                presentationMode.wrappedValue.dismiss()
                            } label: {
                                Image(.menuIconSL)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: SLDeviceInfo.shared.deviceType == .pad ? 200:100)
                            }
                        }
                        //Spacer()
                        VStack {
                            if viewModel.isDefenderWin {
                                Image(.loseIconSL)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: SLDeviceInfo.shared.deviceType == .pad ? 400:250)
                                Image(.tryAgainIconSL)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: SLDeviceInfo.shared.deviceType == .pad ? 400:250)
                            } else {
                                Image(.winIconSL)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: SLDeviceInfo.shared.deviceType == .pad ? 400:250)
                                Image(.bonusIconSL)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: SLDeviceInfo.shared.deviceType == .pad ? 400:250)
                            }
                        }
                        Spacer()
                    }
                    
                }
            }
        }.background(
            ZStack {
                if let bgImage = shopVM.currentTeamItem {
                    Image("\(bgImage.image)")
                        .resizable()
                        .edgesIgnoringSafeArea(.all)
                        .scaledToFill()
                }
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
    TwoPlayersView(shopVM: ShopViewModelSL())
}
