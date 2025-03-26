//
//  GameTypeView.swift
//  Squid Lucky Games
//
//  Created by Dias Atudinov on 26.03.2025.
//

import SwiftUI

struct GameTypeView: View {
    @Environment(\.presentationMode) var presentationMode
    
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
                
                HStack(spacing: 20) {
                    Image(.guardIcon)
                        .resizable()
                        .scaledToFit()
                        .scaleEffect(x: -1, y: 1)
                    
                    VStack {
                        Button {
                            
                        } label: {
                            Image(.aiIconSL)
                                .resizable()
                                .scaledToFit()
                        }
                        
                        Button {
                            
                        } label: {
                            Image(.forTwoIconSL)
                                .resizable()
                                .scaledToFit()
                        }
                        
                        Button {
                            
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
    }
}

#Preview {
    GameTypeView()
}
