import UIKit
import Combine

final class FavoritesViewModel: ObservableObject {
    
    private let udManager = UDManager.shared
    private let imageManager = LocalImageStore.shared
    
    @Published var navigationPath: [FavoritesScreen] = []
    @Published var searchedText = ""
    
    @Published private(set) var observations: [Observation] = []
    
    private(set) var observationsBase: [Observation] = []
    private var cancellable = Set<AnyCancellable>()
    
    init() {
        observeSearchedText()
    }
    
    func loadObservations() {
        Task { [weak self] in
            guard let self else { return }
            
            let observationsUD = await udManager.get([ObservationUD].self, for: .observation) ?? []
            
            let result = await withTaskGroup(of: Observation.self) { group in
                for observationUD in observationsUD {
                    group.addTask {
                        let images = await withTaskGroup(of: UIImage?.self) { group in
                            for imagePath in observationUD.imagePaths {
                                group.addTask {
                                    await self.imageManager.loadImage(named: imagePath)
                                }
                            }
                            
                            var images = [UIImage?]()
                            
                            for await image in group {
                                let imageData = image?.jpegData(compressionQuality: 0.1)
                                let image = UIImage(data: imageData ?? Data())
                                
                                images.append(image)
                            }
                            
                            return images.compactMap{ $0 }
                        }
                        
                        return Observation(from: observationUD, and: images)
                    }
                }
                
                var observations = [Observation]()
                
                for await observation in group {
                    observations.append(observation)
                }
                
                return observations.filter { $0.isFavorite }
            }
            
            await MainActor.run {
                self.observationsBase = result.sorted(by: { $0.date > $1.date })
                self.observations = result.sorted(by: { $0.date > $1.date })
            }
        }
    }
    
    func save(_ observation: Observation) {
        Task { [weak self] in
            guard let self else { return }
            
            var observationsUD = await self.udManager.get([ObservationUD].self, for: .observation) ?? []
            
            let imagePaths = await withTaskGroup(of: String?.self) { group in
                for (index, image) in observation.images.enumerated() {
                    group.addTask {
                        let uniqueUUID = combinedUUID(from: observation.id, and: index)
                        let imagePath = await self.imageManager.save(image, with: uniqueUUID)
                        
                        return imagePath
                    }
                }
                
                var imagePaths: [String?] = []
                
                for await imagePath in group {
                    imagePaths.append(imagePath)
                }
                
                return imagePaths.compactMap { $0 }
            }
            
            let observationUD = ObservationUD(from: observation, and: imagePaths)
            
            if let index = observationsUD.firstIndex(where: { $0.id == observationUD.id }) {
                observationsUD[index] = observationUD
            } else {
                observationsUD.append(observationUD)
            }
            
            await self.udManager.set(observationsUD, for: .observation)
            
            await MainActor.run {
                self.navigationPath = []
            }
        }
    }
    
    private func observeSearchedText() {
        $searchedText
            .receive(on: RunLoop.main)
            .sink { [weak self] text in
                guard let self else { return }
                
                guard text != "" else {
                    self.observations = self.observationsBase
                    return
                }
                
                self.observations = self.observationsBase.filter { $0.species.contains(text) || $0.behavior.contains(text) || $0.habits.contains(text) }
            }
            .store(in: &cancellable)
    }
}
