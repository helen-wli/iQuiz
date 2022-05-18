//
//  ViewController.swift
//  iQuiz
//
//  Created by Helen Li on 5/13/22.
//

import UIKit

// Single cell in the table view, containing a subject, a description, and an icon
class QuizTopicCell: UITableViewCell {
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var subtitle: UILabel!
}

class UITableViewSource: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    weak var vc : ViewController?
    
    let titles = ["Mathematics", "Marvel Super Heroes", "Science"]
    let subtitles = [
        "Test your mathematical knowledge",
        "Show your love to Marvel Super Heroes",
        "Embrace your sientific spirit"
    ]
    let icons = ["math-icon", "superhero-icon", "science-icon"]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: QuizTopicCell = tableView.dequeueReusableCell(withIdentifier: "quizTopicCell") as! QuizTopicCell
        
        cell.title.text = titles[indexPath.row]
        cell.subtitle.text = subtitles[indexPath.row]
        cell.icon.image = UIImage(named: icons[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 115.0
    }
}

class ViewController: UIViewController {
    
    var uiTableViewSource = UITableViewSource()
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func setting(_ sender: UIBarButtonItem) {
    let alert = UIAlertController(title: "Settings", message: "Settings go here", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: nil))
    present(alert, animated: true, completion: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = tableView.indexPathForSelectedRow{
            let questionVC = segue.destination as! QuestionViewController
            questionVC.topicSection = indexPath.row
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        uiTableViewSource.vc = self
        
        tableView.dataSource = uiTableViewSource
        tableView.delegate = uiTableViewSource
    }
}
