//
//  ADUploadDocVC.swift
//  Arcane Driver
//
//  Created by Apple on 17/12/16.
//  Copyright © 2016 Apple. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation
import Firebase
import GeoFire
import SwiftMessages
import SwiftyPickerPopover


class ADUploadDocVC: UIViewController,CLLocationManagerDelegate,UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate,UIScrollViewDelegate{
    
    @IBOutlet weak var commercialimage: UIImageView!
    @IBOutlet weak var vehicleregistrationimage: UIImageView!
    @IBOutlet weak var acraimage: UIImageView!
    var croppingEnabled: Bool = false
    var libraryEnabled: Bool = true
    var activeDocument:Int = 0
    
    @IBOutlet var referralerror: UILabel!
    
    @IBOutlet var vehicleyearerror: UILabel!
    
    @IBOutlet var vehiclemileageerror: UILabel!
    @IBOutlet var vehicleplateerror: UILabel!
    @IBOutlet var vehiclemodelerror: UILabel!
    @IBOutlet var vehiclemodel: HoshiTextField!
    @IBOutlet var vehiclemake: HoshiTextField!
    @IBOutlet weak var passengercount: HoshiTextField!
    
    @IBOutlet var vehiclemakeerror: UILabel!
    @IBOutlet var vehiclemileage: HoshiTextField!
    
    @IBOutlet var vehicleplatefield: HoshiTextField!
    @IBOutlet var vehicleyear: HoshiTextField!
    
    @IBOutlet var carcategoryerror: UILabel!
    
    @IBOutlet var noofpaseengerserror: UILabel!
    
    @IBOutlet var refferaltextfield: HoshiTextField!
    
    @IBOutlet weak var phDocImage: UIImageView!
    @IBOutlet weak var imageView2: UIImageView!
    
    @IBOutlet weak var viewImage: UIView!
    
    @IBOutlet weak var licenceFrontBtn: UIButton!
   
    @IBOutlet weak var licenseBackBtn: UIButton!
    
    @IBOutlet weak var nricFrontBtn: UIButton!
    
    @IBOutlet weak var nricBackBtn: UIButton!
    
    @IBOutlet weak var btnUpload2: UIButton!
    
    @IBOutlet weak var btnUpload3: UIButton!
    
    @IBOutlet weak var btnUpload4: UIButton!
    
    @IBOutlet weak var btnUpload5: UIButton!
    
    @IBOutlet weak var scrollviewupload: UIScrollView!
    
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    
    @IBOutlet weak var labelInvalid: UILabel!
    
    @IBOutlet weak var viewActivity: UIView!
    
    @IBOutlet weak var viewCar: UIView!
    
    @IBOutlet weak var labelCar: UILabel!
    
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    var driverLicenseFront:String! = "testing123.jpg"
    var driverLicenseBack:String! = "testing123.jpg"
    var commInsurance:String! = "testing123.jpg"
    var acraDocument:String! = "testing123.jpg"
    var vehRegDocument:String! = "testing123.jpg"
    var vocLicDocument:String! = "testing123.jpg"
    var privHireDocument:String! = "testing123.jpg"
    var nricFrontDoc:String! = "testing123.jpg"
    var nricBackDoc:String! = "testing123.jpg"

    // Using simple subclass to prevent the copy/paste menu
    // This is optional, and a given app may want a standard UITextField
    
    @IBOutlet weak var tableView: UITableView!
    
    
    var locationManager = CLLocationManager()
    let locationTracker = LocationTracker(threshold: 10.0)
    
    var updatestatus = ""
    
    
    var didFindMyLocation = false
    var currentLocation = CLLocation()
    var urlstringupdate:String = ""
    var downPicker: DownPicker?
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var signInAPIUrl = live_Driver_url
    
    @IBOutlet weak var continuebtn: UIButton!
    typealias jsonSTD = NSArray
    
    typealias jsonSTDAny = [String : AnyObject]
    
    var selectedPic : String!
    
    internal var passValue : String!
     var timer = Timer()
    var totalArrayOfCars:NSMutableArray=NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        /*  NotificationCenter.default.addObserver(self, selector: Selector(("keyboardWillShow:")), name:NSNotification.Name.UIKeyboardWillShow, object: nil);
         NotificationCenter.default.addObserver(self, selector: Selector("keyboardWillHide:"), name:NSNotification.Name.UIKeyboardWillHide, object: nil);
         */
        
