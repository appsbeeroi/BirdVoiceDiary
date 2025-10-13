import UIKit

final class StatisticsViewModel: ObservableObject {
    
    private let udManager = UDManager.shared
    private let imageManager = LocalImageStore.shared
    
    @Published private(set) var observations: [Observation] = []
    
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
                                let imageData = image?.jpegData(compressionQuality: 0.3)
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
                
                return observations
            }
            
            await MainActor.run {
                self.observations = result
            }
        }
    }
}
