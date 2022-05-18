//
//  QuestionViewController.swift
//  iQuiz
//
//  Created by Helen Li on 5/13/22.
//

import UIKit

class AnswerCell: UITableViewCell {
    @IBOutlet weak var mcContent: UILabel!
}

class QuestionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // nth section of the quiz topics: math = 0, marvel = 1, science = 2
    public var topicSection: Int! = nil
    
    // nth question of selected quiz topic
    public var questionNum: Int! = nil
    
    public var selectedTopic: [String]! = nil
    public var topicChoices: [String]! = nil
    public var userChoice: String! = nil
    public var currScore: Int! = nil

    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    let mathQuestions = [
        "What is the ratio of a circle's circumference to its diameter",
        "What is pi approximately?",
        "Mathematician Carl Gauss is"
    ]
    let mathChoices = [
        ["alpha", "beta", "pi", "theta"],
        ["1.57", "3.14", "6.28", "7.85"],
        ["American", "Asian", "German", "Indian"]
    ]
    
    let marvelQuestions = [
        "How many infinity stones are there?",
        "Where is Captain America from?",
        "Pepper Potts is allergic to what?"
        
    ]
    let marvelChoices = [
        ["Three", "Six", "Ten", "idk"],
        ["Boston", "Brooklyn", "Chicago", "New York"],
        ["Eggs", "Mangoes", "Shrimp", "Strawberries"]
    ]
    
    let scienceQuestions = [
        "How many oceans in the world?",
        "How much does the earth weight?"
    ]
    let scienceChoices = [
        ["One", "Two", "Four", "Eight"],
        ["10 billion lbs", "1 trillion lbs", "10 septillion kg", "13 octillion lbs"]
    ]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return topicChoices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: AnswerCell = self.tableView.dequeueReusableCell(withIdentifier: "ansCellType") as! AnswerCell
        cell.mcContent.text = topicChoices[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt: IndexPath) {
        userChoice = topicChoices[didSelectRowAt.row]
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55.0
    }
    
    @IBAction func goNext(_ sender: UIButton) {
        if userChoice == nil { // did NOT choose a choice
            let alert = UIAlertController(title: "Sorry", message: "Please select a choice", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        } else { // go to AnswerViewController
            performSegue(withIdentifier: "toAns", sender: self)
        }
    }

    // Always go to AnswerViewController from QuestionViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? AnswerViewController{
            vc.topicSection = topicSection
            vc.questionNum = questionNum
            vc.userChoice = userChoice
            vc.currScore = currScore
            
            vc.questionText = selectedTopic[questionNum]
            vc.totalQs = selectedTopic.count
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        
        if questionNum == nil {
            questionNum = 0
        }
        if currScore == nil {
            currScore = 0
        }
        
        switch topicSection {
        case 1: // marvel super heroes
            selectedTopic = marvelQuestions
            topicChoices = marvelChoices[questionNum]
        case 2: // science
            selectedTopic = scienceQuestions
            topicChoices = scienceChoices[questionNum]
        default: // topicSection = 0 = math
            selectedTopic = mathQuestions
            topicChoices = mathChoices[questionNum]
        }
        
        questionLabel.text = selectedTopic[questionNum]
        
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
    
    // swipe right to replace pressing "submit" (go to AnswerViewController)
    @objc func swipeRight(_ sender : UISwipeGestureRecognizer) {
        if userChoice == nil { // did NOT choose a choice
            let alert = UIAlertController(title: "Sorry", message: "Please select a choice", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        } else { // go to AnswerViewController
            performSegue(withIdentifier: "toAns", sender: self)
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