        tableView.layer.borderWidth = 2.0;

        
        NotificationCenter.default.addObserver(self, selector: #selector(ADRegisterVC.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ADRegisterVC.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        self.scrollviewupload.contentSize = CGSize(width: 320, height: 2300)

//        if(screenHeight == 568)
//            
//        {
//            
//            self.scrollviewupload.contentSize = CGSize(width: 320, height: 1700)
//            self.scrollviewupload.isScrollEnabled = true
//           // self.viewActivity.frame = CGRect(x: 0, y: 0, width: 320, height: 2200)
//            
//        }
//        if(screenHeight == 667)
//            
//        {
//            
//            self.scrollviewupload.contentSize = CGSize(width: 320, height: 1500)
//            self.scrollviewupload.isScrollEnabled = true
//           // self.viewActivity.frame = CGRect(x: 0, y: 0, width: 320, height: 2200)
//            
//        }
//        else{
//            self.scrollviewupload.contentSize = CGSize(width: 320, height: 1600)
//            self.scrollviewupload.isScrollEnabled = true
//           // self.viewActivity.frame = CGRect(x: 0, y: 0, width: 320, height: 2300)
//            //let sada = viewScroll.contentSize.height
//            
//        }
        
        // self.scrollviewupload.contentSize = CGSize(width: 320, height: 5500)
        
        //self.scrollviewupload.isScrollEnabled = true
        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.isHidden = true
        
        self.viewCar.layer.borderColor = UIColor.black.cgColor
        self.viewCar.layer.borderWidth = 1.0
        
        self.viewActivity.isHidden = true
        
        navigationController!.isNavigationBarHidden = false
        
        labelInvalid.isHidden = true
        referralerror.isHidden = true
        carcategoryerror.isHidden = true
        noofpaseengerserror.isHidden = true
        vehiclemakeerror.isHidden = true
        vehiclemodelerror.isHidden = true
        vehicleyearerror.isHidden = true
        vehiclemileageerror.isHidden = true
        vehicleplateerror.isHidden = true
        
        passengercount.returnKeyType = .next
        vehiclemake.returnKeyType = .next
        vehiclemodel.returnKeyType = .next
        vehicleyear.returnKeyType = .next
        vehiclemileage.returnKeyType = .next
        vehicleplatefield.returnKeyType = .next
        refferaltextfield.returnKeyType = .done
        
        
        passengercount.delegate = self
        vehiclemake.delegate = self
        vehiclemodel.delegate = self
        vehicleyear.delegate = self
        vehiclemileage.delegate = self
        vehicleplatefield.delegate = self
        refferaltextfield.delegate = self
        
        
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "arrow-left.png")!, for: .normal)
        
        if self.passValue == nil{
            
            button.addTarget(self, action: #selector(ADUploadDocVC.profileBtn(_:)), for: .touchUpInside)
        }
        else if self.passValue == "newFbUser"{
            
            button.addTarget(self, action: #selector(ADUploadDocVC.backToMain(_:)), for: .touchUpInside)
        }
        else{
            
            button.addTarget(self, action: #selector(ADUploadDocVC.backToMain(_:)), for: .touchUpInside)
        }
        
        //CGRectMake(0, 0, 53, 31)
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        //(frame: CGRectMake(3, 5, 50, 20))
        let label = UILabel(frame: CGRect(x: 30, y: 5, width: 150, height: 20))
        // label.font = UIFont(name: "Arial-BoldMT", size: 13)
        label.text = "SIX DRIVER"
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.backgroundColor = UIColor.clear
        button.addSubview(label)
        let barButton = UIBarButtonItem(customView: button)
        self.navigationItem.leftBarButtonItem = barButton
        
        
        //    imageView1.tag = 0
        //    imageView1.tag = 1
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        self.locationTracker.addLocationChangeObserver { (result) -> () in
            switch result {
            case .success(let location):
                let coordinate = location.physical.coordinate
                let locationString = "\(coordinate.latitude), \(coordinate.longitude)"
                
                //self.currentLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
                print("location String\(locationString)")
                print("Success")
            case .failure:
                print("Failure")
            }
        }
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        tap.numberOfTapsRequired = 1
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        //  downPicker = DownPicker(textField: textFieldCar, withData: ["Male", "Female", "Other"])
        //  downPicker?.placeholder = "Select your car"
        
        tableView.register((UINib(nibName: "UploadCell", bundle: nil)), forCellReuseIdentifier: "uploadCell")
        
        
        self.callCarsList()
        delayWithSeconds(1200){
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let subContentsVC = storyboard.instantiateViewController(withIdentifier: "homePage") as! ViewController
            self.navigationController?.pushViewController(subContentsVC, animated: true)
            
        }       /* timer = Timer.scheduledTimer(timeInterval: 1200, target: self, selector: #selector(ADUploadDocVC.terminateApp), userInfo: nil, repeats: true)
        let resetTimer = UITapGestureRecognizer(target: self, action: #selector(ADUploadDocVC.resetTimer));
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(resetTimer)*/
    }
  /*  func resetTimer(){
        // invaldidate the current timer and start a new one
        print("User Interacted")
        timer.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1200, target: self, selector: #selector(ADUploadDocVC.terminateApp), userInfo: nil, repeats: true)
    }
    func terminateApp(){
        // Do your segue and invalidate the timer
        print("No User Interaction")
        timer.invalidate()
        let alertController = UIAlertController(title: "Time Out", message: "Please retry your registration", preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
            print("Showing Alert")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let subContentsVC = storyboard.instantiateViewController(withIdentifier: "homePage") as! ViewController
            self.navigationController?.pushViewController(subContentsVC, animated: true)
        }))
        self.present(alertController, animated: true, completion: nil)
    }*/
    func delayWithSeconds(_ seconds: Double, completion: @escaping () -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            completion()
        }
    }
    func keyboardWillShow(notification:NSNotification){
        
        var userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset:UIEdgeInsets = self.scrollviewupload.contentInset
        
        contentInset.bottom = keyboardFrame.size.height
        self.scrollviewupload.isScrollEnabled = true
        self.scrollviewupload.contentInset = contentInset
    }
    
    func keyboardWillHide(notification:NSNotification){
        
        let contentInset:UIEdgeInsets = .zero
        
        self.scrollviewupload.isScrollEnabled = true
        self.scrollviewupload.contentInset = contentInset
    }

    
    /* func keyboardWillShow(sender: NSNotification) {
     self.view.frame.origin.y -= 150
     }
     func keyboardWillHide(sender: NSNotification) {
     self.view.frame.origin.y += 150
     }*/
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if(passengercount == textField)
        {
            vehiclemake.becomeFirstResponder()
        }
        else if(vehiclemake == textField)
        {
            vehiclemodel.becomeFirstResponder()
        }
        else if(vehiclemodel == textField)
        {
            vehicleyear.becomeFirstResponder()
        }
        else if(vehicleyear == textField)
        {
            vehiclemileage.becomeFirstResponder()
        }
        else if(vehiclemileage == textField)
        {
            vehicleplatefield.becomeFirstResponder()
        }
        else if(vehicleplatefield == textField)
        {
            refferaltextfield.becomeFirstResponder()
        }
        else if(refferaltextfield == textField)
        {
            
        }
        
        
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        var result = true
        let str:NSString! = "\(textField.text!)" as NSString!
        
        let prospectiveText = (str).replacingCharacters(in: range, with: string)
        
        // var disallowedCharacterSet = CharacterSet.whitespaces
        var limit = 30
        if(textField == passengercount){
            
            if string.characters.count > 0 {
                
                let disallowedCharacterSet = CharacterSet(charactersIn: "0123456789").inverted
                
                let replacementStringIsLegal = string.rangeOfCharacter(from: disallowedCharacterSet) == nil
                
                let resultingStringLengthIsLegal = prospectiveText.characters.count <= 2
                
                result = replacementStringIsLegal &&
                    
                resultingStringLengthIsLegal
                
            }
        }
        if(textField == vehiclemake){
            
            if string.characters.count > 0 {
                
                let disallowedCharacterSet = CharacterSet(charactersIn: "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ.").inverted
                
                let replacementStringIsLegal = string.rangeOfCharacter(from: disallowedCharacterSet) == nil
                
                let resultingStringLengthIsLegal = prospectiveText.characters.count <= 20
                
                result = replacementStringIsLegal &&
                    
                resultingStringLengthIsLegal
                
            }
        }
        if(textField == vehiclemodel){
            
            if string.characters.count > 0 {
                
                let disallowedCharacterSet = CharacterSet(charactersIn: "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ. ").inverted
                
                let replacementStringIsLegal = string.rangeOfCharacter(from: disallowedCharacterSet) == nil
                
                let resultingStringLengthIsLegal = prospectiveText.characters.count <= 20
                
                result = replacementStringIsLegal &&
                    
                resultingStringLengthIsLegal
                
            }
        }
        if(textField == vehicleyear){
            
            if string.characters.count > 0 {
                
                let disallowedCharacterSet = CharacterSet(charactersIn: "0123456789").inverted
                
                let replacementStringIsLegal = string.rangeOfCharacter(from: disallowedCharacterSet) == nil
                
                let resultingStringLengthIsLegal = prospectiveText.characters.count <= 4
                
                result = replacementStringIsLegal &&
                    
                resultingStringLengthIsLegal
                
            }
        }
        if(textField == vehiclemileage){
            
            if string.characters.count > 0 {
                
                let disallowedCharacterSet = CharacterSet(charactersIn: "0123456789").inverted
                
                let replacementStringIsLegal = string.rangeOfCharacter(from: disallowedCharacterSet) == nil
                
                let resultingStringLengthIsLegal = prospectiveText.characters.count <= 6
                
                result = replacementStringIsLegal &&
                    
                resultingStringLengthIsLegal
                
            }
        }
        
        if(textField == vehicleplatefield){
            
            if string.characters.count > 0 {
                
                let disallowedCharacterSet = CharacterSet(charactersIn: "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ").inverted
                
                let replacementStringIsLegal = string.rangeOfCharacter(from: disallowedCharacterSet) == nil
                
                let resultingStringLengthIsLegal = prospectiveText.characters.count <= 15
                
                result = replacementStringIsLegal &&
                    
                resultingStringLengthIsLegal
                
            }
        }
        
        if(textField == refferaltextfield){
            
            if string.characters.count > 0 {
                
                let disallowedCharacterSet = CharacterSet(charactersIn: "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ-/!#_.:^$!~ ").inverted
                
                let replacementStringIsLegal = string.rangeOfCharacter(from: disallowedCharacterSet) == nil
                
                let resultingStringLengthIsLegal = prospectiveText.characters.count <= 30
                
                result = replacementStringIsLegal &&
                    
                resultingStringLengthIsLegal
                
            }
        }
        else{
            
        }
        return result
    }
    
    func errorField(){
        let pasenger = passengercount.text?.trimmingCharacters(in: .whitespaces)
        let vmakeTrim = vehiclemake.text?.trimmingCharacters(in: .whitespaces)
        let vmodelTrim = vehiclemodel.text?.trimmingCharacters(in: .whitespaces)
        let vyearTrim = vehicleyear.text?.trimmingCharacters(in: .whitespaces)
        let vMileage = vehiclemileage.text?.trimmingCharacters(in: .whitespaces)
        let plateno = vehicleplatefield.text?.trimmingCharacters(in: .whitespaces)
        
        if(pasenger! == "" || (pasenger?.characters.count)! < 2){
            noofpaseengerserror.isHidden = false
        }
        
        if(vmakeTrim! == "" || (vmakeTrim?.characters.count)! < 15){
            vehiclemakeerror.isHidden = false
        }
        if(vmodelTrim! == "" || (vmodelTrim?.characters.count)! < 15){
            vehiclemodelerror.isHidden = false
        }
        if(vyearTrim! == "" || (vyearTrim?.characters.count)! < 10){
            vehicleyearerror.isHidden = false
        }
        
        
        if(vMileage! == "" || (vMileage?.characters.count)! < 3){
            vehiclemileage.isHidden = false
        }
        if(plateno! == "" || (plateno?.characters.count)! < 3){
            vehicleplatefield.isHidden = false
        }
        else{
            
            
            
        }
    }
    
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
        
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
       
        if(screenHeight == 568)
            
        {
            
            self.scrollviewupload.contentSize = CGSize(width: 320, height: 1700)
            self.scrollviewupload.isScrollEnabled = true
            
        }
        if(screenHeight == 667)
            
        {
            
            self.scrollviewupload.contentSize = CGSize(width: 320, height: 1500)
            self.scrollviewupload.isScrollEnabled = true
            
        }
        else{
            self.scrollviewupload.contentSize = CGSize(width: 320, height: 1600)
            self.scrollviewupload.isScrollEnabled = true
            //let sada = viewScroll.contentSize.height
            
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        
        UIApplication.shared.isIdleTimerDisabled = false
        
        //  UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        
        navigationController!.isNavigationBarHidden = false
        
        navigationController!.navigationBar.barStyle = .black
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        scrollviewupload.contentSize.height = 1500
        
        tableView.isHidden = true
        
        if(textField == vehiclemake){
            scrollviewupload.contentSize.height = 1250
            scrollviewupload.setContentOffset(CGPoint(x: 0, y: 600), animated: false)
        }
        if(textField == vehicleyear){
            scrollviewupload.contentSize.height = 1250
            scrollviewupload.setContentOffset(CGPoint(x: 0, y: 600), animated: false)
        }
        if(textField == passengercount){
            scrollviewupload.contentSize.height = 1250
            scrollviewupload.setContentOffset(CGPoint(x: 0, y: 600), animated: false)
        }
        if(textField == vehiclemodel){
            scrollviewupload.contentSize.height = 1250
            scrollviewupload.setContentOffset(CGPoint(x: 0, y: 600), animated: false)
        }
        if(textField == vehiclemileage){
            scrollviewupload.contentSize.height = 1250
            scrollviewupload.setContentOffset(CGPoint(x: 0, y: 600), animated: false)
        }
        if(textField == vehicleplatefield){
            scrollviewupload.contentSize.height = 1150
            scrollviewupload.setContentOffset(CGPoint(x: 0, y: 700), animated: false)
        }
        if(textField == refferaltextfield){
 
            scrollviewupload.contentSize.height = 1250
            scrollviewupload.setContentOffset(CGPoint(x: 0, y: 860), animated: false)
            
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
    
    func backToMain(_ Selector: AnyObject) {
        
        self.appDelegate.setRootViewController()
        
    }
    func profileBtn(_ Selector: AnyObject) {
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField == passengercount{
            
            
            self.noofpaseengerserror.isHidden = true
            
            
        }
            
        else if textField == vehiclemake{
            
            
            self.vehiclemakeerror.isHidden = true
            
            
        }
        else if textField == vehiclemodel{
            
            
            self.vehiclemodelerror.isHidden = true
            
            
        }
        else if textField == vehicleyear{
            
            
            self.vehicleyearerror.isHidden = true
            
            
        }
        else if textField == vehiclemileage{
            
            
            self.vehiclemileageerror.isHidden = true
            
            
        }
        else if textField == vehicleplatefield{
            
            
            self.vehicleplateerror.isHidden = true
            
            
        }
        else{
            
        }
        return true
    }
    func invalidData(){
        
        
        passengercount.borderActiveColor = UIColor.black
        passengercount.borderInactiveColor = UIColor.black
        passengercount.placeholderColor = UIColor.black
        
        vehiclemake.borderActiveColor = UIColor.black
        vehiclemake.borderInactiveColor = UIColor.black
        vehiclemake.placeholderColor = UIColor.black
        
        vehiclemodel.borderActiveColor = UIColor.black
        vehiclemodel.borderInactiveColor = UIColor.black
        vehiclemodel.placeholderColor = UIColor.black
        
        vehicleyear.borderActiveColor = UIColor.black
        vehicleyear.borderInactiveColor = UIColor.black
        vehicleyear.placeholderColor = UIColor.black
        
        vehiclemileage.borderActiveColor = UIColor.black
        vehiclemileage.borderInactiveColor = UIColor.black
        vehiclemileage.placeholderColor = UIColor.black
        
        vehicleplatefield.borderActiveColor = UIColor.black
        vehicleplatefield.borderInactiveColor = UIColor.black
        vehicleplatefield.placeholderColor = UIColor.black
        
        
    }
    @IBAction func btnUploadContinueAction(_ sender: Any) {
        
        errorField()
        
        // if btnUpload1.titleLabel?.text == "a" || btnUpload2.titleLabel?.text == "b"{
        let passengerTrim = passengercount.text?.trimmingCharacters(in: .whitespaces)
        print(self.vehiclemake.text)
        
        let vmakeTrim = vehiclemake.text!.trimmingCharacters(in: .whitespaces)
        let vmodelTrim = vehiclemodel.text!.trimmingCharacters(in: .whitespaces)
        let vyearTrim = vehicleyear.text!.trimmingCharacters(in: .whitespaces)
        let vMileage = vehiclemileage.text!.trimmingCharacters(in: .whitespaces)
        let plateno = vehicleplatefield.text!.trimmingCharacters(in: .whitespaces)
        /*if (self.referralerror.isHidden==false) {
            
            self.referralerror.text = "Invalid Referral Code"
            self.referralerror.isHidden = false
        }
        else{
            
            self.referralerror.isHidden = true
        }*/
        
        print(vmakeTrim)
        
        if(vmakeTrim == "" || vmodelTrim == "" || vyearTrim == "" || vMileage == "" || passengerTrim == ""){
            self.invalidData()
            
            
            
            //            textFieldFirstName.placeholderLabel.text = "Enter a valid name"
        }
        else{
            self.carcategoryerror.isHidden = true
            self.noofpaseengerserror.isHidden = true
            self.vehiclemakeerror.isHidden = true
            self.vehiclemodelerror.isHidden = true
            self.vehicleyearerror.isHidden = true
            self.vehiclemileageerror.isHidden = true
            self.vehicleplateerror.isHidden = true
            // self.validData()
        }
        
        if self.driverLicenseFront == "" || self.commInsurance == ""  || self.driverLicenseBack == "" || self.acraDocument == "" || self.vehRegDocument == "" || self.vocLicDocument == "" || self.privHireDocument == "" || self.nricFrontDoc == "" || self.nricBackDoc == ""{
            self.labelInvalid.text = "Please Upload all documents"
            self.labelInvalid.isHidden = false

        }
        
      
       if (labelCar.text == "Select your car category") {
            
            self.carcategoryerror.text = " Please select your car category"
            self.carcategoryerror.isHidden = false
            self.noofpaseengerserror.isHidden = true
            self.vehiclemakeerror.isHidden = true
            self.vehiclemodelerror.isHidden = true
            self.vehicleyearerror.isHidden = true
            self.vehiclemileageerror.isHidden = true
            self.vehicleplateerror.isHidden = true
        }
            
        else if(passengerTrim == "" || passengercount.text == "" ){
            self.noofpaseengerserror.text = "Enter Number Of Passengers"
            self.noofpaseengerserror.isHidden = false
            self.vehiclemakeerror.isHidden = true
            self.vehiclemodelerror.isHidden = true
            self.vehicleyearerror.isHidden = true
            self.vehiclemileageerror.isHidden = true
            self.vehicleplateerror.isHidden = true
        }
            
            
        else if(vmakeTrim == "" || vehiclemake.text == "" ){
            self.vehiclemakeerror.text = "Enter Vehicle Make"
            self.vehiclemakeerror.isHidden = false
            self.carcategoryerror.isHidden = true
            self.noofpaseengerserror.isHidden = true
            self.noofpaseengerserror.isHidden = true
            self.vehiclemodelerror.isHidden = true
            self.vehicleyearerror.isHidden = true
            self.vehiclemileageerror.isHidden = true
            self.vehicleplateerror.isHidden = true
        }
        else if(vmodelTrim == "" || vehiclemodel.text == "" ){
            self.vehiclemodelerror.text = "Enter Vehicle Model"
            self.vehiclemodelerror.isHidden = false
            self.carcategoryerror.isHidden = true
            self.noofpaseengerserror.isHidden = true
            self.vehiclemakeerror.isHidden = true
            self.vehicleyearerror.isHidden = true
            self.vehiclemileageerror.isHidden = true
            self.vehicleplateerror.isHidden = true
        }
            
            
        else if(vyearTrim == "" || vehicleyear.text == ""){
            self.carcategoryerror.isHidden = true
            self.noofpaseengerserror.isHidden = true
            self.vehiclemakeerror.isHidden = true
            self.vehiclemodelerror.isHidden = true
            self.vehicleyearerror.text = "Enter Vehicle Year"
            self.vehicleyearerror.isHidden = false
            self.vehiclemileageerror.isHidden = true
            self.vehicleplateerror.isHidden = true
        }
            
        else if(vMileage == "" || vehiclemileage.text == ""){
            self.vehiclemileageerror.text = "Enter Vehicle Mileage"
            self.vehiclemileageerror.isHidden = false
            self.carcategoryerror.isHidden = true
            self.noofpaseengerserror.isHidden = true
            self.vehiclemakeerror.isHidden = true
            self.vehiclemodelerror.isHidden = true
            self.vehicleyearerror.isHidden = true
            self.vehicleplateerror.isHidden = true
        }
        else if(plateno == "" || vehicleplatefield.text == ""){
            self.vehiclemileageerror.text = "Enter Vehicle plate No"
            self.vehiclemileageerror.isHidden = true
            self.carcategoryerror.isHidden = true
            self.noofpaseengerserror.isHidden = true
            self.vehiclemakeerror.isHidden = true
            self.vehiclemodelerror.isHidden = true
            self.vehicleyearerror.isHidden = true
            self.vehicleplateerror.isHidden = false
        }
            
        else{
            
            self.vehiclemileageerror.isHidden = true
            self.carcategoryerror.isHidden = true
            self.noofpaseengerserror.isHidden = true
            self.vehiclemakeerror.isHidden = true
            self.vehiclemodelerror.isHidden = true
            self.vehicleyearerror.isHidden = true
            
            if passValue == nil{
                
                self.sigin()
            }
            else if passValue == "newFbUser"{
                
                self.signInNewUserFb()
            }
            else{
                
                self.signInNewUserGb()
            }
            
        }
        
        
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField == passengercount{
            
            
            self.noofpaseengerserror.isHidden = true
            
            
        }
            
        else if textField == vehiclemake{
            
            
            self.vehiclemakeerror.isHidden = true
            
            
        }
        else if textField == vehiclemodel{
            
            
            self.vehiclemodelerror.isHidden = true
            
            
        }
        else if textField == vehicleyear{
            
            
            self.vehicleyearerror.isHidden = true
            
            
        }
        else if textField == vehiclemileage{
            
            
            self.vehiclemileageerror.isHidden = true
            
            
        }
            
        else if textField == vehicleplatefield{
            
            
            self.vehicleplateerror.isHidden = true
            
            
        }
        else{
            
        }
        return true
    }
    func referalupdate(){
        
        self.appDelegate.referalcodevalue = self.refferaltextfield.text!
        print(self.refferaltextfield.text)
        
        if(self.refferaltextfield.text == "")
        {
            
        }
        else{
            
            var urlstring:String = "\(signInAPIUrl)refrel_code/code/\(self.appDelegate.referalcodevalue)"
            
            urlstring = urlstring.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!
            
            
            
            urlstring=(urlstring.replacingOccurrences(of: "Optional", with: "") as String as NSString!) as String
            
            urlstring=(urlstring.replacingOccurrences(of: "(", with: "") as String as NSString!) as String
            
            urlstring=(urlstring.replacingOccurrences(of: ")", with: "") as String as NSString!) as String
            
            urlstring=(urlstring.replacingOccurrences(of: "%22", with: "") as String as NSString!) as String
            
            
            print(urlstring)
            
            self.Referalurl(url: "\(urlstring)")
            
            
        }
    }
    func Referalurl(url : String)
    {
        Alamofire.request(url).responseJSON { (response) in
            
            self.callreferalparsedata(JSONData: response.data!)
            
        }
    }
    
    
    func callreferalparsedata(JSONData : Data){
        
        do{
            
            let readableJSon = try JSONSerialization.jsonObject(with: JSONData, options: .mutableContainers) as! jsonSTD
            
            print(" !!! \(readableJSon[0])")
            
            let value = readableJSon[0] as AnyObject
            if let satus = value.object(forKey: "status"){
                print(satus)
                
                self.updatestatus = satus as! String
                if(self.updatestatus == "Success"){
                    self.referralerror.isHidden=true
                    self.referralerror.text = ""
                    if passValue == nil{
                        
                        self.urlstringupdate = "\(signInAPIUrl)signUp/first_name/\(self.appDelegate.firstname!)/last_name/\(self.appDelegate.lastname!)/nick_name/\(self.appDelegate.nickname)/mobile/\(self.appDelegate.phonenumber!)/country_code/\(self.appDelegate.countrycode!)/password/\(self.appDelegate.password!)/city/\(self.appDelegate.city!)/email/\(self.appDelegate.email!)/regid/5467/profile_pic/\(self.appDelegate.signUpUserProfile!)/license/\(self.appDelegate.signUpUserlicense!)/insurance/\(self.appDelegate.signUpUserdocument!)/ARCA/\(self.appDelegate.signUparcadoc)/vehicle_reg/\(self.appDelegate.signvehiclereg)/commercial_pic/\(self.appDelegate.signcommercialdoc)/passenger_count/\(self.appDelegate.passengersvalue)/referral_code/\(self.appDelegate.referalcodevalue)/category/\(self.labelCar.text!)/vehicle_make/\(self.appDelegate.vehicmake)/vehicle_model/\(self.appDelegate.vehicmodel)/vehicle_year/\(self.appDelegate.vehicyear)/vehicle_mileage/\(self.appDelegate.vehicmileage)/number_plate/\(self.appDelegate.plateno)"
                        
                        
                        
                        
                        self.urlstringupdate = self.urlstringupdate.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!
                        
                        self.urlstringupdate=(self.urlstringupdate.replacingOccurrences(of: "Optional", with: "") as String as NSString!) as String
                        
                        self.urlstringupdate=(self.urlstringupdate.replacingOccurrences(of: "(", with: "") as String as NSString!) as String
                        
                        self.urlstringupdate=(self.urlstringupdate.replacingOccurrences(of: ")", with: "") as String as NSString!) as String
                        
                        self.urlstringupdate=(self.urlstringupdate.replacingOccurrences(of: "%22", with: "") as String as NSString!) as String
                        
                        print(self.urlstringupdate)
                        self.continuebtn.isEnabled = false
                        self.callSiginAPI(url: "\(self.urlstringupdate)")
                    }
                    else if passValue == "newFbUser"{
                        
                        var urlstring:String = "\(signInAPIUrl)fbSignup/regid/5765/first_name/\(self.appDelegate.fbFirstName!)/last_name/\(self.appDelegate.fbLastName!)/mobile/null/country_code/null/password/null/city/null/email/\(self.appDelegate.fbEmail!)/license/\(self.appDelegate.signUpUserlicense!)/insurance/\(self.appDelegate.signUpUserdocument!)/fb_id/\(self.appDelegate.fbID!)/category/\(self.labelCar.text!)/number_plate/\(self.appDelegate.plateno)/vehicle_make/\(self.appDelegate.vehicmake)/vehicle_model/\(self.appDelegate.vehicmodel)/vehicle_year/\(self.appDelegate.vehicyear)/vehicle_mileage/\(self.appDelegate.vehicmileage)/passenger_count/\(self.appDelegate.passengersvalue)/license/\(self.appDelegate.signUpUserlicense!)/insurance/\(self.appDelegate.signUpUserdocument!)/ARCA/\(self.appDelegate.signUparcadoc)/vehicle_reg/\(self.appDelegate.signvehiclereg)/commercial_pic/\(self.appDelegate.signcommercialdoc)/referral_code/\(self.appDelegate.referalcodevalue)"
                        
                        
                        
                        urlstring = urlstring.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!
                        
                        urlstring=(urlstring.replacingOccurrences(of: "Optional", with: "") as String as NSString!) as String
                        
                        urlstring=(urlstring.replacingOccurrences(of: "(", with: "") as String as NSString!) as String
                        
                        urlstring=(urlstring.replacingOccurrences(of: ")", with: "") as String as NSString!) as String
                        
                        urlstring=(urlstring.replacingOccurrences(of: "%22", with: "") as String as NSString!) as String
                        
                        urlstring=(urlstring.replacingOccurrences(of: "%2522", with: "") as String as NSString!) as String
                        
                        print(urlstring)
                        
                        self.callSignInNewUserFBAPI(url: "\(urlstring)")
                    }
                    else{
                        
                        var urlstring:String = "\(signInAPIUrl)googleSignup/regid/5765/first_name/\(self.appDelegate.GPFirstName!)/last_name/\(self.appDelegate.GPLastName!)/mobile/null/country_code/null/password/null/city/null/email/\(self.appDelegate.GPEmail!)/license/\(self.appDelegate.signUpUserlicense!)/insurance/\(self.appDelegate.signUpUserdocument!)/google_id/\(self.appDelegate.GPID!)/category/\(self.labelCar.text!)/number_plate/\(self.vehicleplatefield.text!)/vehicle_make/\(self.appDelegate.vehicmake)/vehicle_model/\(self.appDelegate.vehicmodel)/vehicle_year/\(self.appDelegate.vehicyear)/vehicle_mileage/\(self.appDelegate.vehicmileage)/passenger_count/\(self.appDelegate.passengersvalue)/license/\(self.appDelegate.signUpUserlicense!)/insurance/\(self.appDelegate.signUpUserdocument!)/ARCA/\(self.appDelegate.signUparcadoc)/vehicle_reg/\(self.appDelegate.signvehiclereg)/commercial_pic/\(self.appDelegate.signcommercialdoc)/referral_code/\(self.appDelegate.referalcodevalue)/profile_pic/\(self.appDelegate.GProfileimg!)"
                        
                        
                        
                        urlstring = urlstring.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!
                        
                        urlstring=(urlstring.replacingOccurrences(of: "Optional", with: "") as String as NSString!) as String
                        
                        urlstring=(urlstring.replacingOccurrences(of: "(", with: "") as String as NSString!) as String
                        
                        urlstring=(urlstring.replacingOccurrences(of: ")", with: "") as String as NSString!) as String
                        
                        urlstring=(urlstring.replacingOccurrences(of: "%22", with: "") as String as NSString!) as String
                        
                        urlstring=(urlstring.replacingOccurrences(of: "%2522", with: "") as String as NSString!) as String
                        
                        print(urlstring)
                        
                        
                        self.callSignInNewUserFBAPI(url: "\(urlstring)")
                    }

                    
                    
                }
                else{
                    
                    self.referralerror.isHidden=false
                    self.referralerror.text = "Invalid Referral Code"
                    //self.invalidData()
                    
                }
            }
            
        }
        catch{
            print(error)
        }
    }
    
    @IBAction func btnSelectCarAction(_ sender: Any) {
        
        
        // tableView.isHidden = !tableView.isHidden
        self.labelInvalid.isHidden = true
        tableView.isHidden = false
    }
 
    @IBAction func openCamera(_ sender: AnyObject) {
        
        let cameraViewController = CameraViewController(croppingEnabled: croppingEnabled, allowsLibraryAccess: libraryEnabled) { [weak self] image, asset in
            self?.dismiss(animated: true, completion: nil)
        }
        
        present(cameraViewController, animated: true, completion: nil)
    }
    
    func signInNewUserFb(){
        self.appDelegate.passengersvalue = self.passengercount.text!
        self.appDelegate.vehicmake = self.vehiclemake.text!
        self.appDelegate.vehicmodel = self.vehiclemodel.text!
        self.appDelegate.vehicyear = self.vehicleyear.text!
        self.appDelegate.vehicmileage = self.vehiclemileage.text!
        self.appDelegate.plateno = self.vehicleplatefield.text!
        
        print(self.appDelegate.passengersvalue)
        activityView.startAnimating()
        self.appDelegate.referalcodevalue = self.refferaltextfield.text!
        print(self.appDelegate.referalcodevalue)
        if(self.appDelegate.referalcodevalue != ""){
            referalupdate()
        
        }
        else{
            var urlstring:String = "\(signInAPIUrl)fbSignup/regid/5765/first_name/\(self.appDelegate.fbFirstName!)/last_name/\(self.appDelegate.fbLastName!)/mobile/null/country_code/null/password/null/city/null/email/\(self.appDelegate.fbEmail!)/license/\(self.appDelegate.signUpUserlicense!)/insurance/\(self.appDelegate.signUpUserdocument!)/fb_id/\(self.appDelegate.fbID!)/category/\(self.labelCar.text!)/number_plate/\(self.appDelegate.plateno)/vehicle_make/\(self.appDelegate.vehicmake)/vehicle_model/\(self.appDelegate.vehicmodel)/vehicle_year/\(self.appDelegate.vehicyear)/vehicle_mileage/\(self.appDelegate.vehicmileage)/passenger_count/\(self.appDelegate.passengersvalue)/license/\(self.appDelegate.signUpUserlicense!)/insurance/\(self.appDelegate.signUpUserdocument!)/ARCA/\(self.appDelegate.signUparcadoc)/vehicle_reg/\(self.appDelegate.signvehiclereg)/commercial_pic/\(self.appDelegate.signcommercialdoc)/license_back/\(self.driverLicenseBack)/nric_front/\(self.nricFrontDoc)/nric_back/\(self.nricBackDoc)/ph_hire/\(self.privHireDocument)"
            
           
            
            urlstring = urlstring.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!
            
            urlstring=(urlstring.replacingOccurrences(of: "Optional", with: "") as String as NSString!) as String
            
            urlstring=(urlstring.replacingOccurrences(of: "(", with: "") as String as NSString!) as String
            
            urlstring=(urlstring.replacingOccurrences(of: ")", with: "") as String as NSString!) as String
            
            urlstring=(urlstring.replacingOccurrences(of: "%22", with: "") as String as NSString!) as String
            urlstring=(urlstring.replacingOccurrences(of: "%2522", with: "") as String as NSString!) as String
            
            print(urlstring)
            
            self.callSignInNewUserFBAPI(url: "\(urlstring)")
        }
        
    }
    func signInNewUserGb(){
        self.appDelegate.passengersvalue = self.passengercount.text!
        self.appDelegate.vehicmake = self.vehiclemake.text!
        self.appDelegate.vehicmodel = self.vehiclemodel.text!
        self.appDelegate.vehicyear = self.vehicleyear.text!
        self.appDelegate.vehicmileage = self.vehiclemileage.text!
        self.appDelegate.plateno = self.vehicleplatefield.text!
        
        
        print(self.appDelegate.passengersvalue)
        activityView.startAnimating()
        self.appDelegate.referalcodevalue = self.refferaltextfield.text!
        print(self.appDelegate.referalcodevalue)
        
        if(self.appDelegate.referalcodevalue != ""){
            referalupdate()
       
    }
         else{
            var urlstring:String = "\(signInAPIUrl)googleSignup/regid/5765/first_name/\(self.appDelegate.GPFirstName!)/last_name/\(self.appDelegate.GPLastName!)/mobile/null/country_code/null/password/null/city/null/email/\(self.appDelegate.GPEmail!)/license/\(self.appDelegate.signUpUserlicense!)/insurance/\(self.appDelegate.signUpUserdocument!)/google_id/\(self.appDelegate.GPID!)/category/\(self.labelCar.text!)/number_plate/\(self.vehicleplatefield.text!)/vehicle_make/\(self.appDelegate.vehicmake)/vehicle_model/\(self.appDelegate.vehicmodel)/vehicle_year/\(self.appDelegate.vehicyear)/vehicle_mileage/\(self.appDelegate.vehicmileage)/passenger_count/\(self.appDelegate.passengersvalue)/license/\(self.appDelegate.signUpUserlicense!)/insurance/\(self.appDelegate.signUpUserdocument!)/ARCA/\(self.appDelegate.signUparcadoc)/vehicle_reg/\(self.appDelegate.signvehiclereg)/commercial_pic/\(self.appDelegate.signcommercialdoc)/profile_pic/\(self.appDelegate.GProfileimg!)/license_back/\(self.driverLicenseBack)/nric_front/\(self.nricFrontDoc)/nric_back/\(self.nricBackDoc)/ph_hire/\(self.privHireDocument)"
            
            
            
            urlstring = urlstring.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!
            
            urlstring=(urlstring.replacingOccurrences(of: "Optional", with: "") as String as NSString!) as String
            
            urlstring=(urlstring.replacingOccurrences(of: "(", with: "") as String as NSString!) as String
            
            urlstring=(urlstring.replacingOccurrences(of: ")", with: "") as String as NSString!) as String
            
            urlstring=(urlstring.replacingOccurrences(of: "%22", with: "") as String as NSString!) as String
            
            urlstring=(urlstring.replacingOccurrences(of: "%2522", with: "") as String as NSString!) as String
            print(urlstring)
            
            
            self.callSignInNewUserFBAPI(url: "\(urlstring)")
        }
    
    }
    func callSignInNewUserFBAPI(url : String){
        
        
        activityView.startAnimating()
        
        Alamofire.request(url).responseJSON { (response) in
            
            self.callSignInNewUserFBParseData(JSONData: response.data!)
            
        }
        
    }
    func callSignInNewUserFBParseData(JSONData : Data){
        
        do{
            
            let readableJSon = try JSONSerialization.jsonObject(with: JSONData, options: .mutableContainers) as! jsonSTD
            
            print(" !!! \(readableJSon[0])")
            
            let value = readableJSon[0] as AnyObject
            
            if let final = value.object(forKey: "status"){
                print(final)
                if(final as! String == "Success"){
                    
                    
                    var status_extra = ""
                    var userid:String = ""
                    let email:String = value.object(forKey: "email") as! String
                    let first_name:String = value.object(forKey: "first_name") as! String
                    let last_name:String = value.object(forKey: "last_name") as! String
                    
                    let carCategory:String = value.object(forKey: "category") as! String
                    
                    //     let mobile:String = value.object(forKey: "mobile") as! String
                    if let status_extr:String = value.object(forKey: "status_extra") as? String{
                        if status_extr == "Exist"{
                            status_extra = "Exist"
                        }
                        
                    }
                    print(status_extra)
                    
                    if let userID:String = (value.object(forKey: "userid") as? String){
                        
                        if(status_extra != "Exist"){
                            
                            self.appDelegate.userid = userID
                            
                            print(self.appDelegate.userid!)
                            print(userID)
                            let ref1 = FIRDatabase.database().reference()
                            
                            let userId = userID
                            
                            userid = userID
                            
                            let newUser = [
                                
                                "name": "\(first_name) \(last_name)",
                                //  "location" : "",
                                "email"      : "\(email)",
                                
                                "proof_status" : "Pending" ,
                                
                                ]
                            
                            let requestArray = [
                                
                                "req_id"      : "",
                                "status" : "",
                                
                                ]
                            
                            let acceptArray = [
                                
                                "status"      : "",
                                "trip_id" : "",
                                
                                ]
                            
                            /*  ref1.child(byAppendingPath: "drivers_location")
                             .child(byAppendingPath: userid)
                             .setValue(newUser) */
                            
                            let appendingPath = ref1.child(byAppendingPath: "drivers_data")
                            
                            //                            let appendingPath1 = ref1.child(byAppendingPath: "drivers_data")
                            
                            
                            appendingPath.child(byAppendingPath: userId).setValue(newUser)
                            appendingPath.child(userId).child("request").setValue(requestArray)
                            appendingPath.child(userId).child("accept").setValue(acceptArray)
                            
                            //                            appendingPath.child(byAppendingPath: userId).child(byAppendingPath: "request").setValue(requestArray)
                            //
                            //                            appendingPath.child(byAppendingPath: userId).child(byAppendingPath: "accept").setValue(acceptArray)
                            
                        }
                        else{
                            userid = userID
                            self.appDelegate.userid = userid
                            
                        }
                    }
                    else{
                        
                        userid = (value.object(forKey: "_id") as! String)
                        self.appDelegate.userid = userid
                        
                        var ref1 = FIRDatabase.database().reference()
                        
                        var userId = userid
                        
                        let newUser = [
                            
                            "name": "\(first_name) \(last_name)",
                            //  "location" : "",
                            "email"      : "\(email)",
                            
                            "proof_status" : "Pending" ,
                            ]
                        
                        var requestArray = [
                            
                            "req_id"      : "",
                            "status" : "",
                            
                            ]
                        
                        var acceptArray = [
                            
                            "status"      : "",
                            "trip_id" : "",
                            
                            ]
                        
                        /*  ref1.child(byAppendingPath: "drivers_location")
                         .child(byAppendingPath: userid)
                         .setValue(newUser) */
                        
                        let appendingPath = ref1.child(byAppendingPath: "drivers_data")
                        
                        let appendingPath1 = ref1.child(byAppendingPath: "drivers_data")
                        
                        appendingPath.child(byAppendingPath: userId).setValue(newUser)
                        appendingPath.child(userId).child("request").setValue(requestArray)
                        appendingPath.child(userId).child("accept").setValue(acceptArray)
                        
                        //                        appendingPath.child(byAppendingPath: userId).setValue(newUser)
                        //
                        //                        appendingPath.child(byAppendingPath: userId).child(byAppendingPath: "request").setValue(requestArray)
                        //
                        //                        appendingPath1.child(byAppendingPath: userId).child(byAppendingPath: "accept").setValue(acceptArray)
                        
                    }
                    
                    print("email is \(email)")
                    print(carCategory)
                    self.appDelegate.loggedEmail = email
                    self.appDelegate.fname = first_name
                    self.appDelegate.lname = last_name
                    
                    UserDefaults.standard.setValue(userid, forKey: "userid")
                    
                    UserDefaults.standard.setValue(carCategory, forKey: "carCategoryRegister")
                    
                    print("\(UserDefaults.standard.value(forKey: "userid")!)")
                    self.navigationController?.pushViewController(ADHomePageVC(), animated: true)
                    
                    self.activityView.isHidden = true
                    self.activityView.stopAnimating()
                    
                    
                }
                    
                else{
                    
                }
            }
        }
        catch{
            
            print(error)
            
        }
        
    }
    func sigin(){
        
        self.appDelegate.passengersvalue = self.passengercount.text!
        self.appDelegate.vehicmake = self.vehiclemake.text!
        self.appDelegate.vehicmodel = self.vehiclemodel.text!
        self.appDelegate.vehicyear = self.vehicleyear.text!
        self.appDelegate.vehicmileage = self.vehiclemileage.text!
        self.appDelegate.plateno = self.vehicleplatefield.text!
        
        
        print(self.appDelegate.passengersvalue)
        activityView.startAnimating()
        self.appDelegate.referalcodevalue = self.refferaltextfield.text!
        print(self.appDelegate.referalcodevalue)
        
        
        //String url= Constants.LIVEURL+"signUp/"+"first_name/"+strFirstName+"/last_name/"+strLastName+"/nick_name/"+strNickName+"/mobile/"+strMobile+"/country_code/"+strCountyCode+"/password/"+strPassword+"/city/"+strCity+"/email/"+strEmail+"/regid/344444444444444"+"/profile_pic/"+strProfileImage+"/license/"+strLicense+"/insurance/"+strInsurnce+"/ARCA/"+strArcaProfile+"/vehicle_reg/"+strVehicleReg+"/commercial_pic/"+strCommercial+"/category/"+strSelectedCategory+"/passenger_count/"+strNumOfPassenger+"/vehicle_make/"+strVehiclemake+"/vehicle_model/"+strVehiclemodel+"/vehicle_year/"+strVehicleyear+"/vehicle_mileage/"+strVehiclemileage;
        
        print(appDelegate.signcommercialdoc)
        print(appDelegate.signUparcadoc)
        
        if(self.appDelegate.referalcodevalue != ""){
            
            referalupdate()
            
            
        }
            
        else{
            print(self.appDelegate.signcommercialdoc)
            print(appDelegate.signUparcadoc)
            self.self.labelCar.text!=(self.labelCar.text!.replacingOccurrences(of: " ", with: "_") as String as NSString!) as String
            
            self.urlstringupdate = "\(signInAPIUrl)signUp/first_name/\(self.appDelegate.firstname!)/last_name/\(self.appDelegate.lastname!)/nick_name/\(self.appDelegate.nickname)/mobile/\(self.appDelegate.phonenumber!)/country_code/\(self.appDelegate.countrycode!)/password/\(self.appDelegate.password!)/city/\(self.appDelegate.city!)/email/\(self.appDelegate.email!)/regid/5467/profile_pic/\(self.appDelegate.signUpUserProfile!)/license/\(self.driverLicenseFront!)/insurance/\(self.vocLicDocument!)/ARCA/\(self.acraDocument)/vehicle_reg/\(self.vehRegDocument)/commercial_pic/\(self.commInsurance)/passenger_count/\(self.appDelegate.passengersvalue)/category/\(self.labelCar.text!)/vehicle_make/\(self.appDelegate.vehicmake)/vehicle_model/\(self.appDelegate.vehicmodel)/vehicle_year/\(self.appDelegate.vehicyear)/vehicle_mileage/\(self.appDelegate.vehicmileage)/number_plate/\(self.appDelegate.plateno)/license_back/\(self.driverLicenseBack)/nric_front/\(self.nricFrontDoc)/nric_back/\(self.nricBackDoc)/ph_hire/\(self.privHireDocument)"
            
            
            
            
            self.urlstringupdate = self.urlstringupdate.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!
            
            self.urlstringupdate=(self.urlstringupdate.replacingOccurrences(of: "Optional", with: "") as String as NSString!) as String
            
            self.urlstringupdate=(self.urlstringupdate.replacingOccurrences(of: "(", with: "") as String as NSString!) as String
            
            self.urlstringupdate=(self.urlstringupdate.replacingOccurrences(of: ")", with: "") as String as NSString!) as String
            
            self.urlstringupdate=(self.urlstringupdate.replacingOccurrences(of: "%22", with: "") as String as NSString!) as String
            
            print(self.urlstringupdate)
            self.continuebtn.isEnabled = false
            self.callSiginAPI(url: "\(self.urlstringupdate)")
        }
    }
    
    
    
    func callSiginAPI(url : String){
        
        
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
            
            let final = value.object(forKey: "status")
            
            if let final = value.object(forKey: "status"){
                print(final)
                if(final as! String == "Success"){
                    self.continuebtn.isEnabled = true
                    let email:String = value.object(forKey: "email") as! String
                    let first_name:String = value.object(forKey: "first_name") as! String
                    let last_name:String = value.object(forKey: "last_name") as! String
                    //let mobile:String = value.object(forKey: "mobile") as! String
                    let userid:String = value.object(forKey: "userid") as! String
                    
                    let carCategory:String = value.object(forKey: "category") as! String
                    
                    print("email is \(email)")
                    print("userid is \(userid)")
                    print(carCategory)
                    
                    self.appDelegate.userid = userid
                    self.appDelegate.loggedEmail = email
                    self.appDelegate.fname = first_name
                    self.appDelegate.lname = last_name
                    
                    UserDefaults.standard.setValue(carCategory, forKey: "carCategoryRegister")
                    
                    UserDefaults.standard.setValue(userid, forKey: "userid")
                    
                    print("\(UserDefaults.standard.value(forKey: "userid")!)")
             
                    
                    //  let ref = FIRDatabase.database().reference()
                    
                    //  let geoFire = GeoFire(firebaseRef: ref.child("drivers_location"))
                    
                    //  ref.child("drivers_location/")
                    
                    
                    var ref1 = FIRDatabase.database().reference()
                    
                    var userId = userid
                    
                    let newUser = [
                        
                        "name": "\(first_name) \(last_name)",
                        //  "location" : "",
                        "email"      : "\(email)",
                        "proof_status" : "Pending" ,
                        
                        ]
                    
                    var requestArray = [
                        
                        "req_id"      : "",
                        "status" : "",
                        
                        ]
                    
                    var acceptArray = [
                        
                        "status"      : "",
                        "trip_id" : "",
                        
                        ]
                    
                    /*  ref1.child(byAppendingPath: "drivers_location")
                     .child(byAppendingPath: userid)
                     .setValue(newUser) */
                    
                    var appendingPath = ref1.child(byAppendingPath: "drivers_data")
                    
                    var appendingPath1 = ref1.child(byAppendingPath: "drivers_data")
                    appendingPath.child(byAppendingPath: userId).setValue(newUser)
                    appendingPath.child(userId).child("request").setValue(requestArray)
                    appendingPath.child(userId).child("accept").setValue(acceptArray)
                    
                    //                    appendingPath.child(byAppendingPath: userId).setValue(newUser)
                    //
                    //                    appendingPath.child(byAppendingPath: userId).child(byAppendingPath: "request").setValue(requestArray)
                    //
                    //                    appendingPath1.child(byAppendingPath: userId).child(byAppendingPath: "accept").setValue(acceptArray)
                    
                    
                    
                    /* var age: Void  = ref1.child(byAppendingPath: "drivers_location/\(userid)/email").setValue("\(email)")
                     //    var location: Void  = ref1.child(byAppendingPath: "drivers_location/\(userid)/location").setValue("my location")
                     //     var About : Void = ref1.child(byAppendingPath: "drivers_location/\(userid)/geo_location").setValue("aboutme")
                     
                     //  let geoFire = GeoFire(firebaseRef: ref1.child(byAppendingPath: "drivers_location/\(userid)"))
                     let geoFire = GeoFire(firebaseRef: ref1)
                     
                     ref1.setValue(Any?, withCompletionBlock: <#T##(Error?, FIRDatabaseReference) -> Void#>)
                     
                     
                     geoFire!.setLocation(CLLocation(latitude: (currentLocation.coordinate.latitude), longitude: (currentLocation.coordinate.longitude)), forKey: "geolocatsion") { (error) in
                     
                     if (error != nil) {
                     print("An error occured: \(error)")
                     
                     } else {
                     
                     print("Saved location successfully!")
                     
                     }
                     }  */
                    
                    self.activityView.stopAnimating()
                    
                    appDelegate.callMapVC()
                    
                    //self.navigationController?.pushViewController(ADHomePageVC(), animated: true)
                    
                    
                }
                else{
                    
                    self.activityView.stopAnimating()
                    
                    let toastLabel = UILabel(frame: CGRect(x: 15.0, y: 188, width: 335, height: 30))
                    toastLabel.backgroundColor = UIColor.black
                    toastLabel.textColor = UIColor.white
                    toastLabel.textAlignment = NSTextAlignment.center;
                    self.view.addSubview(toastLabel)
                    toastLabel.text = "Document not uploaded properly"
                    toastLabel.alpha = 1.0
                    toastLabel.layer.cornerRadius = 0;
                    toastLabel.clipsToBounds  =  true
                    
                    UIView.animate(withDuration: 4.0, delay: 0.1, options: UIViewAnimationOptions.curveEaseOut, animations: {
                        
                        toastLabel.alpha = 0.0
                        
                    })
                    self.continuebtn.isEnabled = true
                }
            }
                
            else{
                let warning = MessageView.viewFromNib(layout: .CardView)
                warning.configureTheme(.warning)
                warning.configureDropShadow()
                let iconText = "" //"🤔"
                warning.configureContent(title: "", body: "Document not uploaded properly", iconText: iconText)
                warning.button?.isHidden = true
                var warningConfig = SwiftMessages.defaultConfig
                warningConfig.presentationContext = .window(windowLevel: UIWindowLevelStatusBar)
                
                SwiftMessages.show(config: warningConfig, view: warning)
                self.continuebtn.isEnabled = true
            }
            
        }
        catch{
            
            print(error)
            
            self.activityView.stopAnimating()
            
        }
        
    }
    
    
    // MARK: UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 25.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return totalArrayOfCars.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:UploadCell = tableView.dequeueReusableCell(withIdentifier: "uploadCell") as! UploadCell!
        
        let cars = totalArrayOfCars.object(at: indexPath.row) as? String
        
        if cars == nil || cars == ""{
            
            
        }
        else{
            
            cell.labelCar.text = "  \(cars!)"
        }
        
        return cell
    }
    
    // MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: false)
        labelCar.text = totalArrayOfCars.object(at: indexPath.row) as? String
        tableView.isHidden = true
    }
    
    /*func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
     return 0.0
     }*/
    
    func callCarsList(){
        
        totalArrayOfCars.removeAllObjects()
        
        var urlstring:String = "\(live_request_url)settings/getCategory"
        
        
        urlstring = urlstring.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!
        
        print(urlstring)
        
        let manager : AFHTTPRequestOperationManager = AFHTTPRequestOperationManager()
        
        manager.responseSerializer.acceptableContentTypes =  NSSet(objects: "text/plain", "text/html", "application/json", "audio/wav", "application/octest-stream") as Set<NSObject>
        
        manager.get("\(urlstring)",
            parameters: nil,
            success: { (operation: AFHTTPRequestOperation?,responseObject: Any?) in
                
                let jsonObjects:NSArray = responseObject as! NSArray
                
                if jsonObjects.count == 0{
                    
                    
                }
                for dataDict : Any in jsonObjects.reversed()
                {
                    
                    if jsonObjects.count == 0{
                        
                        
                    }
                    else{
                        
                        
                        let carList = (dataDict as AnyObject).object(forKey: "categoryname") as? String
                        
                        self.totalArrayOfCars.add(carList)
                    }
                    
                    
                }
                
                self.tableView.reloadData()
        },
            failure: { (operation: AFHTTPRequestOperation?,error: Error) in
                print("Error: " + error.localizedDescription)
                
        })
        
    }
    
    @IBAction func driverDocButtonAction(_ sender: UIButton)
    {
        self.labelInvalid.isHidden = true
        self.tableView.isHidden = true
        
        self.activeDocument = sender.tag
        
        self.optionsMenu()
    }


}
extension ADUploadDocVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func optionsMenu() {
        
