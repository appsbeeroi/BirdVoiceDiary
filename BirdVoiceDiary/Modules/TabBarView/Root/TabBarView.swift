import SwiftUI

struct TabBarView: View {
    
    @State private var selection: TabBarState = .observations
    
    @State private var isShowTabBar = true
    
    init() {
        UITabBar.appearance().isHidden = true
    }
    
    var body: some View {
        ZStack {
            image
            tabView
            tabBar
        }
    }
    
    private var image: some View {
        Image(.Images.baseBG)
            .resizeAndFill()
    }
    
    private var tabView: some View {
        TabView(selection: $selection) {
            ObservationView(isShowTabBar: $isShowTabBar)
                .tag(TabBarState.observations)
            
            FavoritesView(isShowTabBar: $isShowTabBar)
                .tag(TabBarState.favorites)
            
            StatisticsView(isShowTabBar: $isShowTabBar)
                .tag(TabBarState.statistics)
            
            SettingsView(isShowTabBar: $isShowTabBar)
                .tag(TabBarState.settings)
        }
    }
    
    private var tabBar: some View {
        VStack {
            HStack(spacing: 5) {
                ForEach(TabBarState.allCases) { state in
                    Button {
                        selection = state
                    } label: {
                        ZStack {
                            Circle()
                                .frame(width: 84, height: 84)
                                .foregroundStyle(state == selection ? .bvdOrange : .white)
                            Image(state.icon)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 28, height: 28)
                                .foregroundStyle(state == selection ? .white : .bvdGray)
                        }
                    }
                }
            }
            .opacity(isShowTabBar ? 1 : 0)
            .animation(.smooth, value: isShowTabBar)
        }
        .frame(maxHeight: .infinity, alignment: .bottom)
    }
}

#Preview {
    TabBarView()
}

