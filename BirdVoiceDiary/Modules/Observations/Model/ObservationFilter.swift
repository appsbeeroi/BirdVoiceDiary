import UIKit

struct ObservationFilter: Equatable {
    var date: Date
    var isFavorite: Bool?
    var isCleared = false 
    
    init() {
        self.date = Date()
    }
}
