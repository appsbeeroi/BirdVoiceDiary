import SwiftUI

struct FavoritesView: View {
    
    @StateObject private var viewModel = FavoritesViewModel()
    
    @Binding var isShowTabBar: Bool
    
    @FocusState var isFocused: Bool
    
    var body: some View {
        NavigationStack(path: $viewModel.navigationPath) {
            ZStack {
                Image(.Images.baseBG)
                    .resizeAndFill()
                
                VStack(spacing: 16) {
                    navigation
                    
                    if !viewModel.observationsBase.isEmpty {
                        searchField
                    }
                    
                    if viewModel.observations.isEmpty {
                        stumb
                    } else {
                        observations
                    }
                }
                .frame(maxHeight: .infinity, alignment: .top)
                .animation(.smooth, value: viewModel.observations)
            }
            .navigationDestination(for: FavoritesScreen.self) { screen in
                switch screen {
                    case .detail(let observation):
                        FavoritesDetailView(viewModel: viewModel, observation: observation)
                }
            }
            .onAppear {
                isShowTabBar = true
                viewModel.loadObservations()
            }
        }
    }
    
    private var navigation: some View {
        Text("Favorites")
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 16)
            .padding(.horizontal, 20)
            .font(.belgrano(with: 30))
            .foregroundStyle(.black)
    }
    
    private var stumb: some View {
        VStack(spacing: 24) {
            Image(.Images.Wood.heart)
                .resizable()
                .scaledToFit()
                .frame(width: 210, height: 210)
            
            VStack(spacing: 8) {
                Text("You don’t have any\nfavorites yet")
                    .font(.belgrano(with: 20))
                    .foregroundStyle(.black)
                
                Text("Mark special observations to keep\nthem close at hand")
                    .font(.belgrano(with: 15))
                    .foregroundStyle(.black.opacity(0.5))
            }
            .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(.white)
        .cornerRadius(25)
        .frame(maxHeight: .infinity)
        .padding(.horizontal, 20)
        .padding(.bottom, 100)
    }
    
    private var searchField: some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 17, weight: .medium))
                .foregroundStyle(.black.opacity(0.5))
            
            TextField("", text: $viewModel.searchedText, prompt: Text("Search")
                .foregroundColor(.black.opacity(0.5))
            )
            .frame(maxWidth: .infinity)
            .font(.belgrano(with: 20))
            .foregroundStyle(.black)
            .focused($isFocused)
            
            if viewModel.searchedText != "" {
                Button {
                    viewModel.searchedText = ""
                    isFocused = false
                } label: {
                    Image(systemName: "multiply.circle.fill")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(.gray.opacity(0.3))
                }
            }
        }
        .frame(height: 70)
        .padding(.horizontal, 10)
        .background(.white)
        .cornerRadius(20)
        .padding(.horizontal, 20)
    }
    
    private var observations: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 24) {
                LazyVStack(spacing: 8) {
                    ForEach(viewModel.observations) { observation in
                        ObservationCellView(observation: observation) {
                            isShowTabBar = false
                            viewModel.navigationPath.append(.detail(observation))
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
        }
        .padding(.bottom, 100)
    }
}

#Preview {
    FavoritesView(isShowTabBar: .constant(false))
}

