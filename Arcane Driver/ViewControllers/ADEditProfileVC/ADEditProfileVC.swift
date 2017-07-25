
//
//  ADEditProfileVC.swift
//  Arcane Driver
//
//  Created by Apple on 20/12/16.
//  Copyright © 2016 Apple. All rights reserved.
//

import UIKit
import Alamofire
import SwiftMessages
import libPhoneNumber_iOS
import Firebase
import GeoFire


class ADEditProfileVC: UIViewController,UITextFieldDelegate,UITableViewDataSource, UITableViewDelegate,UIScrollViewDelegate {


    @IBOutlet weak var countrycodeLabel: UILabel!
    
    @IBOutlet weak var activityspin: UIActivityIndicatorView!
    @IBOutlet weak var activityview: UIView!
    
    @IBOutlet var categorylabel: UILabel!
    @IBOutlet var categorybutton: UIButton!
    @IBOutlet var tableview: UITableView!
    @IBOutlet var vehiclemodeltextfield: UITextField!
    @IBOutlet var vehiclemaketextfield: UITextField!
    @IBOutlet weak var nicknameerror: UILabel!
    @IBOutlet weak var activityView: UIActivityIndicatorView!

    @IBOutlet var vehiclemileagetextfield: UITextField!
    
    @IBOutlet var vehicleplatefield: UITextField!
    @IBOutlet var vehicleyeartextfield: UITextField!
    @IBOutlet weak var referalcode: UITextField!
    @IBOutlet weak var nickname: UITextField!
    @IBOutlet weak var imageView: UIImageView!

    @IBOutlet weak var viewCircle: UIView!

    @IBOutlet weak var btnSave: UIButton!
    
    @IBOutlet weak var inAppbtn: UIButton!
    @IBOutlet weak var wazeMapbtn: UIButton!
    @IBOutlet weak var googleMapbtn: UIButton!
    
    
    @IBOutlet var makeerror: UILabel!
    
    @IBOutlet var mileageerror: UILabel!
    
    @IBOutlet var plateerror: UILabel!

    @IBOutlet var yearerror: UILabel!
    @IBOutlet var modelerror: UILabel!
    
    @IBOutlet weak var textFieldFirstName: UITextField!
    @IBOutlet weak var textFieldLastName: UITextField!
    @IBOutlet weak var textFieldPhone: UITextField!
    @IBOutlet weak var textFieldEmail: UITextField!
    
    @IBOutlet var scrollview: UIScrollView!
    @IBOutlet weak var viewActivity: UIView!

    @IBOutlet weak var labelInvalidPhone: UILabel!

    @IBOutlet weak var nameErrorLabel: UILabel!

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var viewAPIUrl = live_Driver_url
    
    typealias jsonSTD = NSArray
    
    typealias jsonSTDAny = [String : AnyObject]
    
    var totalArrayOfCars:NSMutableArray=NSMutableArray()
    
    let picker = UIImagePickerController()
    var pickedImagePath: URL?
    var pickedImageData: Data?
    
    var localPath: String?
    
    var selectedPic : String!
    
    var profilepic : String!

    var selection: Int!
    var buttonGroup: [UIButton] = []
    var code = ""
    var codeLength = 0
    var codeCheck = 10
    var userproof = ""

    internal var passEditProfile : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        
        activityspin.isHidden = true
        activityview.isHidden = true
       

        makeerror.isHidden=true
        modelerror.isHidden=true
        yearerror.isHidden=true
        makeerror.isHidden=true
        mileageerror.isHidden=true
        plateerror.isHidden=true
        
        print("\(self.appDelegate.userid!)")
        
        let ref = FIRDatabase.database().reference()
        ref.child("drivers_data").child("\(self.appDelegate.userid!)").child("proof_status").observeSingleEvent(of: .value, with: { (snapshot) in
            if(snapshot.exists()){
                print("updating distance \(snapshot.value!)")
                let dict = snapshot.value! as! NSString
                print(dict)
                self.userproof = dict as String
                self.proofstatus()
            }
            print("else")
        })
        
        
        
        vehiclemileagetextfield.delegate = self
        vehicleplatefield.delegate = self
        categorybutton.layer.borderWidth = 1
        categorybutton.layer.borderColor = UIColor.black.cgColor
        
         self.tableview.isHidden=true
        UIApplication.shared.isIdleTimerDisabled = false
        
        self.tableview.separatorStyle = UITableViewCellSeparatorStyle.none

        self.labelInvalidPhone.isHidden = true
        tableview.delegate = self
        tableview.dataSource = self
       //tableview?.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
         tableview.register((UINib(nibName: "UploadCell", bundle: nil)), forCellReuseIdentifier: "uploadCell")
         self.callCarsList()
        self.viewActivity.isHidden = true
        
        navigationController!.navigationBar.barStyle = .black
        
