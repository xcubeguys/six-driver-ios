//
//  ARCompleteTripVC.swift
//  Arcane Rider
//
//  Created by Apple on 24/12/16.
//  Copyright © 2016 Apple. All rights reserved.
//

import UIKit
import Firebase
import GeoFire


class ARCompleteTripVC: UIViewController {

    @IBOutlet weak var buttonBackReceipt: UIButton!
    
    @IBOutlet weak var labelRiderName: UILabel!
    @IBOutlet weak var labelAmount: UILabel!
    @IBOutlet weak var distanceLabelKM: UILabel!

    @IBOutlet weak var imageViewDriverProfile: UIImageView!

    @IBOutlet weak var ratingView: HCSStarRatingView!

    @IBOutlet weak var ratingViewRider: HCSStarRatingView!

    @IBOutlet weak var labelSuccess: UILabel!

    @IBOutlet weak var labelCurrentTime: UILabel!
    @IBOutlet weak var companynamelbl: UILabel!
    @IBOutlet weak var companyfeelbl: UILabel!
    
    var riderpictid:NSString = ""

    @IBOutlet weak var smileimg: UIImageView!
    @IBOutlet weak var smile5swidth: NSLayoutConstraint!
    @IBOutlet weak var smile5sheight: NSLayoutConstraint!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    internal var passSampleFinalArray : NSMutableArray!
    
    internal var passNonDuplicateFinalArray : NSMutableArray!
    let screenSize = UIScreen.main.bounds
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
            var urlstring:String = "\(live_request_url)requests/getDriverTrips/trip_id/\(self.appDelegate.trip_id!)"
            
            print(urlstring)
            let manager : AFHTTPRequestOperationManager = AFHTTPRequestOperationManager()
            manager.responseSerializer.acceptableContentTypes =  NSSet(objects: "text/plain", "text/html", "application/json", "audio/wav", "application/octest-stream") as Set<NSObject>
            manager.get("\(urlstring)",
                parameters: nil,
                success: { (operation: AFHTTPRequestOperation?,responseObject: Any?) in
                    let jsonObjects:NSArray = responseObject as! NSArray
                    for dataDict : Any in jsonObjects
                    {
                        if((dataDict as AnyObject).object(forKey: "pickup") != nil){
                            
                            let iscompany = (dataDict as AnyObject).object(forKey: "company_name") as? String
                            
                            var companyfee = (dataDict as AnyObject).object(forKey: "company_fee") as? String
                            let convertedcompanyfee = Int(companyfee!)
                            
                            if iscompany == nil || iscompany == ""{
                                self.companynamelbl.isHidden = true
                                self.companyfeelbl.isHidden = true
                            }
                            else if iscompany == "None"{
                                self.companynamelbl.isHidden = true
                                self.companyfeelbl.isHidden = true
                            }
                            else{
                                self.companynamelbl.text = "Company Name : \(iscompany!)"
                                self.companyfeelbl.text = "Company Fee: \(convertedcompanyfee!)%"
                            }
                            
                        }
                    }
            },
                failure: { (operation: AFHTTPRequestOperation?,error: Error) in
                    print("Error: " + error.localizedDescription)
            })
        
        let screenHeight = screenSize.height
        //smileimg.loadGif(name: "emoji_24")
        if screenHeight == 568{
            smile5swidth.constant = 50
            smile5sheight.constant = 50
        }
        
        print("CT sampleAray \(self.passSampleFinalArray)")
        
        print("CT nonDupliAray \(self.passNonDuplicateFinalArray)")

        self.toGetRiderpic()
        
        labelSuccess.isHidden = true
        
        ratingView.maximumValue = 5
        ratingView.minimumValue = 0
       // ratingView.tintColor = UIColor.black
        ratingView.allowsHalfStars = true
        
        ratingViewRider.maximumValue = 5
        ratingViewRider.minimumValue = 0
       // ratingViewRider.tintColor = UIColor.black
        ratingViewRider.allowsHalfStars = true
        
        navigationController?.isNavigationBarHidden = true
        
