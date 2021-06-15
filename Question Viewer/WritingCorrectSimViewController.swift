//
//  WritingCorrectSimViewController.swift
//  SAT Daily
//
//  Created by RB on 2/23/21.
//

import StoreKit
import Firebase
import UIKit

class WritingCorrectSimViewController: UIViewController {
    
    var db: Firestore!
    var actualactualquestionid = 0

    @IBOutlet weak var congrats: UILabel!
    @IBOutlet weak var explanation: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let presented = self.presentedViewController
        {
            presented.removeFromParent()
        }
        
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
        
        doStuff()
        reviewCheck()
    }
    
    public func doStuff()
    {
        let qans = UserDefaults.standard.string(forKey: "qans")
        let intqans = Int(qans!) ?? 0
        let newans = intqans + 1
        let final = String(newans)
        UserDefaults.standard.setValue(final, forKey: "qans")
        
        let dailyToday = String(actualactualquestionid)
        let docRef = db.collection("writing").document(dailyToday)
        docRef.getDocument{ (document, error) in
            if let document = document, document.exists {
                // Explanation Code
                let explanation = document.get("explanation")
                let explanationDisplay = explanation as! String
                self.explanation.text = explanationDisplay
            }
        }
        self.congrats.adjustsFontSizeToFitWidth = true
        let randomInt = Int.random(in: 1..<4)
        if randomInt == 1 {
            self.congrats.text = "Well done!"
        }
        else if randomInt == 2 {
            self.congrats.text = "Congrats!"
        }
        else if randomInt == 3 {
            self.congrats.text = "Awesome!"
        }
    }
    
    public func reviewCheck()
    {
        if Int(UserDefaults.standard.string(forKey: "qans")!)! == 10 || Int(UserDefaults.standard.string(forKey: "qans")!)! == 25 || Int(UserDefaults.standard.string(forKey: "qans")!)! == 50  {
            if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
                SKStoreReviewController.requestReview(in: scene)
            }
        }
    }
}

