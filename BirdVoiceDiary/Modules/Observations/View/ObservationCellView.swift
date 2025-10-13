import SwiftUI

struct ObservationCellView: View {
    
    let observation: Observation
    let action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            HStack {
                VStack(spacing: 10) {
                    ZStack {
                        ForEach(Array(observation.images.prefix(3).enumerated()), id: \.offset) { index, image in
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 87, height: 87)
                                .clipped()
                                .cornerRadius(100)
                                .offset(x: CGFloat(index * 50))
                                .zIndex(CGFloat(index * -1))
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text(observation.species)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.belgrano(with: 20))
                        .foregroundStyle(.black)
                }
                
                Circle()
                    .frame(width: 54, height: 54)
                    .foregroundStyle(.bvdOrange)
                    .overlay {
                        Image(systemName: "arrow.up.forward")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundStyle(.white)
                    }
                    .frame(maxHeight: .infinity, alignment: .top)
            }
            .padding(16)
            .background(.white)
            .cornerRadius(28)
        }
    }
}

#Preview {
    ObservationCellView(observation: Observation(isMock: true)) {}
}
