
import UIKit
import Alamofire

class TableViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,UISearchBarDelegate{
    
    var getusername:String?
    var urlpath:String?

    @IBOutlet weak var tableView: UITableView!
    private let button = UIButton(type: UIButton.ButtonType.custom) as UIButton
    var feedItems: NSArray = NSArray()
    var insert = [insertData]()
    var seinsert = [insertData]()
    var didselect:String?
    var oldTaskname:String?
    var sdateSelect: String?
    var edateSelect: String?
    var stextField = UITextField()
    var etextField = UITextField()
    var start_end_date = UIDatePicker()
    let endDate = UIDatePicker()
    var start_end_date1 = UIDatePicker()
    let endDate1 = UIDatePicker()
    var start_end_date2 = UIDatePicker()
    var endDate2 = UIDatePicker()
    var sdateSelect1: String?
    var edateSelect1: String?
    var stextField1 = UITextField()
    var etextField1 = UITextField()
    var textField = UITextField()
    @IBOutlet var sepopView: UIView!
    
    @IBOutlet weak var searbar: UISearchBar!
    
    
    
    @IBOutlet weak var conView: UIView!
    
    @IBAction func logout(_ sender: Any) {
        self.showSpinner(onView: self.view)
        let parameters: Parameters=["logout":"logout"]
                AF.request("https://appstudio.co/iOS/logout.php", method: .get, parameters: parameters).responseJSON
                {[self]Response in
                    if let result = Response.value{
                        let jsonData = result as! NSDictionary
                        print("jsonData : \(jsonData.allValues)")
                        for i in jsonData.allValues{
                            print("Response Status : \(i)")
                            if i as! String == "Success"{
                                performSegue(withIdentifier: "Logout", sender: self)
                            }else{
                            let alert = UIAlertController(title: "Alert", message: "Logout Failed", preferredStyle: UIAlertController.Style.alert)
                            let cancel = UIAlertAction(title: "Ok", style: .cancel) { (action) -> Void in
                                }
                            alert.addAction(cancel)
                            present(alert, animated: true, completion: nil)
                            }
                        }
                    }
                }
    }

    
    @IBAction func AllTaskBtntap(_ sender: Any) {
     
        urlpath?.removeAll()
        insert.removeAll()
        urlpath = "https://appstudio.co/iOS/Retrieve_1.php"
        downloadItems()
        tableView.reloadData()
        Vieww.isHidden = true
   
    }

        @IBOutlet var Vieww: UIView!
         
        @IBAction func Completed(_ sender: UIButton) {
        
         urlpath?.removeAll()
         insert.removeAll()
         urlpath = "https://appstudio.co/iOS/Completed.php"
         downloadItems()
         tableView.reloadData()
         Vieww.isHidden = true
            
         }
    
        @IBAction func Pending(_ sender: UIButton) {
            
         urlpath?.removeAll()
         insert.removeAll()
         urlpath = "https://appstudio.co/iOS/Pending.php"
         downloadItems()
         tableView.reloadData()
         Vieww.isHidden = true
            
         }
       @IBAction func pastBtn(_ sender: UIButton) {
   
        urlpath?.removeAll()
        insert.removeAll()
        urlpath = "https://appstudio.co/iOS/past.php"
        downloadItems()
        tableView.reloadData()
        Vieww.isHidden = true
        
    }
    
      @IBAction func TodayBtn(_ sender: UIButton) {
            
        urlpath?.removeAll()
        insert.removeAll()
        urlpath = "https://appstudio.co/iOS/Today.php"
        downloadItems()
        tableView.reloadData()
        Vieww.isHidden = true
        
         }

     @IBAction func TomorrowBtn(_ sender: Any) {
        urlpath?.removeAll()
        insert.removeAll()
        urlpath = "https://appstudio.co/iOS/Tomorrow.php"
        downloadItems()
        tableView.reloadData()
        Vieww.isHidden = true
    }
    