        navigationController!.isNavigationBarHidden = false
        
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "arrow-left.png")!, for: .normal)
        button.addTarget(self, action: #selector(ADEditProfileVC.profileBtn(_:)), for: .touchUpInside)
        //CGRectMake(0, 0, 53, 31)
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        //(frame: CGRectMake(3, 5, 50, 20))
        let label = UILabel(frame: CGRect(x: 10, y: 5, width: 150, height: 20))
        // label.font = UIFont(name: "Arial-BoldMT", size: 13)
        label.text = "Edit Profile"
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.backgroundColor = UIColor.clear
        button.addSubview(label)
        if UserDefaults.standard.value(forKey: "navoption") != nil{
            let navoption:NSNumber = UserDefaults.standard.value(forKey: "navoption") as! NSNumber
            if(navoption == 0){
               inAppbtn.setImage(UIImage(named: "checkradio.png"), for: .normal)
            }else if(navoption == 2){
                googleMapbtn.setImage(UIImage(named: "checkradio.png"), for: .normal)
            }else{
                wazeMapbtn.setImage(UIImage(named: "checkradio.png"), for: .normal)
            }
        }else{
            wazeMapbtn.setImage(UIImage(named: "checkradio.png"), for: .normal)
        }
        inAppbtn.addTarget(self, action: #selector(ADEditProfileVC.click(sender:)), for: .touchUpInside)
        inAppbtn.tag = 0
        wazeMapbtn.addTarget(self, action: #selector(ADEditProfileVC.click(sender:)), for: .touchUpInside)
        wazeMapbtn.tag = 1
        googleMapbtn.addTarget(self, action: #selector(ADEditProfileVC.click(sender:)), for: .touchUpInside)
        googleMapbtn.tag = 2
        buttonGroup = [inAppbtn,wazeMapbtn,googleMapbtn]
        
        let barButton = UIBarButtonItem(customView: button)
        self.navigationItem.leftBarButtonItem = barButton
        
        viewCircle.layer.cornerRadius = viewCircle.frame.size.width / 2
        viewCircle.clipsToBounds = true
        
        self.activityView.startAnimating()
        
        var urlstring:String = "\(viewAPIUrl)editProfile/user_id/\(self.appDelegate.userid!)"
        
        urlstring = urlstring.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!
        
//        urlstring = urlstring.removingPercentEncoding!
        
        print(urlstring)
        
        self.callviewAPI(url: "\(urlstring)")
        
//        firstnametextField.text = self.appDelegate.fnametextField!
//        lastnametextField.text = self.appDelegate.lnametextfield!
//        mobilenotextField.text = self.appDelegate.mobilenotextField!
//        countrycodeLabel.text = self.appDelegate.countrycodetextfield!
//        emailtextField.text =  self.appDelegate.emailtextField!
        
        
    
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ADEditProfileVC.hidekeyboard))
        
        tapGesture.numberOfTapsRequired = 1
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        
    }
    func proofstatus(){
        
        print("mouni \(userproof)")
        if(userproof == "Accepted"){
            textFieldFirstName.isEnabled = false
            textFieldLastName.isEnabled = false
            textFieldEmail.isEnabled = false
            
        }
        else{
            
            textFieldFirstName.isEnabled = false
            textFieldLastName.isEnabled = false
            textFieldEmail.isEnabled = false
            
        }
        
        
    }
    func click(sender: UIButton) {
        selection = sender.tag
        print(selection)
        sender.setImage(UIImage(named: "checkradio.png"), for: .selected)
        sender.isSelected = true
        var otherButtons = buttonGroup
        otherButtons.remove(at: sender.tag)
        for button in otherButtons {
            button.setImage(UIImage(named: "uncheckradio.png"), for: .normal)
            button.setImage(UIImage(named: "uncheckradio.png"), for: .selected)
        }
        UserDefaults.standard.setValue(selection, forKey: "navoption")
    }
    func hidekeyboard()
    {
        
        self.view.endEditing(true)
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 40.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(totalArrayOfCars)
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
        self.categorylabel.text = totalArrayOfCars.object(at: indexPath.row) as? String
        
        
        
        tableView.isHidden = true
    }
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
                
                self.tableview.reloadData()
        },
            failure: { (operation: AFHTTPRequestOperation?,error: Error) in
                print("Error: " + error.localizedDescription)
                
        })
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        scrollview.contentSize.height = 1060
        
        if(textField == vehiclemileagetextfield){
            scrollview.contentSize.height = 1060
            scrollview.setContentOffset(CGPoint(x: 0, y: 600), animated: false)
        }
        if(textField == vehicleplatefield){
            scrollview.contentSize.height = 1060
            scrollview.setContentOffset(CGPoint(x: 0, y: 600), animated: false)
        }
    }
    func profileBtn(_ Selector: AnyObject) {
        
        self.navigationController?.popViewController(animated: true)
        
    }

    @IBAction func btnUserPicAction(_ sender: Any) {
        
        optionsMenu()
    }

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField == textFieldPhone{
            
            self.labelInvalidPhone.isHidden = true
        }
        else if textField == textFieldLastName
        {
            self.nameErrorLabel.isHidden = true
        }
        else if textField == textFieldFirstName
        {
            self.nameErrorLabel.isHidden = true
        }
        else if textField == nickname
        {
            self.nicknameerror.isHidden = true
        }
        else{
            
        }
        return true
    }
    
    @IBAction func categoryselect(_ sender: Any) {
        self.tableview.isHidden=false
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        var result = true
        let str:NSString! = "\(textField.text!)" as NSString!
        
        let prospectiveText = (str).replacingCharacters(in: range, with: string)
        
        // var disallowedCharacterSet = CharacterSet.whitespaces
        var limit = 30
        
        
        if(textField == textFieldEmail){
            if string.characters.count > 0 {
                
                let disallowedCharacterSet = CharacterSet(charactersIn: "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ.@_-!#$%(){}^&*+").inverted
                
                let replacementStringIsLegal = string.rangeOfCharacter(from: disallowedCharacterSet) == nil
                
                let resultingStringLengthIsLegal = prospectiveText.characters.count <= limit
                
                result = replacementStringIsLegal &&
                    
                resultingStringLengthIsLegal
                
            }
        }
            
        else if(textField == textFieldFirstName){
            limit = 25
            if string.characters.count > 0 {
                
                let disallowedCharacterSet = CharacterSet(charactersIn: "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ").inverted
                
                let replacementStringIsLegal = string.rangeOfCharacter(from: disallowedCharacterSet) == nil
                
                let resultingStringLengthIsLegal = prospectiveText.characters.count <= limit
                
                result = replacementStringIsLegal &&
                    
                resultingStringLengthIsLegal
                
            }
        }
        else if (textField == textFieldLastName){
            limit = 25
            if string.characters.count > 0 {
                
                let disallowedCharacterSet = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ").inverted
                
                let replacementStringIsLegal = string.rangeOfCharacter(from: disallowedCharacterSet) == nil
                
                let resultingStringLengthIsLegal = prospectiveText.characters.count <= limit
                
                result = replacementStringIsLegal &&
                    
                resultingStringLengthIsLegal
                
            }
        }   
        else if(textField == textFieldPhone){
            
            if string.characters.count > 0 {
                
                let disallowedCharacterSet = CharacterSet(charactersIn: "0123456789").inverted
                
                let replacementStringIsLegal = string.rangeOfCharacter(from: disallowedCharacterSet) == nil
                
                if self.codeLength == 0{
                    
                    self.codeCheck = 10
                }
                else{
                    
                    self.codeCheck = self.codeLength
                }
                

                let resultingStringLengthIsLegal = prospectiveText.characters.count <= 15
                
                result = replacementStringIsLegal &&
                    
                resultingStringLengthIsLegal
                
            }
        }
            
            
        else if(textField == vehicleplatefield){
            
            if string.characters.count > 0 {
                
                let disallowedCharacterSet = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789").inverted
                
                let replacementStringIsLegal = string.rangeOfCharacter(from: disallowedCharacterSet) == nil
                
                if self.codeLength == 0{
                    
                    self.codeCheck = 10
                }
                else{
                    
                    self.codeCheck = self.codeLength
                }
                
                
                let resultingStringLengthIsLegal = prospectiveText.characters.count <= self.codeCheck
                
                result = replacementStringIsLegal &&
                    
                resultingStringLengthIsLegal
                
            }
        }
        else{
            limit = 20
        }

        
        return result
    }
    @IBAction func btnCountryAction(_ sender: Any) {
        
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
            
            
            print(code)
            self.code = code
            let phoneUtil = NBPhoneNumberUtil()
            
            do {
                if code != ""{
                    
                    let abc = try phoneUtil.getExampleNumber("\(self.code)")
                    print(abc)
                    print(abc.nationalNumber)
                    var str = "\(abc.nationalNumber!)"
                    print(str.characters.count)
                    self.codeLength = str.characters.count
                }
            }
            catch let error as NSError {
                print(error.localizedDescription)
            }

        }
        
        
        navigationController?.pushViewController(picker, animated: true)
    }
    
    func callviewAPI(url : String){
        
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
            
            if let final = value.object(forKey: "status"){
                print(final)
                if(final as! String == "Success"){
                    
                    var firstname = value.object(forKey: "firstname") as? String
                    var lastname = value.object(forKey: "lastname") as? String
                    let mobile:String = value.object(forKey: "mobile") as! String
                    let cc:String = value.object(forKey: "country_code") as! String
                    let email:String = value.object(forKey: "email") as! String
                    let profilePic = value.object(forKey: "profile_pic") as! String
                    var vehicleplate = value.object(forKey: "number_plate") as! String
                    
                    var nick_name:String = value.object(forKey: "nick_name") as! String
                    var vehicle_make:String = value.object(forKey: "vehicle_make") as! String
                    var vehicle_model:String = value.object(forKey: "vehicle_model") as! String
                    var vehicle_year:String = value.object(forKey: "vehicle_year") as! String
                    var vehicle_mileage:String = value.object(forKey: "vehicle_mileage") as! String
                    
                    var category:String = value.object(forKey: "category") as! String
                    print("\(category)")
                    
                    let refrel_code = value.object(forKey: "refrel_code") as! String

                    if nick_name != nil{
                        nick_name = nick_name.replacingOccurrences(of: "Optional(", with: "")
                        nick_name = nick_name.replacingOccurrences(of: ")", with: "")
                        nick_name = nick_name.replacingOccurrences(of: "%20", with: " ")
                        nick_name = nick_name.replacingOccurrences(of: "\"", with: "")
                        
                    }
                    else{
                        nick_name = ""
                    }

                    

                    if firstname != nil{
                        firstname = firstname?.replacingOccurrences(of: "Optional(", with: "")
                        firstname = firstname?.replacingOccurrences(of: ")", with: "")
                        firstname = firstname?.replacingOccurrences(of: "%20", with: " ")
                        firstname = firstname?.replacingOccurrences(of: "\"", with: "")

                    }
                    else{
                        firstname = ""
                    }
                    
                    if vehicle_make != nil{
                        vehicle_make = vehicle_make.replacingOccurrences(of: "Optional(", with: "")
                        vehicle_make = vehicle_make.replacingOccurrences(of: ")", with: "")
                        vehicle_make = vehicle_make.replacingOccurrences(of: "%20", with: " ")
                        vehicle_make = vehicle_make.replacingOccurrences(of: "\"", with: "")
                        
                    }
                    else{
                        vehicle_make = ""
                    }
                    if vehicle_model != nil{
                        vehicle_model = vehicle_model.replacingOccurrences(of: "Optional(", with: "")
                        vehicle_model = vehicle_model.replacingOccurrences(of: ")", with: "")
                        vehicle_model = vehicle_model.replacingOccurrences(of: "%20", with: " ")
                        vehicle_model = vehicle_model.replacingOccurrences(of: "\"", with: "")
                        
                    }
                    else{
                        vehicle_model = ""
                    }
                    
                    if vehicle_year != nil{
                        vehicle_year = vehicle_year.replacingOccurrences(of: "Optional(", with: "")
                        vehicle_year = vehicle_year.replacingOccurrences(of: ")", with: "")
                        vehicle_year = vehicle_year.replacingOccurrences(of: "%20", with: " ")
                        vehicle_year = vehicle_year.replacingOccurrences(of: "\"", with: "")
                        
                    }
                    else{
                        vehicle_year = ""
                    }
                    
                    if vehicle_mileage != nil{
                        vehicle_mileage = vehicle_mileage.replacingOccurrences(of: "Optional(", with: "")
                        vehicle_mileage = vehicle_mileage.replacingOccurrences(of: ")", with: "")
                        vehicle_mileage = vehicle_mileage.replacingOccurrences(of: "%20", with: " ")
                        vehicle_mileage = vehicle_mileage.replacingOccurrences(of: "\"", with: "")
                        
                    }
                    else{
                        vehicle_mileage = ""
                    }
                    if lastname != nil{
                        lastname = lastname?.replacingOccurrences(of: "Optional(", with: "")
                        lastname = lastname?.replacingOccurrences(of: ")", with: "")
                        lastname = lastname?.replacingOccurrences(of: "%20", with: " ")
                        lastname = lastname?.replacingOccurrences(of: "\"", with: "")

                    }
                    else{
                        lastname = ""
                    }
                    
                    if vehicleplate != nil{
                        vehicleplate = vehicleplate.replacingOccurrences(of: "Optional(", with: "")
                        vehicleplate = vehicleplate.replacingOccurrences(of: ")", with: "")
                        vehicleplate = vehicleplate.replacingOccurrences(of: "%20", with: " ")
                        vehicleplate = vehicleplate.replacingOccurrences(of: "\"", with: "")
                        
                    }
                    else{
                        vehicleplate = ""
                    }
                    
                    UserDefaults.standard.setValue(category, forKey: "carCategoryRegister")
                    
                    self.appDelegate.tocheckcarcategory = category
                    print(self.appDelegate.tocheckcarcategory!)
                    
                    UserDefaults.standard.setValue(self.appDelegate.userid!, forKey: "userid")
                    
                    print("\(UserDefaults.standard.value(forKey: "userid")!)")
                    
                    var ref1 = FIRDatabase.database().reference()
                    
                    var userId = self.appDelegate.userid!
                    
                    
                    textFieldFirstName.text = firstname
                    textFieldLastName.text = lastname
                    textFieldEmail.text = email
                    vehiclemaketextfield.text = vehicle_make
                    vehiclemodeltextfield.text = vehicle_model
                    vehicleyeartextfield.text = vehicle_year
                    vehiclemileagetextfield.text = vehicle_mileage
                    vehicleplatefield.text = vehicleplate
                    categorylabel.text = category
                    
                    
                    nickname.text = nick_name
                    referalcode.text = refrel_code
                    
                    
                    
                    var ccValue = cc
                    if ccValue != ""{
                        
                        countrycodeLabel.text = ccValue
                        
                    }
                    else{
                        
                        countrycodeLabel.text = "cc"
                        
                    }
                    textFieldPhone.text = mobile
                    
                    
                    if profilePic == nil{
                        
                        imageView.image = UIImage(named: "UserPic.png")
                        
                    }
                    else if profilePic == ""{
                        
                        imageView.image = UIImage(named: "UserPic.png")
                        
                    }
                    else{
                        
                        imageView.sd_setImage(with: NSURL(string: profilePic) as URL!)
                        
                    }
                    
                  /*  var value = UserDefaults.standard.object(forKey: "GProfilePic") as? String
                    value = value?.replacingOccurrences(of: "Optional(", with: "")
                    value = value?.replacingOccurrences(of: ")", with: "")
                    
                    if value == nil{
                        
                        if profilePic == nil{
                            
                            imageView.image = UIImage(named: "UserPic.png")
                            
                        }
                        else if profilePic == ""{
                            
                            imageView.image = UIImage(named: "UserPic.png")
                            
                        }
                        else{
                            
                            imageView.sd_setImage(with: NSURL(string: profilePic) as URL!)
                            
                        }
                        
                    }
                    else{
                        
                        print("Google pic \(value!)")
                        
                        imageView.sd_setImage(with: NSURL(string: value!) as URL!)
                        
                    }*/

                    self.activityView.stopAnimating()
                    
                    
                }
                else{
                    
                    
                    self.activityView.stopAnimating()
                    
                }
            }
        }
        catch{
            
            print(error)
            
            self.activityView.stopAnimating()
            
            
        }
        
    }

    @IBAction func btnSaveAction(_ sender: Any) {
        
      //Update car category
        let valueToRemove = self.appDelegate.userid!
        self.removeusercategory(childIWantToRemove: valueToRemove)
        self.activityView.startAnimating()
        let mobileTrim = textFieldPhone.text?.trimmingCharacters(in: .whitespaces)
        var code = self.codeLength
        if self.codeLength == 0{
            code = 10
        }
        else{
            code = self.codeLength
        }


        if textFieldFirstName.text == "" && textFieldLastName.text == "" && textFieldPhone.text
            == "" &&  textFieldEmail.text == "" &&  nickname.text == "" &&  vehiclemaketextfield.text == "" &&  vehiclemodeltextfield.text == "" &&  vehicleyeartextfield.text == "" &&  vehiclemileagetextfield.text == "" && vehicleplatefield.text == ""{
            
            self.activityView.stopAnimating()
            self.nameErrorLabel.isHidden = false
            self.nameErrorLabel.text = "Enter all fields"
          /*  firstnametextField.layer.borderColor = UIColor.red.cgColor
            lastnametextField.layer.borderColor = UIColor.red.cgColor
            mobilenotextField.layer.borderColor = UIColor.red.cgColor
            emailtextField.layer.borderColor = UIColor.red.cgColor*/
            
        }
        else if textFieldFirstName.text == "" {
            
            self.activityView.stopAnimating()
            self.nameErrorLabel.isHidden = false
            self.nameErrorLabel.text = "Enter First Name"

           // firstnametextField.layer.borderColor = UIColor.red.cgColor
        }
        else if vehiclemaketextfield.text == "" {
            
            self.activityView.stopAnimating()
            self.makeerror.isHidden = false
           
            
            // firstnametextField.layer.borderColor = UIColor.red.cgColor
        }
        else if vehiclemodeltextfield.text == "" {
            
            self.activityView.stopAnimating()
            self.modelerror.isHidden = false
           
            
            // firstnametextField.layer.borderColor = UIColor.red.cgColor
        }
        else if vehicleyeartextfield.text == "" {
            
            self.activityView.stopAnimating()
            self.yearerror.isHidden = false
            
            
            // firstnametextField.layer.borderColor = UIColor.red.cgColor
        }
        else if vehiclemileagetextfield.text == "" {
            
            self.activityView.stopAnimating()
            self.mileageerror.isHidden = false
            
            
            // firstnametextField.layer.borderColor = UIColor.red.cgColor
        }
            
        else if vehicleplatefield.text == "" {
            
            self.activityView.stopAnimating()
            self.plateerror.isHidden = false
            
            
            // firstnametextField.layer.borderColor = UIColor.red.cgColor
        }
        else if textFieldLastName.text == "" {
            
            self.activityView.stopAnimating()
            self.nameErrorLabel.isHidden = false
            self.nameErrorLabel.text = "Enter Last Name"

           // lastnametextField.layer.borderColor = UIColor.red.cgColor
            
        }
            
        else if nickname.text == "" {
            
            self.activityView.stopAnimating()
            self.nicknameerror.isHidden = false
            self.nicknameerror.text = "Enter Nick Name"
            
        }

        else if textFieldPhone.text == "" {
            
            self.activityView.stopAnimating()
            self.labelInvalidPhone.isHidden = false
            self.labelInvalidPhone.text = "Enter Mobile Number"


          //  mobilenotextField.layer.borderColor = UIColor.red.cgColor
        }
        else if textFieldPhone.text == "" {
            
            self.activityView.stopAnimating()
            self.plateerror.isHidden = false
            self.plateerror.text = "Enter Vehicle Plate Number"
            
            
            //  mobilenotextField.layer.borderColor = UIColor.red.cgColor
        }
        /*else if (mobileTrim?.characters.count)! < 10{
            
            self.labelInvalidPhone.isHidden = false
            self.activityView.stopAnimating()
        } */
        else if textFieldEmail.text == ""{
            
            self.activityView.stopAnimating()

          //  emailtextField.layer.borderColor = UIColor.red.cgColor
        }
        else if (mobileTrim?.characters.count)! < 7{
            
            self.labelInvalidPhone.isHidden = false
            self.labelInvalidPhone.text = "Invalid Mobile Number"
            self.activityView.stopAnimating()

        }
        else if (mobileTrim?.characters.count)! > 15{
            
            self.activityView.stopAnimating()
            self.labelInvalidPhone.isHidden = false
            self.labelInvalidPhone.text = "Invalid Mobile Number"
        }
        else if(countrycodeLabel.text == "cc" || countrycodeLabel.text == ""){
            
            self.activityView.stopAnimating()
            self.labelInvalidPhone.isHidden = false
            self.labelInvalidPhone.text = "Select a country code"

        }
        else{
            
            self.labelInvalidPhone.isHidden = true
            //self.btnSave.isEnabled = false
            self.activityView.startAnimating()

            let fname:String = textFieldFirstName.text! as String
            let lname:String = textFieldLastName.text! as String
            let mobile:String = textFieldPhone.text! as String
            let countryCode:String = countrycodeLabel.text! as String
            let email:String = textFieldEmail.text! as String
            let nickname:String = self.nickname.text! as String
             let vmake:String = vehiclemaketextfield.text! as String
             let vmodel:String = vehiclemodeltextfield.text! as String
             let vyear:String = vehicleyeartextfield.text! as String
             let vmileage:String = vehiclemileagetextfield.text! as String
            let plateno:String = vehicleplatefield.text! as String
            var urlString : String!
            var urlString1 : String!
            let category1:String = categorylabel.text! as String
            
            self.appDelegate.tochangecarandstatus = self.categorylabel.text!
            print(self.appDelegate.tochangecarandstatus)
            
            if(self.appDelegate.tochangecarandstatus == self.appDelegate.tocheckcarcategory){
                print("Category not changed")
            }
            else{
                urlString1 = "\(viewAPIUrl)ChangeCategory/driver_id/\(self.appDelegate.userid!)/category/\(category1)"
                
                print("\(viewAPIUrl)ChangeCategory/driver_id/\(self.appDelegate.userid!)/category/\(category1)")
                
                urlString1 = urlString1.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!
                
                UserDefaults.standard.removeObject(forKey: "maintain")
                print(UserDefaults.standard.object(forKey: "maintain"))
                
                self.callcategorychangeAPI(url: "\(urlString1!)")
            }
            /*
             let ref = FIRDatabase.database().reference()
            var carCategory = UserDefaults.standard.object(forKey: "carCategoryRegister") as! String
            
            let geoFire = GeoFire(firebaseRef: ref.child("drivers_location").child("\(category1)").child(self.appDelegate.userid!))
            
            
            print(geoFire) */
            
            //http://demo.cogzideltemplates.com/tommy/driver/updateDetails/user_id/58c6627bda71b4665d8b4567/firstname/vikrma/lastname/vikraanth/nick_name/vikram/mobile/8220844413/country_code/+91/city/madurai/email/vikram011@gmail.com/vehicle_make/audi/vehicle_model/2F1/vehicle_year/2015/vehicle_mileage/28/category/Luxury
            
            
            if profilepic == nil{
                
                 urlString = "\(viewAPIUrl)updateDetails/user_id/\(self.appDelegate.userid!)/firstname/\(fname)/lastname/\(lname)/mobile/\(mobile)/country_code/\(countryCode)/city/null/email/\(email)/nick_name/\(nickname)/vehicle_make/\(vmake)/vehicle_model/\(vmodel)/vehicle_year/\(vyear)/vehicle_mileage/\(vmileage)/category/\(category1)/number_plate/\(plateno)"
                
            }
            else
            {
                print(self.profilepic!)
                
                 urlString = "\(viewAPIUrl)updateDetails/user_id/\(self.appDelegate.userid!)/firstname/\(fname)/lastname/\(lname)/mobile/\(mobile)/country_code/\(countryCode)/profile_pic/\(self.profilepic!)/city/null/email/\(email)/nick_name/\(nickname)/vehicle_make/\(vmake)/vehicle_model/\(vmodel)/vehicle_year/\(vyear)/vehicle_mileage/\(vmileage)/category/\(category1)/number_plate/\(plateno)"
                
            }

            urlString = urlString.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!
            
//            urlString = urlString.removingPercentEncoding!
            
            print("Edit profile\(urlString)")
            
            self.calleditAPI(url: "\(urlString!)")
            
        }

        
    }

    func keyBoardSaveCall(){
        
        
    }
    
    func callcategorychangeAPI(url : String){
        
        self.activityView.startAnimating()
        
        Alamofire.request(url).responseJSON { (response) in
            
            self.parseData2(JSONData: response.data!)
        }
        
    }
    
    func calleditAPI(url : String){
        
        self.activityView.startAnimating()

        Alamofire.request(url).responseJSON { (response) in
            
            self.parseData1(JSONData: response.data!)
        }
        
    }
    
    func parseData1(JSONData : Data){
        
        do{
            let readableJSon = try JSONSerialization.jsonObject(with: JSONData, options: .mutableContainers) as! jsonSTD
            
            print(" !!! \(readableJSon[0])")
            
            let value = readableJSon[0] as AnyObject
            
            if let final = value.object(forKey: "status"){
                print(final)
                if(final as! String == "Success"){
                    
                    self.activityView.stopAnimating()
                    
                    if passEditProfile == nil{
                        
                        let allVC = self.navigationController?.viewControllers
                        if allVC != nil{
                            if  let inventoryListVC = allVC![allVC!.count - 2] as? ADViewProfileVC {
                                
                                self.navigationController!.popToViewController(inventoryListVC, animated: true)
                                
                                // self.btnSave.isEnabled = true
                                
                            }

                            
                        }else{
                            print("nill")
                        }
                      
                    }
                    else if passEditProfile == "No Phone Number Alert"{
                        
                        
                        self.appDelegate.callMapVC()
                        
                        //self.btnSave.isEnabled = true

                    }
                    else{
                        
                        let allVC = self.navigationController?.viewControllers
                        
                        if  let inventoryListVC = allVC![allVC!.count - 2] as? ADViewProfileVC {
                            
                            self.navigationController!.popToViewController(inventoryListVC, animated: true)
                            
                           // self.btnSave.isEnabled = true

                        }

                    }
                    
                }
                else{
                    //self.btnSave.isEnabled = true

                    self.activityView.stopAnimating()

                }
            }
        }
        catch{
            
            print(error)
            //self.btnSave.isEnabled = true

            self.activityView.stopAnimating()

        }
        
    }
    
    func parseData2(JSONData : Data){
        
        do{
            
            let readableJSon = try JSONSerialization.jsonObject(with: JSONData, options: .mutableContainers) as! jsonSTD
            
            print(" !!! \(readableJSon[0])")
            
            let value = readableJSon[0] as AnyObject
            
            if let final = value.object(forKey: "status"){
                print(final)
                if(final as! String == "Success"){
                    
                    let userId = self.appDelegate.userid!
                    
                    if(userId != ""){
                        
                    let ref1 = FIRDatabase.database().reference().child("drivers_data").child("\(userId)")
                   let proof = ref1.updateChildValues(["proof_status": "Pending"])
                    self.appDelegate.ProofStatus = "\(proof)"
                        print("ProofStatus\(self.appDelegate.ProofStatus = "\(proof)")")
                   
                    }
                    
                }
                else{
                   print("else")
                }
                
            }
        }
        catch{
            
            print(error)
            //self.btnSave.isEnabled = true
            
            self.activityView.stopAnimating()
            
        }
        
    }
    func removeusercategory(childIWantToRemove: String)
    {
       self.appDelegate.categorycarvalue = categorylabel.text! as String
         var sampcar = self.appDelegate.categorycarvalue
        
        let ref = FIRDatabase.database().reference()
        var carCategoryval = UserDefaults.standard.object(forKey: "carCategoryRegister") as! String
        
        print(carCategoryval)
        
        
        let geoFire = ref.child("drivers_location").child("\(carCategoryval)").child( (self.appDelegate.userid!))
        
        
        ref.child("drivers_location").child(carCategoryval).child(childIWantToRemove).removeValue { (error, ref) in
            
            print(ref)
            print(error)
            
            if error != nil {
                print("error \(error)")
                
            }
            
            else{
                
               self.insertusercategory()
            }
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
    
    func insertusercategory()
        
    {
        
        let ref = FIRDatabase.database().reference()
        
        //print("locations are \(location.coordinate.latitude) and \(location.coordinate.longitude)")
        
        //let geoFire = GeoFire(firebaseRef: ref.child("drivers_location/\(self.appDelegate.userid!)"))
        
        //            let geoFire = GeoFire(firebaseRef: ref.child("drivers_location/\(self.appDelegate.userid!)")) // old
        
        
        
        //carCategoryRegister
        
        self.appDelegate.categorycarvalue = categorylabel.text! as String
        
        var carCategory = UserDefaults.standard.setValue(self.appDelegate.categorycarvalue, forKey: "carCategoryRegister")
        
        var sampcar = self.appDelegate.categorycarvalue
        
        
        print(carCategory)
        print(self.appDelegate.userid!)
        
        
        let geoFire = GeoFire(firebaseRef: ref.child("drivers_location").child("\(sampcar!)"))
        
        let location1 = self.appDelegate.currlocation
        
//        
//        let newUser = [
//            "status" : "1" ,
//            ]
//        
//        ref.child(byAppendingPath: "drivers_location").child(sampcar).setValue(newUser)
        
        
        geoFire!.setLocation(CLLocation(latitude: location1.coordinate.latitude, longitude: location1.coordinate.longitude), forKey: "\(self.appDelegate.userid!)", forBearing: "0.0") { (error) in
            
            if (error != nil) {
                
                //  print("An error occured: \(error)")
                
            }
                
            else{
                
                
                
                ref.child("drivers_location").child("\(sampcar!)").observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    print(snapshot)
                    
                    if snapshot.value != nil{
                        
                        
                        
                        let dict = snapshot.value as? NSDictionary
                        
                        if snapshot.children.allObjects is [FIRDataSnapshot] {
                            
                            
                            
                            if let gandoValues = dict?["\(self.appDelegate.userid!)"] as? NSDictionary{
                                
                                print(gandoValues)
                                
                                if let geo_location = gandoValues["geolocation"] as? NSDictionary{
                                    
                                    //  print(geo_location)
                                    
                                    if let latLong = geo_location["l"] as? NSArray{
                                        
                                        // print(latLong)
                                        
                                        if(latLong.count == 0){
                                            
                                            
                                            
                                        }
                                            
                                        else{
                                            
                                            
                                            
                                            let lat = latLong[0]
                                            
                                            let long = latLong[1]
                                            
                                            
                                            
                                            
                                            
                                        }
                                        
                                    }
                                    
                                }
                                
                                
                                
                                
                                
                            }
                            
                            
                            
                        }
                            
                        else {
                            
                            
                            
                            //   print("no results")
                            
                        }
                        
                    }
                        
                    else
                        
                    {
                        
                        
                        
                    }
                    
                    
                    
                }) { (error) in
                    
                    
                    
                    print(error.localizedDescription)
                    
                }
                
                
                
                
                
            }
            
        }
        
    }
    

    
}
extension ADEditProfileVC: MICountryPickerDelegate {
    
