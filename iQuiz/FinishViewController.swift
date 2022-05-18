//
//  FinishViewController.swift
//  iQuiz
//
//  Created by Helen Li on 5/17/22.
//

import UIKit

class FinishViewController: UIViewController {
    
    // tracks the number of questions that the user got right
    public var userScore: Int! = nil
    
    // total number of questions of corresponding quiz topic
    public var numQs: Int! = nil
    
    // Perfect/Almost label
    @IBOutlet weak var feedbackLabel: UILabel!
    
    // Score: x/y correct
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBAction func goNext(_ sender: UIButton) {
        performSegue(withIdentifier: "toMain", sender: self) // go back to initial vc
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        scoreLabel.text = "Score: \(String(userScore)) / \(String(numQs)) correct"
        
        if userScore == numQs { // got all questions correct
            feedbackLabel.text = "Perfect"
        } else { // made some mistake
            feedbackLabel.text = "Almost"
        }
        
        let swipeLf: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeLeft(_:)))
        swipeLf.direction = .left
        self.view.addGestureRecognizer(swipeLf)
    }
    
    // swipe left to quit the quiz (back to MainViewController)
    @objc func swipeLeft(_ sender : UISwipeGestureRecognizer) {
        self.performSegue(withIdentifier: "toMain", sender: self)
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