        let camera = Camera(delegate_: self)
        
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        optionMenu.popoverPresentationController?.sourceView = self.view
        
        let takePhoto = UIAlertAction(title: "Camera", style: .default) { (alert : UIAlertAction!) in
            camera.presentPhotoCamera(target: self, canEdit: true)
            
            
            
        }
        let sharePhoto = UIAlertAction(title: "Library", style: .default) { (alert : UIAlertAction) in
            camera.presentPhotoLibrary(target: self, canEdit: true)
            
            
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (alert : UIAlertAction) in
            //
            
            
        }
        
        optionMenu.addAction(takePhoto)
        optionMenu.addAction(sharePhoto)
        
        optionMenu.addAction(cancel)
        
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var activeDocImageView:Any? = nil
        
        switch( self.activeDocument )
        {
            case LICENSE_FRONT_DOC : activeDocImageView = self.licenceFrontBtn
            case LICENSE_BACK_DOC : activeDocImageView = self.licenseBackBtn
            case COMM_INS_DOC : activeDocImageView = self.commercialimage
            case ACRA_DOC : activeDocImageView = self.acraimage
            case VEHC_REG_DOC : activeDocImageView = self.vehicleregistrationimage
            case VOC_LIC_DOC : activeDocImageView = self.imageView2
            case PRIV_HIRE_DOC : activeDocImageView = self.phDocImage
            case NRIC_FRONT_DOC : activeDocImageView = self.nricFrontBtn
            case NRIC_BACK_DOC : activeDocImageView = self.nricBackBtn
            default : activeDocImageView = self.licenceFrontBtn
        }
        
        
        /* let image = info[UIImagePickerControllerOriginalImage] as? UIImage
         imageView1.image = image
         self.dismiss(animated: true, completion: nil)
         btnUpload1.tag = 5
         btnUpload1.titleLabel?.text = "a"
         btnUpload1.titleLabel?.textColor = UIColor.clear
         
         self.nextAction = "Yes"
         
         
         self.labelInvalid.isHidden = true*/
        
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        if self.activeDocument == LICENSE_FRONT_DOC || self.activeDocument == LICENSE_BACK_DOC || self.activeDocument == NRIC_FRONT_DOC || self.activeDocument == NRIC_BACK_DOC {
            if let doc = activeDocImageView as? UIButton{
            doc.setImage(image, for:.normal)
            }
        }
        else{
            if let doc = activeDocImageView as? UIImageView{
                doc.image = image
            }
        }
        
