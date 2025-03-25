//
//  MoneyViewSL.swift
//  Squid Lucky Games
//
//  Created by Dias Atudinov on 25.03.2025.
//

import SwiftUI

struct MoneyViewSL: View {
    @StateObject var user = SLUser.shared
    var body: some View {
        ZStack {
            Image(.moneyBgSL)
                .resizable()
                .scaledToFit()
                
            
            Text("\(user.money)")
                .font(.system(size: SLDeviceInfo.shared.deviceType == .pad ? 40:20, weight: .black))
                .foregroundStyle(.white)
                .textCase(.uppercase)
                .offset(x: SLDeviceInfo.shared.deviceType == .pad ? -40:-20, y: SLDeviceInfo.shared.deviceType == .pad ? 4:2)
        }.frame(height: SLDeviceInfo.shared.deviceType == .pad ? 140:70)
    }
}

#Preview {
    MoneyViewSL()
}
