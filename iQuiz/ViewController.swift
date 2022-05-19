//
//  ViewController.swift
//  iQuiz
//
//  Created by Helen Li on 5/13/22.
//

import UIKit

import Foundation
import SystemConfiguration

// Single cell in the table view, containing a subject, a description, and an icon
class QuizTopicCell: UITableViewCell {
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var subtitle: UILabel!
}

// a question, including question text, answer, and multiple choices
struct Question: Codable {
    let text: String
    let answer: String
    let answers: [String]
}

// a collection of questions, including subject title, subject description, and a list of questions
struct Collection: Codable {
    let title: String
    let desc: String
    let questions: [Question]
}

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var quizData : [Collection]? = nil
//    let titles = ["Mathematics", "Marvel Super Heroes", "Science"]
//    let subtitles = [
//        "Test your mathematical knowledge",
//        "Show your love to Marvel Super Heroes",
//        "Embrace your sientific spirit"
//    ]
    var titles : [String] = []
    var subtitles : [String] = []
    let icons = ["science-icon", "superhero-icon", "math-icon"]
    
    var urlString: String = "http://tednewardsandbox.site44.com/questions.json"
    
    var textField: UITextField = UITextField()
    var refreshControl = UIRefreshControl()
    
    @IBOutlet weak var tableView: UITableView!
    
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
    
    @IBAction func setting(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Settings", message: "Please enter a URL", preferredStyle: .alert)
        alert.addTextField { (textField: UITextField) in
            self.textField = textField
            self.textField.placeholder = "your url"
        }
        alert.addAction(UIAlertAction(title: "leave", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: NSLocalizedString("check now", comment: "Default action"), style: .default, handler: {_ in
            if((self.textField.text) != nil){
                self.loadData(self.textField.text!)
            }
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func internetAvailable() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        return (isReachable && !needsConnection)
    }
    
    func alertController(_ errText: String) {
        let alert = UIAlertController(title: "Error", message: errText, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func loadData(_ urlParam: String) {
        
        urlString = urlParam
        
        let request = URLRequest(url: URL(string: urlParam)!)
        
        let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let fileName = "data.json"
        
        if internetAvailable() { // connected to internet
            URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
                
                guard let self = self else { return }
                
                guard error == nil else {
                    self.alertController(error.debugDescription)
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200
                else {
                    self.alertController("error with http response")
                    return
                }
                
                if let data = data {
                    if let json = try? JSONDecoder().decode([Collection].self, from: data) {
                        
                        self.quizData = json
                        self.titles = []
                        self.subtitles = []
                        
                        for collection in json {
                            self.titles.append(collection.title)
                            self.subtitles.append(collection.desc)
                        }

                        if directory != nil {
                            let filePath = directory?.appendingPathComponent(fileName)
                            do {
                                try data.write(to: filePath!, options: .atomic)
                            } catch {
                                self.alertController("can't save data")
                            }
                        } else {
                            self.alertController("can't find data")
                        }
                    }
                    DispatchQueue.main.async{
                        self.tableView.reloadData()
                    }
                } else {
                    self.alertController("can't parse data")
                    return
                }
            }.resume()
            
        } else { // no internet
            
            alertController("network not available")
            
            DispatchQueue.global(qos: .userInitiated).async {
                if directory != nil {
                    let filePath = directory?.appendingPathComponent(fileName)
                    var data: Data? = nil
                    do {
                        try data = Data(contentsOf: filePath!)
                    } catch {
                        NSLog(error.localizedDescription)
                    }
                    
                    if data != nil && data!.count > 0 {
                        if let json = try? JSONDecoder().decode([Collection].self, from: data!) {
                            DispatchQueue.main.async {
                                self.quizData = json
                                self.titles = []
                                self.subtitles = []
                                for collection in json {
                                    self.titles.append(collection.title)
                                    self.subtitles.append(collection.desc)
                                }
                                self.tableView?.reloadData()
                            }
                        } else {
                            self.alertController("can't load local data")
                            return
                        }
                    } else {
                        self.alertController("can't find local data")
                        return
                    }
                }
            }
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = tableView.indexPathForSelectedRow{
            let questionVC = segue.destination as! QuestionViewController
            questionVC.topicSection = indexPath.row
            questionVC.quizData = quizData
            questionVC.urlString = urlString
        }
    }
    
    @objc func refresh(sender: Any?) {
        loadData(urlString)
        self.refreshControl.endRefreshing()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if quizData == nil {
            loadData(urlString)
        }
    }
}
