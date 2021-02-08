//
//  ViewController.swift
//  gRPC Client
//
//  Created by Thanh Nguyen Xuan on 08/02/2021.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction private func getListButtonTapped(_ sender: Any) {
        DataRepository.shared.getPets { pets, result in
            if let result = result {
                print("Call result: \(result)")
            }
            print("Fetched pets: \(pets ?? [])")
        }
    }

    @IBAction private func addNewButtonTapped(_ sender: Any) {
        let alertController = UIAlertController(title: "Add new pet", message: nil, preferredStyle: .alert)
        alertController.addTextField(configurationHandler: { $0.placeholder = "Pet name" })
        alertController.addTextField(configurationHandler: { $0.placeholder = "Pet description" })
        alertController.addAction(UIAlertAction(title: "Save", style: .default, handler: { _ in
            let nameTextField = alertController.textFields![0]
            let descriptionTextField = alertController.textFields![0]
            guard let name = nameTextField.text, !name.isEmpty,
                  let description = descriptionTextField.text, !description.isEmpty else {
                return
            }
            let newPet = Pet(name: name, description: description)
            DataRepository.shared.addPet(newPet) { insertedPet, result in
                if let result = result {
                    print("Call result: \(result)")
                } else {
                    print("Call result: nil")
                }
                if let insertedPet = insertedPet {
                    print("Inserted pet: \(insertedPet)")
                } else {
                    print("Inserted pet: nil")
                }
            }
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }

    @IBAction private func deleteButtonTapped(_ sender: Any) {
        let alertController = UIAlertController(title: "Delete pet by ID", message: nil, preferredStyle: .alert)
        alertController.addTextField(configurationHandler: { $0.placeholder = "Pet id" })
        alertController.addAction(UIAlertAction(title: "Delete", style: .default, handler: { _ in
            let petIdTextField = alertController.textFields![0]
            guard let petId = petIdTextField.text, !petId.isEmpty else {
                return
            }
            DataRepository.shared.delete(petId: petId) { success in
                print(success ? "Delete successfully" : "Delete failed")
            }
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }

}

