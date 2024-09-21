//
//  ViewController.swift
//  AppGlobalDemo
//
//  Created by Anis Mansuri on 09/09/24.
//

import UIKit
import MonitaSDK
import FirebaseCore
import FirebaseAnalytics
import FirebaseAuth
import FirebaseCrashlytics
import FirebaseDatabase
import FirebaseDatabase

class ViewController: UIViewController {
    @IBOutlet var textFieldName, textFieldAge: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        testGet()
//        testPost()
        Analytics.logEvent(AnalyticsEventScreenView, parameters: ["name": "app"])
    }
    func testGet() {
        print(#function)
        var request = URLRequest(url: URL(string: "https://api.chucknorris.io/jokes/random")!,timeoutInterval: Double.infinity)
        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          guard let data = data else {
            print(String(describing: error))
            return
          }
            print(String(data: data, encoding: .utf8))
            
        }
        task.resume()

    }
    

    func testPost() {
        var request = URLRequest(url: URL(string: "https://facebook.com")!,timeoutInterval: Double.infinity)
        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          guard let data = data else {
            print(String(describing: error))
            return
          }
            print(String(data: data, encoding: .utf8))
            
        }
        task.resume()

    }
    @IBAction func getConfigListAction(_ sender: UIButton) {
        
        let viewCon = self.storyboard!.instantiateViewController(identifier: "ListViewController") as! ListViewController
        viewCon.string = MonitaSDK.getConfigList()
        viewCon.allRequest = nil
        self.navigationController?.pushViewController(viewCon, animated: true)
        
    }
    @IBAction func getRequestListAction(_ sender: UIButton) {
        

        let viewCon = self.storyboard!.instantiateViewController(identifier: "ListViewController") as! ListViewController
        viewCon.string = MonitaSDK.getInterceptedRequestList()
        viewCon.allRequest = false
        self.navigationController?.pushViewController(viewCon, animated: true)
    }
    @IBAction func getRequestListAllAction(_ sender: UIButton) {
        Analytics.logEvent(AnalyticsEventSelectContent, parameters: [
          AnalyticsParameterItemID: "id-ViewCOntroller)",
          AnalyticsParameterItemName: "ViewCOntroller",
          AnalyticsParameterContentType: "cont",
        ])
        Analytics.logEvent("Custom Log", parameters: ["Time" : "Value"])
        let viewCon = self.storyboard!.instantiateViewController(identifier: "ListViewController") as! ListViewController
        viewCon.string = MonitaSDK.getInterceptedRequestListAll()
        viewCon.allRequest = true
        self.navigationController?.pushViewController(viewCon, animated: true)
    }
    @IBAction func logErrorAction(_ sender: UIButton) {
        Crashlytics.crashlytics().log("Your custom log message")
    }
    @IBAction func logCrashAction(_ sender: UIButton) {
        //print(UserDefaults.standard.value(forKey: "fda") as! String)
    //https://authentication-5c281.firebaseio.com
        let purchaseData: [String: Any] = [
            "event": "purchase",
            "commerce": [
                "items": [
                    [
                        "itemNumber": "ABC123123",
                        "itemName": "Aristocrat - Preminum Collections",
                        "quantity": 999
                    ]
                ]
            ]
        ]
        
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
    @IBAction func sendDBAction(_ sender: UIButton) {
        
        var name = textFieldName.text!
        var age = textFieldAge.text!
        let ref = Database.database().reference()
        let userData: [String: Any] = ["name": name, "age": age]
        
        ref.child("users").childByAutoId().setValue(userData) { (error, reference) in
            if let error = error {
                print("Error sending data to Firebase: \(error.localizedDescription)")
                UIApplication.showAlert(message: "Error sending data to Firebase: \(error.localizedDescription)")
            } else {
                print("Data successfully sent to Firebase!")
                UIApplication.showAlert(message: "Data successfully sent to Firebase!")
            }
        }

    }
}

