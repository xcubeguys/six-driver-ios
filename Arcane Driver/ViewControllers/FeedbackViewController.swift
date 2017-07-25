//
//  FeedbackViewController.swift
//  SIX Rider
//
//  Created by Apple on 15/05/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit
import SwiftMessages
import Alamofire

class FeedbackViewController: UIViewController,UITextViewDelegate {
let appDelegate = UIApplication.shared.delegate as! AppDelegate
    typealias jsonSTD = NSArray
    var subjecttile = ""
    var urlString : String!
    let screenSize = UIScreen.main.bounds
  
    @IBOutlet weak var submitBtnLabel: UIButton!
    @IBOutlet weak var messageBody: UITextView!
    
    @IBOutlet weak var dwnarw: UIImageView!
    @IBOutlet weak var selectsubbtn: UIButton!
    @IBOutlet weak var selectsubjectview: UIView!
    @IBOutlet weak var dropdownlist: EDropdownList!
    @IBOutlet weak var staticTextViewLabel: UITextView!
    
    var subjectarray = NSMutableArray()

    var feedbackContent = ""
    
    let driverDropDown = DropDown()
    
    lazy var dropDowns: [DropDown] = {
        return [
            self.driverDropDown
        ]
    }()
      
    override func viewDidLoad() {
        super.viewDidLoad()
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        navigationController!.isNavigationBarHidden = false
        
        navigationController!.navigationBar.barStyle = .black
 
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "arrow-left.png")!, for: .normal)
        button.addTarget(self, action: #selector(FeedbackViewController.backBtn(_:)), for: .touchUpInside)
        //CGRectMake(0, 0, 53, 31)
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        //(frame: CGRectMake(3, 5, 50, 20))
        let label = UILabel(frame: CGRect(x: 20, y: 5, width: 100, height: 20))
        // label.font = UIFont(name: "Arial-BoldMT", size: 13)
        label.text = "Feedback"
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.backgroundColor = UIColor.clear
        button.addSubview(label)
        let barButton = UIBarButtonItem(customView: button)
        self.navigationItem.leftBarButtonItem = barButton
        // Do any additional setup after loading the view.r
        selectsubjectview.layer.borderWidth = 1

        if screenHeight == 568{
        
            self.staticTextViewLabel.text = "Found a bug? Have a suggestion? Fill out the form below and we will take a look"
        self.staticTextViewLabel.frame = CGRect(x: 10, y: 50, width: 300, height: 80)
            self.messageBody.frame = CGRect(x: 16, y: 177, width: 285, height: 201)
    self.submitBtnLabel.frame = CGRect(x: 16, y: 390, width: 285, height: 47)
          }
          if screenHeight == 667 {
         self.staticTextViewLabel.text = "Found a bug? Have a suggestion? Fill out the form below and we will take a look"
        }
        if screenHeight == 736{
        
            self.staticTextViewLabel.text = "Found a bug? Have a suggestion? Fill out the form below and we will take a look"
            self.staticTextViewLabel.frame = CGRect(x: 10, y: 50, width: 382, height: 80)
            self.messageBody.frame = CGRect(x: 16, y: 177, width: 382, height: 201)
            self.submitBtnLabel.frame = CGRect(x: 16, y: 390, width: 382, height: 47)
        }
         self.messageBody.text = "Write your Feedback Here...!"
       messageBody.textColor = UIColor.lightGray
      messageBody.delegate = self
        messageBody.layer.borderWidth = 1
        messageBody.layer.borderColor = UIColor.black.cgColor
        messageBody.layer.cornerRadius = 5
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(FeedbackViewController.hidekeyboard))
                tapGesture.numberOfTapsRequired = 1
        view.addGestureRecognizer(tapGesture)
        
        self.getsubject()
    }
    
    @IBAction func selectsubact(_ sender: Any) {
        driverDropDown.show()
    }
    
    
    func setupAmountDropDown1() {
        driverDropDown.anchorView = selectsubbtn
        
        
        driverDropDown.bottomOffset = CGPoint(x: 0, y: selectsubbtn.bounds.height)
        driverDropDown.dataSource = subjectarray as! [String]
        // Action triggered on selection
        driverDropDown.selectionAction = { [unowned self] (index, item) in
            self.selectsubbtn.setTitle(item, for: .normal)
            
        }
    }
    
    func getsubject()
    {
        urlString = "\(live_request_url)home/getsubject"
        urlString = urlString.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!
        print("FeedBack subject:\(urlString)")
        self.callsubject(url: "\(urlString!)")
    }
    
    func hidekeyboard()
    {
        self.view.endEditing(true)
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if messageBody.textColor == UIColor.lightGray {
            messageBody.text = nil
            messageBody.textColor = UIColor.black
            
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if messageBody.text.isEmpty {
            messageBody.text = "Write your Feedback Here...!"
            messageBody.textColor = UIColor.lightGray
        }
        
    }
    @IBAction func backBtn(_ sender: Any) {
     self.navigationController?.popViewController(animated: true)
    }

    
    
    
    @IBAction func submitButton(_ sender: Any) {
        
        feedbackContent = self.messageBody.text
        subjecttile = self.selectsubbtn.currentTitle!
        print("subjecttile\(subjecttile)")

        print("FeedbackContent:\(feedbackContent)")
        
       // let submitClick = 1
        dataUpload()
    
    }
    func dataUpload(){
        
        if self.feedbackContent != "" && selectsubbtn.currentTitle != "Select your subject" {
            
            
            urlString = "\(live_Driver_url)feedback?user_id=\(self.appDelegate.userid!)&feedback=\(feedbackContent)&subject=\(subjecttile)"
            urlString = urlString.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!
            print("FeedBack Upload:\(urlString)")
            self.calleditAPI(url: "\(urlString!)")
              // urlString = urlString.removingPercentEncoding!
        }
        else{
            print("Feedback Content is NIL")
            message()
            
        }
        
        
        
    }
    
    func calleditAPI(url : String){
        
        print("URL:\(url)")
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
                    self.message()
                }
            }
        }
        catch{
            
            print(error)
            //self.btnSave.isEnabled = true
            
        }
        
    }
    
    func callsubject(url : String){
        
        print("URL:\(url)")
        Alamofire.request(url).responseJSON { (response) in
            
            self.parseData2(JSONData: response.data!)
        }
        
    }
    
    func parseData2(JSONData : Data){
        
        do{
            
            let readableJSon = try JSONSerialization.jsonObject(with: JSONData, options: .mutableContainers) as! jsonSTD
            
            print(" !!! \(readableJSon[0])")
            
            let value = readableJSon[0] as AnyObject
            
            for dataDict : Any in readableJSon
                
            {
                
                
                let status1: NSString? = (dataDict as AnyObject).object(forKey: "status") as? NSString
                
                if(status1 == "Success"){
                    
                        let subject: NSString? = (dataDict as AnyObject).object(forKey: "subject") as? NSString
                        subjectarray.add(subject!)
                    
                }
               
            }
            print("subjectarray:\(subjectarray)")
            self.setupAmountDropDown1()
        }
        catch{
            
            print(error)
            //self.btnSave.isEnabled = true
            
        }
        
    }
    

    func message(){

        if messageBody.textColor != UIColor.lightGray && messageBody.text != "" && selectsubbtn.currentTitle != "Select your subject"{
        let warning = MessageView.viewFromNib(layout: .CardView)
        warning.configureTheme(.success)
        warning.configureDropShadow()
        let iconText = "" //"🤔"
        warning.configureContent(title: "", body: "Thanks for submitting your feedback", iconText: iconText)
        warning.button?.isHidden = true
        var warningConfig = SwiftMessages.defaultConfig
        warningConfig.presentationContext = .window(windowLevel: UIWindowLevelStatusBar)
        SwiftMessages.show(config: warningConfig, view: warning)
            messageBody.text.removeAll()
            messageBody.text = "Write your Feedback Here...!"
            messageBody.textColor = UIColor.lightGray
            messageBody.resignFirstResponder()
            
            selectsubbtn.setTitle("Select your subject", for: .normal)
          
            //messageBody.isUserInteractionEnabled = false
           // submitBtnLabel.isEnabled = false
            
        }
        else{
            let warning = MessageView.viewFromNib(layout: .CardView)
            warning.configureTheme(.info)
            warning.configureDropShadow()
            let iconText = "" //"🤔"
            warning.configureContent(title: "", body: "Please provide some feedback for development with subject", iconText: iconText)
            warning.button?.isHidden = true
            var warningConfig = SwiftMessages.defaultConfig
            warningConfig.presentationContext = .window(windowLevel: UIWindowLevelStatusBar)
            SwiftMessages.show(config: warningConfig, view: warning)
        }
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

}