    override func viewDidLoad() {
    super.viewDidLoad()
        self.removeSpinner()
     
        popView.layer.cornerRadius = 10
        popView.layer.borderColor = UIColor.red.cgColor
        popView.layer.borderWidth = 0.3
        popView.bounds = CGRect(x: 0, y: 0, width: self.view.bounds.width * 0.9, height: self.view.bounds.height * 0.4)
        datepicker()
        doneselect()
        Vieww.layer.cornerRadius = 10.0
        Vieww.isHidden = true
        tableView.delegate = self
        tableView.dataSource = self
        downloadItems()
        let bottomImage = UIImage(named: "plus.png")
        let yPst = self.view.frame.size.height - 55 - 20
        button.frame = CGRect(x: 310, y: 700, width: 85, height: 85)
        button.setImage(bottomImage, for: .normal)
        button.autoresizingMask = [.flexibleTopMargin, .flexibleRightMargin]
        button.addTarget(self, action: #selector(buttonClicked(_:)), for:.touchUpInside)
        button.layer.shadowRadius = 3
        button.layer.shadowColor = UIColor.lightGray.cgColor
        button.layer.shadowOpacity = 0.9
        button.layer.shadowOffset = CGSize.zero
        button.layer.zPosition = 1
        view.addSubview(button)
        start()
        end()
        start1()
        end1()
        setUpSearchBar()
        view.addSubview(Vieww)
      //  sepopView.frame = CGRect(x: 0, y: 140, width: 414, height: -40)
        
    }
    
   
    @IBAction func droplist(_ sender: Any) {
        if Vieww.isHidden == false{
            Vieww.isHidden = true
        }else if Vieww.isHidden == true{
            Vieww.isHidden = false
        }
        animatedismiss(desiredView: popView)
    }
    

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
            let off = self.tableView.contentOffset.y
            let yPst = self.view.frame.size.height
            button.frame = CGRect(x:310, y:700, width: button.frame.size.width, height: button.frame.size.height)
        }
    
//floating button action
    @objc private func buttonClicked(_ notification: NSNotification) {
            // do something when you tapped the button
           // insert.removeAll()
                Vieww.isHidden = true
                animatedismiss(desiredView: popView)
                var textField = UITextField()
                let alert = UIAlertController(title: "Add your Task", message: "", preferredStyle: UIAlertController.Style.alert)
                let action = UIAlertAction(title: "Add", style: UIAlertAction.Style.default) { [self](action) in
                let request = NSMutableURLRequest(url: NSURL(string: "https://appstudio.co/iOS/Task.php")! as URL)
                request.httpMethod = "POST"
                    let postString = "date=\(stextField1.text!)&End_Date=\(etextField1.text!)&username=\(getusername as! String)&TaskName=\(textField.text!)&TaskStatus=Pending"
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
                    let task = insertData(TaskName:textField.text!,TaskStatus:"Pending", TaskDate: stextField1.text ,endDate: etextField1.text)
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
                alert.addTextField { [self] (textField1) in
                let toolbar=UIToolbar()
                toolbar.sizeToFit()
     //   self.start_end_date2 = UIDatePicker(frame:CGRect(x: 0, y: self.view.frame.size.height - 220, width:self.view.frame.size.width, height: 216))
    // start_end_date.datePickerMode = .date
            let done1=UIBarButtonItem(barButtonSystemItem: .done, target:self, action:#selector(start1))
            toolbar.setItems([done1], animated: false)
            textField1.inputAccessoryView=toolbar
            textField1.inputView=start_end_date1
            textField1.placeholder = "Choose Start Date"
            start_end_date1.datePickerMode = .date
            stextField1 = textField1
          }

    alert.addTextField { [self] (textField2) in
          let toolbar=UIToolbar()
          toolbar.sizeToFit()
      //      self.endDate2 = UIDatePicker(frame:CGRect(x: 0, y: self.view.frame.size.height - 220, width:self.view.frame.size.width, height: 216))
          let done2=UIBarButtonItem(barButtonSystemItem: .done, target:self, action:#selector(end1))
          toolbar.setItems([done2], animated: false)
          textField2.inputAccessoryView=toolbar
          textField2.inputView=endDate1
          textField2.placeholder = "Choose End Date"
          endDate1.datePickerMode = .date
          etextField1 = textField2
         //   endDate.datePickerMode = .date
          }
          alert.addAction(action)
          alert.addAction(cancel)
          present(alert, animated: true, completion: nil)
          }
    
    @objc func start1(){
        let dateformat=DateFormatter()
        dateformat.dateStyle = .medium
        dateformat.timeStyle = .none
        dateformat.dateFormat = "yyyy-MM-dd"
        let sdatestring = dateformat.string(from: start_end_date1.date)
        stextField1.text="\(sdatestring as! String)"
        self.view.endEditing(true)
    }

    
    @objc func end1(){
        let dateformat=DateFormatter()
        dateformat.dateStyle = .medium
        dateformat.timeStyle = .none
        dateformat.dateFormat = "yyyy-MM-dd"
        let edateString = dateformat.string(from: endDate1.date)
        etextField1.text="\(edateString as! String)"
        self.view.endEditing(true)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return insert.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
    cell.Task1.text = insert[indexPath.row].TaskName
    cell.taskCheck.tag = indexPath.row
    cell.dateBtn.text = insert[indexPath.row].TaskDate
    cell.endDate.text = insert[indexPath.row].endDate
    cell.taskCheck.addTarget(self, action: #selector(cellbtntapped(sender:)), for: .touchUpInside)
        cell.editBtn.tag = indexPath.row
        cell.editBtn.addTarget(self, action: #selector(editcellbtntapped(sender:)), for: .touchUpInside)
        let conValue = Int(insert[indexPath.row].remainDays ?? "")
        if conValue ?? 0 < 0 && insert[indexPath.row].TaskStatus == "Pending"{
            cell.remainingdays.text = "Task date exceeded by \(insert[indexPath.row].remainDays!)"
            cell.remainingdays.textColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        }else if conValue ?? 0 > 0 && insert[indexPath.row].TaskStatus == "Pending"{
            cell.remainingdays.text = "\(insert[indexPath.row].remainDays!) days more"
            cell.remainingdays.textColor = #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)
        }else if conValue ?? 0 == 0 && insert[indexPath.row].TaskStatus == "Pending"{
            cell.remainingdays.text = "Today last date!"
            cell.remainingdays.textColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        }
        
       /* else if conValue ?? 0 > 0 || conValue ?? 0 == 0 || conValue ?? 0 < 0 && insert[indexPath.row].TaskStatus == "Completed"{
            cell.remainingdays.text  = "Task Completed"
            cell.remainingdays.textColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        }*/
    if insert[indexPath.row].TaskStatus == "Pending"{
    cell.Button.setImage(#imageLiteral(resourceName: "Unchecked"), for: .normal)
    } else{
        cell.Button.setImage(#imageLiteral(resourceName: "Checked"), for: .normal)
        cell.remainingdays.text = "Task Completed"
        cell.remainingdays.textColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
    }
            return cell
    }
    
    
    @IBAction func refreshBtn(_ sender: Any) {
        insert.removeAll()
        downloadItems()
        tableView.reloadData()
    }
    
    //below code Not used
    @IBAction func Add(_ sender: Any) {
        //Namo Server: con.test:8888/db.php
        //Mamp: http://localhost:8888/db.php
            seinsert.removeAll()
            insert.removeAll()
            downloadItems()
            var textField = UITextField()
            let alert = UIAlertController(title: "Add your Task", message: "", preferredStyle: UIAlertController.Style.alert)
            let action = UIAlertAction(title: "Add", style: UIAlertAction.Style.default) { [self](action) in
            let request = NSMutableURLRequest(url: NSURL(string: "https://appstudio.co/iOS/Task.php")! as URL)
            request.httpMethod = "POST"
            let postString = "username=\(getusername as! String)&TaskName=\(textField.text!)&TaskStatus=Pending"
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
            let task = insertData(TaskName:textField.text!, TaskStatus:"Pending")
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
        let request = NSMutableURLRequest(url: NSURL(string: "https://appstudio.co/iOS/update.php")! as URL)
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
        let request = NSMutableURLRequest(url: NSURL(string: "https://appstudio.co/iOS/update.php")! as URL)
        request.httpMethod = "POST"
        let postString = "TaskName=\(id.TaskName as! String)&TaskStatus=Completed"
        request.httpBody = postString.data(using: String.Encoding.utf8)
        let task2 = URLSession.shared.dataTask(with: request as URLRequest) {
        data, response, error in
        if error != nil {
        print("error=\(String(describing: error))")
        return
        }
        print("response = \(String(describing: response))")
        let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
        print("responseString = \(String(describing: responseString))")
        }
        task2.resume()
        }
    }
    
    @objc func editcellbtntapped(sender:UIButton){
        let tag = sender.tag
        let indexPath = IndexPath(row: tag, section: 0)
        
        oldTaskname?.removeAll()
        animatedismiss(desiredView: popView)
        Vieww.isHidden = true
        didselect = "\(insert[indexPath.row].TaskName as! String)"
        sdateSelect = "\(insert[indexPath.row].TaskDate as! String)"
        edateSelect = "\(insert[indexPath.row].endDate as! String)"
        print("UpdateFunction \(Int16(insert[indexPath.row].Id as! String) as! Int16)")
            
            
            let alert = UIAlertController(title: "Edit", message: "", preferredStyle: UIAlertController.Style.alert)
            let action = UIAlertAction(title: "update", style: UIAlertAction.Style.default) { [self](action) in
            let alertController = UIAlertController(title: "Edit", message: "Successfully updated!", preferredStyle: UIAlertController.Style.alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default,handler: nil))
            self.tableView.reloadData()
    
                
                    // namo link sever "http://con.test:8888/Task.php"
            let request = NSMutableURLRequest(url: NSURL(string: "https://appstudio.co/iOS/Edit.php")! as URL)
            request.httpMethod = "POST"
                
                let postString = "username=\(getusername as! String)&TaskName=\(textField.text as! String)&TaskStatus=\(insert[indexPath.row].TaskStatus as! String)&date=\(stextField.text as! String)&End_Date=\(etextField.text as! String)&Id=\(Int16(insert[indexPath.row].Id as! String) as! Int16)"
                    print("postString : \(postString)")
                insert.removeAll()
            request.httpBody = postString.data(using: String.Encoding.utf8)
            let task = URLSession.shared.dataTask(with: request as URLRequest) {
                        data, response, error in
            if error != nil {
            print("error=\(String(describing: error))")
                            return
                        }
            print("response = \(String(describing: response))")
            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print("responseString = \(String(describing: responseString))")
                downloadItems()
            }
            task.resume()
            self.present(alertController, animated: true, completion: nil)
           
            self.tableView.reloadData()
                }
            let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
                    }
            alert.addTextField { [self] (alertTextField) in
                 alertTextField.placeholder = "Edit Task"
              alertTextField.text = didselect
                 textField = alertTextField
                }
            alert.addTextField { [self] (textField1) in
              let toolbar=UIToolbar()
              toolbar.sizeToFit()
         //   self.start_end_date2 = UIDatePicker(frame:CGRect(x: 0, y: self.view.frame.size.height - 220, width:self.view.frame.size.width, height: 216))
               // start_end_date.datePickerMode = .date
                let done1=UIBarButtonItem(barButtonSystemItem: .done, target:self, action:#selector(start))
                toolbar.setItems([done1], animated: false)
                textField1.inputAccessoryView=toolbar
                textField1.inputView=start_end_date2
                textField1.placeholder = "Edit Start Date"
                textField1.text = sdateSelect
                start_end_date2.datePickerMode = .date
                stextField = textField1
              }
 
        alert.addTextField { [self] (textField2) in
              let toolbar=UIToolbar()
              toolbar.sizeToFit()
          //      self.endDate2 = UIDatePicker(frame:CGRect(x: 0, y: self.view.frame.size.height - 220, width:self.view.frame.size.width, height: 216))
              let done2=UIBarButtonItem(barButtonSystemItem: .done, target:self, action:#selector(end))
                toolbar.setItems([done2], animated: false)
                textField2.inputAccessoryView=toolbar
                textField2.inputView=endDate2
                textField2.placeholder = "Edit End Date"
                textField2.text = edateSelect
                endDate2.datePickerMode = .date
                etextField = textField2
             //   endDate.datePickerMode = .date
              }
                alert.addAction(action)
            alert.addAction(cancel)
                present(alert, animated: true, completion: nil)
       
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
            print("The count is \(jsonResult.count)")
            jsonElement = jsonResult[i] as! NSDictionary
                //the following insures none of the JsonElement values are nil through optional binding
            if let TaskName = jsonElement["Taskname"] as? String,
            let TaskStatus = jsonElement["TaskStatus"] as? String,
            let TaskDate = jsonElement["date"] as? String,
           let Id = jsonElement["Id"] as? String,
           let TaskendDate = jsonElement["End_Date"] as? String,
            let redays = jsonElement["Remain_Days"] as? String
            {
            print(TaskName)
            print(TaskStatus)
                
                insert.append(insertData(TaskName: TaskName, TaskStatus: TaskStatus,TaskDate: TaskDate,Id: Id,endDate: TaskendDate, remainDays: redays))
                
                seinsert.append(insertData(TaskName: TaskName, TaskStatus: TaskStatus,TaskDate: TaskDate,Id: Id,endDate: TaskendDate, remainDays: redays))
                }
            }
        DispatchQueue.main.async(execute: { [self] () -> Void in
                itemsDownloaded(items: stocks)
        })
        }
    
    
    func itemsDownloaded(items: NSArray) {
        feedItems = items
        self.tableView.reloadData()
      }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      //  didselect?.removeAll()
       // sdateSelect?.removeAll()
       // edateSelect?.removeAll()
        oldTaskname?.removeAll()
        animatedismiss(desiredView: popView)
        Vieww.isHidden = true
        didselect = "\(insert[indexPath.row].TaskName as! String)"
        sdateSelect = "\(insert[indexPath.row].TaskDate as! String)"
        edateSelect = "\(insert[indexPath.row].endDate as! String)"
        print("UpdateFunction \(Int16(insert[indexPath.row].Id as! String) as! Int16)")
            
            
            let alert = UIAlertController(title: "Edit", message: "", preferredStyle: UIAlertController.Style.alert)
            let action = UIAlertAction(title: "update", style: UIAlertAction.Style.default) { [self](action) in
            let alertController = UIAlertController(title: "Edit", message: "Successfully updated!", preferredStyle: UIAlertController.Style.alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default,handler: nil))
            self.tableView.reloadData()
    
                
                    // namo link sever "http://con.test:8888/Task.php"
            let request = NSMutableURLRequest(url: NSURL(string: "https://appstudio.co/iOS/Edit.php")! as URL)
            request.httpMethod = "POST"
                
                let postString = "username=\(getusername as! String)&TaskName=\(textField.text as! String)&TaskStatus=\(insert[indexPath.row].TaskStatus as! String)&date=\(stextField.text as! String)&End_Date=\(etextField.text as! String)&Id=\(Int16(insert[indexPath.row].Id as! String) as! Int16)"
                    print("postString : \(postString)")
                insert.removeAll()
                seinsert.removeAll()
            request.httpBody = postString.data(using: String.Encoding.utf8)
            let task = URLSession.shared.dataTask(with: request as URLRequest) {
                        data, response, error in
            if error != nil {
            print("error=\(String(describing: error))")
                            return
                        }
            print("response = \(String(describing: response))")
            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print("responseString = \(String(describing: responseString))")
                downloadItems()
            }
            task.resume()
            self.present(alertController, animated: true, completion: nil)
           
            self.tableView.reloadData()
                }
            let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
                    }
            alert.addTextField { [self] (alertTextField) in
                 alertTextField.placeholder = "Edit Task"
              alertTextField.text = didselect
                 textField = alertTextField
                }
            alert.addTextField { [self] (textField1) in
              let toolbar=UIToolbar()
              toolbar.sizeToFit()
         //   self.start_end_date2 = UIDatePicker(frame:CGRect(x: 0, y: self.view.frame.size.height - 220, width:self.view.frame.size.width, height: 216))
               // start_end_date.datePickerMode = .date
                let done1=UIBarButtonItem(barButtonSystemItem: .done, target:self, action:#selector(start))
                toolbar.setItems([done1], animated: false)
                textField1.inputAccessoryView=toolbar
                textField1.inputView=start_end_date2
                textField1.placeholder = "Edit Start Date"
                textField1.text = sdateSelect
                start_end_date2.datePickerMode = .date
                stextField = textField1
              }
 
        alert.addTextField { [self] (textField2) in
              let toolbar=UIToolbar()
              toolbar.sizeToFit()
          //      self.endDate2 = UIDatePicker(frame:CGRect(x: 0, y: self.view.frame.size.height - 220, width:self.view.frame.size.width, height: 216))
              let done2=UIBarButtonItem(barButtonSystemItem: .done, target:self, action:#selector(end))
                toolbar.setItems([done2], animated: false)
                textField2.inputAccessoryView=toolbar
                textField2.inputView=endDate2
                textField2.placeholder = "Edit End Date"
                textField2.text = edateSelect
                endDate2.datePickerMode = .date
                etextField = textField2
             //   endDate.datePickerMode = .date
              }
                alert.addAction(action)
            alert.addAction(cancel)
                present(alert, animated: true, completion: nil)
       
    }
    
    @IBOutlet var popView: UIView!
    @IBOutlet weak var taskField: UITextField!
    @IBOutlet weak var dateField: UITextField!
    @IBOutlet weak var endDateField: UITextField!
    
    
    func downloadItems() {
        let request = NSMutableURLRequest(url: NSURL(string: urlpath ?? "https://appstudio.co/iOS/Retrieve_1.php")! as URL)
            request.httpMethod = "POST"
            let postString = "username=\(getusername as! String)"
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

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let id2 = insert[indexPath.row]
           if editingStyle == .delete {
           insert.remove(at: indexPath.row)
           tableView.deleteRows(at: [indexPath], with: .fade)
            let request = NSMutableURLRequest(url: NSURL(string: "https://appstudio.co/iOS/delete.php")! as URL)
            request.httpMethod = "POST"
            let postString = "TaskName=\(id2.TaskName as! String)"
            request.httpBody = postString.data(using: String.Encoding.utf8)
            let task3 = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            if error != nil {
            print("error=\(String(describing: error))")
            return
            }
            print("response = \(String(describing: response))")
            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print("responseString = \(String(describing: responseString))")
            }
            task3.resume()
        }
    }
    
    func datepicker(){
        let toolbar=UIToolbar()
        toolbar.sizeToFit()
        let done=UIBarButtonItem(barButtonSystemItem: .done, target:nil, action:#selector(doneselect))
        toolbar.setItems([done], animated: false)
        dateField.inputAccessoryView=toolbar
        dateField.inputView=start_end_date
        start_end_date.datePickerMode = .date
        endDateField.inputAccessoryView=toolbar
        endDateField.inputView=endDate
        endDate.datePickerMode = .date
    }
    
    @objc func doneselect(){
        let dateformat=DateFormatter()
        dateformat.dateStyle = .medium
        dateformat.timeStyle = .none
        dateformat.dateFormat = "yyyy-MM-dd"
        let datestring = dateformat.string(from: start_end_date.date)
        dateField.text="\(datestring)"
        let enddateString = dateformat.string(from: endDate.date)
        endDateField.text="\(enddateString)"
        self.view.endEditing(true)
    }
    

    @objc func start(){
        let dateformat=DateFormatter()
        dateformat.dateStyle = .medium
        dateformat.timeStyle = .none
        dateformat.dateFormat = "yyyy-MM-dd"
        let sdatestring = dateformat.string(from: start_end_date2.date)
        stextField.text="\(sdatestring as! String)"
        self.view.endEditing(true)
    }

    
    @objc func end(){
        let dateformat=DateFormatter()
        dateformat.dateStyle = .medium
        dateformat.timeStyle = .none
        dateformat.dateFormat = "yyyy-MM-dd"
        let edateString = dateformat.string(from: endDate2.date)
        etextField.text="\(edateString as! String)"
        self.view.endEditing(true)
    }
    
    
    func animateIn(desiredView:UIView){
        let backgroundView = self.view
        backgroundView?.addSubview(desiredView)
        desiredView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        desiredView.alpha = 0
        desiredView.center = backgroundView?.center as! CGPoint
        UIView.animate(withDuration: 0.3, animations: {
        desiredView.transform = CGAffineTransform(scaleX: 1.0 , y: 1.0)
        desiredView.alpha = 1
        })
    }
    
    
    
    
    func  animatedismiss(desiredView:UIView){
        UIView.animate(withDuration: 0.3, animations: {
            desiredView.transform = CGAffineTransform(scaleX: 1.0 , y: 1.0)
            desiredView.alpha = 0
        },completion: { _ in desiredView.removeFromSuperview()} )
    }
    
    
    @IBAction func addTask(_ sender: Any) {
        insert.removeAll()
        seinsert.removeAll()
        animatedismiss(desiredView: popView)
        let request = NSMutableURLRequest(url: NSURL(string: "https://appstudio.co/iOS/Task.php")! as URL)
        request.httpMethod = "POST"
        let postString = "date=\(dateField.text!)&End_Date=\(endDateField.text!)&username=\(getusername!)&TaskName=\(taskField.text!)&TaskStatus=Pending"
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
            self.downloadItems()
        }
        task1.resume()

   //   let task = insertData(TaskName:taskField.text!, TaskStatus:"Pending",TaskDate: dateField.text,endDate: endDateField.text)
    //  self.insert.append(task)
   //   insert.removeAll()
   //   downloadItems()
        taskField.text = ""
        dateField.text = ""
        endDateField.text = ""
        self.tableView.reloadData()
        
    }
    
    @IBAction func animatedout(_ sender: Any) {
    animatedismiss(desiredView: popView)
    }
    
    @IBAction func addtodo(_ sender: Any) {
        animateIn(desiredView: popView)
        Vieww.isHidden = true
    }

    
private func setUpSearchBar() {
    searbar.delegate = self
    }
func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
   // animatedismiss(desiredView: sepopView)
    searbar.text = ""
          }

func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    return searbar
    }

func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
  return UITableView.automaticDimension
    }
          
func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
  
  guard !searchText.isEmpty else{
    insert = seinsert
      tableView.reloadData()
      return
    }
    insert = seinsert.filter({ insertData -> Bool in
        insertData.TaskName.contains(searchText)
    })
    tableView.reloadData()
    }
    
        }

    struct insertData {
    var TaskName:String
    var TaskStatus:String?
    var TaskDate: String?
    var Id:String?
    var endDate: String?
    var remainDays: String?
}

