//
//  AdminViewController.swift
//  projectTwo
//
//  Created by Admin Mac on 24/02/21.
//

import UIKit

class AdminViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
 
    @IBOutlet weak var tabView: UITableView!
    var adData = [AdminData]()
    var listnames: String?
    var keyValue:[String:String] = [:]
    var pendingcount:[String:String] = [:]
    var completedcount:[String:String] = [:]
    var pendintasks:[String] = []
    var namelist:[String] = []
    var selectedname : String?
    var selectedusername : String?
    var didselect: Bool = false
   
    override func viewDidLoad() {
        super.viewDidLoad()
        downloadItems()
        tabView.delegate = self
        tabView.dataSource = self
        // Do any additional setup after loading the view.
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return keyValue.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "adcell", for: indexPath) as! AdminCell
        for (keys,values) in pendingcount{
            if adData[indexPath.row].username == keys{
                cell.pendingLab.text = "\(pendintasks[indexPath.row] as! String)"
                print("\(adData[indexPath.row].counttask)")
            }
        }
        for (keys,values) in completedcount{
            if adData[indexPath.row].username == keys{
                cell.completeLab.text = "\(adData[indexPath.row].counttask as! String)"
                print("completedcount \(adData[indexPath.row].counttask)")
            }

        }
        for (keys,values) in keyValue{
            if adData[indexPath.row].username == keys{
                cell.userLab.text = adData[indexPath.row].name
            }
        }
        
        return cell
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
            print("jsonElement : \(jsonElement)")
            let stock = StockModel()
            print("\(jsonElement["CountTask"] as? String) : \(jsonElement["TaskStatus"] as! String)")
            
            if jsonElement["TaskStatus"] as? String == "Completed"{
                completedcount.updateValue(jsonElement["TaskStatus"] as! String, forKey: jsonElement["username"] as! String)
        

            }else{
                print("*** Pending : \(jsonElement["CountTask"] as! String) : \(jsonElement["TaskStatus"] as! String) ***")
                pendingcount.updateValue(jsonElement["TaskStatus"] as! String, forKey: jsonElement["username"] as! String)
                pendintasks.append(jsonElement["CountTask"] as! String)
                
            }
            if let name = jsonElement["name"] as? String,
               let TaskStatus = jsonElement["TaskStatus"] as? String,
               let taskcount = jsonElement["CountTask"] as? String,
               let username = jsonElement["username"] as? String
            {
                adData.append(AdminData(name: name,username: username,counttask: taskcount))
                keyValue.updateValue(jsonElement["name"] as! String, forKey: jsonElement["username"] as! String)
            }
            stocks.add(stock)
        }
    let groupByCategory = Dictionary(grouping: adData) { (device) -> String in
        return device.name!
    }
    //AdminData.append(contentsOf: groupByCategory.keys)
        DispatchQueue.main.async(execute: { [self] () -> Void in
                itemsDownloaded(items: stocks)
        })
        }
    
    
    func itemsDownloaded(items: NSArray) {
        self.tabView.reloadData()
      }
    
    func downloadItems() {
        let request = NSMutableURLRequest(url: NSURL(string: "https://appstudio.co/iOS/Admin.php")! as URL)
            request.httpMethod = "POST"
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
              data, response, error in
              if error != nil {
                print("error=\(String(describing: error))")
                return
              }
              self.parseJSON(data!)
              print("response = \(String(describing: response))")
            print("The data is: \(data)")
              let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
              print("responseString = \(String(describing: responseString))")
            }
            task.resume()
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didselect = true
        selectedname = adData[indexPath.row].name as! String
        selectedusername = adData[indexPath.row].username as! String
        performSegue(withIdentifier: "didSelectpass", sender: self)
      }
    
    
      override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "didSelectpass"{
          if let viewController: UserViewController = segue.destination as? UserViewController {
            viewController.name = selectedname
            viewController.username = selectedusername
           }
        }
      }
 
    
    
}
struct AdminData {
    var name: String?
    var username: String?
    var counttask:String?
    var pendingtask:String?
    
    
}
