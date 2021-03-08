
import UIKit
import Alamofire

class ViewController: UIViewController {
    
    var feedItems: NSArray = NSArray()
    var log = [logdetails]()
    var mail_add: String?
    var userrname:String?
    @IBOutlet weak var userText: UITextField!
    @IBOutlet weak var passText: UITextField!
    @IBOutlet weak var logBtn: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBAction func logBtnTapped(_ sender: UIButton) {
        self.showSpinner(onView: self.view)
        let parameters: Parameters = ["username":userText.text!,"password":passText.text!]
         //   activityindicator.isHidden = false
         //   activityindicator.startAnimating()
           // print("checkuser : \(checkuser)")
            if userText.text!.trimmingCharacters(in: .whitespaces).isEmpty && passText.text!.trimmingCharacters(in: .whitespaces).isEmpty{
                let alert = UIAlertController(title: "Alert", message: "Fill all the fields", preferredStyle: UIAlertController.Style.alert)
                let cancel = UIAlertAction(title: "Ok", style: .cancel) { (action) -> Void in
                  }
                alert.addAction(cancel)
                present(alert, animated: true, completion: nil)
                self.removeSpinner()
            }else {
              AF.request("https://appstudio.co/iOS/login.php", method: .post, parameters: parameters).responseJSON
              {[self]Response in
                if let result = Response.value{
                  let jsonData = result as! NSDictionary
                  print("jsonData : \(jsonData.allValues)")
                  for i in jsonData.allValues{
                    if i as! String == "success"{
                        if userText.text == "ad@admin.com"{
                       
                       //   userText.text = ""
                      //    passText.text = ""
                       //   activityindicator.stopAnimating()
                       //   activityindicator.isHidden = true
                    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyBoard.instantiateViewController(withIdentifier: "AdView") as! AdminViewController
                                      // vc.pushViewController(vc, animated: true)
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: true, completion: nil)
                    vc.listnames = userText.text
                        }else{
                         
                         // userText.text = ""
                         // passText.text = ""
                      //    activityindicator.stopAnimating()
                       //   activityindicator.isHidden = true
                        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        let navigationController = storyBoard.instantiateViewController(withIdentifier: "HomeNavigationContoller") as! UINavigationController
                        let vc = storyBoard.instantiateViewController(withIdentifier: "HomeView") as! TableViewController
                        navigationController.pushViewController(vc, animated: true)
                        navigationController.modalPresentationStyle = .fullScreen
                        self.present(navigationController, animated: true, completion: nil)
                        vc.getusername = userText.text
                            
                        }
                    }else if i as! String == "failure"{
                   //   activityindicator.stopAnimating()
                 //     activityindicator.isHidden = true
                      let alert = UIAlertController(title: "Alert", message: "Check Username and Password", preferredStyle: UIAlertController.Style.alert)
                      let cancel = UIAlertAction(title: "Ok", style: .cancel) { (action) -> Void in
                        }
                      alert.addAction(cancel)
                      present(alert, animated: true, completion: nil)
                        self.removeSpinner()
                    }}}}}

    }
        
    
    @IBAction func signupBtnTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier :"signupPass") as! SignupView
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        errorLabel.alpha = 0
       downloadItems()
        self.removeSpinner()
        //requestPost()
    }
  
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "HomeView" {
            let user = segue.destination as! TableViewController
            user.getusername = userrname
            }
        
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
            if let Username = jsonElement["username"] as? String,
            let Password = jsonElement["password"] as? String
                {
                print(Username)
                print(Password)
                log.append(logdetails(username: Username, password: Password))
               //log.username = Username
              // log.password = Password
                }
            }
            
        DispatchQueue.main.async(execute: { [self] () -> Void in
        itemsDownloaded(items: stocks)
            })
        }

    
    func requestPost () {
        var request = URLRequest(url: URL(string: "https://appstudio.co/iOS/login1.php")!)
        request.httpMethod = "GET"
        let postString = "username=\(userText.text as! String)&password=\(passText.text as! String)"
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("error=\(error)")
                return
            }
            
            if let array = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [[String:Any]],
               let obj = array.first {
                 let username = obj["username"] as? String
                     let pass = obj["password"] as? String
                 DispatchQueue.main.async {
                    self.log.append(logdetails(username: username, password: pass))
               //     self.log.username = username
               //     self.log.password = pass
                 }}}
            task.resume()
            }
    
    func downloadItems() {
   /* let urlPath = "https://appstudio.co/iOS/login.php"
        let url: URL = URL(string: urlPath)!
        let defaultSession = Foundation.URLSession(configuration: URLSessionConfiguration.default)
        let task = defaultSession.dataTask(with: url) { (data, response, error) in
        if error != nil {
        print("Error")
        }else {
        print("stocks downloaded")
        self.parseJSON(data!)
        }}
        task.resume()*/
    let request = NSMutableURLRequest(url: NSURL(string: "https://appstudio.co/iOS/login1.php")! as URL)
        request.httpMethod = "POST"
        let postString = "username=\(userText.text as! String)&password=\(passText.text as! String)"
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
   
    
    func itemsDownloaded(items: NSArray) {
        feedItems = items
}}


struct logdetails {
    var username:String?
    var password:String?
}
