import SwiftUI

struct ObservationView: View {
    
    @StateObject private var viewModel = ObservationsViewModel()
    
    @Binding var isShowTabBar: Bool
    
    @State private var isShowFilterView = false
    
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
            .navigationDestination(for: ObservationScreen.self) { screen in
                switch screen {
                    case .addRecord(let observation):
                        AddRecordView(observation: observation) { newObservation in
                            viewModel.save(newObservation)
                        }
                    case .detail(let observation):
                        ObservationDetailView(viewModel: viewModel, observation: observation)
                }
            }
            .onAppear {
                viewModel.loadObservations()
                isShowTabBar = true
            }
            .sheet(isPresented: $isShowFilterView) {
                FilterView(filter: viewModel.observationFilter) { updatedFilter in
                    viewModel.observationFilter = updatedFilter
                    isShowFilterView = false 
                }
                .presentationDetents([UIScreen.isSE ? .large : .medium])
                .presentationDragIndicator(.visible)
            }
        }
    }
    
    private var navigation: some View {
        HStack {
            Text("Your observations")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.belgrano(with: 30))
                .foregroundStyle(.black)
            
            Button {
                isShowFilterView.toggle()
            } label: {
                Image(systemName: "line.3.horizontal.decrease")
                    .frame(width: 60, height: 60)
                    .font(.system(size: 22, weight: .medium))
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
    
    private var stumb: some View {
        VStack(spacing: 24) {
            Image(.Images.Wood.birds)
                .resizable()
                .scaledToFit()
                .frame(width: 210, height: 210)
            
            VStack {
                Text("You have no observations yet")
                    .font(.belgrano(with: 20))
                    .foregroundStyle(.black)
                    .lineLimit(1)
                
                Text("Add the first bird to start collecting!")
                    .font(.belgrano(with: 15))
                    .foregroundStyle(.black.opacity(0.5))
            }
            
            recordButton
                .padding(.horizontal, 25)
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
                
                recordButton
            }
            .padding(.horizontal, 20)
            .animation(.smooth, value: viewModel.observationFilter)
        }
        .padding(.bottom, 100)
    }
    
    private var recordButton: some View {
        Button {
            isShowTabBar = false 
            viewModel.navigationPath.append(.addRecord(Observation(isMock: false)))
        } label: {
            Text("Record of observations")
                .frame(height: 65)
                .frame(maxWidth: .infinity)
                .font(.belgrano(with: 20))
                .foregroundStyle(.white)
                .background(.bvdOrange)
                .cornerRadius(24)
        }
    }
}

#Preview {
    ObservationView(isShowTabBar: .constant(false))
}

