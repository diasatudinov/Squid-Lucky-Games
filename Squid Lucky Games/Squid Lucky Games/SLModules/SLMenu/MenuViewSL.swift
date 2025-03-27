import SwiftUI

struct MenuViewSL: View {
    @State private var showGame = false
    @State private var showShop = false
    @State private var showAchivement = false
    @State private var showSettings = false
    
    @StateObject var shopVM = ShopViewModelSL()
    @StateObject var settingsVM = SettingsViewModelSL()
    @StateObject var achievementVM = AchievementsViewModel()
    var body: some View {
        
        GeometryReader { geometry in
            ZStack {
                VStack(spacing: 0) {
                    HStack {
                        
                        Image(.experienceBgSL)
                            .resizable()
                            .scaledToFit()
                            .frame(height: SLDeviceInfo.shared.deviceType == .pad ? 180:90)
                        
                        Spacer()
                        
                        Button {
                            showSettings = true
                        } label: {
                            Image(.settingsIconSL)
                                .resizable()
                                .scaledToFit()
                                .frame(height: SLDeviceInfo.shared.deviceType == .pad ? 160:80)
                        }
                        
                    }
                    Spacer()
                    
                    HStack {
                        Button {
                            showGame = true
                        } label: {
                            Image(.playIconSL)
                                .resizable()
                                .scaledToFit()
                                .frame(height: SLDeviceInfo.shared.deviceType == .pad ? 200:100)
                        }
                        
                    }
                    
                    Spacer()
                    HStack {
                        Button {
                            showAchivement = true
                        } label: {
                            Image(.achivmentIconSL)
                                .resizable()
                                .scaledToFit()
                                .frame(height: SLDeviceInfo.shared.deviceType == .pad ? 140:70)
                        }
                        
                        Spacer()
                        Button {
                            showShop = true
                        } label: {
                            Image(.shopIconSL)
                                .resizable()
                                .scaledToFit()
                                .frame(height: SLDeviceInfo.shared.deviceType == .pad ? 180:90)
                        }
                        
                    }
                }.padding()
            }
            .background(
                ZStack {
                    Image(.menuViewBgSL)
                        .resizable()
                        .edgesIgnoringSafeArea(.all)
                        .scaledToFill()
                }
                
            )
            .onAppear {
                if settingsVM.musicEnabled {
                    MusicManagerSL.shared.playBackgroundMusic()
                }
            }
            .onChange(of: settingsVM.musicEnabled) { enabled in
                if enabled {
                    MusicManagerSL.shared.playBackgroundMusic()
                } else {
                    MusicManagerSL.shared.stopBackgroundMusic()
                }
            }
            .fullScreenCover(isPresented: $showGame) {
                GameTypeView(shopVM: shopVM)
            }
            .fullScreenCover(isPresented: $showShop) {
                ShopViewSL(viewModel: shopVM)
            }
            .fullScreenCover(isPresented: $showAchivement) {
                AchivementsViewSL(viewModel: achievementVM)
            }
            .fullScreenCover(isPresented: $showSettings) {
                SettingsViewSL(settings: settingsVM)
            }
            
        }
        
        
    }
    
}


#Preview {
    MenuViewSL()
}
