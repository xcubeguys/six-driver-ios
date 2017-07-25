//
//  ADViewProfileVC.swift
//  Arcane Driver
//
//  Created by Apple on 20/12/16.
//  Copyright © 2016 Apple. All rights reserved.
//

import UIKit
import Alamofire
import GoogleSignIn
import CoreLocation
import Firebase
import GeoFire
import SwiftMessages


class ADViewProfileVC: UIViewController,CLLocationManagerDelegate {

    @IBOutlet weak var activityView: UIActivityIndicatorView!
   
    @IBOutlet weak var sharebutton: UIButton!
    @IBOutlet weak var nicknamelabel: UILabel!
    @IBOutlet weak var referalcodelabel: UILabel!
    @IBOutlet weak var labelFirst: UILabel!
    @IBOutlet weak var labelLast: UILabel!
    @IBOutlet weak var labelPhone: UILabel!
    @IBOutlet weak var labelEmail: UILabel!
    
    @IBOutlet weak var profilepicload: UIActivityIndicatorView!
    @IBOutlet weak var ShareView: UIView!
    @IBOutlet weak var imageViewProfile: UIImageView!

    @IBOutlet weak var viewCircleProfile: UIView!

    @IBOutlet weak var labelCategory: UILabel!

    @IBOutlet var vehicleyearlabel: UILabel!
    
    @IBOutlet var vehiclemakelabel: UILabel!
    
    @IBOutlet var vehiclemodellabel: UILabel!
    
    @IBOutlet var vehiclemileagelabel: UILabel!
    
    @IBOutlet var platenolabel: UILabel!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var viewAPIUrl = live_Driver_url
    
    var locationManager = CLLocationManager()
    
    typealias jsonSTD = NSArray
    
    typealias jsonSTDAny = [String : AnyObject]
    
    var locationUpdate: LocationUpdate!
    var locationUpdateTimer: Timer!

