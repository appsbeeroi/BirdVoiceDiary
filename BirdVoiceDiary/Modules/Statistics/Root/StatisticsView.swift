import SwiftUI
import Charts

struct StatisticsView: View {
    
    @StateObject private var viewModel = StatisticsViewModel()
    
    @Binding var isShowTabBar: Bool
    
    private var topThreeSpeciesData: [(name: String, quantity: Int, image: UIImage?)] {
        let grouped = Dictionary(grouping: viewModel.observations, by: { $0.species })
        
        let stats = grouped.map { (species, observations) in
            let quantity = observations.count
            let image = observations.first?.images.first
            return (name: species, quantity: quantity, image: image)
        }
        
        let sorted = stats.sorted { $0.quantity > $1.quantity }
            .prefix(3)
        
        return Array(sorted)
    }
    
    private var monthlyData: [(month: String, count: Int)] {
        let calendar = Calendar.current

        let grouped = Dictionary(grouping: viewModel.observations) { obs in
            calendar.component(.month, from: obs.date)
        }

        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.dateFormat = "MMM"

        return (1...12).map { month in
            let monthName = formatter.shortMonthSymbols[month - 1]
            let count = grouped[month]?.count ?? 0
            return (month: monthName, count: count)
        }
    }

    private var maxMonthlyCount: Int {
        monthlyData.map { $0.count }.max() ?? 0
    }

    
    var body: some View {
        ZStack {
            Image(.Images.baseBG)
                .resizeAndFill()
            
            VStack(spacing: 16) {
                navigation
                
                if viewModel.observations.isEmpty {
                    stumb
                } else {
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 12) {
                            numbers
                            rares
                            graph
                        }
                        .padding(.horizontal, 20)
                    }
                    .padding(.bottom, 100)
                }
            }
            .frame(maxHeight: .infinity, alignment: .top)
        }
        .onAppear {
            viewModel.loadObservations()
        }
    }
    
    private var navigation: some View {
        Text("Statistics")
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
                Text("Statistics will appear once you\nstart your diary")
                    .font(.belgrano(with: 20))
                    .foregroundStyle(.black)
                
                Text("Track the species you meet and\ndiscover rare findings!")
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
    
    private var numbers: some View {
        VStack {
            Image(.Images.Wood.grapth)
                .resizable()
                .scaledToFit()
                .frame(width: 115, height: 115)
            
            VStack(spacing: 16) {
                Text("The total number of species")
                    .font(.belgrano(with: 15))
                
                Text(viewModel.observations.count.formatted())
                    .font(.belgrano(with: 36))
            }
            .foregroundStyle(.black)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(.white)
        .cornerRadius(50)
    }
    
    private var rares: some View {
        VStack(spacing: 12) {
            Text("Rare findings")
                .font(.belgrano(with: 15))
                .foregroundStyle(.black)
            
            HStack {
                ForEach(topThreeSpeciesData, id: \.name) { data in
                    VStack(spacing: 12) {
                        VStack {
                            if let image = data.image {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 63, height: 63)
                                    .clipped()
                                    .cornerRadius(100)
                            }
                            
                            Text(data.name)
                                .font(.belgrano(with: 11))
                                .foregroundStyle(.black)
                        }
                        
                        Text(data.quantity.formatted())
                            .font(.belgrano(with: 24))
                            .foregroundStyle(.bvdOrange)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(maxWidth: 100)
                    .padding(.vertical, 18)
                    .background(.bvdSecondWhite)
                    .cornerRadius(115)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 25)
        .background(.white)
        .cornerRadius(50)
    }
    
    private var graph: some View {
        VStack(spacing: 20) {
            Text("How many birds have you heard per month")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.belgrano(with: 15))
                .foregroundStyle(.black)
                .multilineTextAlignment(.leading)
            
            Chart {
                ForEach(monthlyData, id: \.month) { item in
                    BarMark(
                        x: .value("Month", item.month),
                        y: .value("Count", item.count)
                    )
                    .foregroundStyle(.bvdOrange.gradient)
                    .cornerRadius(4)
                }
            }
            .chartXAxis {
                AxisMarks(position: .bottom) { value in
                    AxisTick()
                    AxisValueLabel()
                }
            }
            .chartYAxis {
                AxisMarks(position: .leading) { value in
                    if value.as(Double.self) == 0 {
                        AxisGridLine()
                            .foregroundStyle(.black)
                    }
                    
                    AxisTick()
                    AxisValueLabel()
                }
            }
            .chartYScale(domain: 0...(maxMonthlyCount == 0 ? 1 : maxMonthlyCount))
            .frame(height: 220)
        }
        .padding(20)
        .background(.white)
        .cornerRadius(50)
    }



}

#Preview {
    StatisticsView(isShowTabBar: .constant(false))
}
