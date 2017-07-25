//
//  ARTripsDetailsVC.swift
//  Arcane Rider
//
//  Created by Apple on 13/01/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit
import Alamofire
import Firebase
import GoogleMaps
import CoreLocation

class ARTripsDetailsVC: UIViewController,GMSMapViewDelegate,UIScrollViewDelegate {

    @IBOutlet weak var activityView: UIActivityIndicatorView!
    @IBOutlet weak var mapview: GMSMapView!
    @IBOutlet weak var scrollview: UIScrollView!

    @IBOutlet weak var fareLabel: UILabel!
    @IBOutlet weak var totalFareGreen: UILabel!
   
    @IBOutlet weak var commissionFeeLabel: UILabel!
    @IBOutlet weak var tripDateLabel: UILabel!
    @IBOutlet weak var labelDriverName: UILabel!

    @IBOutlet weak var taxpercent: UILabel!
    @IBOutlet weak var duration: UILabel!
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var labelDrop: UILabel!
    @IBOutlet weak var labelPayment: UILabel!
    @IBOutlet weak var labelAmount: UILabel!
    @IBOutlet weak var labelpick: UILabel!
    @IBOutlet weak var labelbookfee: UILabel!
    @IBOutlet weak var labeltaxpercent: UILabel!
    @IBOutlet weak var labelmultidest: UILabel!
    @IBOutlet weak var labelmultidestcount: UILabel!
    @IBOutlet weak var comapnyfarelbl: UILabel!
    @IBOutlet weak var companyfeelbl: UILabel!
    @IBOutlet weak var companynamelbl: UILabel!
    @IBOutlet weak var comapnybookfeelbl: UILabel!
    @IBOutlet weak var companytaxlbl: UILabel!
    @IBOutlet weak var comapnymultidestlbl: UILabel!
    @IBOutlet weak var companymultidestpricelbl: UILabel!
    @IBOutlet weak var companytaxpercent: UILabel!

    @IBOutlet weak var companytotfaregreen: UILabel!
    @IBOutlet weak var companydistance: UILabel!
    @IBOutlet weak var companyduration: UILabel!
    @IBOutlet weak var companytotpay: UILabel!
    @IBOutlet weak var nocompanyview: UIView!
    @IBOutlet weak var companyview: UIView!
    @IBOutlet weak var imageDriver: UIImageView!

    @IBOutlet weak var ratingViewDriver: HCSStarRatingView!

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var viewAPIUrl = "\(live_request_url)requests/getDriverTrips/trip_id/"

    typealias jsonSTD = NSArray
    
    typealias jsonSTDAny = [String : AnyObject]
    
    internal var tripId : String!
    
    let markera = GMSMarker()
    var polyline = GMSPolyline()
    var marker = GMSMarker()
    
    var googleKey = ""
    
    var myOrigin = CLLocation()
    var myDestination = CLLocation()

    
    var locationManager = CLLocationManager()
    let locationTracker = LocationTracker(threshold: 10.0)

    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        let screenSize: CGRect = UIScreen.main.bounds
        
        screenSize.origin
        
        let screenHeight = screenSize.height;
        
        if((screenSize.width == 320.00) && (screenSize.height == 480.00))
            
        {
            scrollview.contentSize.height=1050
        }
        
        if((screenSize.width == 320.00) && (screenSize.height == 568.00))
            
        {
            scrollview.contentSize.height=750
        }
        
        if((screenSize.width == 414) && (screenSize.height == 736))
        {
            scrollview.contentSize.height=800
        }
        
        if((screenSize.width == 375) && (screenSize.height == 667))
            
        {
            scrollview.contentSize.height=750
        }
        


        self.getAllCredential()
        
        mapview.isUserInteractionEnabled = false
        
        self.getdetails()
        // Do any additional setup after loading the view.
        
        //self.mapview.camera = camera
        
        navigationController!.navigationBar.barStyle = .black
        
        navigationController!.isNavigationBarHidden = false
        
        ratingViewDriver.maximumValue = 5
        ratingViewDriver.minimumValue = 0
        ratingViewDriver.allowsHalfStars = true

