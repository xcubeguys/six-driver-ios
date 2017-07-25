//
//  ARBankVC.swift
//  SIX Driver
//
//  Created by Apple on 24/03/17.
//  Copyright © 2017 Apple. All rights reserved.
//


import UIKit
import Alamofire
import DatePickerDialog
import Stripe
import SwiftMessages

class ARBankVC: UIViewController,UITextFieldDelegate,UIScrollViewDelegate {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var accountholdername: HoshiTextField!
    
    @IBOutlet weak var bankname: HoshiTextField!
    
    @IBOutlet weak var accountnumber: HoshiTextField!
    
    @IBOutlet weak var routing: HoshiTextField!
    @IBOutlet weak var submitspin: UIActivityIndicatorView!
    
    @IBOutlet weak var submitview: UIView!
    
    @IBOutlet var dobbtn: UIButton!
    @IBOutlet var Dobfield: HoshiTextField!
    @IBOutlet weak var billingaddress: HoshiTextField!
    
    @IBOutlet var ssnfield: HoshiTextField!
    @IBOutlet weak var submitbutton: UIButton!
    
    @IBOutlet weak var branchcodeerr: UILabel!
    @IBOutlet weak var pincodeerr: UILabel!
    @IBOutlet weak var pincode: HoshiTextField!
    @IBOutlet weak var branchcode: HoshiTextField!
    @IBOutlet weak var cityfield: HoshiTextField!
    
    @IBOutlet weak var holdernameerr: UILabel!
    
    @IBOutlet weak var banknameerr: UILabel!
    
    @IBOutlet weak var routingerr: UILabel!
    
    @IBOutlet weak var accountnumerr: UILabel!
    
    @IBOutlet weak var billingerr: UILabel!
    
    @IBOutlet weak var lastname: HoshiTextField!
    @IBOutlet weak var firstname: HoshiTextField!
    @IBOutlet weak var firstnameerr: UILabel!
    @IBOutlet weak var lastnameerr: UILabel!
    @IBOutlet var uplodeimg: UIImageView!
    @IBOutlet var docerr: UILabel!
    @IBOutlet weak var cityerr: UILabel!
    
    @IBOutlet var uploaderr: UILabel!
    @IBOutlet var uplodebtn: UIButton!
    @IBOutlet var ssnerr: UILabel!
    @IBOutlet weak var scrollview: UIScrollView!
    
    @IBOutlet var viewActivity: UIView!
    
    var code = ""
    var codeLength = 0
    var acclength = 0
    var ssnlength = 0
    var pincodelength = 0
    var branchcodelength = 0
    typealias jsonSTD = NSArray
    var selectedPic = ""
    var bankimg1 = ""
    var imagee = ""
    typealias jsonSTDImage = NSDictionary
    
    typealias jsonSTDAny = [String : AnyObject]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        submitspin.isHidden = true
        submitview.isHidden = true
        
        navigationController!.isNavigationBarHidden = false
        
