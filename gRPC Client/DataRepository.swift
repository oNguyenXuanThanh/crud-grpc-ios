//
//  DataRepository.swift
//  gRPC Client
//
//  Created by Thanh Nguyen Xuan on 08/02/2021.
//

import Foundation
import SwiftGRPC

extension Pet {
    init(name: String, description: String) {
        self.name = name
        self.description_p = description
    }
}

extension PetRequestId {
    init(id: String) {
        self.id = id
    }
}

class DataRepository {
    // Singletion instance
    static let shared = DataRepository()
    // Client instance với address của gRPC local server
    private let client = PetServiceServiceClient(address: "127.0.0.1:50051", secure: false)

    private init() {}

    func getPets(completion: @escaping ([Pet]?, CallResult?) -> Void) {
        // Vì gRPC get list pet không cần parameter đầu vào nên chỉ cần khời tạo
        // Empty message
        let emptyParameter = Empty()
        // Call gRPC method và trả về list pet trên main thread
        _ = try? client.list(emptyParameter, completion: { petList, result in
            DispatchQueue.main.async {
                completion(petList?.pets, result)
            }
        })
    }

    func addPet(_ pet: Pet, completion: @escaping (Pet?, CallResult?) -> Void) {
        _ = try? client.insert(pet, completion: { createdPet, result in
            DispatchQueue.main.async {
                completion(createdPet, result)
            }
        })
    }

    func delete(petId: String, completion: @escaping (Bool) -> Void) {
        _ = try? client.delete(PetRequestId(id: petId), completion: { pet, result in
            DispatchQueue.main.async {
                completion(pet != nil)
            }
        })
    }
}