        imageDriver.layer.cornerRadius = imageDriver.frame.size.width / 2
        imageDriver.clipsToBounds = true
        
        
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "arrow-left.png")!, for: .normal)
        button.addTarget(self, action: #selector(ARTripsDetailsVC.profileBtn(_:)), for: .touchUpInside)
        //CGRectMake(0, 0, 53, 31)
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        //(frame: CGRectMake(3, 5, 50, 20))
        let label = UILabel(frame: CGRect(x: 10, y: 5, width: 150, height: 20))
        // label.font = UIFont(name: "Arial-BoldMT", size: 13)
        label.text = "Trips Details"
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.backgroundColor = UIColor.clear
        button.addSubview(label)
        let barButton = UIBarButtonItem(customView: button)
        self.navigationItem.leftBarButtonItem = barButton
        

        self.activityView.startAnimating()
        
        
        DispatchQueue.main.async {
            
            self.locationTracker.addLocationChangeObserver { (result) -> () in
                switch result {
                case .success(let location):
                    let coordinate = location.physical.coordinate
                    let locationString = "\(coordinate.latitude), \(coordinate.longitude)"
                    
                    
                    let camera = GMSCameraPosition.camera(withLatitude: self.myOrigin.coordinate.latitude,longitude: self.myOrigin.coordinate.longitude,zoom: 25)
                  
                    
                        //self.mapview.animate(to: GMSCameraPosition.camera(withLatitude: coordinate.latitude, longitude: coordinate.longitude, zoom: 16))
                    

                    self.markera.appearAnimation = kGMSMarkerAnimationPop
                    
                  
                    self.markera.icon = UIImage(named: "endPinRound.png")
                    
                    self.markera.map = self.mapview
                    self.markera.groundAnchor = CGPoint(x: 0.5, y: 0.5)
                    self.markera.isFlat = true
                    self.markera.appearAnimation = kGMSMarkerAnimationNone
                    
                    
                    
                case .failure:
                    print("failed")
                }
            }
        }
        
        self.mapview.delegate = self
        self.mapview.settings.rotateGestures = true
        self.mapview.padding = UIEdgeInsetsMake(64,10,0,0)

        companyview.isHidden = true
        nocompanyview.isHidden = true
        companytotfaregreen.isHidden = true
        totalFareGreen.isHidden = true
        
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
                       
                        let google_api = (dataDict as AnyObject).object(forKey: "google_api_key") as? String
                        self.googleKey = google_api!
                        
                    }
                }
        },
            failure: { (operation: AFHTTPRequestOperation?,error: Error) in
                print("Error: " + error.localizedDescription)
                
        })
    }
    
    
    func getdetails(){
       
        var urlstring:String = "\(live_request_url)requests/getDriverTrips/trip_id/\(tripId!)"
        
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
                        
                        self.activityView.stopAnimating()
                        
                     var pickup: Any = (dataDict as AnyObject).object(forKey: "pickup") as! Any!
                    
                     var drop: Any = (dataDict as AnyObject).object(forKey: "destination") as! Any!
                    
                     var pickuplat:String = ((pickup as AnyObject).object(forKey: "lat") as! String)
                     var pickuplng:String = ((pickup as AnyObject).object(forKey: "long") as! String)
                        
                     var droplat:String = ((drop as AnyObject).object(forKey: "lat") as! String)
                     var droplng:String = ((drop as AnyObject).object(forKey: "long") as! String)
                        
                     var book_fee: Any = (dataDict as AnyObject).object(forKey: "book_fee") as! Any!
                     var tax_percentage: String = (dataDict as AnyObject).object(forKey: "tax_percentage") as! String!
                        
                        let iscompany = (dataDict as AnyObject).object(forKey: "company_name") as? String
                        
                        if iscompany == nil || iscompany == ""{
                            self.nocompanyview.isHidden = false
                            self.totalFareGreen.isHidden = false
                        }
                        else if iscompany == "None"{
                            self.nocompanyview.isHidden = false
                            self.totalFareGreen.isHidden = false
                        }
                        else{
                            self.companyview.isHidden = false
                            self.companytotfaregreen.isHidden = false
                        }
                        
                     if(book_fee != nil){
                        self.labelbookfee.text = "$\(book_fee)"
                        self.comapnybookfeelbl.text = "$\(book_fee)"
                     }
                     if(tax_percentage != nil){
                         self.taxpercent.text = "Tax(\(tax_percentage)%)"
                         self.companytaxpercent.text = "Tax(\(tax_percentage)%)"
                        
                         var taxcalc = Double(Double(tax_percentage)! / 100)
                         print(taxcalc)
                         self.labeltaxpercent.text = "+ $\(taxcalc)"
                         self.companytaxlbl.text = "+ $\(taxcalc)"
                     }
                        
                     var totalpricemultidest = 0
                     
                     var DestinationWaypoints: Any = (dataDict as AnyObject).object(forKey: "DestinationWaypoints") as! Any!
                        
                        if(DestinationWaypoints != nil){
                            
                           if((DestinationWaypoints as? String) == "None"){
                             self.labelmultidest.isHidden = true
                             self.labelmultidestcount.isHidden = true
                             self.companymultidestpricelbl.isHidden = true
                             self.comapnymultidestlbl.isHidden = true
                           }
                           else{
                            var jsonObjects:NSDictionary = (DestinationWaypoints as! NSDictionary)
                            var count = 0
                            for dataDict : Any in jsonObjects
                                {
                                    count += 1
                                    print(count)
                                    self.labelmultidestcount.text = "\(count) Additional Stop"
                                    self.comapnymultidestlbl.text = "\(count) Additional Stop"
                                    totalpricemultidest = count * 5
                                    var addedmultiamt = Double(totalpricemultidest)
                                    self.labelmultidest.text = "+ $\(addedmultiamt)"
                                    self.companymultidestpricelbl.text = "+ $\(addedmultiamt)"
                                 }
                            
                            print(DestinationWaypoints)
                            
                        }
                        }
                        
                     self.myOrigin = CLLocation(latitude: Double(pickuplat)!,longitude: Double(pickuplng)!)
                     self.myDestination = CLLocation(latitude: Double(droplat)!,longitude: Double(droplng)!)
                        
                    self.gettingDirectionsAPI()
                        
                        
                        let pickUpAddress = (dataDict as AnyObject).object(forKey: "pickup_address") as? String
                        print(pickUpAddress)
                        if pickUpAddress == nil || pickUpAddress == ""{
                            
                            self.labelpick.text = "Pickup Location"
                            self.labelpick.textColor = UIColor.lightGray
                        }
                        else{
                            
                            self.labelpick.text = pickUpAddress!
                            self.labelpick.textColor = UIColor.black
                        }
                        
                        let dropAddress = (dataDict as AnyObject).object(forKey: "drop_address") as? String
                        
                        if dropAddress == nil || dropAddress == ""{
                            
                            self.labelDrop.text = "Drop Location"
                            self.labelDrop.textColor = UIColor.lightGray
                        }
                        else{
                            
                            self.labelDrop.text = dropAddress!
                            self.labelDrop.textColor = UIColor.black
                            
                        }
                        //self.ratingViewDriver.value = CGFloat(some)
                        let ref = FIRDatabase.database().reference()
                        print(self.tripId)
                        ref.child("trips_data").child("\(self.tripId!)").child("rider_rating").observeSingleEvent(of: .value, with: { (snapshot) in
                            if(snapshot.exists()){
                                print("updating distance \(snapshot.value!)")
                                let dict = (snapshot.value! as! NSString).doubleValue
                                self.ratingViewDriver.value = CGFloat(dict)
                            }
                            //print(dict)
                        })
                        
                        var fareprice = 0.0
                        let price = (dataDict as AnyObject).object(forKey: "total_price") as? Double
                        
                        if price == nil{
                            
                            self.labelPayment.text = "$"
                        }
                        else{
                            var addedamount = Double(price!) - (Double(Double(tax_percentage)! / 100)) - Double(totalpricemultidest)
                            self.labelPayment.text = "$\(addedamount)"
                            self.comapnyfarelbl.text = "$\(addedamount)"
                            fareprice = price!
                            //self.totalFareGreen.text = "$ \(price!)"
                            
                        }
                        
                        var admin_commission = (dataDict as AnyObject).object(forKey: "admin_commission") as? String
                        
                        let convertedadmincommission = Double(admin_commission!)
                        
                        if convertedadmincommission == nil{
                            
                            self.fareLabel.text = "- $0"
                        }
                        else{
                            
                            self.fareLabel.text = "- $\(convertedadmincommission!)"
                            let totalprice = fareprice - convertedadmincommission!
                            self.totalFareGreen.text = "$\(totalprice)"
                            self.commissionFeeLabel.text = "$\(totalprice)"
                        }
                        
                        var companyfee = (dataDict as AnyObject).object(forKey: "company_fee") as? String
                        
                        let convertedcompanyfee = Double(companyfee!)
                        
                        if convertedcompanyfee == nil{
                            
                            self.companyfeelbl.text = "- 0%"
                        }
                        else{
                            
                            self.companyfeelbl.text = "-\(Int(convertedcompanyfee!))%"
                            let totalprice = fareprice - (convertedcompanyfee! / 100)
                            self.companytotfaregreen.text = "$\(totalprice)"
                            self.companytotpay.text = "$\(totalprice)"
                        }
                        
                        var createddate = NSDate()
                        let tripdate = (dataDict as AnyObject).object(forKey: "created") as? Double
                        if tripdate == nil{
                            self.tripDateLabel.text = ""
                            
                        }
                        else{
                            
                           print("dateformatter in tripdetails:\(String(describing: tripdate))")
                            let date = NSDate(timeIntervalSince1970: tripdate!)
                            let dateFormatter = DateFormatter()
                            dateFormatter.timeStyle = DateFormatter.Style.medium //Set time style
                            dateFormatter.dateStyle = DateFormatter.Style.medium //Set date style
                            dateFormatter.dateFormat = "dd/MM/yyyy  hh:mm a"
                            let localDate = dateFormatter.string(from: date as Date)
                            print("date \(date)")
                            print("our date \(localDate)")
                            
                            createddate = date
                            
                            self.tripDateLabel.text = "\(localDate)"
                            
                           
                        }
                        
                        let tripupdateddate = (dataDict as AnyObject).object(forKey: "update_created") as? Double
                        if tripupdateddate == nil{
                            
                        }
                        else{
                            
                            
                            let date = NSDate(timeIntervalSince1970: tripupdateddate!)
                            let dateFormatter = DateFormatter()
                            dateFormatter.timeStyle = DateFormatter.Style.medium //Set time style
                            dateFormatter.dateStyle = DateFormatter.Style.medium //Set date style
                            dateFormatter.dateFormat = "dd/MM/yyyy  hh:mm a"
                            let localDate = dateFormatter.string(from: date as Date)
                            print("date \(date)")
                            print("our date \(localDate)")
                            
                            let duration = date.timeIntervalSince(createddate as Date)
                            print("duration:\(duration)")
                            
                             let duration1=self.Duration(Int(duration))
                            print("duration1\(duration1)")
                            
                            
                        }
                        
                        
                        let totdist = (dataDict as AnyObject).object(forKey: "total_distance") as? String
                        
                        if totdist == nil || totdist == ""{
                            
                            self.distance.text = "0 mi"
                            self.companydistance.text = "0 mi"
                        }
                        else{
                            
                            self.distance.text = "\(totdist!) mi"
                            self.companydistance.text = "\(totdist!) mi"
                        }
                        
                        let riderName = (dataDict as AnyObject).object(forKey: "rider_name") as? String
                        
                        if riderName == nil{
                            
                            self.labelDriverName.text = ""
                        }
                        else{
                            
                            self.labelDriverName.text = "\(riderName!)"
                            
                        }
                        
                        let companyname = (dataDict as AnyObject).object(forKey: "company_name") as? String
                        
                        if companyname == nil{
                            
                            self.companynamelbl.text = ""
                        }
                        else{
                            
                            self.companynamelbl.text = "\(companyname!)"
                            
                        }
                        
                        
                        
                        // let
                        let profilePic  = (dataDict as AnyObject)
                            .object(forKey: "rider_profile") as? String
                        
                        if profilePic == nil || profilePic == ""{
                            
                            self.imageDriver.image = UIImage(named: "UserPic.png")
                            
                        }
                        else
                        {
                            
                            self.imageDriver.sd_setImage(with: NSURL(string: profilePic!) as URL!)
                            
                        }
                        
                    }
                }
                self.activityView.stopAnimating()
        },
            failure: { (operation: AFHTTPRequestOperation?,error: Error) in
                print("Error: " + error.localizedDescription)
                self.activityView.stopAnimating()
        })
    }
    
    func Duration(_ seconds: Int) {
        print(seconds)
        
//        let seconds = ti % 60
//        let minutes = (ti / 60) % 60
//        let hours = (ti / 3600)
//        return NSString(format: "%0.2d:%0.2d:%0.2d.%0.3d",hours,minutes,seconds,ms)
       
        let second = Int(seconds / 60) % 60
        if(second == 00){
            self.setStatusText(text: String(format: "%0.2d sec", Int(seconds % 60)))
        }
        else{
            self.setStatusText(text: String(format: "%0.2d hr %0.2d min", Int(seconds / 3600) % 24, Int(seconds / 60) % 60))
        }
    }
    
    func setStatusText(text: String) {
        
        self.duration.text! = text
        self.companyduration.text! = text
    }
    
    func gettingDirectionsAPI(){
        
        let originString = "\(myOrigin.coordinate.latitude),\(myOrigin.coordinate.longitude)"
        let destinationString = "\(myDestination.coordinate.latitude),\(myDestination.coordinate.longitude)"
        
        
    
        var urlstring:String = "https://maps.googleapis.com/maps/api/directions/json?&origin=\(originString)&destination=\(destinationString)&mode=driving&key=\(self.googleKey)"
        
        urlstring = urlstring.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!
        print(urlstring)
        
        let manager : AFHTTPRequestOperationManager = AFHTTPRequestOperationManager()
        
        manager.responseSerializer.acceptableContentTypes =  Set<AnyHashable>(["application/json", "text/json", "text/javascript", "text/html"])
        
        manager.get( "\(urlstring)",
            parameters: nil,
            success: { (operation: AFHTTPRequestOperation?,responseObject: Any?) in
                let jsonObjects:NSDictionary = responseObject as! NSDictionary
                
                if(jsonObjects["status"] as! String != "NOT_FOUND"){
                    
                    let routesArray:NSArray = jsonObjects["routes"] as! NSArray
                    
                    if routesArray.count > 0 {
                        CATransaction.begin()
                        CATransaction.setAnimationDuration(0.0)
                        CATransaction.setCompletionBlock {
                            
                            self.polyline.map = nil
                            
                            let routeDict:NSDictionary = routesArray[0] as! NSDictionary
                            let routeOverviewPolyline:NSDictionary = routeDict["overview_polyline"] as! NSDictionary
                            let points = (routeOverviewPolyline["points"] as! String)
                            let path: GMSPath = GMSPath(fromEncodedPath: points)!
                            self.polyline = GMSPolyline(path: path)
                            self.polyline.strokeWidth = 5.0
                            self.polyline.strokeColor = .blue
                            
                            self.polyline.geodesic = true
                            self.polyline.map = self.mapview
                            
                            self.markera.map = self.mapview
                            self.markera.appearAnimation = kGMSMarkerAnimationNone
                            
                            self.markera.icon = UIImage(named: "endPinRound.png")
                           
                            self.markera.map = self.mapview
                            self.markera.position = CLLocationCoordinate2D(latitude: self.myOrigin.coordinate.latitude, longitude: self.myOrigin.coordinate.longitude)
                            self.markera.groundAnchor = CGPoint(x: 0.5, y: 0.5)
                            self.markera.tracksViewChanges = false
                           
                          
                            self.marker.appearAnimation = kGMSMarkerAnimationNone
                            self.marker.icon = UIImage(named: "endPinSquare.png") //  to set pickup location
                            self.marker.map = self.mapview
                            self.marker.position = CLLocationCoordinate2D(latitude: self.myDestination.coordinate.latitude, longitude: self.myDestination.coordinate.longitude)
                            
                             let camera = GMSCameraPosition.camera(withLatitude: self.myOrigin.coordinate.latitude,longitude: self.myOrigin.coordinate.longitude,zoom: 16)
                            
                            self.mapview.animate(to: GMSCameraPosition.camera(withLatitude: self.myOrigin.coordinate.latitude, longitude: self.myOrigin.coordinate.longitude, zoom: 16))
                            
                            let mapView = GMSMapView.map(withFrame: .zero, camera: camera)
                            mapView.isMyLocationEnabled = true
                            mapView.delegate = self
                        }
                        
                        CATransaction.commit()
                    }
                    
                }
                else{
                    
                }
                
                
        },
            failure: { (operation: AFHTTPRequestOperation?,error: Error) in
                print("Error: " + error.localizedDescription)
        })
        
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

    func profileBtn(_ Selector: AnyObject) {
        
        self.navigationController?.popViewController(animated: true)
        
    }

    
    
    
}
