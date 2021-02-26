//
//  UserViewController.swift
//  projectTwo
//
//  Created by Admin Mac on 25/02/21.
//
import UIKit

class UserViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
   
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var name:String?
    var username:String?
    var userTask = [userTasks]()
    var feedItems: NSArray = NSArray()
    var selectedStock : StockModel = StockModel()
    let stock = StockModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        nameLabel.text = username
        downloadItems()
    }
    
    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userTask.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserTableViewCell", for: indexPath) as! UserTableViewCell
        cell.TaskName.text = userTask[indexPath.row].TaskName
        cell.TaskStatus.text = userTask[indexPath.row].TaskStatus
        print("The name is :\(cell.TaskName.text)")
        print("The status is :\(cell.TaskStatus.text)")
        return cell
    }
    
    func itemsDownloaded(items: NSArray) {
        feedItems = items
        self.tableView.reloadData()
    }
    
    func downloadItems() {
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://appstudio.co/iOS/Retrieve_1.php")! as URL)
        request.httpMethod = "POST"
        let postString = "username=\(username as! String)"
        print("postString \(postString)")
        request.httpBody = postString.data(using: String.Encoding.utf8)
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            if error != nil {
                print("error=\(String(describing: error))")
                return
            }
            self.parseJSON(data!)
            print("response = \(String(describing: response))")
            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print("responseString = \(String(describing: responseString))")
        }
        task.resume()
    }
    
    func parseJSON(_ data:Data) {
            var jsonResult = NSArray()
            do{
                jsonResult = try JSONSerialization.jsonObject(with: data, options:JSONSerialization.ReadingOptions.allowFragments) as! NSArray
            } catch let error as NSError {
                print(error)
            }
            var jsonElement = NSDictionary()
            let stocks = NSMutableArray()
            for i in 0 ..< jsonResult.count
            {
                jsonElement = jsonResult[i] as! NSDictionary
                let stock = StockModel()
                //the following insures none of the JsonElement values are nil through optional binding
                print("jsonElement \(jsonElement["Id"] as? String)")
                if let TaskName = jsonElement["Taskname"] as? String,
                   let TaskStatus = jsonElement["TaskStatus"] as? String,let Id = jsonElement["Id"] as? String
                {
                    userTask.append(userTasks(TaskName: TaskName, TaskStatus: TaskStatus, Id: Id))
                    print(userTask)
                }
                stocks.add(stock)
            }
            
        DispatchQueue.main.async(execute: { [self] () -> Void in
            itemsDownloaded(items: stocks)
            })
        }}

struct userTasks {
    var TaskName:String!
    var TaskStatus:String!
    var Id:String!
}