        if let data = UIImagePNGRepresentation(image!) {
            
            let filename = getDocumentsDirectory().appendingPathComponent("profile.png")
            try? data.write(to: filename)
            
            print("im \(filename)")
            self.selectedPic = String(describing: filename)
        }
        self.dismiss(animated: true, completion: nil)
        
        
        self.labelInvalid.isHidden = true
        
        self.viewActivity.isHidden = false
        
        LoadingIndicatorView.show(self.viewActivity, loadingText: "Uploading...")
        
        let rimage:UIImage = self.imageRotatedByDegrees(0.0,image: image!)
        
        let imgdata:Data = UIImageJPEGRepresentation(rimage,90)!
        
        let viewImageUrl = "\(self.signInAPIUrl)imageUpload/"
        
        let request:NSMutableURLRequest = NSMutableURLRequest(url: URL(string:"\(viewImageUrl)\(self.selectedPic!)")!)
        
        print("\(request)")
        
        request.httpMethod = "POST"
        
        let boundary = NSString(format: "---------------------------14737809831466499882746641449")
        
        let contentType = NSString(format: "multipart/form-data; boundary=%@",boundary)
        
        request.addValue(contentType as String, forHTTPHeaderField: "Content-Type")
        
        let body = NSMutableData()
        
        body.append(NSString(format: "\r\n--%@\r\n",boundary).data(using: String.Encoding.utf8.rawValue)!)
        
