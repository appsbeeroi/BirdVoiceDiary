import SwiftUI

struct ObservationDetailView: View {
    
    @ObservedObject var viewModel: ObservationsViewModel
    
    @State var observation: Observation
    
    @State private var currentImageIndex = 0
    @State private var isLoading = false
    
    var body: some View {
        ZStack {
            Image(.Images.baseBG)
                .resizeAndFill()
            
            ScrollView(showsIndicators: false) {
                VStack {
                    images
                    species
                    info
                    actionButtons
                }
                .frame(maxHeight: .infinity, alignment: .top)
            }
            .ignoresSafeArea()

            
            VStack(spacing: 16) {
                navigation
            }
            .frame(maxHeight: .infinity, alignment: .top)
            
            
            if isLoading {
                RoundedRectangle(cornerRadius: 20)
                    .frame(width: 60, height: 60)
                    .foregroundStyle(.white)
                    .overlay {
                        ProgressView()
                    }
            }
        }
        .navigationBarBackButtonHidden()
    }
    
    private var images: some View {
        TabView(selection: $currentImageIndex) {
            ForEach(Array(observation.images.enumerated()), id: \.offset) { index, image in
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: UIScreen.main.bounds.width)
                    .clipped()
                    .tag(index)
            }
        }
        .frame(height: 400)
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        .overlay(alignment: .bottom) {
            HStack {
                ForEach(0..<observation.images.count, id: \.self) { index in
                    RoundedRectangle(cornerRadius: 30)
                        .frame(width: index == currentImageIndex ? 70 : 15, height: 15)
                        .padding(.bottom, 16)
                        .foregroundStyle(index == currentImageIndex ? .bvdOrange : .white.opacity(0.5))
                }
            }
        }
    }
    
    private var navigation: some View {
        HStack {
            Button {
                isLoading = true 
                viewModel.save(observation)
            } label: {
                Image(systemName: "arrow.backward")
                    .frame(width: 60, height: 60)
                    .font(.system(size: 24, weight: .light))
                    .foregroundStyle(.bvdOrange)
                    .background(.white)
                    .cornerRadius(60)
                    .overlay {
                        Circle()
                            .stroke(.bvdOrange, lineWidth: 1)
                    }
            }
            
            Spacer()
            
            Button {
                observation.isFavorite.toggle()
            } label: {
                Image(systemName: observation.isFavorite ? "heart.fill" : "heart")
                    .frame(width: 60, height: 60)
                    .font(.system(size: 24, weight: .light))
                    .foregroundStyle(.bvdOrange)
                    .background(.white)
                    .cornerRadius(60)
                    .overlay {
                        Circle()
                            .stroke(.bvdOrange, lineWidth: 1)
                    }
            }

        }
        .padding(.top, 16)
        .padding(.horizontal, 20)
    }
    
    private var species: some View {
        Text(observation.species)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 20)
            .font(.belgrano(with: 25))
    }
    
    private var info: some View {
        VStack(spacing: 16) {
            date
            Divider()
            time
            Divider()
            behavior
            habits
        }
        .padding(.vertical, 20)
        .padding(.horizontal, 16)
        .background(.white)
        .cornerRadius(30)
        .padding(.horizontal, 20)
    }
    
    private var date: some View {
        HStack {
            Text("Date")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.belgrano(with: 14))
                .foregroundStyle(.black.opacity(0.5))
            
            Text(observation.date.formatted(.dateTime.year().month(.twoDigits).day()))
                .font(.belgrano(with: 20))
                .foregroundStyle(.black)
        }
    }
    
    private var time: some View {
        HStack {
            Text("Time")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.belgrano(with: 14))
                .foregroundStyle(.black.opacity(0.5))
            
            Text(observation.date.formatted(.dateTime.hour().minute()))
                .font(.belgrano(with: 20))
                .foregroundStyle(.black)
        }
    }
    
    private var behavior: some View {
        VStack(spacing: 10) {
            Text("Behavior")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.belgrano(with: 15))
                .foregroundStyle(.black.opacity(0.5))
            
            Text(observation.behavior)
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.belgrano(with: 20))
                .foregroundStyle(.black)
                .multilineTextAlignment(.leading)
        }
    }
    
    private var habits: some View {
        VStack(spacing: 10) {
            Text("Habits")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.belgrano(with: 15))
                .foregroundStyle(.black.opacity(0.5))
            
            Text(observation.habits)
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.belgrano(with: 20))
                .foregroundStyle(.black)
                .multilineTextAlignment(.leading)
        }
    }
    
    private var actionButtons: some View {
        HStack(spacing: 0) {
            Button {
                viewModel.navigationPath.append(.addRecord(observation))
            } label: {
                Circle()
                    .frame(width: 60, height: 60)
                    .foregroundStyle(.white)
                    .overlay {
                        ZStack {
                            Circle()
                                .stroke(.blue, lineWidth: 1)
                                
                            Image(systemName: "pencil")
                                .font(.system(size: 20, weight: .medium))
                                .foregroundStyle(.blue)
                        }
                    }
            }
            
            Button {
                viewModel.remove(observation)
            } label: {
                Circle()
                    .frame(width: 60, height: 60)
                    .foregroundStyle(.white)
                    .overlay {
                        ZStack {
                            Circle()
                                .stroke(.red, lineWidth: 1)
                                
                            Image(systemName: "trash")
                                .font(.system(size: 20, weight: .medium))
                                .foregroundStyle(.red)
                        }
                    }
            }
            .offset(x: -10)
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
        .padding(.horizontal, 10)
    }
}

#Preview {
    ObservationDetailView(viewModel: ObservationsViewModel(), observation: Observation(isMock: true))
}
