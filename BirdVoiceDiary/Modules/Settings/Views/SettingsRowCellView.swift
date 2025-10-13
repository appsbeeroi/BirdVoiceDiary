import SwiftUI

struct SettingsRowCellView: View {
    
    let type: SettinsRowType
    
    @Binding var isEnable: Bool
    
    let action: () -> Void
    
    @State private var isCleared = false
    
    var body: some View {
        Button {
            guard type != .notifications else { return }
            action()
            
            if type == .dataCleaning {
                isCleared = true
            }
        } label: {
            HStack {
                Text(type.title)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.belgrano(with: 24))
                    .foregroundStyle(.black)
                
                if type == .notifications {
                    Toggle(isOn: $isEnable) {}
                        .labelsHidden()
                        .tint(.bvdOrange)
                }
                
                if type == .dataCleaning && isCleared {
                    Text("Clear")
                        .font(.belgrano(with: 24))
                        .foregroundStyle(.red)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                isCleared = false
                            }
                        }
                }
                
                if type == .about || type == .privacy {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .regular))
                }
            }
            .frame(height: 67)
            .padding(.horizontal, 16)
            .background(.white)
            .cornerRadius(22)
            .animation(.default, value: isCleared)
        }
    }
}