    func countryPicker(_ picker: MICountryPicker, didSelectCountryWithName name: String, code: String) {
        // picker.navigationController?.popToRootViewController(animated: true)
        // label.text = "Selected Country: \(name)"
    }
    
    func countryPicker(_ picker: MICountryPicker, didSelectCountryWithName name: String, code: String, dialCode: String) {
        
        //  picker.navigationController?.popToRootViewController(animated: true)
        
        //  navigationController!.isNavigationBarHidden = true
        picker.navigationController?.popViewController(animated: true)
        
        self.nameErrorLabel.isHidden = true
        self.labelInvalidPhone.isHidden = true
        countrycodeLabel.text = "\(dialCode)"
        countrycodeLabel.textColor = UIColor.black
        
    }


}

extension ADEditProfileVC
: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
            
            
            
        }
        
        optionMenu.addAction(takePhoto)
        optionMenu.addAction(sharePhoto)
        
        optionMenu.addAction(cancel)
        
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
//        activityspin.isHidden = false
//        activityview.isHidden = false
//        activityspin.startAnimating()
     /*   guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            return
        }
        
        imageView.image = image
        
        let documentDirectory: NSString = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! as NSString
        
        let imageName = "temp"
        let imagePath = documentDirectory.appendingPathComponent(imageName)
        
        if let data = UIImageJPEGRepresentation(image, 80) {
            try? data.write(to: URL(fileURLWithPath: imagePath), options: [.atomic])
            
        }
        
        localPath = imagePath
        
        dismiss(animated: true, completion: {
            
        })
        
        let data1 = UIImageJPEGRepresentation(image, 80)
        
        let URL1 = try! URLRequest(url: "https://demo.cogzidel.com/arcane_lite/driver/imageUpload/", method: .post, headers: nil)
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            
            multipartFormData.append(data1!, withName: "file_pack", fileName: "file_pack", mimeType: "text/plain")
            
        }, with: URL1, encodingCompletion: { (result) in
            
            switch result {
            case .success(let upload, _, _):
                
                upload.responseJSON { response in
                    
                    print(response.request)  // original URL request
                    print(response.response) // URL response
                    print(response.data)     // server data
                    print(response.result)   // result of response serialization
                    //                        self.showSuccesAlert()
                    if let JSON = response.result.value {
                        
                        print("JSON: \(JSON)")
                    }
                }
                
            case .failure(let encodingError):
                print(encodingError)
            }
            
        })*/
        
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        imageView.image = image
        if let data = UIImagePNGRepresentation(image!) {
            
            let filename = getDocumentsDirectory().appendingPathComponent("profile.png")
            try? data.write(to: filename)
            
            print("im \(filename)")
            self.selectedPic = String(describing: filename)
        }
        self.dismiss(animated: true, completion: nil)
        
        self.viewActivity.isHidden = false
        
        LoadingIndicatorView.show(self.viewActivity, loadingText: "Uploading...")
        
        let rimage:UIImage = self.imageRotatedByDegrees(0.0,image: image!)
        
        let imgdata:Data = UIImageJPEGRepresentation(rimage,90)!
        
        let viewImageUrl = "\(self.viewAPIUrl)imageUpload/"

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
        
        let operation : AFHTTPRequestOperation = AFHTTPRequestOperation(request: request as URLRequest!)
        
