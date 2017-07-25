//
//  ADRegisterVC.swift
//  Arcane Driver
//
//  Created by Apple on 16/12/16.
//  Copyright © 2016 Apple. All rights reserved.
//

import UIKit
import Alamofire
import UserNotifications

class ADRegisterVC: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var btnContinue: UIButton!
    
    @IBOutlet weak var btnSignIn: UIButton!
    
    @IBOutlet weak var viewScroll: UIScrollView!
    
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var signInAPIUrl = live_Driver_url
    
    typealias jsonSTD = NSArray
    
    typealias jsonSTDAny = [String : AnyObject]
    
    
    @IBOutlet weak var textFieldFirstName: HoshiTextField!
    @IBOutlet weak var textFieldLastName: HoshiTextField!
    @IBOutlet weak var textFieldEmail: HoshiTextField!
    @IBOutlet weak var textFieldMobile: HoshiTextField!
    @IBOutlet weak var textFieldPassword: HoshiTextField!
    @IBOutlet weak var textFieldConfirmPassword: HoshiTextField!
    @IBOutlet weak var textFieldCity: HoshiTextField!
    @IBOutlet weak var labelCountry: HoshiTextField!
    
    //    @IBOutlet var labelCountry: UILabel!
    
    @IBOutlet var fnameLabel: UILabel!
    @IBOutlet var lnameLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var mobileLabel: UILabel!
    @IBOutlet var pwdLabel: UILabel!
    @IBOutlet var cpwdLabel: UILabel!
    @IBOutlet var cityLabel: UILabel!
    
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        
        return .lightContent
    }
    
    var begin = 1
    
    func errorField(){
        
        let emailTrim = textFieldEmail.text?.trimmingCharacters(in: .whitespaces)
        let passwordTrim = textFieldPassword.text?.trimmingCharacters(in: .whitespaces)
        let firstNameTrim = textFieldFirstName.text?.trimmingCharacters(in: .whitespaces)
        let lastNameTrim = textFieldLastName.text?.trimmingCharacters(in: .whitespaces)
        let mobileTrim = textFieldMobile.text?.trimmingCharacters(in: .whitespaces)
        let confirmTrim = textFieldConfirmPassword.text?.trimmingCharacters(in: .whitespaces)
        let cityTrim = textFieldCity.text?.trimmingCharacters(in: .whitespaces)
        
        if(begin == 1){
            
        }
        else{
            
        }
        
        if(firstNameTrim! == "" || (firstNameTrim?.characters.count)! < 3){
            fnameLabel.isHidden = false
        }
        if(lastNameTrim! == "" || (lastNameTrim?.characters.count)! < 3){
            lnameLabel.isHidden = false
        }
        if(emailTrim! == "" || !(isValidEmail(testStr: emailTrim!))){
            emailLabel.isHidden = false
        }
        if(cityTrim == ""){
            cityLabel.isHidden = false
        }
        if(mobileTrim! == "" || (mobileTrim?.characters.count)! < 8){
            mobileLabel.isHidden = false
        }
        if(passwordTrim! == "" || (passwordTrim?.characters.count)! < 6){
            pwdLabel.isHidden = false
        }
        if(confirmTrim! == "" || (confirmTrim?.characters.count)! < 6){
            cpwdLabel.isHidden = false
        }
        if(textFieldConfirmPassword.text != textFieldPassword.text){
            cpwdLabel.isHidden = false
        }
        if(labelCountry.text == "cc"){
            mobileLabel.isHidden = false
        }
        else{
            
            
            
        }
    }
    
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        if(textField == textFieldFirstName){
            fnameLabel.isHidden = true
        }
        if(textField == textFieldLastName){
            lnameLabel.isHidden = true
        }
        if(textField == textFieldMobile){
            mobileLabel.isHidden = true
        }
        if(textField == textFieldPassword){
            pwdLabel.isHidden = true
        }
        if(textField == textFieldConfirmPassword){
            cpwdLabel.isHidden = true
        }
        if(textField == textFieldCity){
            cityLabel.isHidden = true
        }
        if(textField == textFieldEmail){
            emailLabel.isHidden = true
        }
        
        //self.errorField()
        
        
        return true
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIApplication.shared.isIdleTimerDisabled = false
        
        UNUserNotificationCenter.current().delegate = self
        
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        
        let sada = viewScroll.contentSize.height
        
        
        
        self.appDelegate.loginType = "ARCANE DRIVER"
        // Do any additional setup after loading the view.
        
        navigationController!.navigationBar.barStyle = .black
        
        navigationController!.isNavigationBarHidden = false
        
        viewScroll.isScrollEnabled = true
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        
        btnSignIn.layer.borderColor = UIColor.black.cgColor
        btnSignIn.layer.borderWidth = 1.0
        
        
        let tapGesture1 = UITapGestureRecognizer(target: self, action: #selector(self.tapBlurButton1(_:)))
        tapGesture1.numberOfTapsRequired = 1
        tapGesture1.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGesture1)
        
        
        /* let btnName: UIButton = UIButton()
         btnName.setImage(UIImage(named: "arrow-left.png"), for: UIControlState())
         btnName.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
         btnName.addTarget(self, action: #selector(ADRegisterVC.profileBtn(_:)), for: .touchUpInside)
         
         let leftBarButton:UIBarButtonItem = UIBarButtonItem()
         leftBarButton.customView = btnName
         self.navigationItem.leftBarButtonItem = leftBarButton*/
        
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "arrow-left.png")!, for: .normal)
        button.addTarget(self, action: #selector(ADRegisterVC.profileBtn(_:)), for: .touchUpInside)
        //CGRectMake(0, 0, 53, 31)
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        //(frame: CGRectMake(3, 5, 50, 20))
        let label = UILabel(frame: CGRect(x: 15, y: 5, width: 100, height: 20))
        // label.font = UIFont(name: "Arial-BoldMT", size: 13)
        label.text = "Register"
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.backgroundColor = UIColor.clear
        button.addSubview(label)
        let barButton = UIBarButtonItem(customView: button)
        self.navigationItem.leftBarButtonItem = barButton
        
        /*   NotificationCenter.defaultCenter.addObserver(self, selector: #selector(ADSignInVC.keyboardWillShow(_:)), name:UIKeyboardWillShowNotification, object: nil)
         NotificationCenter.defaultCenter.addObserver(self, selector: #selector(ADSignInVC.keyboardWillHide(_:)), name:UIKeyboardWillHideNotification, object: nil)*/
        
        NotificationCenter.default.addObserver(self, selector: #selector(ADRegisterVC.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ADRegisterVC.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        textFieldFirstName.returnKeyType = .next
        textFieldLastName.returnKeyType = .next
        textFieldEmail.returnKeyType = .next
        textFieldMobile.returnKeyType = .next
        textFieldPassword.returnKeyType = .next
        textFieldConfirmPassword.returnKeyType = .next
        textFieldCity.returnKeyType = .done
        
        textFieldFirstName.delegate = self
        textFieldLastName.delegate = self
        textFieldEmail.delegate = self
        textFieldMobile.delegate = self
        textFieldPassword.delegate = self
        textFieldConfirmPassword.delegate = self
        textFieldCity.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ADRegisterVC.hidekeyboard))
        
        tapGesture.numberOfTapsRequired = 1
        view.addGestureRecognizer(tapGesture)
        
        if screenHeight == 568{
            
            self.view.frame = CGRect(x: 0, y: 0, width: screenWidth, height: 800)
            viewScroll.isScrollEnabled = true
            viewScroll.contentSize.height = 700
            
        }
        
        //        fnameLabel.frame.size = self.textFieldFirstName.bounds.size
    }
    
    
    func hidekeyboard()
    {
        self.view.endEditing(true)
    }
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
        notificationContent.title = "Arcane Driver"
        notificationContent.subtitle = "Local Notifications"
        notificationContent.body = "Driver Registerd Successfully"
        
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
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField == textFieldFirstName{
            
            textFieldFirstName.borderActiveColor = UIColor.black
            textFieldFirstName.borderInactiveColor = UIColor.black
            textFieldFirstName.placeholderColor = UIColor.black
            self.fnameLabel.isHidden = true
            
            
        }
        else if textField == textFieldLastName{
            
            textFieldLastName.borderActiveColor = UIColor.black
            textFieldLastName.borderInactiveColor = UIColor.black
            textFieldLastName.placeholderColor = UIColor.black
            self.lnameLabel.isHidden = true
            
        }
        else if textField == textFieldMobile{
            
            textFieldMobile.borderActiveColor = UIColor.black
            textFieldMobile.borderInactiveColor = UIColor.black
            textFieldMobile.placeholderColor = UIColor.black
            self.mobileLabel.isHidden = true
            
            
        }
        else if textField == textFieldPassword{
            
            textFieldPassword.borderActiveColor = UIColor.black
            textFieldPassword.borderInactiveColor = UIColor.black
            textFieldPassword.placeholderColor = UIColor.black
            self.pwdLabel.isHidden = true
            
            
            
        }
        else if textField == textFieldConfirmPassword{
            
            textFieldConfirmPassword.borderActiveColor = UIColor.black
            textFieldConfirmPassword.borderInactiveColor = UIColor.black
            textFieldConfirmPassword.placeholderColor = UIColor.black
            self.cpwdLabel.isHidden = true
            
        }
        else if textField == textFieldCity{
            
            
            textFieldCity.borderActiveColor = UIColor.black
            textFieldCity.borderInactiveColor = UIColor.black
            textFieldCity.placeholderColor = UIColor.black
            self.cityLabel.isHidden = true
            
        }
        else if textField == textFieldEmail {
            
            textFieldEmail.borderActiveColor = UIColor.black
            textFieldEmail.borderInactiveColor = UIColor.black
            textFieldEmail.placeholderColor = UIColor.black
            emailLabel.isHidden = true
            
        }
        else{
            
            
            
        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if(textFieldFirstName == textField)
        {
            textFieldLastName.becomeFirstResponder()
        }
        else if(textFieldLastName == textField)
        {
            textFieldEmail.becomeFirstResponder()
        }
        else if(textFieldEmail == textField)
        {
            textFieldMobile.becomeFirstResponder()
        }
        else if(textFieldMobile == textField)
        {
            textFieldPassword.becomeFirstResponder()
        }
        else if(textFieldPassword == textField)
        {
            textFieldConfirmPassword.becomeFirstResponder()
        }
        else if(textFieldConfirmPassword == textField)
        {
            textFieldCity.becomeFirstResponder()
        }
        else if(textFieldCity == textField)
        {
            continueBtnAction()
        }
        textField.resignFirstResponder()
        return true
    }
    func keyboardWillShow(notification:NSNotification){
        
        var userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset:UIEdgeInsets = self.viewScroll.contentInset
        
        contentInset.bottom = keyboardFrame.size.height
        self.viewScroll.isScrollEnabled = true
        self.viewScroll.contentInset = contentInset
    }
    
    func keyboardWillHide(notification:NSNotification){
        
        let contentInset:UIEdgeInsets = .zero
        // let contentInset:UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)
        self.viewScroll.isScrollEnabled = true
        self.viewScroll.contentInset = contentInset
    }
    
    func profileBtn(_ Selector: AnyObject) {
        
        self.navigationController?.popViewController(animated: true)
        
        
    }
    func tapBlurButton1(_ sender: UITapGestureRecognizer) {
        
        textFieldFirstName.resignFirstResponder()
        textFieldLastName.resignFirstResponder()
        textFieldEmail.resignFirstResponder()
        textFieldPassword.resignFirstResponder()
        textFieldConfirmPassword.resignFirstResponder()
        textFieldMobile.resignFirstResponder()
        textFieldCity.resignFirstResponder()
        
        
    }
    @IBAction func btnRegSignInAction(_ sender: Any) {
        
        //   self.navigationController?.popViewController(animated: true)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.callMainVC()
        
    }
    
    @IBAction func btnRegContinueAction(_ sender: Any) {
        
        
        continueBtnAction()
    }
    
    
    func callAPIEmailExists(){
        
        self.btnContinue.isEnabled = false
        
        activityView.startAnimating()
        
        let value = textFieldEmail.text!
        var final = value
        final = final.replacingOccurrences(of: " ", with: "%20")
        final = final.replacingOccurrences(of: "%20", with: "")
        
        print(final)
        
        
        let combileUrl = "emailExist/email/\(value)"
        let finalUrl = "\(signInAPIUrl)\(combileUrl)"
        
        print(finalUrl)
        
        callAllReadyEmail(url: finalUrl)
        
    }
    
    func callAPIPhoneExists(){
        
        activityView.startAnimating()
        
        let value = textFieldMobile.text!
        var final = value
        final = final.replacingOccurrences(of: " ", with: "%20")
        final = final.replacingOccurrences(of: "%20", with: "")
        
        print(final)
        
        
        let combileUrl = "mobileExist/mobile/\(value)"
        let finalUrl = "\(signInAPIUrl)\(combileUrl)"
        
        print(finalUrl)
        
        callAllReadyPhone(url: finalUrl)
        
    }
    
    
    func continueBtnAction(){
        
        
        self.errorField()
        
        let emailTrim = textFieldEmail.text?.trimmingCharacters(in: .whitespaces)
        let passwordTrim = textFieldPassword.text?.trimmingCharacters(in: .whitespaces)
        let firstNameTrim = textFieldFirstName.text?.trimmingCharacters(in: .whitespaces)
        let lastNameTrim = textFieldLastName.text?.trimmingCharacters(in: .whitespaces)
        let mobileTrim = textFieldMobile.text?.trimmingCharacters(in: .whitespaces)
        let confirmTrim = textFieldConfirmPassword.text?.trimmingCharacters(in: .whitespaces)
        let cityTrim = textFieldCity.text?.trimmingCharacters(in: .whitespaces)
        
        
        
        if(firstNameTrim == "" || lastNameTrim == "" || emailTrim == "" || mobileTrim == "" || confirmTrim == "" || cityTrim == "" || passwordTrim == ""){
            self.invalidData()
            //            textFieldFirstName.placeholderLabel.text = "Enter a valid name"
        }
        else if(labelCountry.text == "cc" || labelCountry.text == ""){
            self.errorField()
        }
        else if ((firstNameTrim?.characters.count)! < 3 || (lastNameTrim?.characters.count)! < 3){
            self.errorField()
        }
        else if(emailTrim == ""){
            self.invalidEmail()
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
        else if(passwordTrim != confirmTrim){
            self.errorField()
        }
        else if (mobileTrim?.characters.count)! < 10{
            
            self.mobileLabel.isHidden = false
            self.mobileLabel.text = "Invalid Mobile Number"
        }
        else{
            
            self.activityView.startAnimating()
            
            self.validData()
            self.appDelegate.email = emailTrim
            self.appDelegate.password = passwordTrim
            self.appDelegate.firstname = firstNameTrim
            self.appDelegate.lastname = lastNameTrim
            self.appDelegate.phonenumber = mobileTrim
            self.appDelegate.countrycode = labelCountry.text!
            self.appDelegate.city = cityTrim
            
            
            //   self.navigationController?.pushViewController(ADProfileVC(), animated: true)
            
            callAPIEmailExists()
            
        }
        
        
    }
    
    func invalidData(){
        
        
        textFieldFirstName.borderActiveColor = UIColor.black
        textFieldFirstName.borderInactiveColor = UIColor.black
        textFieldFirstName.placeholderColor = UIColor.black
        
        textFieldLastName.borderActiveColor = UIColor.black
        textFieldLastName.borderInactiveColor = UIColor.black
        textFieldLastName.placeholderColor = UIColor.black
        
        textFieldMobile.borderActiveColor = UIColor.black
        textFieldMobile.borderInactiveColor = UIColor.black
        textFieldMobile.placeholderColor = UIColor.black
        
        textFieldConfirmPassword.borderActiveColor = UIColor.black
        textFieldConfirmPassword.borderInactiveColor = UIColor.black
        textFieldConfirmPassword.placeholderColor = UIColor.black
        
        textFieldCity.borderActiveColor = UIColor.black
        textFieldCity.borderInactiveColor = UIColor.black
        textFieldCity.placeholderColor = UIColor.black
        
        self.invalidEmail()
        self.invalidPwd()
        
        
    }
    
    func invalidPwd(){
        
        textFieldPassword.borderActiveColor = UIColor.black
        textFieldPassword.borderInactiveColor = UIColor.black
        textFieldPassword.placeholderColor = UIColor.black
        
        
    }
    
    func invalidEmail(){
        
        textFieldEmail.borderActiveColor = UIColor.black
        textFieldEmail.borderInactiveColor = UIColor.black
        textFieldEmail.placeholderColor = UIColor.black
        
    }
    
    func validData(){
        
        textFieldEmail.borderActiveColor = UIColor.black
        textFieldEmail.borderInactiveColor = UIColor.black
        textFieldEmail.placeholderColor = UIColor.black
        
        textFieldPassword.borderActiveColor = UIColor.black
        textFieldPassword.borderInactiveColor = UIColor.black
        textFieldPassword.placeholderColor = UIColor.black
    }
    
    func isValidEmail(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    @IBAction func openCountryAction(_ sender: AnyObject) {
        
        let picker = MICountryPicker { (name, code) -> () in
            print(code)
        }
        
        // Optional: To pick from custom countries list
        picker.customCountriesCode = ["EG", "US", "AF", "AQ", "AX", "IN","AL","DZ","AS","AD","AO","AI","AG","AR","AM","AW","AU","AT","AZ","BS","BH","BD","BB","BY","BE","BZ","BJ","BM","BT","BO","BA","BW","BR","IO","BN","BG","BF","BI","KH","CM","CA","CV","KY","CF","TD","CL","CN","CX","CC","CO","KM","CG","CD","CK","CR","CI","HR","CU","CY","CZ","DK","DJ","DM","DO","EC","EG","SV","GQ","ER","EE","ET","FK","FO","FJ","FI","FR","GF","PF","GA","GM","GE","DE","GH","GI","GR","GL","GD","GP","GU","GT","GG","GN","GW","GY","HT","VA","HN","HK","HU","IS","ID","IR","IQ","IE","IM","IL","IT","JM","JP","JE","JO","KZ","KE","KI","KP","KR","KW","KG","LA","LV","LB","LS","LR","LY","LI","LT","LU","MO","MK","MG","MW","MY","MV","ML","MT","MH","MQ","MR","MU","YT","MX","FM","MD","MC","MN","ME","MS","MA","MZ","MM","NA","NR","NP","NL","AN","NC","NZ","NI","NE","NZ","NU","NF","MP","NO","OM","PK","PW","PS","PA","PG","PY","PE","PH","PN","PL","PT","PR","QA","RO","RU","RW","RE","BL","SH","KN","LC","MF","PM","VC","WS","SM","ST","SA","SN","RS","SC","SL","SG","SK","SI","SB","SO","ZA","SS","GS","ES","LK","SD","SR","SJ","SZ","SE","CH","SY","TW","TJ","TZ","TH","TL","TG","TK","TO","TT","TN","TR","TM","TC","TV","UG","UA","AE","GB","US","UY","UZ","VU","VE","VN","VG","VI","WF","YE","ZM","ZW"]
        
        // delegate
        picker.delegate = self
        
        // Display calling codes
        picker.showCallingCodes = true
        
        // or closure
        picker.didSelectCountryClosure = { name, code in
            
            //      picker.navigationController?.popToRootViewController(animated: true)
            
            //  picker.navigationController?.popViewController(animated: true)
            
            print(code)
        }
        
        //   self.navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.pushViewController(picker, animated: true)
        
        // navigationController?.present(picker, animated: true, completion: nil)
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        var result = true
        let str:NSString! = "\(textField.text!)" as NSString!
        
        let prospectiveText = (str).replacingCharacters(in: range, with: string)
        
        // var disallowedCharacterSet = CharacterSet.whitespaces
        var limit = 30
        
        
        if(textField == textFieldEmail){
            if string.characters.count > 0 {
                
                let disallowedCharacterSet = CharacterSet(charactersIn: "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ.@").inverted
                
                let replacementStringIsLegal = string.rangeOfCharacter(from: disallowedCharacterSet) == nil
                
                let resultingStringLengthIsLegal = prospectiveText.characters.count <= limit
                
                result = replacementStringIsLegal &&
                    
                resultingStringLengthIsLegal
                
            }
        }
        else if (textField == textFieldPassword){
            limit = 20
            if string.characters.count > 0 {
                
                let disallowedCharacterSet = CharacterSet(charactersIn: "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ.!@$&*()_+-*/,:;[]{}|").inverted
                
                let replacementStringIsLegal = string.rangeOfCharacter(from: disallowedCharacterSet) == nil
                
                let resultingStringLengthIsLegal = prospectiveText.characters.count <= limit
                
                result = replacementStringIsLegal &&
                    
                resultingStringLengthIsLegal
                
            }
        }
            
        else if(textField == textFieldFirstName){
            
            if string.characters.count > 0 {
                
                let disallowedCharacterSet = CharacterSet(charactersIn: "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ.").inverted
                
                let replacementStringIsLegal = string.rangeOfCharacter(from: disallowedCharacterSet) == nil
                
                let resultingStringLengthIsLegal = prospectiveText.characters.count <= limit
                
                result = replacementStringIsLegal &&
                    
                resultingStringLengthIsLegal
                
            }
        }
        else if (textField == textFieldLastName){
            limit = 20
            if string.characters.count > 0 {
                
                let disallowedCharacterSet = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ").inverted
                
                let replacementStringIsLegal = string.rangeOfCharacter(from: disallowedCharacterSet) == nil
                
                let resultingStringLengthIsLegal = prospectiveText.characters.count <= limit
                
                result = replacementStringIsLegal &&
                    
                resultingStringLengthIsLegal
                
            }
        }   // phonenumber  countrycode  city
        else if(textField == textFieldMobile){
            
            if string.characters.count > 0 {
                
                let disallowedCharacterSet = CharacterSet(charactersIn: "0123456789").inverted
                
                let replacementStringIsLegal = string.rangeOfCharacter(from: disallowedCharacterSet) == nil
                
                let resultingStringLengthIsLegal = prospectiveText.characters.count <= 15
                
                result = replacementStringIsLegal &&
                    
                resultingStringLengthIsLegal
                
            }
        }
            
        else if (textField == textFieldCity){
            limit = 20
            if string.characters.count > 0 {
                
                let disallowedCharacterSet = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ").inverted
                
                let replacementStringIsLegal = string.rangeOfCharacter(from: disallowedCharacterSet) == nil
                
                let resultingStringLengthIsLegal = prospectiveText.characters.count <= limit
                
                result = replacementStringIsLegal &&
                    
                resultingStringLengthIsLegal
                
            }
        }
        else{
            limit = 20
        }
        
        //   if string.characters.count > 0 {
        
        //   disallowedCharacterSet = CharacterSet.whitespaces
        
        //   let replacementStringIsLegal = string.rangeOfCharacter(from: disallowedCharacterSet) == nil
        
        //  let resultingStringLengthIsLegal = prospectiveText.characters.count <= limit
        
        //  result = replacementStringIsLegal &&
        
        //  resultingStringLengthIsLegal
        
        //}
        return result
    }
    
    
    func callAllReadyEmail(url : String){
        
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
                if(final as! String == "Fail"){
                    
                    self.btnContinue.isEnabled = true
                    
                    self.activityView.stopAnimating()
                    
                    self.emailLabel.isHidden = false
                    self.emailLabel.text = "Email Already Exists"
                    
                }
                else{
                    
                    self.btnContinue.isEnabled = false
                    
                    self.activityView.stopAnimating()
                    
                    self.emailLabel.isHidden = true
                    
                    callAPIPhoneExists()
                    
                    //   self.navigationController?.pushViewController(ADProfileVC(), animated: true)
                }
            }
            
        }
        catch{
            
            print(error)
            
            self.activityView.stopAnimating()
            
        }
        
    }
    
    
    func callAllReadyPhone(url : String){
        
        self.activityView.startAnimating()
        
        
        Alamofire.request(url).responseJSON { (response) in
            
            self.parseDataPhone(JSONData: response.data!)
            
        }
        
    }
    
    
    func parseDataPhone(JSONData : Data){
        
        do{
            
            let readableJSon = try JSONSerialization.jsonObject(with: JSONData, options: .mutableContainers) as! jsonSTD
            
            print(" !!! \(readableJSon[0])")
            
            let value = readableJSon[0] as AnyObject
            
            let final = value.object(forKey: "status")
            
            if let final = value.object(forKey: "status"){
                print(final)
                if(final as! String == "Fail"){
                    
                    self.btnContinue.isEnabled = true
                    
                    self.activityView.stopAnimating()
                    
                    self.mobileLabel.isHidden = false
                    self.mobileLabel.text = "Phone Number Already Exists"
                    
                }
                else{
                    
                    self.activityView.stopAnimating()
                    
                    self.mobileLabel.isHidden = true
                    
                    self.navigationController?.pushViewController(ADProfileVC(), animated: true)
                    
                    self.btnContinue.isEnabled = true
                }
            }
            
        }
        catch{
            
            print(error)
            
            self.activityView.stopAnimating()
            
        }
        
    }
    
}
extension ADRegisterVC: MICountryPickerDelegate {
    
    func countryPicker(_ picker: MICountryPicker, didSelectCountryWithName name: String, code: String) {
        // picker.navigationController?.popToRootViewController(animated: true)
        // label.text = "Selected Country: \(name)"
    }
    
    func countryPicker(_ picker: MICountryPicker, didSelectCountryWithName name: String, code: String, dialCode: String) {
        
        //  picker.navigationController?.popToRootViewController(animated: true)
        
        //  navigationController!.isNavigationBarHidden = true
        picker.navigationController?.popViewController(animated: true)
        
        labelCountry.text = "\(dialCode)"
        self.mobileLabel.isHidden = true
        print(labelCountry.text!)
        self.appDelegate.countrycode = labelCountry.text!
        labelCountry.textColor = UIColor.black
        
    }
    
    
}
extension ADRegisterVC: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert])
    }
    
}
