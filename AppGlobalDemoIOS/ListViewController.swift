//
//  ListViewController.swift
//  AppGlobalDemo
//
//  Created by Anis Mansuri on 11/09/24.
//

import UIKit
import FirebaseAnalytics
class ListViewController: UIViewController {
    @IBOutlet weak var textView: UITextView!
    var string = ""
    var allRequest: Bool? = false
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.text = string
        textView.isEditable = false
        if allRequest == nil {
            Analytics.logEvent(AnalyticsEventScreenView, parameters: [AnalyticsParameterScreenName: "ConfigViewControllerAll"])
        } else {
            if allRequest! {
                Analytics.logEvent(AnalyticsEventScreenView, parameters: [AnalyticsParameterScreenName: "ListViewControllerAll"])
            } else {
                Analytics.logEvent(AnalyticsEventScreenView, parameters: [AnalyticsParameterScreenName: "ListViewControllerFiltered"])
            }

        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
