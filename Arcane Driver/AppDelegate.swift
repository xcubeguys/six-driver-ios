//
//  AppDelegate.swift
//  Arcane Driver
//
//  Created by Apple on 16/12/16.
//  Copyright © 2016 Apple. All rights reserved.
//

import UIKit
import CoreData
import GoogleSignIn
import CoreData
import GoogleMaps
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit
import UserNotifications
import CoreLocation
import FirebaseCrash
import Fabric
import Crashlytics
import Stripe

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    

    var referalcodevalue:String! = ""
    var referalcode:String! = ""
    var firstname:String! = ""
    var lastname:String! = ""
    var email:String! = ""
    var password:String! = ""
    var phonenumber:String! = ""
    var countrycode:String! = ""
    var city:String! = ""
    var nickname:String! = ""
    var final_tollfee = "0"
    var previous_tollfee = "0"
    var passengersvalue:String! = ""
    
    var signUpUserProfile:String! = ""
    var signUpUserlicense:String! = ""
    var signUpUserdocument:String! = ""

    
    var signUparcadoc:String! = ""
    var signvehiclereg:String! = ""
    var signcommercialdoc:String! = ""
    
    var userName:String! = ""
    var passWord:String! = ""

    var cancelfromrider:String! = ""
    var cancelfromdriver:String! = ""
    var encode:String! = ""
    
    // Vehicle

    var vehicmake:String! = ""
    var vehicmodel:String! = ""
    var vehicyear:String! = ""
    var vehicmileage:String! = ""
    var plateno:String! = ""
    var categorycarvalue:String! = ""
    var currlocation = CLLocation()
    
    // fb signin
    var fbEmail:String! = ""
    var fbFirstName:String! = ""
    var fbLastName:String! = ""
    var fbMobile:String! = ""
    var fbID:String! = ""
    
    // google signin
    var GPEmail:String! = ""
    var GPFirstName:String! = ""
    var GPLastName:String! = ""
    var GPMobile:String! = ""
    var GPID:String! = ""
    var GProfileimg:String! = ""
    
    //mouni
    
    var str1:String! = ""
    var city1:String! = ""
    var zip1:String! = ""
    var con1:String! = ""
    //updatelocation
    var updatelocatiostatus:NSNumber = 0
    var updatelocationname:String = ""
    
    // default
    // Static user id
    
    var userid:String! = ""
    var loggedEmail:String! = ""
    var fname:String! = ""
    var lname:String! = ""
    var ProofStatus:String! = ""
    var tochangecarandstatus:String! = ""
    
    var tocheckcarcategory:String! = ""
    
    var usertouchdtrip:String! = "0"
    var usertouchdtrip1:String! = "0"
    var usertouchdtrip2:String! = "0"
    var tostopcallingfunc:String! = "0"
    var toinsertid:String! = "0"
    var gotosettings:String! = "0"
    // Edit Profile
    
    var fnametextField:String! = ""
    var lnametextfield:String! = ""
    var emailtextField:String! = ""
    var mobilenotextField:String! = ""
    var countrycodetextfield:String! = ""

    //Earning details
    var amountdaily:String! = ""
    var amountweekly:String! = ""
    var amountmonthly:String! = ""
    var amountyearly:String! = ""
    var tripsdaily:String! = ""
    var tripsweekly:String! = ""
    var tripsmonthly:String! = ""
    var tripsyearly:String! = ""
    var admincomdaily:String! = ""
    var admincomweekly:String! = ""
    var amdincommonthly:String! = ""
    var admincomyearly:String! = ""
    var selectedearning:String! = ""
    var tothoursonline:String! = ""
    var timeatonline = NSDate()
    var testvalue:String! = "0"
    var testvaluelogout:String! = "0"
    var calculatedduration = 0
    var statusonnew = 0
    var toupdateonlogout = 0
    
    /*Driver online time*/
    var timestatus:String = ""
    var dailytimes:String = ""
    var timeinsec:Int = 0
    var finaltime:String = "0"
    var timestatuslogout:String = "0"
    var finaldec:Int = 0
    var lasttime:String = ""
    /*end*/
    //Request ID for trip
    var request_id:String! = ""
    var req_status:String! = ""
    var rider_id:String! = ""
    
    var riderName:String! = ""
    var riderName1:String! = ""
    
    var trip_id:String! = ""
    var trip_idwithname:String! = ""
    //pictripid
    var pictripid:String = ""
    // check login type
    var loginType:String! = "Register"
    
    var driverToRider : String!

    var distance:Float! = 0.0
    
    var locationUpdate: LocationUpdate!
    var locationUpdateTimer: Timer!

    var tripid:String! = ""
    
    var stripe_ApiKey = ""
    
    let locationTracker = LocationTracker(threshold: 10.0)

    var locate = CLLocation()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        
        initApp()
        
        Fabric.with([Crashlytics.self])

        FIRApp.configure()

        self.getAllCredential()
        
        self.getLocation()
        
        GMSServices.provideAPIKey("AIzaSyC1HunZ8WltlwpEYuEkyA-vVzh4DsFpa2c")
        
        
        self.abc()
        
        let value = UserDefaults.standard.object(forKey: "userid")
        
        if value != nil{
            
            //callMapVC()
        }
        else{
            
            //setRootViewController()
        }
        
        self.callLocalNotification()
        
