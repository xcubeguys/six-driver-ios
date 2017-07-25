//
//  ViewController.swift
//  Arcane Driver
//
//  Created by Apple on 16/12/16.
//  Copyright © 2016 Apple. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import GoogleSignIn
import Alamofire
import Firebase
import CoreLocation

class ViewController: UIViewController,GIDSignInDelegate,GIDSignInUIDelegate,FBSDKLoginButtonDelegate {

    @IBOutlet weak var btnSiginIn: UIButton!
    @IBOutlet weak var btnRegister: UIButton!
    @IBOutlet weak var btnGoogle: UIButton!
    @IBOutlet weak var btnFacebook: UIButton!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    
    var signIn : GIDSignIn?
    
    var signInAPIUrl = live_Driver_url
    
    typealias jsonSTD = NSArray
    
    typealias jsonSTDAny = [String : AnyObject]
    
    var locationManager = CLLocationManager()
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    var passValue : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationManager.stopUpdatingLocation()
        self.locationManager.stopUpdatingHeading()
        
        
        // Do any additional setup after loading the view, typically from a nib.
        
        UIApplication.shared.isIdleTimerDisabled = false

        navigationController!.isNavigationBarHidden = true
        
        self.spinner.isHidden = true

        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "SIGN IN", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        
        btnSiginIn.layer.borderColor = UIColor.black.cgColor
        btnSiginIn.layer.borderWidth = 1.0
//        self.navigationController?.pushViewController(ADUploadDocVC(), animated: true)

    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        
        return .lightContent
    }

    override func viewWillAppear(_ animated: Bool) {
        
        navigationController!.isNavigationBarHidden = true
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func btnSignInAction(_ sender: Any) {
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "SIGN IN", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        

        self.navigationController?.pushViewController(ADSignInVC(), animated: true)
        
    }
    
    @IBAction func btnRegisterAction(_ sender: Any) {
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "REGISTER", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        

        self.navigationController?.pushViewController(ADRegisterVC(), animated: true)
    }
    
    @IBAction func btnGoogleAction(_ sender: Any) {
        
        
        
        self.appDelegate.loginType = "Google"

        signIn = GIDSignIn.sharedInstance()
        signIn?.clientID = "920670843910-s5t9lcomi4i45snuo0sgoedd36jmpdbf.apps.googleusercontent.com"
        signIn!.shouldFetchBasicProfile=true
        signIn!.delegate=self
        signIn!.uiDelegate=self
        GIDSignIn.sharedInstance().signIn()
        GIDSignIn.sharedInstance().shouldFetchBasicProfile = true
        
        self.disabling()

        
    }
    
    func disabling(){
        
        self.btnGoogle.isEnabled = false
        self.btnFacebook.isEnabled = false
        self.btnSiginIn.isEnabled = false
        self.btnRegister.isEnabled = false

        self.spinner.isHidden = false
        self.spinner.startAnimating()

    }
    
    func enabling(){
        
        self.btnGoogle.isEnabled = true
        self.btnFacebook.isEnabled = true
        self.btnSiginIn.isEnabled = true
        self.btnRegister.isEnabled = true
        
        self.spinner.isHidden = true
        self.spinner.stopAnimating()
      

    }

    
    @IBAction func btnFBAciton(_ sender: Any) {
          self.appDelegate.loginType = "Facebook"
        FBSDKAccessToken.setCurrent(nil)
        
        self.disabling()
        
        if(FBSDKAccessToken.current() != nil) {
            FBSDKAccessToken.setCurrent(nil)
            // self.returnUserData()
            
        } else {
            FBSDKAccessToken.setCurrent(nil)
            let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
            fbLoginManager.loginBehavior = FBSDKLoginBehavior.web
            
            fbLoginManager.logIn(withReadPermissions: ["public_profile", "email", "user_friends"], from: self, handler:{ (result, error) -> Void in
                //            fbLoginManager .logIn(withReadPermissions: ["public_profile", "email", "user_friends"], handler: { (result, error) -> Void in
                print(error)
                if (error != nil){
                    //self.returnUserData()
                    self.enabling()
                }
                else if (result?.isCancelled)! {
                    //handle cancellation
                    self.enabling()
                    
                }
                else
                {
                    let fbloginresult : FBSDKLoginManagerLoginResult = result!
                    if(fbloginresult.grantedPermissions.contains("email"))
                    {
                        self.returnUserData()
                    }
                }
            })
            
            
            //            fbLoginManager.logInWithReadPermissions(["email"],fromViewController: self) { (result:FBSDKLoginManagerLoginResult!, fberror) -> Void in
            //
            //                print("Facebook login failed. Error \(fberror)")
            //            }
        }
    }
    
    func storeAccessToken(_ accessToken: String!) {
        UserDefaults.standard.set(accessToken, forKey: "SavedAccessHTTPBody")
    }
    
    func loadAccessToken() -> String! {
        return UserDefaults.standard.object(forKey: "SavedAccessHTTPBody") as? String
    }
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        //print("User Logged In")
        if ((error) != nil)
        {
            
        }
        else if result.isCancelled {
            // Handle cancellations
            self.enabling()
        }
        else {
            // If you ask for multiple permissions at once, you
            // should check if specific permissions missing
            if result.grantedPermissions.contains("email")
            {
                // Do work
                
            }
        }
    }
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        
    }
    
    
    
    func returnUserData(){
        print("login successfull")
        
        var outstatus:NSString = ""
        
        var object = [[String:Any]]()
        
        let requestParameters1 = ["fields": "id, email, first_name, last_name, gender,name"]
        let graphRequest1 : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: requestParameters1)
        graphRequest1.start(completionHandler: { (connection, user, error) -> Void in
            
            let response = user as AnyObject?
            
            let userEmail:String? = response?.object(forKey: "email") as? String
            let firstname:String? = response?.object(forKey: "first_name") as? String
            let lastname:String? = response?.object(forKey: "last_name") as? String
            let facebookid:String? = response?.object(forKey: "id") as? String
            let userName:String? = response?.object(forKey: "name") as? String
            
            //print(userEmail!)
            print(firstname!)
            print(lastname!)
            print(facebookid!)
            print(userName!)
            
            self.appDelegate.fbEmail = userEmail
            self.appDelegate.fbFirstName = firstname
            self.appDelegate.fbLastName = lastname
            self.appDelegate.fbID = facebookid
            self.appDelegate.userName = userName
            
            self.loginWithFB()
            
        })

    }
    
    func loginWithFB(){
        
        print("Login With facebook")


        /* var urlstring:String = "\(signInAPIUrl)fbSignup/regid/5764/first_name/\(self.appDelegate.fbFirstName!)/last_name/\(self.appDelegate.fbLastName!)/mobile/null/country_code/+91/city/madurai/email/\(self.appDelegate.fbEmail!)/fb_id/\(self.appDelegate.fbID!)"
        
        urlstring = urlstring.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!
        print(urlstring)
        
        self.callSiginAPI(url: "\(urlstring)")
        */
        
 
        
        self.checkNewFBExist()
        
    }
    
    func checkNewFBExist(){
        
        var urlstring:String = "\(signInAPIUrl)FBExist/fb_id/\(self.appDelegate.fbID!)"
        
        urlstring = urlstring.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!
        print(urlstring)
        
        self.callNewFBExistApi(url: "\(urlstring)")
        
    }
    
    func callNewFBExistApi(url : String){
        
        Alamofire.request(url).responseJSON { (response) in
            
            self.callNewFBExistParseData(JSONData: response.data!)
            
            print(response)
            
        }
        
    }
    
    func callNewFBExistParseData(JSONData : Data){
        
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
                            
                            let appendingPath1 = ref1.child(byAppendingPath: "drivers_data")
                            
                            
                            appendingPath.child(byAppendingPath: userId).setValue(newUser)
                            
                            appendingPath.child(byAppendingPath: userId).child(byAppendingPath: "request").setValue(requestArray)
                            
                            appendingPath1.child(byAppendingPath: userId).child(byAppendingPath: "accept").setValue(acceptArray)
                            
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
                        
                        appendingPath.child(byAppendingPath: userId).child(byAppendingPath: "request").setValue(requestArray)
                        
                        appendingPath1.child(byAppendingPath: userId).child(byAppendingPath: "accept").setValue(acceptArray)
                        
                    }
                    
                    print("email is \(email)")
                    print(carCategory)
                    self.appDelegate.loggedEmail = email
                    self.appDelegate.fname = first_name
                    self.appDelegate.lname = last_name
                    
                    UserDefaults.standard.setValue(userid, forKey: "userid")

                    UserDefaults.standard.setValue(carCategory, forKey: "carCategoryRegister")
                    self.navigationController?.pushViewController(ADHomePageVC(), animated: true)
                    
                    self.spinner.isHidden = true
                    self.spinner.stopAnimating()
                    
                    
                    print("\(UserDefaults.standard.value(forKey: "userid")!)")
                    
                }
                else{
                    
                    let documentVC = ADUploadDocVC()
                    self.passValue = "newFbUser"
                    documentVC.passValue = passValue
                    self.navigationController?.pushViewController(documentVC, animated: true)
                }
                
            }
            else{
                
                
            }
        }
        catch{
            
            print(error)
            
        }
        
    }

    func checkNewGBExist(){
        
        
        var urlstring:String = "\(signInAPIUrl)GBExist/google_id/\(self.appDelegate.GPID!)"
        
        urlstring = urlstring.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!
        print(urlstring)
        
        self.callNewGBExistApi(url: "\(urlstring)")
        
    }
    
    func callNewGBExistApi(url : String){
        
        Alamofire.request(url).responseJSON { (response) in
            
            self.callNewGBExistParseData(JSONData: response.data!)
            
            print(response)
            
        }
        
    }

    func callNewGBExistParseData(JSONData : Data){
        
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
                    //     let mobile:String = value.object(forKey: "mobile") as! String
                    let carCategory:String = value.object(forKey: "category") as! String

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
                            
                            let appendingPath1 = ref1.child(byAppendingPath: "drivers_data")
                            
                            
                            appendingPath.child(byAppendingPath: userId).setValue(newUser)
                            
                            appendingPath.child(byAppendingPath: userId).child(byAppendingPath: "request").setValue(requestArray)
                            
                            appendingPath1.child(byAppendingPath: userId).child(byAppendingPath: "accept").setValue(acceptArray)
                            
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
                        
                        appendingPath.child(byAppendingPath: userId).child(byAppendingPath: "request").setValue(requestArray)
                        
                        appendingPath1.child(byAppendingPath: userId).child(byAppendingPath: "accept").setValue(acceptArray)
                        
                    }
                    
                    print("email is \(email)")
                    print(carCategory)
                    self.appDelegate.loggedEmail = email
                    self.appDelegate.fname = first_name
                    self.appDelegate.lname = last_name
                    
                    UserDefaults.standard.setValue(userid, forKey: "userid")

                    UserDefaults.standard.setValue(carCategory, forKey: "carCategoryRegister")
                    self.navigationController?.pushViewController(ADHomePageVC(), animated: true)
                    
                    self.spinner.isHidden = true
                    self.spinner.stopAnimating()
                    
                    UserDefaults.standard.setValue(userid, forKey: "userid")
                    
                    print("\(UserDefaults.standard.value(forKey: "userid")!)")
                    
                }
                else{
                    
                    let documentVC = ADUploadDocVC()
                    self.passValue = "newGbUser"
                    documentVC.passValue = passValue
                    self.navigationController?.pushViewController(documentVC, animated: true)
                }
                
            }
            else{
                
                
            }
        }
        catch{
            
            print(error)
            
        }
        
    }

    func loginWithGoogle(){
        
       /* print("Login with google")
        var urlstring:String = "http://demo.cogzidel.com/arcane_lite/driver/googleSignup/regid/5765/first_name/\(self.appDelegate.GPFirstName!)/last_name/\(self.appDelegate.GPLastName!)/mobile/null/country_code/null/password/null/city/null/email/\(self.appDelegate.GPEmail!)/license/yy.png/insurance/zz.png/google_id/\(self.appDelegate.GPID!)/"
        
        urlstring = urlstring.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!
        print(urlstring)
        
        self.callSiginAPI(url: "\(urlstring)")*/

        self.disabling()
        
        self.checkNewGBExist()
    }
    
    func callSiginAPI(url : String){
        
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
                    

                    var status_extra = ""
                    var userid:String = ""
                    let email:String = value.object(forKey: "email") as! String
                    let first_name:String = value.object(forKey: "first_name") as! String
                    let last_name:String = value.object(forKey: "last_name") as! String
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
                            
                            let appendingPath1 = ref1.child(byAppendingPath: "drivers_data")
                            
                            
                            appendingPath.child(byAppendingPath: userId).setValue(newUser)
                            
                            appendingPath.child(byAppendingPath: userId).child(byAppendingPath: "request").setValue(requestArray)
                            
                            appendingPath1.child(byAppendingPath: userId).child(byAppendingPath: "accept").setValue(acceptArray)

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
                        
                        appendingPath.child(byAppendingPath: userId).child(byAppendingPath: "request").setValue(requestArray)
                        
                        appendingPath1.child(byAppendingPath: userId).child(byAppendingPath: "accept").setValue(acceptArray)

                    }
                    
                    print("email is \(email)")
                    self.appDelegate.loggedEmail = email
                    self.appDelegate.fname = first_name
                    self.appDelegate.lname = last_name
                    
                    self.navigationController?.pushViewController(ADHomePageVC(), animated: true)
                    
                    self.spinner.isHidden = true
                    self.spinner.stopAnimating()

                    UserDefaults.standard.setValue(userid, forKey: "userid")
                    
                    print("\(UserDefaults.standard.value(forKey: "userid")!)")

                    

                }
                    
                else{
                    
                }
            }
        }
        catch{
            
            print(error)
            
        }
        
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,withError error: Error!) {
        if (error == nil) {
            // Perform any operations on signed in user here.
            let gpid = user.userID                  // For client-side use only!
            print("userid \(gpid)")
            // let idToken = user.authentication.idToken // Safe to send to the server
            let GPName = user.profile.name
            let GPfname = user.profile.givenName
            let GPlname = user.profile.familyName
            let GPemail = user.profile.email
            if user.profile.hasImage{
                
                let GPProfilePic = user.profile.imageURL(withDimension: 200)
                
                let value = String(describing: GIDSignIn.sharedInstance().currentUser.profile.imageURL(withDimension: 100))
                
                print("tested ok \(value)")
                
                UserDefaults.standard.setValue(value, forKey: "GProfilePic")
                
                print(GPProfilePic)
                var status_img = "\(GPProfilePic!)"
                status_img = status_img.replacingOccurrences(of: "/", with: "-__-")
                self.appDelegate.GProfileimg = status_img
                self.appDelegate.signUpUserProfile = status_img as String!

            }
            else{
                self.appDelegate.GProfileimg = " "
                self.appDelegate.signUpUserProfile = " "
            }
            
            self.appDelegate.GPEmail = GPemail
            self.appDelegate.GPFirstName = GPfname
            self.appDelegate.GPLastName = GPlname
            self.appDelegate.GPID = gpid
            
            print(self.appDelegate.GPEmail)
            print(self.appDelegate.GPFirstName)
            print(self.appDelegate.GPLastName)
            print(self.appDelegate.GPEmail)
            print(self.appDelegate.GPID)
            
            self.loginWithGoogle()
        }
        
    }
    
    func presentSignInViewController(_ viewController: UIViewController) {
        //googleoutlet.enabled=true
        self.present(viewController, animated: true, completion: nil)
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user:GIDGoogleUser!,
              withError error: Error!) {
        //googleoutlet.enabled=true
        // Perform any operations when the user disconnects from app here.
        // ...
        self.enabling()
    }
    
    func sign(inWillDispatch signIn: GIDSignIn!, error: Error!) {
        //googleoutlet.enabled=true
        //  myActivityIndicator.stopAnimating()
        self.enabling()
    }
    
    // Present a view that prompts the user to sign in with Google
    func sign(_ signIn: GIDSignIn!,
              present viewController: UIViewController!) {
        // googleoutlet.enabled=true
        self.present(viewController, animated: true, completion: nil)
    }
    
    // Dismiss the "Sign in with Google" view
    func sign(_ signIn: GIDSignIn!,
              dismiss viewController: UIViewController!) {
        
        //        googleoutlet.isEnabled=true
        //        self.spinner.isHidden=false
        //        //self.spinnervi.hidden = false
        //        self.spinner.startAnimating()
        //        self.disablebutton()
        
        print("call dismiss \(NSStringFromClass(viewController.classForCoder))")
        
        if NSStringFromClass(viewController.classForCoder) == "SFSafariViewController" {
            self.dismiss(animated: true, completion: nil)
        }
        self.enabling()
    }

    

}