    override var preferredStatusBarStyle: UIStatusBarStyle {
        
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ShareView.isHidden = true

        UIApplication.shared.isIdleTimerDisabled = false

        navigationController!.navigationBar.barStyle = .black
        
        navigationController!.isNavigationBarHidden = false

        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "arrow-left.png")!, for: .normal)
        button.addTarget(self, action: #selector(ADViewProfileVC.profileBtn(_:)), for: .touchUpInside)
        //CGRectMake(0, 0, 53, 31)
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        //(frame: CGRectMake(3, 5, 50, 20))
        let label = UILabel(frame: CGRect(x: 20, y: 5, width: 100, height: 20))
        // label.font = UIFont(name: "Arial-BoldMT", size: 13)
        label.text = "Settings"
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.backgroundColor = UIColor.clear
        profilepicload.startAnimating()
        button.addSubview(label)
        let barButton = UIBarButtonItem(customView: button)
        self.navigationItem.leftBarButtonItem = barButton

        viewCircleProfile.layer.cornerRadius = viewCircleProfile.frame.size.width / 2
        viewCircleProfile.clipsToBounds = true
        
        rightNaviCallBtn()
        
        locationManager.delegate = self
        self.appDelegate.referalcode = self.referalcodelabel.text
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        
    }

    override func viewWillAppear(_ animated: Bool) {
        
      //  self.checkNetwork()
        self.ShareView.isHidden = true
        
        self.activityView.startAnimating()
        
        var urlstring:String = "\(viewAPIUrl)editProfile/user_id/\(self.appDelegate.userid!)"
        
        urlstring = urlstring.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!
        
        urlstring = urlstring.removingPercentEncoding!
        
        print(urlstring)
        
        self.callviewAPI(url: "\(urlstring)")
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func checkNetwork(){
        
        NotificationCenter.default.addObserver(self, selector: #selector(ADViewProfileVC.networkStatusChanged(_:)), name: NSNotification.Name(rawValue: ReachabilityStatusChangedNotification), object: nil)
        Reach().monitorReachabilityChanges()

    }
    func mergeImageAndText(text: NSString, atPoint: CGPoint) -> UIImage{
        let demoImage = UIImage(named: "driversharereferal.png")!
        // Setup the font specific variables
        let textColor = UIColor.black
        let textFont = UIFont(name: "Helvetica", size: 48)!
        // Setup the image context using the passed image
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(demoImage.size,false,scale)
        // Setup the font attributes that will be later used to dictate how the text should be drawn
        let textFontAttributes = [
            NSFontAttributeName: textFont,
            NSForegroundColorAttributeName: textColor,
            ] as [String : Any]
        demoImage.draw(in: CGRect(x: 0, y: 0, width: 1024, height: 768))
        let rect =  CGRect(x: atPoint.x, y: atPoint.y, width: demoImage.size.width, height: demoImage.size.height)
        // Draw the text into an image
        text.draw(in: rect, withAttributes: textFontAttributes)
        // Create a new image out of the images we have created
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        // End the context now that we have the image we need
        UIGraphicsEndImageContext()
        //Pass the image back up to the caller
        print(text)
        print(newImage!)
        //view.addSubview(newImage)
        return newImage!
    }

    @IBAction func feedbackButton(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Main", bundle:nil)
                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "feedbackVC") as! FeedbackViewController
       self.navigationController?.pushViewController(nextViewController, animated: true)
    
    }
    @IBAction func socialNetworkButton(_ sender: Any) {
        
        //  let shareText = "Get Credit on your Bank Account by using Referral Code on Registering with SIX Driver App Your Referral Code is "
        
        let space = "\(self.referalcodelabel.text!)"
        
        //let code = ".Enjoy your Trip"
        
        // let myWebsite = ("\(shareText)\(space)\(code)")
        
        let imagenew = self.mergeImageAndText(text: "\(space)" as NSString, atPoint: CGPoint(x: 460, y: 440))
        print("fbreferalcodeShareImage:\(imagenew)")
        // let shareItems:Array = [shareText,space,code]
        
        // let shareItems:Array = [myWebsite]
        
        // let firstActivityItem = "\(myWebsite)"
        let activityVC = UIActivityViewController(activityItems: [imagenew], applicationActivities: nil)
        
        activityVC.excludedActivityTypes = [
            UIActivityType.postToWeibo,
            UIActivityType.print,
            UIActivityType.copyToPasteboard,
            UIActivityType.assignToContact,
            UIActivityType.saveToCameraRoll,
            UIActivityType.addToReadingList,
            UIActivityType.postToFlickr,
            UIActivityType.postToVimeo,
            UIActivityType.postToTencentWeibo,
            UIActivityType.airDrop
        ]
        
        
        self.present(activityVC, animated: true, completion: nil)
    }
    
    @IBAction func contactsShareButton(_ sender: Any) {
        
        self.navigationController?.pushViewController(STAddContactVC(), animated: true)
        
    }
    
    @IBAction func cancelShareButton(_ sender: Any) {
        
        self.ShareView.isHidden = true
        
        
        
    }
    
    @IBAction func shareaction(_ sender: Any) {
        
        self.ShareView.isHidden = false
     
        
        
    }
    
    
    func networkStatusChanged(_ notification: Notification) {
        let userInfo = (notification as NSNotification).userInfo
        
        print(userInfo!)
        
        if let alertMessage = userInfo!["Status"] as? String{
            
            if alertMessage == "Online (WiFi)"{  //
                
                print(" wifi yes")
                
                let status = MessageView.viewFromNib(layout: .StatusLine)
                status.backgroundView.backgroundColor = UIColor(red: 97.0/255.0, green: 161.0/255.0, blue: 23.0/255.0, alpha: 1.0)
                status.bodyLabel?.textColor = UIColor.white
                status.configureContent(body: "Internet Connected")
                var statusConfig = SwiftMessages.defaultConfig
                statusConfig.presentationContext = .window(windowLevel: UIWindowLevelStatusBar)
                
                SwiftMessages.show(config: statusConfig, view: status)
                
            }
            else if alertMessage == "Online (WWAN)"{
                
                print("wwan yes")
                
                let status = MessageView.viewFromNib(layout: .StatusLine)
                status.backgroundView.backgroundColor = UIColor(red: 97.0/255.0, green: 161.0/255.0, blue: 23.0/255.0, alpha: 1.0)
                status.bodyLabel?.textColor = UIColor.white
                status.configureContent(body: "Internet Connected")
                var statusConfig = SwiftMessages.defaultConfig
                statusConfig.presentationContext = .window(windowLevel: UIWindowLevelStatusBar)
                
                SwiftMessages.show(config: statusConfig, view: status)
                
            }
            else{
                
                print("no and unknown")
                
                let status = MessageView.viewFromNib(layout: .StatusLine)
                status.backgroundView.backgroundColor = UIColor(red: 249.0/255.0, green: 66.0/255.0, blue: 47.0/255.0, alpha: 1.0)
                status.bodyLabel?.textColor = UIColor.white
                status.configureContent(body: "Couldn't connect to the server. Check your network connection.")
                var statusConfig = SwiftMessages.defaultConfig
                statusConfig.presentationContext = .window(windowLevel: UIWindowLevelStatusBar)

                SwiftMessages.show(config: statusConfig, view: status)

            }
        }
        else{
            
            
        }
    }
    
    func profileBtn(_ Selector: AnyObject) {
        
        UserDefaults.standard.removeObject(forKey: "oneTime")

        appDelegate.callMapVC()
        self.appDelegate.gotosettings = "0"
        self.navigationController?.popViewController(animated: true)
        
    }
    
    func rightNaviCallBtn(){
        
        let btnName: UIButton = UIButton()
        btnName.setImage(UIImage(named: "pencil.png"), for: UIControlState())
        btnName.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btnName.addTarget(self, action: #selector(ADViewProfileVC.callHistoryBtn(_:)), for: .touchUpInside)
        
        let leftBarButton:UIBarButtonItem = UIBarButtonItem()
        leftBarButton.customView = btnName
        self.navigationItem.rightBarButtonItem = leftBarButton
        
    }
    
    
    func callHistoryBtn(_ Selector: AnyObject) {
        
        self.navigationController?.pushViewController(ADEditProfileVC(), animated: true)
        
    }
    
    @IBAction func btnLogOut(_ sender: Any) {
        
        
        
     /*   let alert = UIAlertController(title: "Confirm", message: "Are You Sure want to Log Out?",
                                      preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "OK", style: .default)
        {
            (action : UIAlertAction!) -> Void in
            
            let prefs = UserDefaults.standard
            prefs.removeObject(forKey: "userid")
            
            self.appDelegate.setRootViewController()
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default)
        {
            (action : UIAlertAction!) -> Void in
        }
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)*/
        
        let optionMenu = UIAlertController(title: nil, message: "Are You Sure want to Log Out?", preferredStyle: .actionSheet)
        optionMenu.popoverPresentationController?.sourceView = self.view
        
        let takePhoto = UIAlertAction(title: "Confirm", style: .default) { (alert : UIAlertAction!) in
            
            
        }
        let sharePhoto = UIAlertAction(title: "Log Out", style: .default) { (alert : UIAlertAction) in
            
            

            self.locationUpdate = LocationUpdate()
            self.locationUpdate.stopLocationTracking()

            let offlineLocation = CLLocation(latitude: 0.00, longitude: 0.00)
            self.locationManager.stopUpdatingLocation()
            let stop = ADHomePageVC()
            stop.locationManager.stopUpdatingLocation()

            var carCategory = UserDefaults.standard.object(forKey: "carCategoryRegister") as! String

            let ref1 = FIRDatabase.database().reference()
            let geofire = GeoFire(firebaseRef: ref1.child("drivers_location").child("\(carCategory)"))
            
            geofire?.setLocation(CLLocation(latitude: offlineLocation.coordinate.latitude, longitude: offlineLocation.coordinate.longitude), forKey: "\(self.appDelegate.userid!)", forBearing: "0.0", withCompletionBlock:
                { (error) in
                    
                    print(error)
                    if (error != nil) {

                        print("Your are now offline")
                        
                    }
                    else{
                        
                    }
            })

//            self.locationManager.stopUpdatingLocation()
            UserDefaults.standard.removeObject(forKey: "userid")
            UserDefaults.standard.removeObject(forKey: "maintain")
            UserDefaults.standard.set("", forKey: "GProfilePic")
            UserDefaults.standard.removeObject(forKey: "oneTime")
          //  UserDefaults.standard.removeObject(forKey: "carCategoryRegister")
    
            GIDSignIn.sharedInstance().signOut()
            
            self.callApiMaintainStatusOff()
           

            UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)

            self.appDelegate.setRootViewController()
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (alert : UIAlertAction) in
            
            
            
        }
        
    //    optionMenu.addAction(takePhoto)
        optionMenu.addAction(sharePhoto)
        
        optionMenu.addAction(cancel)
        
        self.present(optionMenu, animated: true, completion: nil)

        
    }
    
    func callApiMaintainStatusOff(){
        self.appDelegate.lasttime = self.appDelegate.lasttime.replacingOccurrences(of: "%20", with: " ")
       
        self.appDelegate.lasttime = self.appDelegate.lasttime .replacingOccurrences(of: "hr", with: "")
      
        self.appDelegate.lasttime = self.appDelegate.lasttime .replacingOccurrences(of: "min", with: "")
        
        self.appDelegate.lasttime = self.appDelegate.lasttime .replacingOccurrences(of: "sec", with: "")
 
        self.appDelegate.lasttime = self.appDelegate.lasttime.removingPercentEncoding!
        // result = result.trimmingCharacters(in: .whitespaces)
        self.appDelegate.lasttime = self.appDelegate.lasttime.replacingOccurrences(of: " ", with: "", options:[], range: nil)
        print("\(self.appDelegate.timeinsec)")
        
        var urlstring:String = "\(viewAPIUrl)updateOnlineStatus/userid/\(self.appDelegate.userid!)/online_status/0/online_duration/\(self.appDelegate.lasttime)"
        //self.appDelegate.lasttime self.appDelegate.timeinsec
        
        self.appDelegate.timestatuslogout = "1"
       // UserDefaults.standard.set(self.appDelegate.timestatuslogout, forKey: "statuslogout")
        
        urlstring = urlstring.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!
        print("urlstring\(urlstring)")
        
        
        let manager : AFHTTPRequestOperationManager = AFHTTPRequestOperationManager()
        
        manager.responseSerializer.acceptableContentTypes =  Set<AnyHashable>(["application/json", "text/json", "text/javascript", "text/html"])
        
        manager.get( "\(urlstring)",
            parameters: nil,
            success: { (operation: AFHTTPRequestOperation?,responseObject: Any?) in
                let jsonObjects=responseObject as! NSArray
                //                var dataDict: NSDictionary?
                
                let value = jsonObjects[0] as AnyObject
                
                
                print(value)
                
                
        },
            failure: { (operation: AFHTTPRequestOperation?,error: Error) in
                print("Error: " + error.localizedDescription)
        })
        
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
                    
                var firstname:String! = value.object(forKey: "firstname") as? String
                var lastname:String! = value.object(forKey: "lastname") as? String
                let mobile:String = value.object(forKey: "mobile") as! String
                let cc:String = value.object(forKey: "country_code") as! String
                let email:String = value.object(forKey: "email") as! String
                let profilePic = value.object(forKey: "profile_pic") as? String
                let carCategory = value.object(forKey: "category") as! String
                
                 var nick_name = value.object(forKey: "nick_name") as? String
                 let refrel_code = value.object(forKey: "refrel_code") as? String
                
                var vehicle_make:String = value.object(forKey: "vehicle_make") as! String
                var vehicle_model:String = value.object(forKey: "vehicle_model") as! String
                var vehicle_year:String = value.object(forKey: "vehicle_year") as! String
                var vehicle_mileage:String = value.object(forKey: "vehicle_mileage") as! String
                var plateno:String = value.object(forKey: "number_plate") as! String

                
                if nick_name != nil{
                    nick_name = nick_name?.replacingOccurrences(of: "Optional(", with: "")
                    nick_name = nick_name?.replacingOccurrences(of: ")", with: "")
                    nick_name = nick_name?.replacingOccurrences(of: "%20", with: " ")
                    nick_name = nick_name?.replacingOccurrences(of: "\"", with: "")
                    nick_name = nick_name?.removingPercentEncoding!
                }
                else{
                    nick_name = ""
                }
                
                if plateno != nil{
                    plateno = plateno.replacingOccurrences(of: "Optional(", with: "")
                    plateno = plateno.replacingOccurrences(of: ")", with: "")
                    plateno = plateno.replacingOccurrences(of: "%20", with: " ")
                    plateno = plateno.replacingOccurrences(of: "\"", with: "")
                    plateno = plateno.removingPercentEncoding!
                }
                else{
                    plateno = ""
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

                
                if firstname != nil{
                    firstname = firstname?.replacingOccurrences(of: "Optional(", with: "")
                    firstname = firstname?.replacingOccurrences(of: ")", with: "")
                    firstname = firstname?.replacingOccurrences(of: "%20", with: " ")
                    firstname = firstname?.replacingOccurrences(of: "\"", with: "")
                    firstname = firstname.removingPercentEncoding!
                }
                else{
                    firstname = ""
                }
                
                if lastname != nil{
                    lastname = lastname?.replacingOccurrences(of: "Optional(", with: "")
                    lastname = lastname?.replacingOccurrences(of: ")", with: "")
                    lastname = lastname?.replacingOccurrences(of: "%20", with: " ")
                    lastname = lastname?.replacingOccurrences(of: "\"", with: "")
                    lastname = lastname.removingPercentEncoding!

                }
                else{
                    lastname = ""
                }

                if carCategory == "" {
                    
                    labelCategory.text = ""
                }
                else{
                    
                    labelCategory.text = "\(carCategory)"
                }
                labelFirst.text = firstname
                labelLast.text = lastname
                labelEmail.text = email
                vehiclemakelabel.text = vehicle_make
                vehiclemodellabel.text = vehicle_model
                vehicleyearlabel.text = vehicle_year
                vehiclemileagelabel.text = vehicle_mileage
                platenolabel.text = plateno
                
                nicknamelabel.text=nick_name
                referalcodelabel.text=refrel_code
                self.appDelegate.referalcode = refrel_code
                
                var ccValue = cc
                labelPhone.text = "\(ccValue) \(mobile)"

                if profilePic == nil{
                    
                    imageViewProfile.image = UIImage(named: "UserPic.png")
                    
                }
                else if profilePic == ""{
                    
                    imageViewProfile.image = UIImage(named: "UserPic.png")
                    
                }
                else{
                    
                    imageViewProfile.sd_setImage(with: NSURL(string: profilePic!) as URL!)
                    
                }

              /*  var value = UserDefaults.standard.object(forKey: "GProfilePic") as? String
                value = value?.replacingOccurrences(of: "Optional(", with: "")
                value = value?.replacingOccurrences(of: ")", with: "")

                if value == nil || value == ""{
                    
                    if profilePic == nil{
                        
                        imageViewProfile.image = UIImage(named: "UserPic.png")
                        
                    }
                    else if profilePic == ""{
                        
                        imageViewProfile.image = UIImage(named: "UserPic.png")
                        
                    }
                    else{
                        
                        imageViewProfile.sd_setImage(with: NSURL(string: profilePic) as URL!)
                        
                    }
                    
                }
                else{
                                        
                    imageViewProfile.sd_setImage(with: NSURL(string: value!) as URL!)
                    
                }*/
                

              /*  self.appDelegate.fnametextField = firstnametextField.text
                self.appDelegate.lnametextfield = lastnametextField.text
                self.appDelegate.emailtextField = emailtextField.text
                self.appDelegate.mobilenotextField = phonenotextField.text
                self.appDelegate.countrycodetextfield = countrycodetextField.text*/
                
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
    
    

    }
    
    

extension UIImageView{
    
    func setImageFromURl(stringImageUrl url: String){
        
        if let url = NSURL(string: url) {
            if let data = NSData(contentsOf: url as URL) {
                self.image = UIImage(data: data as Data)
            }
        }
    }
}
