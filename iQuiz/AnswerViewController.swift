//
//  AnswerViewController.swift
//  iQuiz
//
//  Created by Helen Li on 5/17/22.
//

import UIKit

class AnswerViewController: UIViewController {
    
    // users's choice
    var userChoice: String! = nil
    
    // question text in label
    var questionText: String! = nil
    
    // when reached, go back to "Main"
    var totalQs: Int! = nil
    
    // nth section of the quiz topics
    var topicSection: Int! = nil
    
    // nth question of selected quiz topic
    var questionNum: Int! = nil
    
    // current number of correct answers by the user
    var currScore: Int! = nil
    
//    let keys = [
//        ["pi", "3.14", "German"], // math keys
//        ["Six", "Brooklyn", "Strawberries"], // marvel keys
//        ["Four", "13 octillion lbs"] // science keys
//    ]
    var key: String! = nil
    
    var quizData: [Collection]? = nil
    var urlString: String! = nil
    
    @IBOutlet weak var alarm: UILabel!
    @IBOutlet weak var question: UILabel!
    @IBOutlet weak var Ans: UILabel!
    
    @IBAction func getNext(_ sender: UIButton) {
        if totalQs == questionNum {
            performSegue(withIdentifier: "toFinish", sender: self)
        } else {
            performSegue(withIdentifier: "toQues", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? QuestionViewController {
            vc.topicSection = topicSection
            vc.questionNum = questionNum
            vc.currScore = currScore
            vc.quizData = quizData
            vc.urlString = urlString
        }
        
        if let vc = segue.destination as? FinishViewController {
            vc.userScore = currScore
            vc.numQs = totalQs
            vc.urlString = urlString
        }
        
        if let vc = segue.destination as? ViewController{
            vc.urlString = urlString
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if userChoice == key {
            alarm.text = "Got right!"
            currScore += 1
        } else {
            alarm.text = "Got wrong :("
        }
        
        Ans.text = "Key: \(key!)"
        question.text = questionText
        
        questionNum += 1
        
        let swipeLf: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeLeft(_:)))
        swipeLf.direction = .left
        self.view.addGestureRecognizer(swipeLf)
        
        let swipeRt: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeRight(_:)))
        swipeRt.direction = .right
        self.view.addGestureRecognizer(swipeRt)
    }
    
    // swipe left to quit the quiz (back to MainViewController)
    @objc func swipeLeft(_ sender : UISwipeGestureRecognizer) {
        self.performSegue(withIdentifier: "toMain", sender: self)
    }
    
    // swipe right to replace pressing "Next"
    @objc func swipeRight(_ sender : UISwipeGestureRecognizer) {
        if totalQs == questionNum {
            performSegue(withIdentifier: "toFinish", sender: self)
        } else {
            performSegue(withIdentifier: "toQues", sender: self)
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
