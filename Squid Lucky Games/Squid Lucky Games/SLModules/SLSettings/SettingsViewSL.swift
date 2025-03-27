import SwiftUI

struct SettingsViewSL: View {
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var settings: SettingsViewModelSL
    
    var body: some View {
        ZStack {
            
            VStack {
                ZStack {
                    
                    Image(.settingsBgSL)
                        .resizable()
                        .scaledToFit()
                    
                    
                    VStack {
                        HStack {
                            
                            Image(.soundIconSL)
                                .resizable()
                                .scaledToFit()
                                .frame(height: SLDeviceInfo.shared.deviceType == .pad ? 140:70)
                            VStack {
                                Image(.sound)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: SLDeviceInfo.shared.deviceType == .pad ? 30:15)
                                Button {
                                    settings.soundEnabled.toggle()
                                } label: {
                                    ZStack {
                                        Image(.switcherBgSL)
                                            .resizable()
                                            .scaledToFit()
                                        HStack {
                                            if !settings.soundEnabled {
                                                Image(.switcherIconSL)
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(height: SLDeviceInfo.shared.deviceType == .pad ? 90:45)
                                                    .padding(.leading, 30)
                                                Spacer()
                                            }
                                            
                                            if settings.soundEnabled {
                                                Spacer()
                                                Image(.switcherIconSL)
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(height: SLDeviceInfo.shared.deviceType == .pad ? 90:45)
                                                    .padding(.trailing, 30)
                                                
                                            }
                                        }
                                        
                                    }.frame(width: SLDeviceInfo.shared.deviceType == .pad ? 500: 200)
                                }
                            }
                        }
                        
                        HStack {
                            
                            Image(.musicIconSL)
                                .resizable()
                                .scaledToFit()
                                .frame(height: SLDeviceInfo.shared.deviceType == .pad ? 160:80)
                            VStack {
                                Image(.music)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: SLDeviceInfo.shared.deviceType == .pad ? 30:15)
                                Button {
                                    settings.musicEnabled.toggle()
                                    
                                } label: {
                                    ZStack {
                                        Image(.switcherBgSL)
                                            .resizable()
                                            .scaledToFit()
                                        HStack {
                                            if !settings.musicEnabled {
                                                Image(.switcherIconSL)
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(height: SLDeviceInfo.shared.deviceType == .pad ? 90:45)
                                                    .padding(.leading, 30)
                                                Spacer()
                                            }
                                            
                                            if settings.musicEnabled {
                                                Spacer()
                                                Image(.switcherIconSL)
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(height: SLDeviceInfo.shared.deviceType == .pad ? 90:45)
                                                    .padding(.trailing, 30)
                                                
                                            }
                                        }
                                        
                                    }.frame(width: SLDeviceInfo.shared.deviceType == .pad ? 500: 200)
                                }
                            }
                        }
                        
                        HStack(spacing: SLDeviceInfo.shared.deviceType == .pad ? 40:20) {
                            Image(.languageIconSL)
                                .resizable()
                                .scaledToFit()
                                .frame(height: SLDeviceInfo.shared.deviceType == .pad ? 140:70)
                            
                            Image(.refreshIconSL)
                                .resizable()
                                .scaledToFit()
                                .frame(height: SLDeviceInfo.shared.deviceType == .pad ? 120:60)
                        }
                        
                    }
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            Image(.personIconSL)
                                .resizable()
                                .scaledToFit()
                                .frame(height: SLDeviceInfo.shared.deviceType == .pad ? 400:200)
                                .offset(x: SLDeviceInfo.shared.deviceType == .pad ? 180:90)
                        }
                    }
                }.frame(width: SLDeviceInfo.shared.deviceType == .pad ? 700:350, height: SLDeviceInfo.shared.deviceType == .pad ? 600:300)
            }
            
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
                Spacer()
            }.padding()
            
        }
        .background(
            ZStack {
                Image(.settingsViewBgSL)
                    .resizable()
                    .edgesIgnoringSafeArea(.all)
                    .scaledToFill()
            }
            
        )
        
    }
}


#Preview {
    SettingsViewSL(settings: SettingsViewModelSL())
}
