import Foundation

struct ObservationUD: Codable {
    var id: UUID
    var date: Date
    var imagePaths: [String]
    var specidies: String
    var behaviors: String
    var habits: String
    var isFavorite: Bool
    
    init(from model: Observation, and imagePaths: [String]) {
        self.id = model.id
        self.date = model.date
        self.imagePaths = imagePaths
        self.specidies = model.species
        self.behaviors = model.behavior
        self.habits = model.habits
        self.isFavorite = model.isFavorite
    }
}
