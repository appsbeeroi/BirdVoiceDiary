import UIKit

struct Observation: Identifiable, Equatable, Hashable {
    var id: UUID
    var date: Date
    var images: [UIImage]
    var species: String
    var behavior: String
    var habits: String
    var isFavorite = false
    
    var isLock: Bool {
        self.images.isEmpty || self.species == "" || self.behavior == "" || self.habits == ""
    }
    
    init(isMock: Bool) {
        self.id = UUID()
        self.date = Date()
        self.images = isMock ? [UIImage(resource: .Images.Wood.birds), UIImage(resource: .Images.Wood.gear)] : []
        self.species = isMock ? "Woodpecker" : ""
        self.behavior = isMock ? "Perching" : ""
        self.habits = isMock ? "Foraging" : ""
    }
    
    init(from ud: ObservationUD, and images: [UIImage]) {
        self.id = ud.id
        self.date = ud.date
        self.images = images
        self.species = ud.specidies
        self.behavior = ud.behaviors
        self.habits = ud.habits
        self.isFavorite = ud.isFavorite
    }
}

