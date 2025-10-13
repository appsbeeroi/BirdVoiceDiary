import UIKit

final class LocalImageStore {
    
    static let shared = LocalImageStore()
    
    private let directoryName = "StoredImages"
    private let fileManager = FileManager.default
    private let baseURL: URL
    
    private init() {
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        baseURL = documentsURL.appendingPathComponent(directoryName, isDirectory: true)
        createDirectoryIfNeeded()
    }
    
    // MARK: - Directory Management
    
    private func createDirectoryIfNeeded() {
        var isDir: ObjCBool = false
        if !fileManager.fileExists(atPath: baseURL.path, isDirectory: &isDir) || !isDir.boolValue {
            do {
                try fileManager.createDirectory(at: baseURL, withIntermediateDirectories: true)
                print("📁✅ Created directory at \(baseURL.path)")
            } catch {
                print("📁❌ Failed to create directory: \(error.localizedDescription)")
            }
        }
    }
    
    private func fileURL(for id: UUID) -> URL {
        baseURL.appendingPathComponent("\(id.uuidString).png")
    }
    
    private func fileURL(named name: String) -> URL {
        baseURL.appendingPathComponent(name)
    }
}

// MARK: - Public API

extension LocalImageStore {
    
    /// Сохраняет изображение в локальное хранилище
    @discardableResult
    func save(_ image: UIImage, with id: UUID) async -> String? {
        let fileURL = fileURL(for: id)
        
        guard let data = image.pngData() else {
            print("📷❌ Failed to encode image as PNG")
            return nil
        }
        
        do {
            try data.write(to: fileURL, options: .atomic)
            print("💾✅ Saved image to \(fileURL.lastPathComponent)")
            return fileURL.lastPathComponent
        } catch {
            print("💾❌ Failed to save image: \(error.localizedDescription)")
            return nil
        }
    }
    
    /// Загружает изображение по имени файла
    func loadImage(named name: String) async -> UIImage? {
        let fileURL = fileURL(named: name)
        guard fileManager.fileExists(atPath: fileURL.path) else {
            print("📂⚠️ Image not found: \(name)")
            return nil
        }
        return UIImage(contentsOfFile: fileURL.path)
    }
    
    /// Удаляет изображение по UUID
    func deleteImage(with id: UUID) async {
        let fileURL = fileURL(for: id)
        
        guard fileManager.fileExists(atPath: fileURL.path) else {
            print("🗑️⚠️ File not found for deletion: \(fileURL.lastPathComponent)")
            return
        }
        
        do {
            try fileManager.removeItem(at: fileURL)
            print("🗑️✅ Deleted image: \(fileURL.lastPathComponent)")
        } catch {
            print("🗑️❌ Failed to delete image: \(error.localizedDescription)")
        }
    }
    
    /// Проверяет, существует ли изображение с данным именем
    func imageExists(named name: String) -> Bool {
        let fileURL = fileURL(named: name)
        return fileManager.fileExists(atPath: fileURL.path)
    }
}
