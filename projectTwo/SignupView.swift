//
//  SignupView.swift
//  projectTwo
//
//  Created by Admin Mac on 12/02/21.
//

import UIKit
//import Alamofire

class SignupView: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var nameTextF: UITextField!
    @IBOutlet weak var userNameTextF: UITextField!
    @IBOutlet weak var passTextF: UITextField!
    @IBOutlet weak var SignupBtn: UIButton!
    @IBOutlet weak var messageLabel: UILabel!
    var exist: String?
    var mail_Add:String?
    var signup = [signdt]()


    var feedItems: NSArray = NSArray()
    var selectedStock : StockModel = StockModel()
    
    
    
    @IBAction func signupTapped(_ sender: UIButton) {
        Verify()
        if !nameTextF.text!.trimmingCharacters(in: .whitespaces).isEmpty && !userNameTextF.text!.trimmingCharacters(in: .whitespaces).isEmpty && !passTextF.text!.trimmingCharacters(in: .whitespaces).isEmpty  {
            if exist != "Matching"{
           
       let request = NSMutableURLRequest(url: NSURL(string: "https://appstudio.co/iOS/orgReg.php")! as URL)
       request.httpMethod = "POST"
       let postString = "name=\(nameTextF.text!)&username=\(userNameTextF.text!)&password=\(passTextF.text!)"
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
        }
        task.resume()
       /* let alertController = UIAlertController(title: "User's Detail", message: "Successfully Added", preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default,handler: nil))
        self.present(alertController, animated: true, completion: nil)*/
            
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let navigationController = storyBoard.instantiateViewController(withIdentifier: "HomeNavigationContoller") as! UINavigationController
        let vc = storyBoard.instantiateViewController(withIdentifier: "HomeView") as! TableViewController
        navigationController.pushViewController(vc, animated: true)
        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController, animated: true, completion: nil)
        vc.getusername = userNameTextF.text
        nameTextF.text = ""
        userNameTextF.text = ""
        passTextF.text = ""
        nameTextF.becomeFirstResponder()
            }
    else{
                  print("Failed Error")
                let alert = UIAlertController(title: "Alert", message: "User already exists", preferredStyle: UIAlertController.Style.alert)
                let cancel = UIAlertAction(title: "Ok", style: .cancel) { (action) -> Void in
                  }
                alert.addAction(cancel)
                present(alert, animated: true, completion: nil)
              }

       } else {
           /* let alert = UIAlertController(title: "Alert", message: "Fill All Fields", preferredStyle: UIAlertController.Style.alert)
            let cancel = UIAlertAction(title: "Ok", style: .cancel) { (action) -> Void in */
            let alert = UIAlertController(title: "Alert", message: "Fill All Fields", preferredStyle: UIAlertController.Style.alert)
            let cancel = UIAlertAction(title: "Ok", style: .cancel) { (action) -> Void in
              }
            alert.addAction(cancel)
            present(alert, animated: true, completion: nil)
            nameTextF.text = ""
            userNameTextF.text = ""
            passTextF.text = ""
            nameTextF.becomeFirstResponder()
}
    }
    func Verify(){
            for Verified in signup{
            print("Verified : \(Verified)")
                if Verified.username as! String == userNameTextF.text as! String{
                    exist = "Matching" as! String
                    print("Verify : \(Verified.name) \(userNameTextF.text as! String)")
                }
            }
        }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messageLabel.alpha = 0
        nameTextF.delegate = self
        nameTextF.becomeFirstResponder()
        downloadItems()

    }
    
 //   func exists(){
  //      if signup.isEmpty == false{
    //      exist = "matching"
    //    }
   //   }
    
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
                //the following insures none of the JsonElement values are nil through optional binding
            let stock = StockModel()
            if let Name = jsonElement["name"] as? String,
            let userName = jsonElement["username"] as? String,
            let Password = jsonElement["password"] as? String            {
                signup.append(signdt(name: Name, username: userName, password: Password))
                }
                stocks.add(stock)
            }
        DispatchQueue.main.async(execute: { [self] () -> Void in
                itemsDownloaded(items: stocks)
        })
        }
    
    
    func itemsDownloaded(items: NSArray) {
        feedItems = items
   
      }
    
    
    func downloadItems() {
        let request = NSMutableURLRequest(url: NSURL(string: "https://appstudio.co/iOS/login1.php")! as URL)
        request.httpMethod = "POST"
        let postString = "username=\(userNameTextF.text as! String)"

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
    }}


struct signdt {
    var name:String?
    var username:String?
    var password:String?
}
