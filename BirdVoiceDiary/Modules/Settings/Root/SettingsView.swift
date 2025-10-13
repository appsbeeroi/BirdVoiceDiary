import SwiftUI

struct SettingsView: View {
    
    @AppStorage("isNotificationSetup") var isNotificationSetup = false
    
    @Binding var isShowTabBar: Bool
    
    @State var selectedRow: SettinsRowType?
    
    @State private var isNotificationEnable = false
    @State private var isShowNotificationAlert = false
    
    var body: some View {
        ZStack {
            Image(.Images.baseBG)
                .resizeAndFill()
            
            VStack(spacing: 16) {
                navigation
                image
                cells
            }
            .frame(maxHeight: .infinity, alignment: .top)
            .padding(.horizontal, 20)
            
            if let selectedRow,
               let url = URL(string: selectedRow.documentURLString) {
                WebView(url: url) {
                    self.selectedRow = nil
                    self.isShowTabBar = true
                }
                .ignoresSafeArea(edges: [.bottom])
            }
        }
        .onChange(of: isNotificationEnable) { isEnable in
            if isEnable {
                Task {
                    switch await PushManager.shared.status {
                        case .authorized:
                            isNotificationSetup = isEnable
                        case .denied:
                            isShowNotificationAlert = true
                        case .notDetermined:
                            await PushManager.shared.requestAccess()
                    }
                }
            } else {
                isNotificationSetup = false
            }
        }
        .alert("Notification permission wasn't allowed", isPresented: $isShowNotificationAlert) {
            Button("Yes") {
                openSettings()
            }
            
            Button("No") {
                isNotificationEnable = false
            }
        } message: {
            Text("Open app settings?")
        }
    }
    
    private var navigation: some View {
        Text("Settings")
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 16)
            .padding(.horizontal, 20)
            .font(.belgrano(with: 30))
            .foregroundStyle(.black)
    }
    
    private var image: some View {
        Image(.Images.Wood.gear)
            .resizable()
            .scaledToFit()
            .frame(width: UIScreen.isSE ? 100 : 160, height: UIScreen.isSE ? 100 : 180)
            .clipped()
    }
    
    private var cells: some View {
        ForEach(SettinsRowType.allCases) { type in
            SettingsRowCellView(type: type, isEnable: $isNotificationEnable) {
                switch type {
                    case .privacy, .about:
                        isShowTabBar = false
                        selectedRow = type
                    case .dataCleaning:
                        UDManager.shared.remove(.observation)
                    default:
                        return 
                }
            }
        }
    }
    
    private func openSettings() {
           guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
           if UIApplication.shared.canOpenURL(settingsURL) {
               UIApplication.shared.open(settingsURL)
           }
       }
}

#Preview {
    SettingsView(isShowTabBar: .constant(false))
}