//        operation.responseSerializer.acceptableContentTypes = NSSet(object: "text/html") as Set<NSObject>
        
        operation.responseSerializer.acceptableContentTypes =  Set<AnyHashable>(["application/json", "text/json", "text/javascript", "text/html"])

        
        operation.setCompletionBlockWithSuccess(
            
            { (operation : AFHTTPRequestOperation?, responseObject: Any?) in
                
                
                let response : NSString = operation!.responseString as NSString
                let data:Data = response.data(using: String.Encoding.utf8.rawValue)!
                
                let json = try! JSONSerialization.jsonObject(with: data, options: []) as AnyObject
                
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
                
                self.profilepic = self.selectedPic!
                
                print("\(self.profilepic!),\(self.selectedPic!)")
                
                LoadingIndicatorView.hide()
                
                self.viewActivity.isHidden = true

                self.activityspin.isHidden = true
                self.activityview.isHidden = true
                self.activityspin.stopAnimating()
                
        }, failure: { (operation, error) -> Void in
            print("image uploaded failed")
            
            LoadingIndicatorView.hide()
            
            self.activityspin.isHidden = true
            self.activityview.isHidden = true
            self.activityspin.stopAnimating()
            
            self.viewActivity.isHidden = true
            
            self.errorUploadImage()

        })
        
        operation.start()

    }
    
    func errorUploadImage(){
        
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
   /* func upload(){
        
        guard let path = localPath else {
            return
        }
        
    }*/
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
}