        body.append(NSString(format:"Content-Disposition: form-data; name=\"title\"\r\n\r\n").data(using: String.Encoding.utf8.rawValue)!)
        
        body.append("Hello World".data(using: String.Encoding.utf8, allowLossyConversion: true)!)
        
        body.append(NSString(format: "\r\n--%@\r\n", boundary).data(using: String.Encoding.utf8.rawValue)!)
        
        body.append(NSString(format:"Content-Disposition: form-data; name=\"uploadedfile\"; filename=\"bklblk.jpg\"\r\n").data(using: String.Encoding.utf8.rawValue)!)
        
        body.append(NSString(format: "Content-Type: application/octet-stream\r\n\r\n").data(using: String.Encoding.utf8.rawValue)!)
        
        body.append(imgdata)
        
        body.append(NSString(format: "\r\n--%@\r\n", boundary).data(using: String.Encoding.utf8.rawValue)!)
        
        request.httpBody = body as Data
        print(request.httpBody)
        let operation : AFHTTPRequestOperation = AFHTTPRequestOperation(request: request as URLRequest!)
        
        //            operation.responseSerializer.acceptableContentTypes = NSSet(object: "text/html") as Set<NSObject>
        operation.responseSerializer.acceptableContentTypes =  Set<AnyHashable>(["application/json", "text/json", "text/javascript", "text/html"])
        
