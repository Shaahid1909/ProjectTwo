
import UIKit
import Alamofire

class TableViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    
    
let urlPath = "http://localhost:8888/Retrieve_1.php"

    @IBOutlet weak var tableView: UITableView!
    
    
    var feedItems: NSArray = NSArray()
    var selectedStock : StockModel = StockModel()
    var insert = [insertData]()
    override func viewDidLoad() {
    super.viewDidLoad()
    tableView.delegate = self
    tableView.dataSource = self
    downloadItems()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return insert.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
    cell.Task1.text = insert[indexPath.row].TaskName
    cell.taskCheck.tag = indexPath.row
    cell.taskCheck.addTarget(self, action: #selector(cellbtntapped(sender:)), for: .touchUpInside)
    if insert[indexPath.row].TaskStatus == "Pending"{
    cell.Button.setImage(#imageLiteral(resourceName: "Unchecked"), for: .normal)
    } else{
        cell.Button.setImage(#imageLiteral(resourceName: "Checked"), for: .normal)
        }
            return cell
        }

    @IBAction func Add(_ sender: Any) {
        var textField = UITextField()
            let alert = UIAlertController(title: "Add your Task", message: "", preferredStyle: UIAlertController.Style.alert)
            let action = UIAlertAction(title: "Add", style: UIAlertAction.Style.default) { [self](action) in
            let request = NSMutableURLRequest(url: NSURL(string: "http://localhost:8888/Task.php")! as URL)
            request.httpMethod = "POST"
            let postString = "TaskName=\(textField.text!)&TaskStatus=Pending"
            request.httpBody = postString.data(using: String.Encoding.utf8)
            let task1 = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            if error != nil {
            print("error=\(String(describing: error))")
            return
            }
            print("response = \(String(describing: response))")
            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print("responseString = \(String(describing: responseString))")
            }
            task1.resume()
            let task = insertData(TaskName: textField.text!, TaskStatus: "pending")
            self.insert.append(task)
            self.tableView.reloadData()
            let alertController = UIAlertController(title: "Task", message: "Task Added", preferredStyle: UIAlertController.Style.alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default,handler: nil))
            self.present(alertController, animated: true, completion: nil)
            }
            let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
            }
            alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new task"
            textField = alertTextField
            }
            alert.addAction(action)
            alert.addAction(cancel)
            present(alert, animated: true, completion: nil)
            }

    @objc func cellbtntapped(sender:UIButton){
        let tag = sender.tag
        let indexPath = IndexPath(row: tag, section: 0)
        let id = insert[indexPath.row]
        if sender.isSelected{
        sender.isSelected = false
        sender.setImage(#imageLiteral(resourceName: "Unchecked"), for: .normal)
        print("Checked Deselected")
        let request = NSMutableURLRequest(url: NSURL(string: "http://localhost:8888/update.php")! as URL)
        request.httpMethod = "POST"
        let postString = "TaskName=\(id.TaskName as! String)&TaskStatus=Pending"
        request.httpBody = postString.data(using: String.Encoding.utf8)
        let task1 = URLSession.shared.dataTask(with: request as URLRequest) {
        data, response, error in
        if error != nil {
        print("error=\(String(describing: error))")
        return
        }
        print("response = \(String(describing: response))")
        let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
        print("responseString = \(String(describing: responseString))")
        }
        task1.resume()
        }else{
        
            sender.isSelected = true
            sender.setImage(#imageLiteral(resourceName: "Checked"), for: .normal)
            print("Checked Selected")
            let request = NSMutableURLRequest(url: NSURL(string: "http://localhost:8888/update.php")! as URL)
            request.httpMethod = "POST"
            let postString = "TaskName=\(id.TaskName as! String)&TaskStatus=Completed"
            request.httpBody = postString.data(using: String.Encoding.utf8)
            let task1 = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            if error != nil {
            print("error=\(String(describing: error))")
            return
                }
                print("response = \(String(describing: response))")
                let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                print("responseString = \(String(describing: responseString))")
            }
            task1.resume()
          }
          }
    
    func itemsDownloaded(items: NSArray) {
        feedItems = items
        self.tableView.reloadData()

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
                if let TaskName = jsonElement["TaskName"] as? String,
                    let TaskStatus = jsonElement["TaskStatus"] as? String
                {
                    print(TaskName)
                    print(TaskStatus)
                    stock.TaskName = TaskName
                    stock.TaskStatus = TaskStatus
                    insert.append(insertData(TaskName: TaskName, TaskStatus: TaskStatus))
                }
                stocks.add(stock)
            }
        DispatchQueue.main.async(execute: { [self] () -> Void in
            itemsDownloaded(items: stocks)
            })
        }
    
    func downloadItems() {
        let url: URL = URL(string: urlPath)!
        let defaultSession = Foundation.URLSession(configuration: URLSessionConfiguration.default)
        let task = defaultSession.dataTask(with: url) { (data, response, error) in
        if error != nil {
        print("Error")
            }else {
        print("stocks downloaded")
        self.parseJSON(data!)
            }}
        task.resume()
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

        if editingStyle == .delete {
        insert.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
      
         


        }
    }
    
    
    
}

struct insertData {
    var TaskName:String?
    var TaskStatus:String?
}

