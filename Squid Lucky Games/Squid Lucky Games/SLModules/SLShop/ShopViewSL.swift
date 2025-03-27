//
//  ShopViewSL.swift
//  Squid Lucky Games
//
//  Created by Dias Atudinov on 25.03.2025.
//

import SwiftUI

struct ShopViewSL: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var user = SLUser.shared
    @ObservedObject var viewModel: ShopViewModelSL

    let columns = Array(repeating: GridItem(.flexible(), spacing: SLDeviceInfo.shared.deviceType == .pad ? 20:10), count: 3)
    
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
                    
                    MoneyViewSL()
                    
                }
                Spacer()
                LazyVGrid(columns: columns, spacing: SLDeviceInfo.shared.deviceType == .pad ? 40:20) {
                    ForEach(viewModel.shopTeamItems, id: \.self) { item in
                        Button {
                            if viewModel.boughtItems.contains(where: {$0.name == item.name}) {
                                withAnimation {
                                    viewModel.currentTeamItem = item
                                }
                            } else {
                                if user.money >= 3000 {
                                    user.minusUserBirds(for: 3000)
                                    viewModel.boughtItems.append(item)
                                }
                            }
                        } label: {
                            
                        ZStack {
                            if viewModel.boughtItems.contains(where:{
                                $0.name == item.name }) {
                                Image("\(item.icon)")
                                    .resizable()
                                    .scaledToFit()
                                
                            } else {
                                Image("\(item.icon)Off")
                                    .resizable()
                                    .scaledToFit()
                                
                            }
                            
                            if let currentItem = viewModel.currentTeamItem, currentItem.name == item.name {
                                VStack {
                                    Spacer()
                                    HStack {
                                        Spacer()
                                        Image(.tickIconSL)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(height: SLDeviceInfo.shared.deviceType == .pad ? 100:50)
                                            .offset(x: SLDeviceInfo.shared.deviceType == .pad ? 10:5, y: SLDeviceInfo.shared.deviceType == .pad ? 10:5)
                                    }
                                }
                            }
                            
                            if !viewModel.boughtItems.contains(where:{
                                $0.name == item.name }) {
                                ZStack {
                                    Image(user.money >= 3000 ? .buttonIconSL : .buttonOffIconSL)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: SLDeviceInfo.shared.deviceType == .pad ? 100:50)
                                    Text("3000")
                                        .font(.system(size: SLDeviceInfo.shared.deviceType == .pad ? 40:20, weight: .medium))
                                        .foregroundStyle(.white)
                                        .textCase(.uppercase)
                                }
                                
                            }
                            
                        }.frame(width: SLDeviceInfo.shared.deviceType == .pad ? 400:200, height: SLDeviceInfo.shared.deviceType == .pad ? 230:115)
                    }
                    }
                }
                .padding()
                Spacer()
            }.padding()
            
        }.background(
            Image(.loadingViewBgSL)
                .resizable()
                .ignoresSafeArea()
                .scaledToFill()
        )
    }
}

#Preview {
    ShopViewSL(viewModel: ShopViewModelSL())
}
