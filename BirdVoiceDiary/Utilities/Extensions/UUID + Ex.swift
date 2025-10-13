import Foundation
import CryptoKit

func combinedUUID(from uuid: UUID, and int: Int) -> UUID {
    var data = Data(uuid.uuidString.utf8)
    var intValue = int
    data.append(Data(bytes: &intValue, count: MemoryLayout<Int>.size))
    
    let hash = SHA256.hash(data: data)
    
    let uuidBytes = Array(hash.prefix(16))
    let newUUID = uuidBytes.withUnsafeBytes { ptr -> UUID in
        let tuple = ptr.load(as: uuid_t.self)
        return UUID(uuid: tuple)
    }
    
    return newUUID
}
