
import UIKit
//import Alamofire

class ViewController: UIViewController {
    
    var feedItems: NSArray = NSArray()
    var selectedStock : StockModel = StockModel()
    var log = [logdetails]()
    var userrname:String?
    
    @IBOutlet weak var userText: UITextField!
    @IBOutlet weak var passText: UITextField!
    @IBOutlet weak var logBtn: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBAction func logBtnTapped(_ sender: UIButton) {
        if userText.text?.isEmpty != true && passText.text?.isEmpty != true{
       for Verify in log{
              if userText.text == Verify.username && passText.text == Verify.password{
                print("Log in successful \(Verify.username) \(Verify.password) \(Verify.password)")
              let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let navigationController = storyBoard.instantiateViewController(withIdentifier: "HomeNavigationContoller") as! UINavigationController
                let vc = storyBoard.instantiateViewController(withIdentifier: "HomeView") as! TableViewController
                navigationController.pushViewController(vc, animated: true)
                navigationController.modalPresentationStyle = .fullScreen
                self.present(navigationController, animated: true, completion: nil)
             
                vc.getusername = userText.text
              
              }else{
                print("Failed Error")
                
              }
       }
          //  let alertController = UIAlertController(title: "Alert", message: "Incorrect Credentials", preferredStyle: UIAlertController.Style.alert)
       //     alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default,handler: nil))
          //  self.present(alertController, animated: true, completion: nil)
         //   print("Login fail")
            }else{
                let alert = UIAlertController(title: "Alert", message: "Fill All Fields", preferredStyle: UIAlertController.Style.alert)
                let cancel = UIAlertAction(title: "Ok", style: .cancel) { (action) -> Void in
                  }
                alert.addAction(cancel)
                present(alert, animated: true, completion: nil)
              }
    }
        
 /*       let request = NSMutableURLRequest(url: NSURL(string: "http://localhost:8888/checklog.php")! as URL)
        request.httpMethod = "POST"
        let postString = "username=\(userText.text as! String)&password=\(passText.text as! String)"
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
    */
    
 
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        errorLabel.alpha = 0
        downloadItems()
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
            let stock = StockModel()
            if let Username = jsonElement["username"] as? String,
            let Password = jsonElement["password"] as? String
                {
                print(Username)
                print(Password)
                log.append(logdetails(username: Username, password: Password))
                
                
                print(log)
                }
                stocks.add(stock)
            }
            
        DispatchQueue.main.async(execute: { [self] () -> Void in
        itemsDownloaded(items: stocks)
            })
        }
    
    func downloadItems() {
        let urlPath = "https://appstudio.co/iOS/login.php"
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
   
    
    
    func itemsDownloaded(items: NSArray) {
        feedItems = items
    }}

struct logdetails {
    var username:String?
    var password:String?
}
