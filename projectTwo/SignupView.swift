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
    @IBAction func signupTapped(_ sender: UIButton) {
    let request = NSMutableURLRequest(url: NSURL(string: "http://localhost:8888/orgReg.php")! as URL)
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
        let alertController = UIAlertController(title: "User's Detail", message: "Successfully Added", preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default,handler: nil))
        self.present(alertController, animated: true, completion: nil)
        nameTextF.text = ""
        userNameTextF.text = ""
        passTextF.text = ""
        nameTextF.becomeFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messageLabel.alpha = 0
        nameTextF.delegate = self
        nameTextF.becomeFirstResponder()

        
    }
    
    
    
    
}
