//
//  ProductViewController.swift
//  AppGlobalDemoIOS
//
//  Created by Anis Mansuri on 13/09/24.
//

import UIKit
import MonitaSDK
import FirebaseDatabase
import FirebaseFirestore

class ProductViewController: UIViewController {

    // Outlet for the label to display the product quantity
    @IBOutlet weak var quantityLabel: UILabel!

    // Outlet for the stepper control
    @IBOutlet weak var stepper: UIStepper!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up the initial values for the stepper and label
        stepper.minimumValue = 1
        stepper.maximumValue = 10
        stepper.stepValue = 1
        stepper.value = 1
        
        quantityLabel.text = "Quantity: \(Int(stepper.value))"
    }
    @IBAction func buttonInfoAction(_ sender: UIButton) {
        

        let viewCon = self.storyboard!.instantiateViewController(identifier: "ViewController") as! ViewController
        
        self.navigationController?.pushViewController(viewCon, animated: true)
    }

    // Action triggered when the stepper value changes
    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        // Update the label with the current stepper value
        quantityLabel.text = "Quantity: \(Int(sender.value))"
    }
    @IBAction func buttonPurchaseAction(_ sender: UIButton) {
        let qty = Int(stepper.value)
        
        // Update the label with the current stepper value
        let purchaseData: [String: Any] = [
            "event": "purchase",
            "commerce": [
                "items": [
                    [
                        "itemNumber": "ABC123",
                        "itemName": "Aristocrat - Preminum Collection",
                        "quantity": qty
                    ]
                ]
            ]
        ]
        //saveInStore(dic: purchaseData)
        
        let url = URL(string: "https://authentication-5c281.firebaseio.com/ProductPurchase.json")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // Convert the payload to JSON data
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: purchaseData, options: [])
        } catch {
            print("Error serializing JSON: \(error)")
            return
        }

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                return
            }

            guard let data = data else {
                print("No data")
                return
            }

            if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                print("Response: \(json)")
            }
        }

        task.resume()
        

    }
    func saveInStore(dic: [String: Any]) {
        let db = Firestore.firestore()
        // Reference to a specific document
        let userRef = db.collection("ProductPurchase").addDocument(data: dic)

        // Set data
        userRef.setData(dic) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
                UIApplication.showAlert(message: "Product Purchased!")
            }
        }


        
    }
    func saveInRealTime(dic: [String: Any]) {
        
        
        let ref = Database.database().reference()

        ref.child("ProductPurchase").childByAutoId().setValue(dic) { (error, reference) in
            if let error = error {
                print("Error sending data to Firebase: \(error.localizedDescription)")
                UIApplication.showAlert(message: "Error sending data to Firebase: \(error.localizedDescription)")
            } else {
                print("Data successfully sent to Firebase!")
                UIApplication.showAlert(message: "Product Purchased!")
            }
        }
    }
}
