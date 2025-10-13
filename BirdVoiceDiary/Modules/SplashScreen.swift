import SwiftUI

struct SplashScreen: View {
    
    @Binding var isShowMain: Bool
    
    @State private var isAnimating = false
    
    var body: some View {
        ZStack {
            Image(.Images.baseBG)
                .resizeAndFill()
            
            VStack(spacing: 24) {
                Image(.Images.Wood.birds)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 280, height: 280)
                
                Text("BirdVoice\nDiary")
                    .font(.belgrano(with: 58))
                    .foregroundStyle(.black)
                    .multilineTextAlignment(.center)
                    .opacity(isAnimating ? 1 : 0)
            }
            .animation(.smooth(duration: 1), value: isAnimating)
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                isAnimating = true
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    isShowMain.toggle()
                }
            }
        }
    }
}

#Preview {
    SplashScreen(isShowMain: .constant(false))
}