//        UINavi.pushViewController(ADHomePageVC(), animated: true)
        
        
            
        //return true
        
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    
    func abc(){
        print("updateLocation")
        if locationUpdate != nil {
                self.locationUpdate.updateLocationToServer()

        }
    }


    
    func getAllCredential(){
        var urlstring:String = "\(live_request_url)settings/getDetails"
        urlstring = urlstring.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!
        print(urlstring)
        let manager : AFHTTPRequestOperationManager = AFHTTPRequestOperationManager()
        manager.responseSerializer.acceptableContentTypes =  NSSet(objects: "text/plain", "text/html", "application/json", "audio/wav", "application/octest-stream") as Set<NSObject>
        manager.get("\(urlstring)",
            parameters: nil,
            success: { (operation: AFHTTPRequestOperation?,responseObject: Any?) in
                let jsonObjects:NSArray = responseObject as! NSArray
                for dataDict : Any in jsonObjects
                {
                    if jsonObjects.count == 0{
                        
                    }
                    else{
                        let is_live_stripe = (dataDict as AnyObject).object(forKey: "is_live_stripe") as? String
                        
                        if is_live_stripe == nil {
                            
                        }
                        else{
                            if(is_live_stripe == "0"){
                                let Test_PublishKey = (dataDict as AnyObject).object(forKey: "Test_PublishKey") as? String
                                self.stripe_ApiKey = Test_PublishKey!
                                print(self.stripe_ApiKey)
                                Stripe.setDefaultPublishableKey(self.stripe_ApiKey)
                            }
                            else{
                                let Live_ApiKey = (dataDict as AnyObject).object(forKey: "Live_ApiKey") as? String
                                self.stripe_ApiKey = Live_ApiKey!
                                print(self.stripe_ApiKey)
                                Stripe.setDefaultPublishableKey(self.stripe_ApiKey)
                            }
                        }
                    }
                }
        },
            failure: { (operation: AFHTTPRequestOperation?,error: Error) in
                print("Error: " + error.localizedDescription)
                
        })
    }


    func getLocation(){
        
        self.locationTracker.addLocationChangeObserver { (result) -> () in
            switch result {
            case .success(let location):
                let coordinate = location.physical.coordinate
                
                self.locate = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
                
            case .failure:
                break
            }
        }
        
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.

        
        //The app is getting terminated, the driver status to be set OFFLINE to avoid ride requests
        if self.userid != ""{
            let ref1 = FIRDatabase.database().reference().child("drivers_data").child(self.userid!)
            ref1.updateChildValues(["online_status": "0"])
        }

        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Arcane_Driver")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    func callLocalNotification(){
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (success, error) in
            if let error = error {
                print("Request Authorization Failed (\(error), \(error.localizedDescription))")
            }
            else{
                
            }
        }
    }
    
    func initApp(){
        
        
        UINavigationBar.appearance().isTranslucent = false
        
        UINavigationBar.appearance().barTintColor = UIColor.black
        
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        UIBarButtonItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName:UIColor.white], for: UIControlState())
        UIBarButtonItem.appearance().tintColor = UIColor.white
        
        
    }
    
    func setRootViewController(){
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        // instantiate your desired ViewController
        let rootController = storyboard.instantiateViewController(withIdentifier: "appRootNavigationController")
        
        // Because self.window is an optional you should check it's value first and assign your rootViewController
        
        self.window!.rootViewController = rootController
        
    }
    
    func callMainVC(){
        
        let vc = ADSignInVC()
        let navigationController = UINavigationController(rootViewController: vc)
        window!.rootViewController = navigationController
        
    }
    
    func callMapVC(){
        
        let vc = ADHomePageVC()
        let navigationController = UINavigationController(rootViewController: vc)
        window!.rootViewController = navigationController
        
        UserDefaults.standard.removeObject(forKey: "oneTime")
    }
    
    func callProfileVC(){

        let vc = ADViewProfileVC()
        let navigationController = UINavigationController(rootViewController: vc)
        window!.rootViewController = navigationController
        
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        //let checkFB = FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
        let checkGoogle = GIDSignIn.sharedInstance().handle(url as URL!,sourceApplication: sourceApplication,annotation: annotation)
        //        return checkGoogle || checkFB
        return checkGoogle
    }
    
    

}

