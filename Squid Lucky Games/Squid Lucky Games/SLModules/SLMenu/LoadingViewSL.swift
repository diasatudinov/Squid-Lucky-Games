//
//  LoadingViewSL.swift
//  Squid Lucky Games
//
//  Created by Dias Atudinov on 24.03.2025.
//

import SwiftUI

struct LoadingViewSL: View {
    @State private var progress: Double = 0.0
    @State private var timer: Timer?
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                
                VStack {
                    Spacer()
                    ZStack {
                        VStack(spacing: 10) {
                            
                            Image(.logoIconSL)
                                .resizable()
                                .scaledToFit()
                                .frame(height: SLDeviceInfo.shared.deviceType == .pad ? 400:200)
                            
                            Image(.loadingText)
                                .resizable()
                                .scaledToFit()
                                .frame(height: SLDeviceInfo.shared.deviceType == .pad ? 40:20)
                            HStack {
                                Spacer()
                                ZStack {
                                    Image(.loaderBg)
                                        .resizable()
                                        .scaledToFit()
                                    
                                    Image(.loaderFront)
                                        .resizable()
                                        .scaledToFit()
                                        .mask(alignment: .leading) {
                                            Rectangle()
                                                .frame(width: (geometry.size.width * progress))
                                                .animation(.easeInOut, value: progress)
                                        }
                                        .frame(height: SLDeviceInfo.shared.deviceType == .pad ? 39.6:19.8)
                                    
                                }.frame(height: SLDeviceInfo.shared.deviceType == .pad ? 67:33.5)
                                Spacer()
                            }
                        }
                    }
                    .foregroundColor(.black)
                    Spacer()
                }
            }.background(
                Image(.loadingViewBgSL)
                    .resizable()
                    .ignoresSafeArea()
                    .scaledToFill()
            )
            .onAppear {
                startTimer()
            }
        }
    }
    
    func startTimer() {
        timer?.invalidate()
        progress = 0
        timer = Timer.scheduledTimer(withTimeInterval: 0.07, repeats: true) { timer in
            if progress < 1 {
                progress += SLDeviceInfo.shared.deviceType == .pad ? 0.005:0.003
            } else {
                timer.invalidate()
            }
        }
    }
}


#Preview {
    LoadingViewSL()
}
