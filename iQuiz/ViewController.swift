//
//  ViewController.swift
//  iQuiz
//
//  Created by Helen Li on 5/13/22.
//

import UIKit

// Single cell in the table view, containing a subject, a description, and an icon
class QuizTopicCell: UITableViewCell {
    // subject name label
    @IBOutlet weak var subject: UILabel!
    
    // subject description label
    @IBOutlet weak var subjectDescription: UILabel!
    
    // icon
    @IBOutlet weak var icon: UIImageView!
}


// TableViewDataSource and TableViewDelegate
class UITableViewSource : NSObject, UITableViewDataSource, UITableViewDelegate {
    
    weak var vc : ViewController?
    
    let quizTopics : [String] = ["Mathematics", "Science", "Marvel Super Heroes"]
    let topicDescriptions : [String] = [
        "Test your math knowledge",
        "Embrace your scientific spirit",
        "Show your love to Marvel Heroes"
    ]
    let iconNames = ["math-icon", "science-icon", "superhero-icon"]
    
    
    /*
     UITableViewDataSource methods
     */
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quizTopics.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : QuizTopicCell = tableView.dequeueReusableCell(withIdentifier: "quizTopicCell", for: indexPath) as! QuizTopicCell
        
        cell.subject.text = quizTopics[indexPath.row]
        cell.subjectDescription.text = topicDescriptions[indexPath.row]
        cell.icon.image = UIImage(named: iconNames[indexPath.row])
        
        return cell
    }
    
    
    /*
     UITableViewDelegate method
     */
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150.0
    }
}


// (Main) View Controller
class ViewController: UIViewController {
    
    var uiTableViewSource = UITableViewSource()

    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func settingsPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Settings", message: "Settings go here", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: nil))
        uiTableViewSource.vc!.present(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        uiTableViewSource.vc = self
        
        tableView.dataSource = uiTableViewSource
        tableView.delegate = uiTableViewSource
    }
}
