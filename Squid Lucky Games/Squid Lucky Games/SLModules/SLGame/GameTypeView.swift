//
//  GameTypeView.swift
//  Squid Lucky Games
//
//  Created by Dias Atudinov on 26.03.2025.
//

import SwiftUI

struct GameTypeView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var shopVM: ShopViewModelSL
    
    @State private var showAIView = false
    @State private var show2PlayerView = false
    @State private var showOnlineView = false
    var body: some View {
        ZStack {
            
            VStack(spacing: 0) {
                HStack {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image(.backIconSL)
                            .resizable()
                            .scaledToFit()
                            .frame(height: SLDeviceInfo.shared.deviceType == .pad ? 140:70)
                    }
                    
                    Spacer()
                }
                
                HStack(spacing: SLDeviceInfo.shared.deviceType == .pad ? 40:20) {
                    Image(.guardIcon)
                        .resizable()
                        .scaledToFit()
                        .scaleEffect(x: -1, y: 1)
                    
                    VStack {
                        Button {
                            showAIView = true
                        } label: {
                            Image(.aiIconSL)
                                .resizable()
                                .scaledToFit()
                        }
                        
                        Button {
                            show2PlayerView = true
                        } label: {
                            Image(.forTwoIconSL)
                                .resizable()
                                .scaledToFit()
                        }
                        
                        Button {
                            showOnlineView = true
                        } label: {
                            Image(.onlineIconSL)
                                .resizable()
                                .scaledToFit()
                        }
                    }
                    Image(.guardIcon)
                        .resizable()
                        .scaledToFit()
                   
                }
                
            }.padding()
            
        }.background(
            ZStack {
                Image(.gameTypeBgSL)
                    .resizable()
                    .edgesIgnoringSafeArea(.all)
                    .scaledToFill()
            }
            
        )
        .fullScreenCover(isPresented: $showAIView) {
            AgainstPlayersView(shopVM: shopVM)
        }
        .fullScreenCover(isPresented: $show2PlayerView) {
            TwoPlayersView(shopVM: shopVM)
        }
        .fullScreenCover(isPresented: $showOnlineView) {
            AgainstPlayersView(shopVM: shopVM)
        }
    }
}

#Preview {
    GameTypeView(shopVM: ShopViewModelSL())
}
