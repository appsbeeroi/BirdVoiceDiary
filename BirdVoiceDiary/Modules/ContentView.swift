import SwiftUI

struct ContentView: View {
    
    @State var isShowMain = false
    
    var body: some View {
        if isShowMain {
            TabBarView()
        } else {
            SplashScreen(isShowMain: $isShowMain)
        }
    }
}

#Preview {
    ContentView()
}
