import SwiftUI

struct FilterView: View {
    
    @State var filter: ObservationFilter
    
    let updateFilter: (ObservationFilter) -> Void
    
    var body: some View {
        ZStack {
            Image(.Images.baseBG)
                .resizeAndFill()
            
            VStack {
                header
                datePicker
                favoritePicker
                
                Spacer()
                
                doneButton
            }
            .frame(maxHeight: .infinity)
            .padding(.top, 16)
            .padding(.horizontal, 20)
            .padding(.bottom, UIScreen.isSE ? 16 : 0)
        }
    }
    
    private var header: some View {
        ZStack {
            HStack {
                Button {
                    filter.isCleared = true
                    filter.date = Date()
                    filter.isFavorite = nil
                } label: {
                    Text("Clear all")
                        .foregroundStyle(filter.isCleared ? .bvdOrange : .black.opacity(0.5))
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Text("Filter")
                .foregroundStyle(.black)
        }
        .font(.system(size: 17, weight: .semibold))
    }
    
    private var datePicker: some View {
        DatePicker("", selection: $filter.date, displayedComponents: [.date])
            .labelsHidden()
            .datePickerStyle(.wheel)
            .padding()
            .background(.white)
            .cornerRadius(28)
    }
    
    private var favoritePicker: some View {
        Picker("", selection: $filter.isFavorite) {
            Text("All")
                .tag(Bool?.none)
            Text("Favorite")
                .tag(true)
            Text("No favorite")
                .tag(false)
        }
        .pickerStyle(.segmented)
    }
    
    private var doneButton: some View {
        Button {
            updateFilter(filter)
        } label: {
            Text("Done")
                .frame(height: 65)
                .frame(maxWidth: .infinity)
                .font(.belgrano(with: 20))
                .background(.bvdOrange)
                .foregroundStyle(.white)
                .cornerRadius(24)
        }
    }
}
