enum TabBarState: Identifiable, CaseIterable {
    var id: Self { self }
    
    case observations
    case favorites
    case statistics
    case settings
    
    var icon: ImageResource {
        switch self {
            case .observations:
                    .Icons.home
            case .favorites:
                    .Icons.favorites
            case .statistics:
                    .Icons.statistics
            case .settings:
                    .Icons.settings
        }
    }
}