        imageViewDriverProfile.layer.cornerRadius = imageViewDriverProfile.frame.size.width / 2
        imageViewDriverProfile.clipsToBounds = true
        
        
        self.updateDistance()

               /* self.buttonBackReceipt.backgroundColor = UIColor.white
        self.buttonBackReceipt.layer.borderWidth = 2.0
        self.buttonBackReceipt.layer.borderColor = UIColor.clear.cgColor
        self.buttonBackReceipt.layer.shadowColor = UIColor.lightGray.cgColor
        self.buttonBackReceipt.layer.shadowOpacity = 1.0
        self.buttonBackReceipt.layer.shadowRadius = 5.0
        self.buttonBackReceipt.layer.shadowOffset = CGSize(width: 0, height: 3)*/

    }
    
    func updateDistance(){
        
        
        
            //            var total  = String(format: "%.2f", (self.appDelegate.distance))
            //            total = total.replacingOccurrences(of: "Optional(", with: "")
            //            total = total.replacingOccurrences(of: ")", with: "")
            //            total = total.replacingOccurrences(of: "\"", with: "")
            
            let total = self.appDelegate.distance
            
           // var trimTotal = String(format: "%.2f", total!)
            var trimTotal = String(format: "%.0f", total!)
            trimTotal = trimTotal.replacingOccurrences(of: "Optional(", with: "")
            trimTotal = trimTotal.replacingOccurrences(of: ")", with: "")
            trimTotal = trimTotal.replacingOccurrences(of: "\"", with: "")
            

          //  let amount = (self.appDelegate.distance) * 4 // old hided
        
            let amount = self.appDelegate.distance

            let myDistance = Int(total!)

            var priceSome = ""
            let price = UserDefaults.standard.integer(forKey: "completeTripPassPrice")
        
            if price == nil{
            
                priceSome = "0"
            }
            else{
            
                priceSome = String(price)

            }
    
          /*  var distance = UserDefaults.standard.integer(forKey: "completeTripPassDistance")
            var finalDistance = ""
            if distance == nil {
                
                finalDistance = "0"
            }
            else{
                
                finalDistance = distance
            }*/
    
        
            var trimAmount = String(format: "%.2f", amount!)
            trimAmount = trimAmount.replacingOccurrences(of: "Optional(", with: "")
            trimAmount = trimAmount.replacingOccurrences(of: ")", with: "")
            trimAmount = trimAmount.replacingOccurrences(of: "\"", with: "")
            
        
        
            var completePrice = UserDefaults.standard.object(forKey: "completePrice") as? String
            var pricePass = ""
            if completePrice == nil || completePrice == ""{
                
                pricePass = ""
            }
            else{
                
                pricePass = completePrice!
            }
        
            let completeDistance = UserDefaults.standard.object(forKey: "completeDistance") as? String

            var distancePass = ""
        
            if completeDistance == nil || completeDistance == ""{
            
                distancePass = ""
            }
            else{
            
                distancePass = completeDistance!
                
            }
        
            self.distanceLabelKM.text = "Total Distance : \(distancePass) KM"
            var total_tripamount = Double(pricePass)! + Double(self.appDelegate.final_tollfee)!
           // print("self.appDelegate.final_tollfee\(self.appDelegate.final_tollfee)")
           let myFloat = total_tripamount
        print("myFloat\("%.2f",myFloat)")
       var value = String(format:"%.2f", myFloat)
        print("\(value)")
            self.labelAmount.text = "$\(value)"
        }

    override func viewWillAppear(_ animated: Bool) {
        
        UIApplication.shared.isIdleTimerDisabled = false

        self.updateRiderRatings()
        
        self.callCurrentTime()
        
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
    @IBAction func btnMoveMapPageVC(_ sender: Any) {
        
        UserDefaults.standard.removeObject(forKey: "rider_id")
        
        UserDefaults.standard.setValue("" , forKey:"DistanceKM")
        self.appDelegate.distance = 0.0
        appDelegate.callMapVC()
        
    }

    @IBAction func ratingChangeActionDriver(_ sender: HCSStarRatingView) {
        
        print(String(format: "Changed driver rating", sender.value))
        
        self.appDelegate.driverToRider = String(describing: sender.value)
        
        print("DriverRatToRider \(self.appDelegate.driverToRider)")
        
        print("DriverRatToRider !! \(self.appDelegate.driverToRider!)")
        
        let value = self.appDelegate.driverToRider!
        
        if value == nil{
            
            self.appDelegate.driverToRider = "0"
           // self.labelSuccess.isHidden = true
        }
        else{
            
            self.appDelegate.driverToRider = value
          //  self.labelSuccess.isHidden = false
          //  self.labelSuccess.text = "You have submitted your rating successfully"
        }
        
        self.sendDriverRatingsToRider()
        
    }
    func sendDriverRatingsToRider(){
        
        let rate:Double = Double(self.appDelegate.driverToRider)!
        print(rate)
        if(rate > 0.0 && rate < 1.1){
            smileimg.loadGif(name: "emoji_rate1")
        }
        if(rate > 1.0 && rate < 2.1){
            smileimg.loadGif(name: "emoji_rate2")
        }
        if(rate > 2.0 && rate < 3.1){
            smileimg.loadGif(name: "emoji_rate3")
        }
        if(rate > 3.0 && rate < 4.1){
            smileimg.loadGif(name: "emoji_rate4")
        }
        if(rate > 4.0 && rate <= 5.1){
            smileimg.loadGif(name: "emoji_rate5")
        }

        
        if(self.appDelegate.trip_id != ""){
            
            let ref = FIRDatabase.database().reference().child("trips_data").child("\(self.appDelegate.trip_id!)")
            
            let tripId = self.appDelegate.trip_id!
            
            if(tripId != ""){
                
                
                ref.updateChildValues(["driver_rating" : "\(self.appDelegate.driverToRider!)"])
                
            }
            else{
                
                print(" raj no trip id")
            }

        }

        
        
    }

    func updateRiderRatings(){
        
        let ref = FIRDatabase.database().reference()
        
        let tripId = self.appDelegate.trip_id!
        
        if(tripId != ""){
            
            ref.child("trips_data").child("\(tripId)").observe(.value, with: { (snapshot) in
                
                print("updating distance \(snapshot.value)")
                let status1 = snapshot.value as Any
                
                print("distance is \(status1)")
                if status1 != nil {
                    
                    print(status1)
                    
                    if (status1 as? NSDictionary) != nil{
                        
                        let dict:NSDictionary = (status1 as? NSDictionary)!
                        
                        print(dict)
                        
                        let driverRated = dict["rider_rating"]
                        
                        print(driverRated)
                    
                        let value = UserDefaults.standard.set(driverRated, forKey: "rider_Rating_value")
                        
                        let some = UserDefaults.standard.double(forKey: "rider_Rating_value")
                        
                        self.ratingViewRider.value = CGFloat(some)
                        
                    }
                    else
                    {
                        
                    }
                    
                }
                else{
                    
                    
                }
            })
        }
        else{
            
            
        }
        
    }
    
    func toGetRiderpic(){
    
    let ref = FIRDatabase.database().reference()
    
    let tripId = self.appDelegate.trip_id!
    
    if(tripId != ""){
    
    ref.child("trips_data").child("\(tripId)").child("riderid").observe(.value, with: { (snapshot) in
        
        print("updating")
        if (snapshot.exists()) {
        let status1 = snapshot.value as! String
        print("trip id is here\(status1)")
        var riderpicid = "\(status1)"
        riderpicid = riderpicid.replacingOccurrences(of: "Optional(", with: "")
        riderpicid = riderpicid.replacingOccurrences(of: ")", with: "")
        print(riderpicid)
        self.riderpictid = riderpicid as NSString
        print(self.riderpictid)
        
        self.getRiderDetails()
    
        }
    })
    }
    else{
    
    
    }
    
    }
    
    func getRiderDetails(){
        
        // calling driver profile url
        // self.appDelegate.rider_id
       
        
        var urlstring:String = "\(live_rider_url)editProfile/user_id/\(self.riderpictid)"
        
        // set Permenant Value for rider and driver for trip.
        
        
        urlstring = urlstring.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!
        print(urlstring)
        
        let manager : AFHTTPRequestOperationManager = AFHTTPRequestOperationManager()
        
        manager.responseSerializer.acceptableContentTypes =  Set<AnyHashable>(["application/json", "text/json", "text/javascript", "text/html"])
        
        manager.get( "\(urlstring)",
            parameters: nil,
            success: { (operation: AFHTTPRequestOperation?,responseObject: Any?) in
                let jsonObjects=responseObject as! NSArray
                //                var dataDict: NSDictionary?
                if let result:NSDictionary = jsonObjects[0] as? NSDictionary{
                    print(result)
                    
                    var profile_pic = result["profile_pic"] as? String
                    var firstname = result["firstname"] as? String
                    var lastname = result["lastname"] as? String
                    
                    if firstname == nil{
                        firstname = ""
                    }
                    else{
                        
                        firstname = (firstname as AnyObject).replacingOccurrences(of: "Optional(", with: "")
                        firstname = (firstname as AnyObject).replacingOccurrences(of: ")", with: "")
                        
                    }
                    
                    if lastname == nil{
                        lastname = ""
                    }
                    else{
                        
                        lastname = (lastname as AnyObject).replacingOccurrences(of: "Optional(", with: "")
                        lastname = (lastname as AnyObject).replacingOccurrences(of: ")", with: "")
                        
                        
                    }

                    var fullName:String! = "\(firstname) \(lastname)"
                    
                    fullName = (fullName as AnyObject).replacingOccurrences(of: "Optional(", with: "")
                    fullName = (fullName as AnyObject).replacingOccurrences(of: ")", with: "")
                    fullName = (fullName as AnyObject).replacingOccurrences(of: "\"", with: "")
                    fullName = (fullName as AnyObject).replacingOccurrences(of: "%20", with: " ")
                    
                    print(fullName)
                    
                    self.appDelegate.riderName1 = fullName
                    
                    self.labelRiderName.text = "\(self.appDelegate.riderName1!)"
                    
                    print(self.labelRiderName.text)
                    
                    if profile_pic == nil ||  profile_pic == ""
                    {
                        
                        
                    }
                    else
                    {
                        profile_pic = (profile_pic as AnyObject).replacingOccurrences(of: "Optional(", with: "")
                        profile_pic = (profile_pic as AnyObject).replacingOccurrences(of: ")", with: "")
                        profile_pic = (profile_pic as AnyObject).replacingOccurrences(of: "\"", with: "")
                        profile_pic = (profile_pic as AnyObject).replacingOccurrences(of: "%20", with: " ")
                        
                        let imageURL1 = profile_pic
                        
                        let url = URL(string: imageURL1!)
                        
                        print(url)
                        
                        UserDefaults.standard.setValue(profile_pic, forKey: "rpRiderImage1")
                        
                        var value = UserDefaults.standard.object(forKey: "rpRiderImage1") as? String
                        value = value?.replacingOccurrences(of: "Optional(", with: "")
                        value = value?.replacingOccurrences(of: ")", with: "")
                        
                        if value == "" || value == nil {
                            
                            self.imageViewDriverProfile.image = UIImage(named: "UserPic.png")
                            
                        }
                        else{
                            
                            self.imageViewDriverProfile.sd_setImage(with: NSURL(string: value!) as URL!)
                        }
                        
                    }
                    
                    
                }
        },
            failure: { (operation: AFHTTPRequestOperation?,error: Error) in
                print("Error: " + error.localizedDescription)
        })
        
        
    }
    func callCurrentTime()
    {
        
        let date = NSDate()
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = DateFormatter.Style.medium //Set time style
        dateFormatter.dateStyle = DateFormatter.Style.medium //Set date style
        //  dateFormatter.dateFormat = "dd/MM/yyyy" //Specify your format that you want
        let localDate = dateFormatter.string(from: date as Date)
        self.labelCurrentTime.text = "\(localDate)"
        print("date \(date)")
        print("our date \(localDate)")
    }
}
