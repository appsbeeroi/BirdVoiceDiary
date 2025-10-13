enum SettinsRowType: Identifiable, CaseIterable {
    var id: Self { self }
    
    case notifications
    case dataCleaning
    case about
    case privacy
    
    var title: String {
        switch self {
            case .notifications:
                "Notifications"
            case .dataCleaning:
                "Data cleaning"
            case .about:
                "About the developer"
            case .privacy:
                "Privacy Policy"
        }
    }
    
    var documentURLString: String {
        switch self {
            case .about:
                "https://sites.google.com/view/birdvoicediary/home"
            case .privacy:
                "https://sites.google.com/view/birdvoicediary/privacy-policy"
            default:
                ""
        }
    }
}
