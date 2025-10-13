import SwiftUI

struct AddRecordView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State var observation: Observation
    
    let saveAction: (Observation) -> Void
    
    @State private var selectedImage: UIImage?
    @State private var selectedImageIndex: Int?
    @State private var isShowImagePicker = false
    @State private var isSHowSaveView = false
    
    @FocusState var focusState: AddRecordFocuseState?
    
    var body: some View {
        ZStack {
            Image(.Images.baseBG)
                .resizeAndFill()
            
            VStack(spacing: 16) {
                navigation
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 16) {
                        datePicker
                        timePicker
                        imageSelector
                        species
                        behavior
                        habits
                        doneButton
                    }
                    .padding(.horizontal, 20)
                }
                .disabled(isSHowSaveView)
            }
            .frame(maxHeight: .infinity, alignment: .top)
            
            if isSHowSaveView {
                saveView
            }
        }
        .navigationBarBackButtonHidden()
        .animation(.smooth, value: isSHowSaveView)
        .sheet(isPresented: $isShowImagePicker) {
            ImagePicker(selectedImage: $selectedImage)
        }
        .onChange(of: selectedImage ?? UIImage()) { image in
            if let selectedImageIndex,
               observation.images.count - 1 >= selectedImageIndex {
                observation.images[selectedImageIndex] = image
            } else {
                observation.images.append(image)
            }
        }
    }
    
    private var navigation: some View {
        HStack {
            Button {
                dismiss()
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
            
            Text("Record of observations")
                .frame(maxWidth: .infinity, alignment: .trailing)
                .font(.belgrano(with: 25))
                .foregroundStyle(.black)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
        }
        .padding(.top, 16)
        .padding(.horizontal, 20)
    }
    
    private var datePicker: some View {
        DatePicker("", selection: $observation.date, displayedComponents: [.date])
            .labelsHidden()
            .datePickerStyle(.wheel)
            .padding()
            .background(.white)
            .cornerRadius(28)
    }
    
    private var timePicker: some View {
        DatePicker("", selection: $observation.date, displayedComponents: [.hourAndMinute])
            .labelsHidden()
            .datePickerStyle(.wheel)
            .padding()
            .background(.white)
            .cornerRadius(28)
    }
    
    private var imageSelector: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 10) {
                if observation.images.isEmpty {
                    Button {
                        selectedImageIndex = nil
                        isShowImagePicker.toggle()
                    } label: {
                        RoundedRectangle(cornerRadius: 38)
                            .frame(width: 130, height: 130)
                            .foregroundStyle(.white)
                            .cornerRadius(38)
                            .overlay {
                                Image(systemName: "photo")
                                    .font(.system(size: 40, weight: .medium))
                                    .foregroundStyle(.bvdGray.opacity(0.3))
                            }
                    }
                }
                
                ForEach(Array(observation.images.enumerated()), id: \.offset) { index, image in
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 130, height: 130)
                        .clipped()
                        .cornerRadius(38)
                }
                
                Button {
                    selectedImageIndex = nil
                    isShowImagePicker.toggle()
                } label: {
                    Circle()
                        .frame(width: 46, height: 46)
                        .foregroundStyle(.bvdOrange)
                        .overlay {
                            Image(systemName: "plus")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundStyle(.white)
                        }
                }
            }
        }
    }
    
    private var species: some View {
        AdaptableTextField(
            title: "Species name",
            focusType: .species,
            text: $observation.species,
            focusState: $focusState
        )
    }
    
    private var behavior: some View {
        AdaptableTextField(
            title: "Behavior",
            focusType: .behavior,
            text: $observation.behavior,
            focusState: $focusState
        )
    }
    
    private var habits: some View {
        AdaptableTextField(
            title: "Habits",
            focusType: .habits,
            text: $observation.habits,
            focusState: $focusState
        )
    }
    
    private var doneButton: some View {
        Button {
            isSHowSaveView.toggle()
        } label: {
            Text("Done")
                .frame(height: 65)
                .frame(maxWidth: .infinity)
                .font(.belgrano(with: 20))
                .foregroundStyle(.white)
                .background(.bvdOrange.opacity(observation.isLock ? 0.5: 1))
                .cornerRadius(24)
        }
        .disabled(observation.isLock)
    }
    
    private var saveView: some View {
        ZStack {
            Color.black.opacity(0.3)
                .ignoresSafeArea()
            
            VStack {
                Button {
                    saveAction(observation)
                } label: {
                    Image(systemName: "multiply.circle.fill")
                        .font(.system(size: 24, weight: .medium))
                        .foregroundStyle(.bvdGray.opacity(0.3))
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.trailing)
                
                Image(.Images.Wood.checkmark)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 220, height: 200)
                
                Text("Observation\nadded!")
                    .font(.belgrano(with: 32))
                    .foregroundStyle(.black)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 30)
            .background(.white)
            .cornerRadius(25)
            .padding(.horizontal, 20)
        }
    }
}

#Preview {
    AddRecordView(observation: Observation(isMock: true)) { _ in }
}

#Preview {
    AddRecordView(observation: Observation(isMock: false)) { _ in }
}
