//
//  ADResetPasswordVC.swift
//  Arcane Driver
//
//  Created by Apple on 20/12/16.
//  Copyright © 2016 Apple. All rights reserved.
//

import UIKit
import Alamofire
import SwiftMessages

class ADResetPasswordVC: UIViewController,UITextFieldDelegate {

    @IBOutlet var emailtextField: HoshiTextField!
    @IBOutlet var label: UILabel!
    
    @IBOutlet var labelValidEmail: UILabel!

    @IBOutlet weak var activityView: UIActivityIndicatorView!

    @IBOutlet weak var buttonEmail: UIButton!

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var signInAPIUrl = live_Driver_url
    
    typealias jsonSTD = NSArray
    
    typealias jsonSTDAny = [String : AnyObject]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        UIApplication.shared.isIdleTimerDisabled = false

        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "arrow-left.png")!, for: .normal)
        button.addTarget(self, action: #selector(ADResetPasswordVC.profileBtn(_:)), for: .touchUpInside)
   
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
      
        let label = UILabel(frame: CGRect(x: 24, y: 5, width: 150, height: 20))
 
        label.text = "Forgot Password"
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.backgroundColor = UIColor.clear
        button.addSubview(label)
        let barButton = UIBarButtonItem(customView: button)
        self.navigationItem.leftBarButtonItem = barButton
        
        self.label.adjustsFontSizeToFitWidth = true
        
        emailtextField.returnKeyType = .done
        
        emailtextField.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ADResetPasswordVC.hidekeyboard))
        
        tapGesture.numberOfTapsRequired = 1
        view.addGestureRecognizer(tapGesture)
        
        
    }
    
    func hidekeyboard()
    {
        self.view.endEditing(true)
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField == emailtextField{
            
            emailtextField.borderActiveColor = UIColor.black
            emailtextField.borderInactiveColor = UIColor.black
            emailtextField.placeholderColor = UIColor.black
            self.labelValidEmail.isHidden = true
            
            
        }
        else{
            
            
            
        }
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        if textField == emailtextField{
            
            
        }
        else{
            
            
            
        }
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if(emailtextField == textField)
        {
           // resetAction()
            
            let status = Reach().connectionStatus()
            switch status {
            case .unknown, .offline:
                print("Not connected")
                self.activityView.stopAnimating()
                let status = MessageView.viewFromNib(layout: .StatusLine)
                status.backgroundView.backgroundColor = UIColor(red: 249.0/255.0, green: 66.0/255.0, blue: 47.0/255.0, alpha: 1.0)
                status.bodyLabel?.textColor = UIColor.white
                status.configureContent(body: "No Internet Connection!!")
                var statusConfig = SwiftMessages.defaultConfig
                statusConfig.presentationContext = .window(windowLevel: UIWindowLevelStatusBar)
                
                SwiftMessages.show(config: statusConfig, view: status)
                
            case .online(.wwan):
                print("Connected via WWAN")
                resetAction()
                
            case .online(.wiFi):
                print("Connected via WiFi")
                resetAction()
                
            }

        }
        else
        {
            
            
        }
        textField.resignFirstResponder()
        return true
    }
    func profileBtn(_ Selector: AnyObject) {
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func loginBtnAction(_ sender: Any) {
  
        self.navigationController?.pushViewController(ADSignInVC(), animated: true)
    }
    
    @IBAction func resetBtnAction(_ sender: Any) {
        
        emailtextField.resignFirstResponder()
        activityView.startAnimating()
       // resetAction()
        
        let status = Reach().connectionStatus()
        switch status {
        case .unknown, .offline:
            print("Not connected")
            self.activityView.stopAnimating()
            let status = MessageView.viewFromNib(layout: .StatusLine)
            status.backgroundView.backgroundColor = UIColor(red: 249.0/255.0, green: 66.0/255.0, blue: 47.0/255.0, alpha: 1.0)
            status.bodyLabel?.textColor = UIColor.white
            status.configureContent(body: "No Internet Connection!!")
            var statusConfig = SwiftMessages.defaultConfig
            statusConfig.presentationContext = .window(windowLevel: UIWindowLevelStatusBar)
            
            SwiftMessages.show(config: statusConfig, view: status)
            
        case .online(.wwan):
            print("Connected via WWAN")
            resetAction()
            
        case .online(.wiFi):
            print("Connected via WiFi")
            resetAction()
            
        }

    }
    
    func resetAction(){
        
        emailtextField.resignFirstResponder()
        self.buttonEmail.isEnabled = false
        
        let emailTrim = emailtextField.text?.trimmingCharacters(in: .whitespaces)
        
        if(emailTrim == ""){
            self.buttonEmail.isEnabled = true
            self.labelValidEmail.text = "Enter a Valid Email"
            self.invalidEmail()
        }
        else if (!(isValidEmail(testStr: emailTrim!))){
            
            self.buttonEmail.isEnabled = true
            self.validData()
            self.invalidEmail()
        }
        else{
            
            self.buttonEmail.isEnabled = false
            self.validData()
            resetpassword()
        }

        
    }
    
    func invalidEmail(){
        
        activityView.stopAnimating()

        self.labelValidEmail.isHidden = false

     //    emailtextField.borderActiveColor = UIColor.red
     //   emailtextField.borderInactiveColor = UIColor.red
     //   emailtextField.placeholderColor = UIColor.red
        
    }
    
    func validData(){
        
        activityView.startAnimating()

        self.labelValidEmail.isHidden = true

     //    emailtextField.borderActiveColor = UIColor.black
     //   emailtextField.borderInactiveColor = UIColor.black
     //   emailtextField.placeholderColor = UIColor.black
        
    }
    
    func isValidEmail(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func resetpassword(){
        
        self.buttonEmail.isEnabled = false
        
        activityView.startAnimating()

        
        var email1 = emailtextField.text! as String
        
//        email1 = email1.replacingOccurrences(of: "Optional(", with: "")
//        email1 = email1.replacingOccurrences(of: ")", with: "")
//        print("eee\(email1)")
        
        
        var urlstring:String = "\(signInAPIUrl)forgotPassword/email/\(email1)/"
        
        urlstring = urlstring.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!
        
        urlstring = urlstring.removingPercentEncoding!
        
        print(urlstring)
        
        self.callResetAPI(url: "\(urlstring)")
        // just modified
        
    }
    
    func callResetAPI(url : String){
        
        activityView.startAnimating()

        Alamofire.request(url).responseJSON { (response) in
            
            self.parseData(JSONData: response.data!)
            
        }
        
    }
    
    
    func parseData(JSONData : Data){
        
        do{
            
            let readableJSon = try JSONSerialization.jsonObject(with: JSONData, options: .mutableContainers) as! jsonSTD
            
            print(" !!! \(readableJSon[0])")
            
            let value = readableJSon[0] as AnyObject
            
            if let final = value.object(forKey: "status"){
                print(final)
                if(final as! String == "Success"){
                    
                    self.labelValidEmail.isHidden  = true
                    
                    self.activityView.stopAnimating()
 
                    //  self.navigationController?.pushViewController(ARSignInVC(), animated: true)
                 //   self.appDelegate.setRootViewController()
                    
                    let iconText = "" //"🤔"
                    let success = MessageView.viewFromNib(layout: .CardView)
                    success.configureTheme(.success)
                    success.configureDropShadow()
                    success.configureContent(title: "", body: "Reset link successfully sent to the email", iconText: iconText)
                    success.button?.isHidden = true
                    var successConfig = SwiftMessages.defaultConfig
                    successConfig.presentationStyle = .top
                    successConfig.presentationContext = .window(windowLevel: UIWindowLevelNormal)
                    
                    SwiftMessages.show(config: successConfig, view: success)
                    
                    self.appDelegate.callMainVC()
                    
                    self.buttonEmail.isEnabled = true
                }
                else{
                    
                    
                   /* self.labelValidEmail.isHidden  = false
                    self.labelValidEmail.text = "Email does not exist"*/
                    
                    self.buttonEmail.isEnabled = true
                    
                    self.activityView.stopAnimating()

                    let warning = MessageView.viewFromNib(layout: .CardView)
                    warning.configureTheme(.warning)
                    warning.configureDropShadow()
                    let iconText = "" //"🤔"
                    warning.configureContent(title: "", body: "Email has not registered!!", iconText: iconText)
                    warning.button?.isHidden = true
                    var warningConfig = SwiftMessages.defaultConfig
                    warningConfig.presentationContext = .window(windowLevel: UIWindowLevelStatusBar)
                    SwiftMessages.show(config: warningConfig, view: warning)
                    
                    /*let toastLabel = UILabel(frame: CGRect(x: 16.0, y: 420, width: 345, height: 30))
                    toastLabel.backgroundColor = UIColor.black
                    toastLabel.textColor = UIColor.white
                    toastLabel.textAlignment = NSTextAlignment.center;
                    self.view.addSubview(toastLabel)
                    toastLabel.text = "Email does not exist"
                    toastLabel.alpha = 1.0
                    toastLabel.layer.cornerRadius = 0;
                    toastLabel.clipsToBounds  =  true
                    
                    UIView.animate(withDuration: 4.0, delay: 0.1, options: UIViewAnimationOptions.curveEaseOut, animations: {
                        
                        toastLabel.alpha = 0.0
                        
                    }) */
                    
                }
            }
        }
        catch{
            
            self.buttonEmail.isEnabled = true
            
            self.activityView.stopAnimating()
            
            print(error)
            
        }
        
    }
    
    


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
