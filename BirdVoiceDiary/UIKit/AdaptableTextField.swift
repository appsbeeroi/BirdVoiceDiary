import SwiftUI

struct AdaptableTextField: View {
    
    let title: String
    let focusType: AddRecordFocuseState
    
    @Binding var text: String
    
    @FocusState.Binding var focusState: AddRecordFocuseState?
    
    var body: some View {
        VStack(spacing: 16) {
            Text(title)
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.belgrano(with: 15))
                .foregroundStyle(.bvdGray)
            
            ZStack {
                TextField("", text: $text)
                    .frame(maxWidth: .infinity)
                    .opacity(0.01)
                    .focused($focusState, equals: focusType)
                
                HStack {
                    Text(text == "" ? "Enter text..." : text)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.belgrano(with: 20))
                        .foregroundStyle(.black.opacity(text == "" ? 0.5 : 1))
                        .onTapGesture {
                            focusState = focusType
                        }
                    
                    if text != "" {
                        Button {
                            text = ""
                            focusState = nil
                        } label: {
                            Image(systemName: "multiply.circle.fill")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundStyle(.bvdGray.opacity(0.3))
                                .frame(maxHeight: .infinity, alignment: .top)
                        }
                    }
                }
            }
        }
        .padding(.vertical, 20)
        .padding(.horizontal, 16)
        .background(.white)
        .cornerRadius(20)
    }
}
