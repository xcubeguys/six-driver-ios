//
//  ADSignInVC.swift
//  Arcane Driver
//
//  Created by Apple on 16/12/16.
//  Copyright © 2016 Apple. All rights reserved.
//

import UIKit
import Alamofire
import UserNotifications
import SwiftMessages
import Crashlytics

class ADSignInVC: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var textFieldEmail: HoshiTextField!

    @IBOutlet weak var textFieldPassword: HoshiTextField!

    @IBOutlet weak var btnSignIn: UIButton!
    
    @IBOutlet weak var btnForgotPassword: UIButton!

    @IBOutlet weak var activityView: UIActivityIndicatorView!

    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    @IBOutlet weak var inputViewBottomConstraint: NSLayoutConstraint!
    
    var signInAPIUrl = live_Driver_url
    
    typealias jsonSTD = NSArray
    
    typealias jsonSTDAny = [String : AnyObject]

    @IBOutlet weak var labelValidEmail: UILabel!

    @IBOutlet weak var labelValidPassword: UILabel!

    @IBOutlet weak var loading: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

       // UNUserNotificationCenter.current().delegate = self //notify
        

        // Do any additional setup after loading the view.
        
        UIApplication.shared.isIdleTimerDisabled = false

        loading.isHidden = true
        
        navigationController!.isNavigationBarHidden = false
        
        navigationController!.navigationBar.barStyle = .black
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "REGISTER", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        
        btnForgotPassword.layer.borderColor = UIColor.black.cgColor
        btnForgotPassword.layer.borderWidth = 1.0
        
        
        let tapGesture1 = UITapGestureRecognizer(target: self, action: #selector(self.tapBlurButton1(_:)))
        tapGesture1.numberOfTapsRequired = 1
        tapGesture1.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGesture1)
        
      /*  let btnName: UIButton = UIButton()
        btnName.setImage(UIImage(named: "arrow-left.png"), for: UIControlState())
        btnName.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btnName.addTarget(self, action: #selector(ADSignInVC.profileBtn(_:)), for: .touchUpInside)
        
        let leftBarButton:UIBarButtonItem = UIBarButtonItem()
        leftBarButton.customView = btnName
        self.navigationItem.leftBarButtonItem = leftBarButton*/
        
        
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "arrow-left.png")!, for: .normal)
        button.addTarget(self, action: #selector(ADSignInVC.profileBtn(_:)), for: .touchUpInside)
        //CGRectMake(0, 0, 53, 31)
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        //(frame: CGRectMake(3, 5, 50, 20))
        let label = UILabel(frame: CGRect(x: 10, y: 5, width: 100, height: 20))
        // label.font = UIFont(name: "Arial-BoldMT", size: 13)
        label.text = "Sign In"
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.backgroundColor = UIColor.clear
        button.addSubview(label)
        let barButton = UIBarButtonItem(customView: button)
        self.navigationItem.leftBarButtonItem = barButton
        
        textFieldEmail.returnKeyType = .next
        textFieldPassword.returnKeyType = .done
        
        textFieldEmail.delegate = self
        textFieldPassword.delegate = self
        
       
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ADSignInVC.hidekeyboard))
        
        tapGesture.numberOfTapsRequired = 1
        view.addGestureRecognizer(tapGesture)
    }
    
   /* func animateImageView() {
        
        loading.image = UIImage.gifWithName("loadingBlack")
        
    }*/

    
    func notifyMe(){
        
        // Request Notification Settings
        UNUserNotificationCenter.current().getNotificationSettings { (notificationSettings) in
            switch notificationSettings.authorizationStatus {
            case .notDetermined:
                self.requestAuthorization(completionHandler: { (success) in
                    guard success else { return }
                    
                    // Schedule Local Notification
                    self.scheduleLocalNotification()
                })
            case .authorized:
                // Schedule Local Notification
                self.scheduleLocalNotification()
            case .denied:
                print("Application Not Allowed to Display Notifications")
            }
        }
        
    }
    
    // MARK: - Private Methods
    
    private func requestAuthorization(completionHandler: @escaping (_ success: Bool) -> ()) {
        // Request Authorization
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (success, error) in
            if let error = error {
                print("Request Authorization Failed (\(error), \(error.localizedDescription))")
            }
            
            completionHandler(success)
        }
    }
    
    private func scheduleLocalNotification() {
        // Create Notification Content
        let notificationContent = UNMutableNotificationContent()
        
        // Configure Notification Content
        notificationContent.title = "SIX Driver"
        notificationContent.subtitle = "Local Notifications"
        notificationContent.body = "Driver Signed In Successfully"
        
        // Add Trigger
        let notificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 1.0, repeats: false)
        
        // Create Notification Request
        let notificationRequest = UNNotificationRequest(identifier: "cocoacasts_local_notification", content: notificationContent, trigger: notificationTrigger)
        
        // Add Request to User Notification Center
        UNUserNotificationCenter.current().add(notificationRequest) { (error) in
            if let error = error {
                print("Unable to Add Notification Request (\(error), \(error.localizedDescription))")
            }
        }
    }

    func hidekeyboard()
    {
        self.view.endEditing(true)
    }
    
   /* override var preferredStatusBarStyle: UIStatusBarStyle {
     
        return .lightContent
    }*/
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField == textFieldEmail{
            
            textFieldEmail.borderActiveColor = UIColor.black
            textFieldEmail.borderInactiveColor = UIColor.black
            textFieldEmail.placeholderColor = UIColor.black
            self.labelValidEmail.isHidden = true

            
        }
        else{
            
            textFieldPassword.borderActiveColor = UIColor.black
            textFieldPassword.borderInactiveColor = UIColor.black
            textFieldPassword.placeholderColor = UIColor.black
            self.labelValidPassword.isHidden = true

        }
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        if textField == textFieldEmail{
            
            
        }
        else{
            
            
            
        }
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if(textFieldEmail == textField)
        {
            textFieldPassword.becomeFirstResponder()
        }
        else if(textFieldPassword == textField)
        {
            let status = Reach().connectionStatus()
            switch status {
            case .unknown, .offline:
                print("Not connected")
                let status = MessageView.viewFromNib(layout: .StatusLine)
                status.backgroundView.backgroundColor = UIColor(red: 249.0/255.0, green: 66.0/255.0, blue: 47.0/255.0, alpha: 1.0)
                status.bodyLabel?.textColor = UIColor.white
                status.configureContent(body: "No Internet Connection!!")
                var statusConfig = SwiftMessages.defaultConfig
                statusConfig.presentationContext = .window(windowLevel: UIWindowLevelStatusBar)
                
                SwiftMessages.show(config: statusConfig, view: status)
            case .online(.wwan):
                print("Connected via WWAN")
                keyboardDoneCall()

            case .online(.wiFi):
                print("Connected via WiFi")
                keyboardDoneCall()

            }

        }
        textField.resignFirstResponder()
        return true
    }
    
    
    func profileBtn(_ Selector: AnyObject) {
        
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.setRootViewController()
        
    }
    func tapBlurButton1(_ sender: UITapGestureRecognizer) {
        
        textFieldEmail.resignFirstResponder()
        textFieldPassword.resignFirstResponder()
        
    }
    @IBAction func btnSignInAction(_ sender: Any) {
        
        self.activityView.startAnimating()
        self.appDelegate.timestatuslogout = "0"
       // keyboardDoneCall()
        
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
            keyboardDoneCall()
            
        case .online(.wiFi):
            print("Connected via WiFi")
            keyboardDoneCall()
            
        }
        
       // Crashlytics.sharedInstance().crash()


    }
    
    @IBAction func btnForgotPasswordAction(_ sender: Any) {
        
    self.navigationController?.pushViewController(ADResetPasswordVC(), animated: true)
    }
    
    func keyboardDoneCall(){
        
        textFieldEmail.resignFirstResponder()
        textFieldPassword.resignFirstResponder()
        
        let emailTrim = textFieldEmail.text?.trimmingCharacters(in: .whitespaces)
        let passwordTrim = textFieldPassword.text?.trimmingCharacters(in: .whitespaces)
        
        if(emailTrim == "" || passwordTrim == ""){
            
            self.labelValidEmail.isHidden = false
            self.labelValidPassword.isHidden = false
            
            self.invalidEmail()
            self.invalidPwd()
        }
        else if (!(isValidEmail(testStr: emailTrim!))){
            self.validData()
            self.invalidEmail()
        }
        else if (passwordTrim == ""){
            self.validData()
            self.invalidPwd()
        }
        else if((passwordTrim?.characters.count)! < 6){
            self.validData()
            self.invalidPwd()
        }
        else{
            
            self.labelValidEmail.isHidden = false
            self.labelValidPassword.isHidden = false
            
            self.activityView.startAnimating()

        //    loading.isHidden = false
            
         //   self.animateImageView()

            self.validData()
            self.appDelegate.userName = emailTrim
           // self.appDelegate.passWord = passwordTrim
            print(passwordTrim!)
            var paswd = "\(passwordTrim!)"
            paswd = paswd.replacingOccurrences(of: "[ |@!#$&+-/;:,()_.]", with: "", options: [.regularExpression])
            paswd=(paswd.replacingOccurrences(of: "[", with: "") as String as NSString!) as String
            paswd=(paswd.replacingOccurrences(of: "]", with: "") as String as NSString!) as String
            paswd=(paswd.replacingOccurrences(of: "*", with: "") as String as NSString!) as String
            print("mouni\(paswd)") // +14084561234
            self.appDelegate.passWord = paswd
            print(passwordTrim!)

            let longstring = "\(passwordTrim!)"
            let data = (longstring).data(using: String.Encoding.utf8)
            var base64 = data!.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
            print(longstring)
            
            print(base64)// dGVzdDEyMw==\n
            base64=(base64.replacingOccurrences(of: "=", with: "") as String as NSString!) as String
            
            let combileUrl = "password/\(paswd)/email/\(emailTrim!)/encrypt_password/\(base64)"
            let finalUrl = "\(self.signInAPIUrl)signIn/\(combileUrl)"
            print(finalUrl)
            callSiginAPI(url: finalUrl)
            
        }

    }
    
    func invalidPwd(){
        
        
        self.activityView.stopAnimating()

        self.labelValidPassword.isHidden = false

    //    textFieldPassword.borderActiveColor = UIColor.red
   //     textFieldPassword.borderInactiveColor = UIColor.red
    //    textFieldPassword.placeholderColor = UIColor.red
        
        
    }
    
    func invalidEmail(){
        
        
        self.activityView.stopAnimating()

        self.labelValidEmail.isHidden = false

    //    textFieldEmail.borderActiveColor = UIColor.red
    //    textFieldEmail.borderInactiveColor = UIColor.red
    //    textFieldEmail.placeholderColor = UIColor.red
        
    }
    
    func validData(){
        
        self.labelValidEmail.isHidden = true
        self.labelValidPassword.isHidden = true
        
   //     textFieldEmail.borderActiveColor = UIColor.black
   //     textFieldEmail.borderInactiveColor = UIColor.black
   //     textFieldEmail.placeholderColor = UIColor.black
        
   //     textFieldPassword.borderActiveColor = UIColor.black
   //     textFieldPassword.borderInactiveColor = UIColor.black
   //     textFieldPassword.placeholderColor = UIColor.black
        
    }
    
    func isValidEmail(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    func callSiginAPI(url : String){
        
        self.activityView.startAnimating()

        
        Alamofire.request(url).responseJSON { (response) in
            
            self.parseData(JSONData: response.data!)
            
        }
        
    }
    
    
    func parseData(JSONData : Data){
        
        do{
            
            let readableJSon = try JSONSerialization.jsonObject(with: JSONData, options: .mutableContainers) as! jsonSTD
            
            print(" !!! \(readableJSon[0])")
            
            let value = readableJSon[0] as AnyObject
            
            let final = value.object(forKey: "status")
            
            if let final = value.object(forKey: "status"){
                print(final)
                if(final as! String == "Success"){
                    let email:String = value.object(forKey: "email") as! String
                    let first_name:String = value.object(forKey: "first_name") as! String
                    let last_name:String = value.object(forKey: "last_name") as! String
                //    let mobile:String = (value.object(forKey: "mobile") as? String)!
                    let userid:String = value.object(forKey: "userid") as! String
                    
                     let carCategory:String = value.object(forKey: "category") as! String
                    
                    print("email is \(email)")
                    print(carCategory)
                    
                    self.appDelegate.userid = userid
                    self.appDelegate.loggedEmail = email
                    self.appDelegate.fname = first_name
                    self.appDelegate.lname = last_name
                    
                    self.activityView.stopAnimating()

                 //   self.notifyMe()
                    
                    UserDefaults.standard.setValue(userid, forKey: "userid")
                    
                    UserDefaults.standard.setValue(carCategory, forKey: "carCategoryRegister")

                    print("\(UserDefaults.standard.value(forKey: "userid")!)")

                    
                self.navigationController?.pushViewController(ADHomePageVC(), animated: true)
        
                    
                }
                else{
                    
                   /* let toastLabel = UILabel(frame: CGRect(x: btnSignIn.frame.origin.x, y: (view.frame.size.height / 2) + 100, width: 335, height: 12))
                    toastLabel.backgroundColor = UIColor.white
                    toastLabel.textColor = UIColor.black
                    toastLabel.textAlignment = NSTextAlignment.center;
                    self.view.addSubview(toastLabel)
                    toastLabel.text = "Invalid Email address or Password"
                    toastLabel.alpha = 1.0
                    toastLabel.layer.cornerRadius = 0;
                    toastLabel.clipsToBounds  =  true
                    
                    UIView.animate(withDuration: 8.0, delay: 0.1, options: UIViewAnimationOptions.curveEaseOut, animations: {
                        
                        toastLabel.alpha = 0.0
                        
                    })*/
                    
                    self.activityView.stopAnimating()

                    let warning = MessageView.viewFromNib(layout: .CardView)
                    warning.configureTheme(.warning)
                    warning.configureDropShadow()
                    let iconText = "" //"🤔"
                    warning.configureContent(title: "", body: "Invalid User name or Password", iconText: iconText)
                    warning.button?.isHidden = true
                    var warningConfig = SwiftMessages.defaultConfig
                    warningConfig.presentationContext = .window(windowLevel: UIWindowLevelStatusBar)
                    SwiftMessages.show(config: warningConfig, view: warning)
                    
                }
            }
            
        }
        catch{
            
            print(error)
            
            self.activityView.stopAnimating()

        }
        
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        var result = true
        let str:NSString! = "\(textField.text!)" as NSString!
        
        let prospectiveText = (str).replacingCharacters(in: range, with: string)
        var limit = 30
        
        if(textField == textFieldEmail){
            limit = 30
            
            if string.characters.count > 0 {
               // let disallowedCharacterSet = CharacterSet.whitespaces
                
                let disallowedCharacterSet = CharacterSet(charactersIn: "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ.@_-!#$%(){}^&*+").inverted
               
                let replacementStringIsLegal = string.rangeOfCharacter(from: disallowedCharacterSet) == nil
                
                let resultingStringLengthIsLegal = prospectiveText.characters.count <= 64
                
                result = replacementStringIsLegal &&
                    
                resultingStringLengthIsLegal
            }
        }
            
        else if (textField == textFieldPassword){
            limit = 20
            if string.characters.count > 0 {
                //     let disallowedCharacterSet = CharacterSet.whitespaces
                
                let disallowedCharacterSet = CharacterSet(charactersIn: "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ.!@$&*()_+-*/,:;[]{}|").inverted
              
                let replacementStringIsLegal = string.rangeOfCharacter(from: disallowedCharacterSet) == nil
                
                let resultingStringLengthIsLegal = prospectiveText.characters.count <= limit
                
                result = replacementStringIsLegal &&
                    
                resultingStringLengthIsLegal
            }
        }
        
        else{}
        
        return result
    }


}
extension ADSignInVC: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert])
    }
    
}
