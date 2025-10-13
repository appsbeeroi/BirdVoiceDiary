import SwiftUI

@main
struct BirdVoiceDiaryApp: App {
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    Task {
                        await PushManager.shared.requestAccess()
                    }
                }
        }
    }
}