        navigationController!.navigationBar.barStyle = .black
        
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "arrow-left.png")!, for: .normal)
        button.addTarget(self, action: #selector(AREarningsVC.profileBtn(_:)), for: .touchUpInside)
        
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        
        let label = UILabel(frame: CGRect(x: 40, y: 5, width: 160, height: 20))
        
        label.text = "Bank Details"
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.backgroundColor = UIColor.clear
        button.addSubview(label)
        let barButton = UIBarButtonItem(customView: button)
        self.navigationItem.leftBarButtonItem = barButton
        
        self.holdernameerr.isHidden = true
        self.banknameerr.isHidden = true
        self.routingerr.isHidden = true
        self.accountnumerr.isHidden = true
        self.billingerr.isHidden = true
        self.docerr.isHidden = true
        self.ssnerr.isHidden = true
        self.uploaderr.isHidden = true
        self.pincodeerr.isHidden = true
        self.branchcodeerr.isHidden = true
        self.firstnameerr.isHidden = true
        self.lastnameerr.isHidden = true
        
        // self.cityerr.isHidden = true
        accountholdername.delegate = self
        bankname.delegate = self
        routing.delegate = self
        accountnumber.delegate = self
        billingaddress.delegate = self
        Dobfield.delegate = self
        ssnfield.delegate = self
        pincode.delegate = self
        branchcode.delegate = self
        firstname.delegate = self
        lastname.delegate = self
        //  cityfield.delegate = self
        
        var urlstring:String = "\(live_Driver_url)getBankDetails/driver_id/\(self.appDelegate.userid!)"
        
        urlstring = urlstring.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!
        
        urlstring = urlstring.removingPercentEncoding!
        print(urlstring)
        self.callviewAPI(url: "\(urlstring)")
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ARBankVC.hidekeyboard))
        tapGesture.numberOfTapsRequired = 1
        view.addGestureRecognizer(tapGesture)
        // scrollview.frame=CGRect(x: 0, y: 64, width: 320, height: 800)
        
        let screenSize: CGRect = UIScreen.main.bounds
        
        screenSize.origin
        
        let screenHeight = screenSize.height;
        
        if((screenSize.width == 320.00) && (screenSize.height == 480.00))
            
        {
            
            //scrollview.contentSize.width=375
            scrollview.contentSize.height=1050
            //print("device is 4s")
            
            
        }
        
        
        
        if((screenSize.width == 320.00) && (screenSize.height == 568.00))
            
            
        {
            
            //scrollview.contentSize.width=375
            scrollview.frame=CGRect(x: 0, y: 20, width: self.scrollview.frame.size.width, height: 800)
            
            //print("device is 5s")
            
        }
        
        if((screenSize.width == 414) && (screenSize.height == 736))
        {
            
            //scrollview.contentSize.width=375
            scrollview.contentSize.height=1000
            
            //print("device is 6 Plus")
            
        }
        
        if((screenSize.width == 375) && (screenSize.height == 667))
            
        {
            
            //print("device is 6 ")
            //scrollview.contentSize.width=375
            scrollview.contentSize.height=900
            
            
        }
        
        
    }
    
    func profileBtn(_ Selector: AnyObject) {
        // appDelegate.callMapVC()
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func DobAct(_ sender: Any) {
        
           let currentDate = Date()
        
           DatePickerDialog().show(title: "Date of Birth", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", maximumDate: currentDate, datePickerMode: .date) {
            (date) -> Void in
            var datePass = "\(date)"
            
            if datePass == "nil"{
                
                self.Dobfield.textColor = UIColor.clear
                
            }
            else{
                
                datePass = datePass.replacingOccurrences(of: "Optional(", with: "")
                datePass = datePass.replacingOccurrences(of: ")", with: "")
                
                let timestamp = "\(datePass)"
                let formatter = DateFormatter()
                formatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
                formatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
                let date = formatter.date(from: timestamp)
                formatter.dateFormat = "dd-MM-yyyy"
                let st = formatter.string(from: date!)
                print(st)
                
                // print("\(dateString)")
                
                
                self.Dobfield.text = "\(st)"
                self.Dobfield.textColor = UIColor.black
            }
            
        }
        
    }
    
    @IBAction func uplodeact(_ sender: Any) {
        
        optionsMenu()
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        scrollview.contentSize.height = 900
        
        if(textField == billingaddress){
            scrollview.contentSize.height = 1000
            scrollview.setContentOffset(CGPoint(x: 0, y: 190), animated: false)
        }
        if(textField == ssnfield){
            scrollview.contentSize.height = 1010
            scrollview.setContentOffset(CGPoint(x: 0, y: 320), animated: false)
        }
        if(textField == pincode){
            scrollview.contentSize.height = 1010
            scrollview.setContentOffset(CGPoint(x: 0, y: 320), animated: false)
        }
       
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func callviewAPI(url : String){
        
        //self.activityView.startAnimating()
        
        Alamofire.request(url).responseJSON { (response) in
            
            self.parseData(JSONData: response.data!)
        }
        
    }
    
    func parseData(JSONData : Data){
        
        var newlink = ""
        var newlink1 = ""
        
        do{
            
            let readableJSon = try JSONSerialization.jsonObject(with: JSONData, options: .mutableContainers) as! jsonSTD
            
            print(" !!! \(readableJSon[0])")
            
            let value = readableJSon[0] as AnyObject
            
            if let final = value.object(forKey: "status"){
                print(final)
                if(final as! String == "Success"){
                    
                    print("sucess")
                    var driverid = value.object(forKey: "driver_id") as? String
                    var Accountno = value.object(forKey: "account_number") as? String
                    var bank_name:String = value.object(forKey: "bank_name") as! String
                    var Routing:String = value.object(forKey: "routing_number") as! String
                    var Accountname:String = value.object(forKey: "account_name") as! String
                    var billingadd = value.object(forKey: "billing") as! String
                    
                    var dobdate = value.object(forKey: "dob") as! String
                    
                    var ssnvalue = value.object(forKey: "ssn") as! String
                    
                    var bankimg = value.object(forKey: "stripe_doc") as! String
                    
                    var postal = value.object(forKey: "postal") as! String
                    
                    if Accountname != nil{
                        Accountname = Accountname.replacingOccurrences(of: "Optional(", with: "")
                        Accountname = Accountname.replacingOccurrences(of: ")", with: "")
                        Accountname = Accountname.replacingOccurrences(of: "%20", with: " ")
                        Accountname = Accountname.replacingOccurrences(of: "\"", with: "")
                        
                        //  self.appDelegate.firstnamewallet = Accountname
                        
                        //   print(self.appDelegate.firstnamewallet)
                        
                    }
                    else{
                        Accountname = ""
                    }
                    if bank_name != nil{
                        bank_name = bank_name.replacingOccurrences(of: "Optional(", with: "")
                        bank_name = bank_name.replacingOccurrences(of: ")", with: "")
                        bank_name = bank_name.replacingOccurrences(of: "%20", with: " ")
                        bank_name = bank_name.replacingOccurrences(of: "\"", with: "")
                        bank_name = bank_name.replacingOccurrences(of: "%2522", with: "")
                        
                    }
                    else{
                        bank_name = ""
                    }
                    if Routing != nil{
                        Routing = Routing.replacingOccurrences(of: "Optional(", with: "")
                        Routing = Routing.replacingOccurrences(of: ")", with: "")
                        Routing = Routing.replacingOccurrences(of: "%20", with: " ")
                        Routing = Routing.replacingOccurrences(of: "\"", with: "")
                        Routing = Routing.replacingOccurrences(of: "%2522", with: "")
                        
                        newlink = Routing.components(separatedBy: "-").first!
                        
                        print(newlink as String)
                        
                        newlink = newlink.replacingOccurrences(of: " ", with: "")
                        
                        
                        newlink1 = Routing.components(separatedBy: "-").last!
                        
                        newlink1 = newlink1.replacingOccurrences(of: " ", with: "")
                        
                        print(newlink1 as String)

                        
                    }
                    else{
                        Routing = ""
                    }
                    
                    if Accountno != nil{
                        Accountno = Accountno?.replacingOccurrences(of: "Optional(", with: "")
                        Accountno = Accountno?.replacingOccurrences(of: ")", with: "")
                        Accountno = Accountno?.replacingOccurrences(of: "%20", with: " ")
                        Accountno = Accountno?.replacingOccurrences(of: "\"", with: "")
                        Accountno = Accountno?.replacingOccurrences(of: "%2522", with: "")
                        
                        
                        
                    }
                    else{
                        Accountno = ""
                    }
                    
                    if billingaddress != nil{
                        billingadd = billingadd.replacingOccurrences(of: "Optional(", with: "")
                        billingadd = billingadd.replacingOccurrences(of: ")", with: "")
                        billingadd = billingadd.replacingOccurrences(of: "%20", with: " ")
                        billingadd = billingadd.replacingOccurrences(of: "\"", with: "")
                        billingadd = billingadd.replacingOccurrences(of: "%2522", with: "")
                        
                        
                        
                    }
                    else{
                        billingadd = ""
                    }
                    
                    if dobdate != nil{
                        dobdate = dobdate.replacingOccurrences(of: "Optional(", with: "")
                        dobdate = dobdate.replacingOccurrences(of: ")", with: "")
                        dobdate = dobdate.replacingOccurrences(of: "%20", with: " ")
                        dobdate = dobdate.replacingOccurrences(of: "\"", with: "")
                    }
                    else{
                        dobdate = ""
                    }
                    
                    if ssnvalue != nil{
                        ssnvalue = ssnvalue.replacingOccurrences(of: "Optional(", with: "")
                        ssnvalue = ssnvalue.replacingOccurrences(of: ")", with: "")
                        ssnvalue = ssnvalue.replacingOccurrences(of: "%20", with: " ")
                        ssnvalue = ssnvalue.replacingOccurrences(of: "\"", with: "")
                    }
                    else{
                        ssnvalue = ""
                    }
                    /*   if bankimg != nil{
                     bankimg = bankimg.replacingOccurrences(of: "Optional(", with: "")
                     bankimg = bankimg.replacingOccurrences(of: ")", with: "")
                     bankimg = bankimg.replacingOccurrences(of: "%20", with: " ")
                     bankimg = bankimg.replacingOccurrences(of: "\"", with: "")
                     }*/
                    if bankimg == nil{
                        
                        uplodeimg.image = UIImage(named: "sampleDoc.png")
                        
                    }
                    else if bankimg == ""{
                        
                        uplodeimg.image = UIImage(named: "sampleDoc.png")
                        UserDefaults.standard.setValue(bankimg, forKey: "stripe_doc")
                    }
                    else{
                        
                        UserDefaults.standard.setValue(bankimg, forKey: "stripe_doc")
                        uplodeimg.sd_setImage(with: NSURL(string: bankimg) as URL!)
                        
                        self.imagee = bankimg as String!
                        self.imagee = self.imagee.replacingOccurrences(of: "http://34.225.236.233/images/", with: "") as String
                        self.imagee = self.imagee.replacingOccurrences(of: "http://www.sixtnc.com/images/", with: "") as String
                        print(self.imagee)
                        self.selectedPic = self.imagee
                        
                    }
                    
                    if postal != nil && postal != "null"{
                        postal = postal.replacingOccurrences(of: "Optional(", with: "")
                        postal = postal.replacingOccurrences(of: ")", with: "")
                        postal = postal.replacingOccurrences(of: "%20", with: " ")
                        postal = postal.replacingOccurrences(of: "\"", with: "")
                        postal = postal.replacingOccurrences(of: "%2522", with: "")
                        
                    }
                    else{
                        postal = ""
                    }
                    
                    accountholdername.text! = Accountname
                    bankname.text! = bank_name
                    routing.text! = newlink
                    branchcode.text! = newlink1
                    accountnumber.text! = Accountno!
                    billingaddress.text! = billingadd
                    pincode.text! = postal
                    Dobfield.text! = dobdate
                    ssnfield.text! = ssnvalue
                    
                    // Dobfield.text! = Dobvalue
                    //  ssnfield.text! = ssnvalue
                    
                    
                }
                else{
                    
                    
                    // self.activityView.stopAnimating()
                    
                }
            }
        }
        catch{
            
            print(error)
            
            // self.activityView.stopAnimating()
            
        }
        
    }
    
    
  
    func hidekeyboard()
    {
        self.view.endEditing(true)
    }
    
    func errorField(){
        
        let holdername = accountholdername.text?.trimmingCharacters(in: .whitespaces)
        let bankname = self.bankname.text?.trimmingCharacters(in: .whitespaces)
        let routing = self.routing.text?.trimmingCharacters(in: .whitespaces)
        let accnum = self.accountnumber.text?.trimmingCharacters(in: .whitespaces)
        let billingnum = self.billingaddress.text?.trimmingCharacters(in: .whitespaces)
        let dob_value = self.Dobfield.text?.trimmingCharacters(in: .whitespaces)
        let ssn_val = self.ssnfield.text?.trimmingCharacters(in: .whitespaces)
        let pincode1 = self.pincode.text?.trimmingCharacters(in: .whitespaces)
        let branchcode1 = self.branchcode.text?.trimmingCharacters(in: .whitespaces)
        let frstname = self.firstname.text?.trimmingCharacters(in: .whitespaces)
        let lstname = self.lastname.text?.trimmingCharacters(in: .whitespaces)
        //  let city = self.cityfield.text?.trimmingCharacters(in: .whitespaces)
        
        if(holdername == ""){
            holdernameerr.isHidden=false
        }
        else if(bankname == ""){
            banknameerr.isHidden=false
        }
        else if(routing == ""){
            routingerr.isHidden=false
        }
        else if(accnum == ""){
            accountnumerr.isHidden=false
        }
        else if(billingnum == ""){
            billingerr.isHidden=false
        }
        else if(pincode1 == ""){
            pincodeerr.isHidden=false
        }
        else if(branchcode1 == ""){
            branchcodeerr.isHidden=false
        }
        else if(frstname == ""){
            firstnameerr.isHidden=false
        }
        else if(lstname == ""){
            lastnameerr.isHidden=false
        }
            /*else if(city == ""){
             cityerr.isHidden=false
             }*/
        else {
            
        }
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField == accountholdername{
            
            holdernameerr.isHidden=true
        }
        else if textField == bankname{
            
            banknameerr.isHidden=true
        }
        else if textField == routing{
            
            routingerr.isHidden=true
        }
        else if textField == accountnumber{
            
            accountnumerr.isHidden=true
        }
        else if textField == billingaddress{
            
            billingerr.isHidden=true
        }
        else if textField == Dobfield{
            
            docerr.isHidden=true
        }
        else if textField == pincode{
            
            pincodeerr.isHidden=true
        }
        else if textField == branchcode{
            
            branchcodeerr.isHidden=true
        }
        else if textField == firstname{
            
            firstnameerr.isHidden=true
        }
        else if textField == lastname{
            
            lastnameerr.isHidden=true
        }
            
        else if textField == ssnfield{
            
            ssnerr.isHidden=true
        }
            /* else if textField == cityfield{
             
             cityerr.isHidden=true
             }*/
        else{
            
            
        }
        
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        if textField == accountholdername{
            
            holdernameerr.isHidden=true
        }
        else if textField == bankname{
            
            banknameerr.isHidden=true
        }
        else if textField == routing{
            
            routingerr.isHidden=true
        }
        else if textField == accountnumber{
            
            accountnumerr.isHidden=true
        }
        else if textField == billingaddress{
            
            billingerr.isHidden=true
        }
        else if textField == Dobfield{
            
            docerr.isHidden=true
        }
        else if textField == pincode{
            
            pincodeerr.isHidden=true
        }
        else if textField == branchcode{
            
            branchcodeerr.isHidden=true
        }
        else if textField == firstname{
            
            firstnameerr.isHidden=true
        }
        else if textField == lastname{
            
            lastnameerr.isHidden=true
        }
            
        else if textField == ssnfield{
            
            ssnerr.isHidden=true
        }
            
            
            /*  else if textField == cityfield{
             cityerr.isHidden=true
             }*/
        else{
            
        }
        
        return true
        
    }
    
    
    @IBAction func submitaction(_ sender: Any) {


      
         print(self.selectedPic)
        
        
        
        errorField()
        
        accountholdername.resignFirstResponder()
        bankname.resignFirstResponder()
        routing.resignFirstResponder()
        accountnumber.resignFirstResponder()
        billingaddress.resignFirstResponder()
        Dobfield.resignFirstResponder()
        ssnfield.resignFirstResponder()
        pincode.resignFirstResponder()
        branchcode.resignFirstResponder()
        firstname.resignFirstResponder()
        lastname.resignFirstResponder()
        //cityfield.resignFirstResponder()
        
        var code = self.codeLength
        if self.codeLength == 0{
            code = 8
        }
        else{
            code = self.codeLength
        }
        
        var code1 = self.acclength
        if self.acclength == 0{
            code1 = 9
        }
        else{
            code1 = self.acclength
        }
        
        var code2 = self.ssnlength
        if self.ssnlength == 0{
            code2 = 8
        }
        else{
            code2 = self.ssnlength
        }
        var code3 = self.pincodelength
        if self.pincodelength == 0{
            code3 = 10
        }
        else{
            code3 = self.pincodelength
        }
        var code4 = self.branchcodelength
        if self.branchcodelength == 0{
            code4 = 10
        }
        else{
            code4 = self.branchcodelength
        }
        
        
        let holdername = accountholdername.text?.trimmingCharacters(in: .whitespaces)
        
        let bankname1 = self.bankname.text?.trimmingCharacters(in: .whitespaces)
        
        let routing1 = self.routing.text?.trimmingCharacters(in: .whitespaces)
        
        let accountnumber1 = self.accountnumber.text?.trimmingCharacters(in: .whitespaces)
        
        let billingaddress1 = self.billingaddress.text?.trimmingCharacters(in: .whitespaces)
        
        let dob_value1 = self.Dobfield.text?.trimmingCharacters(in: .whitespaces)
        
        let ssn_value1 = self.ssnfield.text?.trimmingCharacters(in: .whitespaces)
        
        let pin_code1 = self.pincode.text?.trimmingCharacters(in: .whitespaces)
        
        let branch_code1 = self.branchcode.text?.trimmingCharacters(in: .whitespaces)
        
        let firstname1 = self.firstname.text?.trimmingCharacters(in: .whitespaces)
        
        let lastname1 = self.lastname.text?.trimmingCharacters(in: .whitespaces)
        
        //   let cityfields = cityfield.text?.trimmingCharacters(in: .whitespaces)
        
        
        if(self.accountholdername.text == "" && self.bankname.text == "" && self.routing.text == "" && self.accountnumber.text == "" && self.billingaddress.text == "" && self.Dobfield.text == "" && self.ssnfield.text == "" && self.selectedPic == "" && self.pincode.text! == "" && self.branchcode.text! == "" && self.firstname.text! == "" && self.lastname.text! == "")
        {
            holdernameerr.isHidden=false
            banknameerr.isHidden=false
            routingerr.isHidden=false
            accountnumerr.isHidden=false
            billingerr.isHidden=false
            docerr.isHidden = false
            ssnerr.isHidden = false
            uploaderr.isHidden = false
            pincodeerr.isHidden = false
            branchcodeerr.isHidden = false
            firstnameerr.isHidden = false
            lastnameerr.isHidden = false
            //cityerr.isHidden=false
        }
            
            
            //       else if(self.accountnumber.text != "") {
            //
            //
            //        }
            
            
        else if holdername == ""{
            
            holdernameerr.isHidden=false
            banknameerr.isHidden=true
            routingerr.isHidden=true
            accountnumerr.isHidden=true
            billingerr.isHidden=true
            docerr.isHidden = true
            ssnerr.isHidden = true
            uploaderr.isHidden = true
            pincodeerr.isHidden = true
            branchcodeerr.isHidden = true
            firstnameerr.isHidden = true
            lastnameerr.isHidden = true
            //cityerr.isHidden=true
        }
        else if bankname1 == ""{
            holdernameerr.isHidden=true
            banknameerr.isHidden=false
            routingerr.isHidden=true
            accountnumerr.isHidden=true
            billingerr.isHidden=true
            docerr.isHidden = true
            ssnerr.isHidden = true
            uploaderr.isHidden = true
            pincodeerr.isHidden = true
            branchcodeerr.isHidden = true
            firstnameerr.isHidden = true
            lastnameerr.isHidden = true
            //cityerr.isHidden=true
        }
        else if routing1 == ""{
            holdernameerr.isHidden=true
            banknameerr.isHidden=true
            routingerr.isHidden=false
            accountnumerr.isHidden=true
            billingerr.isHidden=true
            docerr.isHidden = true
            ssnerr.isHidden = true
            uploaderr.isHidden = true
            pincodeerr.isHidden = true
            branchcodeerr.isHidden = true
            firstnameerr.isHidden = true
            lastnameerr.isHidden = true
            //cityerr.isHidden=true
        }
        else if accountnumber1 == ""{
            holdernameerr.isHidden=true
            banknameerr.isHidden=true
            routingerr.isHidden=true
            accountnumerr.isHidden=false
            billingerr.isHidden=true
            docerr.isHidden = true
            ssnerr.isHidden = true
            uploaderr.isHidden = true
            pincodeerr.isHidden = true
            branchcodeerr.isHidden = true
            firstnameerr.isHidden = true
            lastnameerr.isHidden = true
            // cityerr.isHidden=true
        }
        else if billingaddress1 == ""{
            holdernameerr.isHidden=true
            banknameerr.isHidden=true
            routingerr.isHidden=true
            accountnumerr.isHidden=true
            billingerr.isHidden=false
            docerr.isHidden = true
            ssnerr.isHidden = true
            uploaderr.isHidden = true
            pincodeerr.isHidden = true
            branchcodeerr.isHidden = true
            firstnameerr.isHidden = true
            lastnameerr.isHidden = true
            //cityerr.isHidden=true
        }
        else if dob_value1 == ""{
            holdernameerr.isHidden=true
            banknameerr.isHidden=true
            routingerr.isHidden=true
            accountnumerr.isHidden=true
            billingerr.isHidden=true
            docerr.isHidden = false
            ssnerr.isHidden = true
            uploaderr.isHidden = true
            pincodeerr.isHidden = true
            branchcodeerr.isHidden = true
            firstnameerr.isHidden = true
            lastnameerr.isHidden = true
            //cityerr.isHidden=true
        }
        else if ssn_value1 == ""{
            holdernameerr.isHidden=true
            banknameerr.isHidden=true
            routingerr.isHidden=true
            accountnumerr.isHidden=true
            billingerr.isHidden=true
            docerr.isHidden = true
            ssnerr.isHidden = false
            uploaderr.isHidden = true
            pincodeerr.isHidden = true
            branchcodeerr.isHidden = true
            firstnameerr.isHidden = true
            lastnameerr.isHidden = true
            //cityerr.isHidden=true
        }
       
        else if(self.selectedPic == ""){
            
            holdernameerr.isHidden=true
            banknameerr.isHidden=true
            routingerr.isHidden=true
            accountnumerr.isHidden=true
            billingerr.isHidden=true
            docerr.isHidden = true
            ssnerr.isHidden = true
            uploaderr.isHidden = false
            pincodeerr.isHidden = true
            branchcodeerr.isHidden = true
            firstnameerr.isHidden = true
            lastnameerr.isHidden = true
        }

            
            
        else if(uplodeimg == UIImage(named: "sampleDoc.png")){
            holdernameerr.isHidden=true
            banknameerr.isHidden=true
            routingerr.isHidden=true
            accountnumerr.isHidden=true
            billingerr.isHidden=true
            docerr.isHidden = true
            ssnerr.isHidden = true
            uploaderr.isHidden = false
            pincodeerr.isHidden = true
            branchcodeerr.isHidden = true
            firstnameerr.isHidden = true
            lastnameerr.isHidden = true
        }
        else if pin_code1 == ""{
            holdernameerr.isHidden=true
            banknameerr.isHidden=true
            routingerr.isHidden=true
            accountnumerr.isHidden=true
            billingerr.isHidden=true
            docerr.isHidden = true
            ssnerr.isHidden = true
            uploaderr.isHidden = true
            pincodeerr.isHidden = false
            branchcodeerr.isHidden = true
            firstnameerr.isHidden = true
            lastnameerr.isHidden = true
            //cityerr.isHidden=true
        }
        else if branch_code1 == ""{
            holdernameerr.isHidden=true
            banknameerr.isHidden=true
            routingerr.isHidden=true
            accountnumerr.isHidden=true
            billingerr.isHidden=true
            docerr.isHidden = true
            ssnerr.isHidden = true
            uploaderr.isHidden = true
            pincodeerr.isHidden = true
            branchcodeerr.isHidden = false
            firstnameerr.isHidden = true
            lastnameerr.isHidden = true
            //cityerr.isHidden=true
        }
        else if firstname1 == ""{
            holdernameerr.isHidden=true
            banknameerr.isHidden=true
            routingerr.isHidden=true
            accountnumerr.isHidden=true
            billingerr.isHidden=true
            docerr.isHidden = true
            ssnerr.isHidden = true
            uploaderr.isHidden = true
            pincodeerr.isHidden = true
            branchcodeerr.isHidden = true
            firstnameerr.isHidden = false
            lastnameerr.isHidden = true
            //cityerr.isHidden=true
        }
        else if lastname1 == ""{
            holdernameerr.isHidden=true
            banknameerr.isHidden=true
            routingerr.isHidden=true
            accountnumerr.isHidden=true
            billingerr.isHidden=true
            docerr.isHidden = true
            ssnerr.isHidden = true
            uploaderr.isHidden = true
            pincodeerr.isHidden = true
            branchcodeerr.isHidden = true
            firstnameerr.isHidden = true
            lastnameerr.isHidden = false
            //cityerr.isHidden=true
        }
            /* else if cityfields == ""{
             holdernameerr.isHidden=true
             banknameerr.isHidden=true
             routingerr.isHidden=true
             accountnumerr.isHidden=true
             billingerr.isHidden=true
             cityerr.isHidden=false
             }*/
            
        else if(self.routing.text != "" || self.accountnumber.text != "" || self.ssnfield.text != "" || self.pincode.text != "" || self.branchcode.text != "" || self.firstname.text != "" || self.lastname.text != "")
        {
            if((routing.text?.characters.count)! == 0){
                routingerr.isHidden=false
                self.routingerr.text = "Enter valid Bank Code No"
            }

            else if((accountnumber.text?.characters.count)! == 0){
                accountnumerr.isHidden=false
                self.accountnumerr.text = "Enter valid Account No No"
            }

            else if((ssnfield.text?.characters.count)! == 0){
                ssnerr.isHidden=false
                self.ssnerr.text = "Enter valid NRIC Number"
            }
                
            else if((pincode.text?.characters.count)! == 0){
                pincodeerr.isHidden=false
                self.pincodeerr.text = "Enter valid Postal Code No"
            }
                
            else if((branchcode.text?.characters.count)! == 0){
                branchcodeerr.isHidden=false
                self.branchcodeerr.text = "Enter valid Branch code No"
            }
            else if((firstname.text?.characters.count)! == 0){
                firstnameerr.isHidden=false
                self.firstnameerr.text = "Enter valid First Name"
            }
                
            else if((lastname.text?.characters.count)! == 0){
                lastnameerr.isHidden=false
                self.lastnameerr.text = "Enter valid Last Name"
            }
                
            else{
                submitspin.isHidden = false
                submitview.isHidden = false
                submitspin.startAnimating()
                self.tokenforbankaccount()
                
                holdernameerr.isHidden=true
                banknameerr.isHidden=true
                routingerr.isHidden=true
                accountnumerr.isHidden=true
                billingerr.isHidden=true
                docerr.isHidden = true
                ssnerr.isHidden = true
                uploaderr.isHidden = true
                branchcodeerr.isHidden = true
                pincodeerr.isHidden = true
                firstnameerr.isHidden = true
                lastnameerr.isHidden = true
                
                
                // self.appDelegate.cityvalue = cityfields
                
            }
            
            
        }
            
        else{
            
            submitspin.isHidden = false
            submitview.isHidden = false
            submitspin.startAnimating()
            self.tokenforbankaccount()
            
            holdernameerr.isHidden=true
            banknameerr.isHidden=true
            routingerr.isHidden=true
            accountnumerr.isHidden=true
            billingerr.isHidden=true
            docerr.isHidden = true
            ssnerr.isHidden = true
            uploaderr.isHidden = true
            branchcodeerr.isHidden = true
            pincodeerr.isHidden = true
            firstnameerr.isHidden = true
            lastnameerr.isHidden = true
            // cityerr.isHidden=true
            
            
          
                   // self.appDelegate.cityvalue = cityfields
            
        }
        
    }
       func savebankdetails(url : String){
        Alamofire.request(url).responseJSON { (response) in
            
            self.parseData1(JSONData: response.data!)
            
        }
        
        
        
    }
    
    func parseData1(JSONData : Data){
        
        do{
            
            let readableJSon1 = try JSONSerialization.jsonObject(with: JSONData, options: .mutableContainers) as! jsonSTD
            
            print(" !!! \(readableJSon1[0])")
            
            let value = readableJSon1[0] as AnyObject
            
            let final = value.object(forKey: "status")
            
            if let final = value.object(forKey: "status"){
                print(final)
                if(final as! String == "Success"){
                    
                    submitspin.isHidden = true
                    submitview.isHidden = true
                    submitspin.stopAnimating()
                        
                        let warning = MessageView.viewFromNib(layout: .CardView)
                        warning.configureTheme(.success)
                        warning.configureDropShadow()
                        let iconText = "" //"🤔"
                        warning.configureContent(title: "", body: "Bank details saved successfully", iconText: iconText)
                        warning.button?.isHidden = true
                        var successConfig = SwiftMessages.defaultConfig
                        successConfig.presentationContext = .window(windowLevel: UIWindowLevelNormal)
                        SwiftMessages.show(config: successConfig, view: warning)
                   
                    
                //spinner.isHidden=false
               // spinner.startAnimating()
              /*  let toastLabel = UILabel(frame: CGRect(x: 15.0, y: 188, width: 335, height: 30))
                toastLabel.backgroundColor = UIColor.black
                toastLabel.textColor = UIColor.white
                toastLabel.textAlignment = NSTextAlignment.center;
                self.view.addSubview(toastLabel)
                toastLabel.text = "Bank Details updated sucessfully"
                toastLabel.alpha = 1.0
                toastLabel.layer.cornerRadius = 0;
                toastLabel.clipsToBounds  =  true*/
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let subContentsVC = storyboard.instantiateViewController(withIdentifier: "AREarnVC") as! ARReferalVC
                self.navigationController?.pushViewController(subContentsVC, animated: true)
                    
                }
                else{
                    
                    submitspin.isHidden = true
                    submitview.isHidden = true
                    submitspin.stopAnimating()
                    
                    let warning = MessageView.viewFromNib(layout: .CardView)
                    warning.configureTheme(.warning)
                    warning.configureDropShadow()
                    let iconText = "" //"🤔"
                    warning.configureContent(title: "", body: "Something went wrong. Your bank details was not saved", iconText: iconText)
                    warning.button?.isHidden = true
                    var warningConfig = SwiftMessages.defaultConfig
                    warningConfig.presentationContext = .window(windowLevel: UIWindowLevelStatusBar)
                    SwiftMessages.show(config: warningConfig, view: warning)

                }
            }
        }
        catch{
            print(error)
            //spinner.isHidden=true
           // spinner.stopAnimating()
        }
    }
    
    
    func tokenforbankaccount(){
        
        let longstring =  self.billingaddress.text!
        let data = (longstring).data(using: String.Encoding.utf8)
        let base64 = data!.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        print(base64)
        
        self.appDelegate.encode = base64
        print(self.appDelegate.encode)
        
        var routingno = ("\(self.routing.text!)-\(self.branchcode.text!)")
        print(routingno)
        
        let card: STPBankAccountParams = STPBankAccountParams()
        
        card.accountNumber = self.accountnumber.text!
        card.routingNumber = routingno
        card.country = "SG"
        card.currency = "SGD"
        
        //card.routingNumber = card.routingNumber?.replacingOccurrences(of: "-", with: "0")
        
        print(card.accountNumber)
        print(card.routingNumber)
        print(card.country)
        print(card.currency)
        print(card)
        
        STPAPIClient.shared().createToken(withBankAccount: card) { token, error in
            guard let stripeToken = token else {
                NSLog("Error creating token: %@", error!.localizedDescription);
                
                self.submitspin.isHidden = true
                self.submitview.isHidden = true
            
                let warning = MessageView.viewFromNib(layout: .CardView)
                warning.configureTheme(.warning)
                warning.configureDropShadow()
                let iconText = "" //"🤔"
                warning.configureContent(title: "", body: error!.localizedDescription, iconText: iconText)
                warning.button?.isHidden = true
                var warningConfig = SwiftMessages.defaultConfig
                warningConfig.presentationContext = .window(windowLevel: UIWindowLevelStatusBar)
                SwiftMessages.show(config: warningConfig, view: warning)
                
                return
            }
            print("token \(stripeToken)")
            print("img\(self.selectedPic)")
            print(self.bankimg1)
            print("\(live_Driver_url)addBankDetails?driver_id=\(self.appDelegate.userid!)&account_name=\(self.accountholdername.text!)&bank_name=\(self.bankname.text!)&routing_number=\(routingno)&account_number=\(self.accountnumber.text!)&billing=\(self.appDelegate.encode!)&payment_mode=stripe&token=\(stripeToken)&dob=\(self.Dobfield.text!)&ssn=\(self.ssnfield.text!)&stripe_doc=\(self.selectedPic)&postal=\(self.pincode.text!)&first_name=\(self.firstname.text!)&last_name=\(self.lastname.text!)")
            
            var urlstring:String = "\(live_Driver_url)addBankDetails?driver_id=\(self.appDelegate.userid!)&account_name=\(self.accountholdername.text!)&bank_name=\(self.bankname.text!)&routing_number=\(routingno)&account_number=\(self.accountnumber.text!)&billing=\(self.appDelegate.encode!)&payment_mode=stripe&token=\(stripeToken)&dob=\(self.Dobfield.text!)&ssn=\(self.ssnfield.text!)&stripe_doc=\(self.selectedPic)&postal=\(self.pincode.text!)&first_name=\(self.firstname.text!)&last_name=\(self.lastname.text!)"
            print(urlstring)
            urlstring = urlstring.replacingOccurrences(of: "Optional", with: "")
            urlstring = urlstring.replacingOccurrences(of: "(", with: "")
            urlstring = urlstring.replacingOccurrences(of: ")", with: "")
            urlstring = urlstring.replacingOccurrences(of: "\"", with: "")
            urlstring = urlstring.replacingOccurrences(of: " ", with: "%20")
            urlstring = urlstring.replacingOccurrences(of: " ", with: "%2520")
           
            
            urlstring = urlstring.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            urlstring = urlstring.removingPercentEncoding!
            
            //   urlstring = UTF8.decode(urlstring)
            print(urlstring)
            //   urlstring = UTF8.decode(urlstring)
            //print(urlstring)
            self.savebankdetails(url: "\(urlstring)")
            
        }
        
        
    }
   
    func valid(){
        accountholdername.borderActiveColor = UIColor.black
        accountholdername.borderInactiveColor = UIColor.black
        accountholdername.placeholderColor = UIColor.darkGray
        
        bankname.borderActiveColor = UIColor.black
        bankname.borderInactiveColor = UIColor.black
        bankname.placeholderColor = UIColor.darkGray
        
        routing.borderActiveColor = UIColor.black
        routing.borderInactiveColor = UIColor.black
        routing.placeholderColor = UIColor.darkGray
        
        accountnumber.borderActiveColor = UIColor.black
        accountnumber.borderInactiveColor = UIColor.black
        accountnumber.placeholderColor = UIColor.darkGray
        
        billingaddress.borderActiveColor = UIColor.black
        billingaddress.borderInactiveColor = UIColor.black
        billingaddress.placeholderColor = UIColor.darkGray
        
        Dobfield.borderActiveColor = UIColor.black
        Dobfield.borderInactiveColor = UIColor.black
        Dobfield.placeholderColor = UIColor.darkGray
        
        ssnfield.borderActiveColor = UIColor.black
        ssnfield.borderInactiveColor = UIColor.black
        ssnfield.placeholderColor = UIColor.darkGray
        
        pincode.borderActiveColor = UIColor.black
        pincode.borderInactiveColor = UIColor.black
        pincode.placeholderColor = UIColor.darkGray
        
        branchcode.borderActiveColor = UIColor.black
        branchcode.borderInactiveColor = UIColor.black
        branchcode.placeholderColor = UIColor.darkGray
        
        firstname.borderActiveColor = UIColor.black
        firstname.borderInactiveColor = UIColor.black
        firstname.placeholderColor = UIColor.darkGray
        
        lastname.borderActiveColor = UIColor.black
        lastname.borderInactiveColor = UIColor.black
        lastname.placeholderColor = UIColor.darkGray
        
        /* cityfield.borderActiveColor = UIColor.black
         cityfield.borderInactiveColor = UIColor.black
         cityfield.placeholderColor = UIColor.darkGray*/
        
    }
    
    func invalid(){
        
        
        accountholdername.borderActiveColor = UIColor.red
        accountholdername.borderInactiveColor = UIColor.red
        accountholdername.placeholderColor = UIColor.red
        
        bankname.borderActiveColor = UIColor.red
        bankname.borderInactiveColor = UIColor.red
        bankname.placeholderColor = UIColor.red
        
        routing.borderActiveColor = UIColor.red
        routing.borderInactiveColor = UIColor.red
        routing.placeholderColor = UIColor.red
        
        accountnumber.borderActiveColor = UIColor.red
        accountnumber.borderInactiveColor = UIColor.red
        accountnumber.placeholderColor = UIColor.red
        
        billingaddress.borderActiveColor = UIColor.red
        billingaddress.borderInactiveColor = UIColor.red
        billingaddress.placeholderColor = UIColor.red
        
        Dobfield.borderActiveColor = UIColor.red
        Dobfield.borderInactiveColor = UIColor.red
        Dobfield.placeholderColor = UIColor.red
        
        ssnfield.borderActiveColor = UIColor.red
        ssnfield.borderInactiveColor = UIColor.red
        ssnfield.placeholderColor = UIColor.red
        
        pincode.borderActiveColor = UIColor.red
        pincode.borderInactiveColor = UIColor.red
        pincode.placeholderColor = UIColor.red
        
        branchcode.borderActiveColor = UIColor.red
        branchcode.borderInactiveColor = UIColor.red
        branchcode.placeholderColor = UIColor.red
        
        firstname.borderActiveColor = UIColor.red
        firstname.borderInactiveColor = UIColor.red
        firstname.placeholderColor = UIColor.red
        
        lastname.borderActiveColor = UIColor.red
        lastname.borderInactiveColor = UIColor.red
        lastname.placeholderColor = UIColor.red
        
        
        /* cityfield.borderActiveColor = UIColor.red
         cityfield.borderInactiveColor = UIColor.red
         cityfield.placeholderColor = UIColor.red*/
        
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if(textField == firstname){
            if(firstname.text == ""){
                self.invalid()
            }
            else{
                firstname.resignFirstResponder()
                lastname.becomeFirstResponder()
            }
        }
        else if(textField == lastname){
            if(lastname.text == ""){
                self.invalid()
            }
            else{
                lastname.resignFirstResponder()
                accountholdername.becomeFirstResponder()
            }
        }
        else if(textField == accountholdername){
            if(accountholdername.text == ""){
                self.invalid()
            }
            else{
                accountholdername.resignFirstResponder()
                bankname.becomeFirstResponder()
            }
        }
        else if(textField == bankname){
            if(bankname.text == ""){
                self.invalid()
            }
            else{
                bankname.resignFirstResponder()
                routing.becomeFirstResponder()
            }
        }
        else if(textField == routing){
            if(routing.text == ""){
                self.invalid()
            }
            else{
                routing.resignFirstResponder()
                branchcode.becomeFirstResponder()
            }
        }
            
        else if(textField == branchcode){
            if(branchcode.text == ""){
                self.invalid()
            }
            else{
                branchcode.resignFirstResponder()
                accountnumber.becomeFirstResponder()
            }
        }
            
        else if(textField == accountnumber){
            if(accountnumber.text == ""){
                self.invalid()
            }
            else{
                accountnumber.resignFirstResponder()
                billingaddress.becomeFirstResponder()
                // cityfield.becomeFirstResponder()
            }
        }
            
        else if(textField == billingaddress){
            if(billingaddress.text == ""){
                self.invalid()
            }
            else{
                billingaddress.resignFirstResponder()
                pincode.becomeFirstResponder()
                // cityfield.becomeFirstResponder()
            }
        }
        else if(textField == pincode){
            if(pincode.text == ""){
                //self.invalid()
            }
            else{
                pincode.resignFirstResponder()
                ssnfield.becomeFirstResponder()
                // cityfield.becomeFirstResponder()
            }
        }
        else if(textField == ssnfield){
            if(ssnfield.text == ""){
                self.invalid()
            }
            else{
                //Dobfield.resignFirstResponder()
                ssnfield.resignFirstResponder()
                // cityfield.becomeFirstResponder()
            }
        }
            
            /*   else if(textField == cityfield){
             if(cityfield.text == ""){
             self.invalid()
             }
             else{
             cityfield.resignFirstResponder()
             
             }
             }*/
            
            
        else{
            
        }
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        var result = true
        let str:NSString! = "\(textField.text!)" as NSString!
        
        let prospectiveText = (str).replacingCharacters(in: range, with: string)
        var limit = 30
        if(textField == accountholdername){
            limit = 30
            if string.characters.count > 0 {
                
                //let owedCharacterSet = CharacterSet.whitespaces
                
                let disallowedCharacterSet = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ").inverted
                
                let replacementStringIsLegal = string.rangeOfCharacter(from: disallowedCharacterSet) == nil
                
                let resultingStringLengthIsLegal = prospectiveText.characters.count <= limit
                
                result = replacementStringIsLegal &&
                    
                resultingStringLengthIsLegal
                
            }
            
        }
        if(textField == firstname){
            limit = 25
            if string.characters.count > 0 {
                
                //let owedCharacterSet = CharacterSet.whitespaces
                
                let disallowedCharacterSet = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ").inverted
                
                let replacementStringIsLegal = string.rangeOfCharacter(from: disallowedCharacterSet) == nil
                
                let resultingStringLengthIsLegal = prospectiveText.characters.count <= limit
                
                result = replacementStringIsLegal &&
                    
                resultingStringLengthIsLegal
                
            }
            
        }
        if(textField == lastname){
            limit = 25
            if string.characters.count > 0 {
                
                //let owedCharacterSet = CharacterSet.whitespaces
                
                let disallowedCharacterSet = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ").inverted
                
                let replacementStringIsLegal = string.rangeOfCharacter(from: disallowedCharacterSet) == nil
                
                let resultingStringLengthIsLegal = prospectiveText.characters.count <= limit
                
                result = replacementStringIsLegal &&
                    
                resultingStringLengthIsLegal
                
            }
            
        }
        if(textField == bankname){
            limit = 30
            if string.characters.count > 0 {
                
                //     let disallowedCharacterSet = CharacterSet.whitespaces
                
                let disallowedCharacterSet = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ").inverted
                
                let replacementStringIsLegal = string.rangeOfCharacter(from: disallowedCharacterSet) == nil
                
                let resultingStringLengthIsLegal = prospectiveText.characters.count <= limit
                
                result = replacementStringIsLegal &&
                    
                resultingStringLengthIsLegal
                
            }
            
        }
        if(textField == routing){
            limit = 10
            if string.characters.count > 0 {
                
                // let disallowedCharacterSet = CharacterSet.whitespaces
                
                let disallowedCharacterSet = CharacterSet(charactersIn: "0123456789-").inverted
                
                let replacementStringIsLegal = string.rangeOfCharacter(from: disallowedCharacterSet) == nil
                
                let resultingStringLengthIsLegal = prospectiveText.characters.count <= limit
                
                result = replacementStringIsLegal &&
                    
                resultingStringLengthIsLegal
                
            }
            
        }
        if(textField == branchcode){
            limit = 10
            if string.characters.count > 0 {
                
                // let disallowedCharacterSet = CharacterSet.whitespaces
                
                let disallowedCharacterSet = CharacterSet(charactersIn: "0123456789-").inverted
                
                let replacementStringIsLegal = string.rangeOfCharacter(from: disallowedCharacterSet) == nil
                
                let resultingStringLengthIsLegal = prospectiveText.characters.count <= limit
                
                result = replacementStringIsLegal &&
                    
                resultingStringLengthIsLegal
                
            }
            
        }
        if(textField == pincode){
            limit = 10
            if string.characters.count > 0 {
                
                // let disallowedCharacterSet = CharacterSet.whitespaces
                
                let disallowedCharacterSet = CharacterSet(charactersIn: "0123456789-").inverted
                
                let replacementStringIsLegal = string.rangeOfCharacter(from: disallowedCharacterSet) == nil
                
                let resultingStringLengthIsLegal = prospectiveText.characters.count <= limit
                
                result = replacementStringIsLegal &&
                    
                resultingStringLengthIsLegal
                
            }
            
        }
        if(textField == accountnumber){
            limit = 15
            if string.characters.count > 0 {
                
                //     let disallowedCharacterSet = CharacterSet.whitespaces
                
                let disallowedCharacterSet = CharacterSet(charactersIn: "0123456789").inverted
                
                let replacementStringIsLegal = string.rangeOfCharacter(from: disallowedCharacterSet) == nil
                
                let resultingStringLengthIsLegal = prospectiveText.characters.count <= limit
                
                result = replacementStringIsLegal &&
                    
                resultingStringLengthIsLegal
                
            }
            
        }
        if(textField == billingaddress){
            limit = 30
            if string.characters.count > 0 {
                
                //     let disallowedCharacterSet = CharacterSet.whitespaces
                
                let disallowedCharacterSet = CharacterSet(charactersIn: "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ.!@$&*()_+-*/,:;[]{}%~^|# ").inverted
                
                let replacementStringIsLegal = string.rangeOfCharacter(from: disallowedCharacterSet) == nil
                
                let resultingStringLengthIsLegal = prospectiveText.characters.count <= limit
                
                result = replacementStringIsLegal &&
                    
                resultingStringLengthIsLegal
                
            }
            
        }
        
        if(textField == ssnfield){
            limit = 20
            if string.characters.count > 0 {
                
                //     let disallowedCharacterSet = CharacterSet.whitespaces
                
                let disallowedCharacterSet = CharacterSet(charactersIn: "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ.!@$&*()_+-*/,:;[]{}%~^| #").inverted
                
                let replacementStringIsLegal = string.rangeOfCharacter(from: disallowedCharacterSet) == nil
                
                let resultingStringLengthIsLegal = prospectiveText.characters.count <= limit
                
                result = replacementStringIsLegal &&
                    
                resultingStringLengthIsLegal
                
            }
            
        }
            /*  if(textField == cityfield){
             limit = 30
             if string.characters.count > 0 {
             
             //     let disallowedCharacterSet = CharacterSet.whitespaces
             
             let disallowedCharacterSet = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789").inverted
             
             let replacementStringIsLegal = string.rangeOfCharacter(from: disallowedCharacterSet) == nil
             
             let resultingStringLengthIsLegal = prospectiveText.characters.count <= limit
             
             result = replacementStringIsLegal &&
             
             resultingStringLengthIsLegal
             
             }
             
             }*/
        else{
            
        }
        
        return result
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
extension ARBankVC
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
        
        
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        uplodeimg.image = image
        if let data = UIImagePNGRepresentation(image!) {
            
            let filename = getDocumentsDirectory().appendingPathComponent("sampleDoc.png")
            try? data.write(to: filename)
            
            print("im \(filename)")
            self.selectedPic = String(describing: filename)
        }
        self.dismiss(animated: true, completion: nil)
        //    callImageUpload()
        
        self.viewActivity.isHidden = false
        
        LoadingIndicatorView.show(self.viewActivity, loadingText: "Uploading...")
        
        let rimage:UIImage = self.imageRotatedByDegrees(0.0,image: image!)
        
        let imgdata:Data = UIImageJPEGRepresentation(rimage,90)!
        
        var viewImageUrl = "\(live_Driver_url)imageUpload/"
        
        viewImageUrl = viewImageUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        var request:NSMutableURLRequest = NSMutableURLRequest(url: URL(string:"\(viewImageUrl)\(self.selectedPic)")!)
        
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
        //        operation.responseSerializer.acceptableContentTypes = NSSet(object: "application/json") as Set<NSObject>
        
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
                self.bankimg1 = tmpstr as String
                print(self.bankimg1)
                
                print("image uploaded")
                
                self.selectedPic = tmpstr as String!
                
                LoadingIndicatorView.hide()
                
                self.viewActivity.isHidden = true
                
                
                
        }, failure: { (operation, error) -> Void in
            print("image uploaded failed")
            print(error?.localizedDescription)
            
            LoadingIndicatorView.hide()
            
            self.viewActivity.isHidden = true
            
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

