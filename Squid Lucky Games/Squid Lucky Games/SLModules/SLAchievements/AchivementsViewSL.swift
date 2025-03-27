import SwiftUI

struct AchivementsViewSL: View {
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var viewModel: AchievementsViewModel
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                
                VStack {
                    ZStack(alignment: .top) {
                        HStack {
                            Spacer()
                            Image(.achievementsLogoSL)
                                .resizable()
                                .scaledToFit()
                                .frame(height: SLDeviceInfo.shared.deviceType == .pad ? 300:150)
                            
                            Spacer()
                            
                            
                        }
                        
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
                    }
                    AchivementsScrollViewSL(viewModel: viewModel)
                }.padding()
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
}

#Preview {
    AchivementsViewSL(viewModel: AchievementsViewModel())
}


struct AchivementsScrollViewSL: View {
    @State private var scrollOffset: CGFloat = 0
    
    var totalContentHeight: CGFloat { SLDeviceInfo.shared.deviceType == .pad ? 500:250
    }
    
    let columns = Array(repeating: GridItem(.flexible(), spacing: 0), count: 5)
    
    @ObservedObject var viewModel: AchievementsViewModel
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .topTrailing) {
                ScrollView(showsIndicators: false) {
                    // Wrap the offset reader and the grid in a VStack.
                    VStack(spacing: 0) {
                        // Zero-height view to capture the scroll offset.
                        GeometryReader { geo in
                            Color.clear
                                .preference(key: ScrollOffsetPreferenceKey.self,
                                            value: geo.frame(in: .named("scroll")).minY)
                        }
                        .frame(height: 0)
                        
                        // The grid itself.
                        LazyVGrid(columns: columns, spacing: SLDeviceInfo.shared.deviceType == .pad ? 40:20) {
                            ForEach(1...20, id: \.self) { index in
                                achivementCell(
                                    achievement: index,
                                    isAchived: viewModel.getAchievement(for: index)
                                )
                                .onTapGesture {
                                    viewModel.achievement1Done(for: index)
                                }
                            }
                        }
                        .padding(.horizontal)
                        
                    }
                }
                .coordinateSpace(name: "scroll")
                // Update the scroll offset whenever it changes.
                .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
                    scrollOffset = value
                }

                CustomScrollIndicator(
                    scrollOffset: scrollOffset,
                    totalContentHeight: totalContentHeight,
                    visibleHeight: geometry.size.height
                )
                .padding(.trailing, 4)
            }
        }
    }
    
    @ViewBuilder
    func achivementCell(achievement: Int, isAchived: Bool) -> some View {
        Image("achivement\(achievement)")
            .resizable()
            .scaledToFit()
            .frame(width: SLDeviceInfo.shared.deviceType == .pad ? 170:85, height: SLDeviceInfo.shared.deviceType == .pad ? 170:85)
            .opacity(isAchived ? 0.5 : 1)
    }
    
}

struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
// Custom scroll indicator view.
struct CustomScrollIndicator: View {
    let scrollOffset: CGFloat
    let totalContentHeight: CGFloat
    let visibleHeight: CGFloat

    var body: some View {
        // Calculate the indicator's height based on visible content vs total content.
        let indicatorHeight = max((visibleHeight / totalContentHeight) * visibleHeight, 30)
        let maxIndicatorOffset = visibleHeight - indicatorHeight
        // Compute scroll progress (clamped between 0 and 1).
        let progress = min(max(-scrollOffset / (totalContentHeight - visibleHeight), 0), 1)
        let indicatorOffset = progress * maxIndicatorOffset
        
        return ZStack {
            Image(.indicatorBgSL)
                .resizable()
                .scaledToFit()

            Image(.indicatorSL)
                .resizable()
                .scaledToFit()
                .frame(width: SLDeviceInfo.shared.deviceType == .pad ? 92:46, height: SLDeviceInfo.shared.deviceType == .pad ? 72:36)
                .offset(y: indicatorOffset)
        }
    }
}