        operation.setCompletionBlockWithSuccess(
            
            { (operation : AFHTTPRequestOperation?, responseObject: Any?) in
                
                
                let response : NSString = operation!.responseString as NSString
                let data:Data = (response.data(using: String.Encoding.utf8.rawValue)! as? Data)!
                print(data)
                
                let json = try! JSONSerialization.jsonObject(with: data, options: []) as AnyObject
                print(json)
                
                let imageStatus = json.value(forKey: "status")
                var tmpimg:NSString="\(imageStatus!)" as NSString
                tmpimg=tmpimg.replacingOccurrences(of: "(", with: "") as NSString
                tmpimg=tmpimg.replacingOccurrences(of: ")", with: "") as NSString
                tmpimg=tmpimg.replacingOccurrences(of: "\"", with: "") as NSString
                tmpimg=tmpimg.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) as NSString
                if(tmpimg == "Success"){
                    let imageurl = json.value(forKey: "imageurl")
                    
                    let imageName = json.value(forKey: "image_name")
                    
                    var tmpstr:NSString="\(imageName!)" as NSString
                    tmpstr=tmpstr.replacingOccurrences(of: "(", with: "") as NSString
                    tmpstr=tmpstr.replacingOccurrences(of: ")", with: "") as NSString
                    tmpstr=tmpstr.replacingOccurrences(of: "\"", with: "") as NSString
                    tmpstr=tmpstr.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) as NSString
                    
                    print(" !! \(imageurl)")
                    
                    print(" final \(tmpstr)")
                    
                    print("image uploaded")
                    
                    self.selectedPic = tmpstr as String!
                    
                    self.appDelegate.signUpUserlicense = tmpstr as String!
                    
                    switch( self.activeDocument )
                    {
                        case LICENSE_FRONT_DOC : self.driverLicenseFront = tmpstr as String!
                        case LICENSE_BACK_DOC : self.driverLicenseBack = tmpstr as String!
                        case COMM_INS_DOC : self.commInsurance = tmpstr as String!
                        case ACRA_DOC : self.acraDocument = tmpstr as String!
                        case VEHC_REG_DOC : self.vehRegDocument = tmpstr as String!
                        case VOC_LIC_DOC : self.vocLicDocument = tmpstr as String!
                        case PRIV_HIRE_DOC : self.privHireDocument = tmpstr as String!
                        case NRIC_FRONT_DOC : self.nricFrontDoc = tmpstr as String!
                        case NRIC_BACK_DOC : self.nricBackDoc = tmpstr as String!
                        default : self.driverLicenseFront = tmpstr as String!
                    }
                    
                    LoadingIndicatorView.hide()
                    
                    self.viewActivity.isHidden = true
                    
                }else{
                    print("image uploaded failed")
                    
                    LoadingIndicatorView.hide()
                    
                    self.viewActivity.isHidden = true
                    //sampleDoc.png
                    let newImg: UIImage? = UIImage(named: "sampleDoc.png")
                    
                    if self.activeDocument == LICENSE_FRONT_DOC || self.activeDocument == LICENSE_BACK_DOC || self.activeDocument == NRIC_FRONT_DOC || self.activeDocument == NRIC_BACK_DOC {
                        if let doc = activeDocImageView as? UIButton{
                            doc.setImage(newImg, for:.normal)
                        }
                    }
                    else{
                        if let doc = activeDocImageView as? UIImageView{
                            doc.image = newImg
                        }
                    }
                    
                    let warning = MessageView.viewFromNib(layout: .CardView)
                    warning.configureTheme(.warning)
                    warning.configureDropShadow()
                    let iconText = "" //"🤔"
                    warning.configureContent(title: "", body: "Network error image upload failed", iconText: iconText)
                    warning.button?.isHidden = true
                    var warningConfig = SwiftMessages.defaultConfig
                    warningConfig.presentationContext = .window(windowLevel: UIWindowLevelStatusBar)
                    
                    SwiftMessages.show(config: warningConfig, view: warning)
                }
                
                
                
        }, failure: { (operation, error) -> Void in
            print("image uploaded failed")
            print(error?.localizedDescription)
            LoadingIndicatorView.hide()
            
            self.viewActivity.isHidden = true
            //sampleDoc.png
            let newImg: UIImage? = UIImage(named: "sampleDoc.png")
            
            if self.activeDocument == LICENSE_FRONT_DOC || self.activeDocument == LICENSE_BACK_DOC || self.activeDocument == NRIC_FRONT_DOC || self.activeDocument == NRIC_BACK_DOC {
                if let doc = activeDocImageView as? UIButton{
                    doc.setImage(newImg, for:.normal)
                }
            }
            else{
                if let doc = activeDocImageView as? UIImageView{
                    doc.image = newImg
                }
            }

            
            let warning = MessageView.viewFromNib(layout: .CardView)
            warning.configureTheme(.warning)
            warning.configureDropShadow()
            let iconText = "" //"🤔"
            warning.configureContent(title: "", body: "Network error image upload failed", iconText: iconText)
            warning.button?.isHidden = true
            var warningConfig = SwiftMessages.defaultConfig
            warningConfig.presentationContext = .window(windowLevel: UIWindowLevelStatusBar)
            
            SwiftMessages.show(config: warningConfig, view: warning)
        })
        
        operation.start()
    
    }
    
    func imageRotatedByDegrees(_ degrees: CGFloat, image: UIImage) -> UIImage{
        
        let size = image.size
        
        
        
        UIGraphicsBeginImageContext(size)
        
        let context = UIGraphicsGetCurrentContext()
        
        
        
        context?.translateBy(x: 0.5*size.width, y: 0.5*size.height)
        
        context?.rotate(by: CGFloat(DegreesToRadians(Double(degrees))))
        
        
        
        image.draw(in: CGRect(origin: CGPoint(x: -size.width*0.5, y: -size.height*0.5), size: size))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        
        
        return newImage!
        
    }
    func DegreesToRadians(_ degrees: Double) -> Double {
        
        return degrees * M_PI / 180.0
        
    }
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
    
}
