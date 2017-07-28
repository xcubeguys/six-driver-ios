 //
//  ADHomePageVC.swift
//  Arcane Driver
//
//  Created by Apple on 17/12/16.
//  Copyright © 2016 Apple. All rights reserved.
//

import UIKit
import GoogleMaps
import Firebase
import GeoFire
import CoreLocation
import GoogleMaps
import Alamofire
import SwiftMessages
import AVFoundation
import UserNotifications
import FirebaseCrash
import PMAlertController
import MessageUI

import Speech
import AVFoundation
import Intents
import CoreAudio
import AudioToolbox

var audioPlayer: AVAudioPlayer?
var audioRecorder: AVAudioRecorder?



let maplocStyle = "[\n  {\n    \"elementType\": \"geometry\",\n    \"stylers\": [\n      {\n        \"color\": \"#f5f5f5\"\n      }\n    ]\n  },\n  {\n    \"elementType\": \"labels.icon\",\n    \"stylers\": [\n      {\n        \"visibility\": \"off\"\n      }\n    ]\n  },\n  {\n    \"elementType\": \"labels.text.fill\",\n    \"stylers\": [\n      {\n        \"color\": \"#616161\"\n      }\n    ]\n  },\n  {\n    \"elementType\": \"labels.text.stroke\",\n    \"stylers\": [\n      {\n        \"color\": \"#f5f5f5\"\n      }\n    ]\n  },\n  {\n    \"featureType\": \"administrative.land_parcel\",\n    \"elementType\": \"labels.text.fill\",\n    \"stylers\": [\n      {\n        \"color\": \"#bdbdbd\"\n      }\n    ]\n  },\n  {\n    \"featureType\": \"poi\",\n    \"elementType\": \"geometry\",\n    \"stylers\": [\n      {\n        \"color\": \"#eeeeee\"\n      }\n    ]\n  },\n  {\n    \"featureType\": \"poi\",\n    \"elementType\": \"labels.text.fill\",\n    \"stylers\": [\n      {\n        \"color\": \"#757575\"\n      }\n    ]\n  },\n  {\n    \"featureType\": \"poi.park\",\n    \"elementType\": \"geometry\",\n    \"stylers\": [\n      {\n        \"color\": \"#e5e5e5\"\n      }\n    ]\n  },\n  {\n    \"featureType\": \"poi.park\",\n    \"elementType\": \"labels.text.fill\",\n    \"stylers\": [\n      {\n        \"color\": \"#9e9e9e\"\n      }\n    ]\n  },\n  {\n    \"featureType\": \"road\",\n    \"elementType\": \"geometry\",\n    \"stylers\": [\n      {\n        \"color\": \"#ffffff\"\n      }\n    ]\n  },\n  {\n    \"featureType\": \"road.arterial\",\n    \"elementType\": \"labels.text.fill\",\n    \"stylers\": [\n      {\n        \"color\": \"#757575\"\n      }\n    ]\n  },\n  {\n    \"featureType\": \"road.highway\",\n    \"elementType\": \"geometry\",\n    \"stylers\": [\n      {\n        \"color\": \"#dadada\"\n      }\n    ]\n  },\n  {\n    \"featureType\": \"road.highway\",\n    \"elementType\": \"labels.text.fill\",\n    \"stylers\": [\n      {\n        \"color\": \"#616161\"\n      }\n    ]\n  },\n  {\n    \"featureType\": \"road.local\",\n    \"elementType\": \"labels.text.fill\",\n    \"stylers\": [\n      {\n        \"color\": \"#9e9e9e\"\n      }\n    ]\n  },\n  {\n    \"featureType\": \"transit.line\",\n    \"elementType\": \"geometry\",\n    \"stylers\": [\n      {\n        \"color\": \"#e5e5e5\"\n      }\n    ]\n  },\n  {\n    \"featureType\": \"transit.station\",\n    \"elementType\": \"geometry\",\n    \"stylers\": [\n      {\n        \"color\": \"#eeeeee\"\n      }\n    ]\n  },\n  {\n    \"featureType\": \"water\",\n    \"elementType\": \"geometry\",\n    \"stylers\": [\n      {\n        \"color\": \"#c9c9c9\"\n      }\n    ]\n  },\n  {\n    \"featureType\": \"water\",\n    \"elementType\": \"labels.text.fill\",\n    \"stylers\": [\n      {\n        \"color\": \"#9e9e9e\"\n      }\n    ]\n  }\n]"



class ADHomePageVC: UIViewController,CLLocationManagerDelegate,GMSMapViewDelegate,UNUserNotificationCenterDelegate,MFMessageComposeViewControllerDelegate,UITextFieldDelegate,AVSpeechSynthesizerDelegate, AVAudioRecorderDelegate {

    var isnotify = false
    var previous_route = ""
    var googleKey = ""
    @IBOutlet weak var viewMap: GMSMapView!
    @IBOutlet var goOnline: UIButton!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet var lockimage: UIImageView!
    @IBOutlet var bottomview: UIView!
    @IBOutlet var staroutlet: UIImageView!
    @IBOutlet var accountoutlet: UIImageView!
    @IBOutlet var homeoutlet: UIImageView!
    @IBOutlet var creditoutlet: UIImageView!
    @IBOutlet weak var tollfeeview: UIView!
    
    @IBOutlet weak var test_view: UIView!
    
    @IBOutlet weak var tripsViewButton: UIButton!
    @IBOutlet weak var accountDownView: UIView!
    @IBOutlet weak var completebtnoutlet: UIButton!
    @IBOutlet weak var startbtnoutlet: UIButton!
    @IBOutlet weak var tripsView: UIView!
//    @IBOutlet var homeBtnoutlet: UIButton!
//    @IBOutlet var earningBtnoutlet: UIButton!
//    @IBOutlet var ratingBtnoutlet: UIButton!
//    @IBOutlet var accountBtnoutlet: UIButton!
    
    @IBOutlet weak var loadview: UIView!
    @IBOutlet weak var loadspin: UIActivityIndicatorView!
    @IBOutlet var viewOffline: UIView!
    
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var autoScrollLabel: CBAutoScrollLabel?

    @IBOutlet var viewCirlceNew: UIView!
    

    var Updatedlat:NSString = ""
    var Updatedlon:NSString = ""
    var previousaddr = ""
    var updatedloc = ""
    var waypointmerge:NSString = ""
     var waypointmerge1:NSString = ""
    var multipledestinationfare:Float = 0.0
    var dropprice1:Float = 0.0
    
    var timeatonline = NSDate()
    var onlineduration = 0
    var calculatedduration = 0
    var count = 0
    var count1 = 0
    var durationfromurl = 0
    var markercount = 0
    var tripDistance:CLLocationDistance = 0
    var tripLocation:CLLocation? = nil
    var voiceturnedon = "1"

    @IBOutlet weak var cancelbtnview: UIView!
  
    // @IBOutlet weak var sidemenuView: UIView!
    @IBOutlet weak var bottomMenuView: UIView!
    @IBOutlet weak var ratingView: UIView!
    @IBOutlet weak var startTripView: UIView!
    @IBOutlet weak var completeTripView: UIView!
    @IBOutlet weak var sidemenuBtn: UIButton!
    
    
    @IBOutlet var requestView: UIView!
    @IBOutlet var acceptButton: UIButton!
    
    @IBOutlet weak var sourceView: UIImageView!

    @IBOutlet weak var viewPhone: UIView!

    @IBOutlet weak var tollfee_inner: UIView!
    @IBOutlet weak var tollheadlbl: UILabel!

    @IBOutlet var arriveNowView: UIView!

    @IBOutlet var viewMainDown: UIView!

    @IBOutlet weak var labelValidAmount: UILabel!
    @IBOutlet weak var tollfeepaybtn: UIButton!
    // inside arrivenow view
    
    @IBOutlet var viewArrivePickUp: UIView!

    @IBOutlet var arrivenow1: UIView!
    @IBOutlet var arrivenow2: UIView!
    @IBOutlet var arrivenow3: UIView!
    @IBOutlet weak var tollfeebtn: UIButton!
    
    @IBOutlet weak var rideraddressview: CBAutoScrollLabel!

    @IBOutlet var markTestView: UIView!

    @IBOutlet weak var markTestInsideView: CBAutoScrollLabel!

    @IBOutlet var viewRequestNew: UIView!

    @IBOutlet weak var etalbll: UILabel!
    @IBOutlet weak var distlbll: UILabel!
    @IBOutlet weak var dropaddrrlbl: UILabel!
    @IBOutlet weak var dropview: UIView!
    @IBOutlet weak var pickupview: UIView!
    @IBOutlet weak var pickupaddrrlbl: UILabel!
    @IBOutlet weak var pickupaddrrtv: UITextView!
    @IBOutlet weak var dropaddrrtv: UITextView!
    @IBOutlet weak var estimatedfarelbl: UILabel!
  //  @IBOutlet var labeledLargeProgressView: DALabeledCircularProgressView!

    
    // inside begin tirp view
    @IBOutlet var starttip1: UIView!
    @IBOutlet var starttip2: UIView!

    @IBOutlet weak var textFieldAmount: HoshiTextField!
    
    // inside complete tirp view
    @IBOutlet var completetrip1: UIView!
    @IBOutlet var completetrip2: UIView!

    var acceptBtnTapped = 1
    
    @IBOutlet var acceptingView: UIView!

    
    @IBOutlet var btnGps: UIButton!
    @IBOutlet weak var voiceTxt: UILabel!

    
    @IBOutlet var arrivenowLabel: UILabel!
    @IBOutlet var startTripLabel: UILabel!
    @IBOutlet var completeTripLabel: UILabel!
    
    @IBOutlet weak var lockImageView: UIImageView!
    @IBOutlet var buttonBackAddress: UIButton!

    @IBOutlet weak var starDownView: UIView!
    @IBOutlet weak var viewExtraMap: GMSMapView!

    @IBOutlet weak var viewBlurPH: UIView!

    @IBOutlet weak var viewContact: UIView!

    @IBOutlet weak var homeDownView: UIView!
     @IBOutlet weak var creditCardDownView: UIView!
    @IBOutlet weak var labelPickUpRider: UILabel!
    @IBOutlet weak var labelPickUpRiderCar: UILabel!

    @IBOutlet weak var imageViewPickUpRider: UIImageView!

    @IBOutlet var viewBlurCurrentTrip: UIView!

    var locationManager = CLLocationManager()
    let locationTracker = LocationTracker(threshold: 10.0)

    var locationUpdateCancel: LocationUpdate!

    var didFindMyLocation = false
    var currentLocation = CLLocation()

    var defaultLocation = CLLocation()
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var appState = UIApplication.shared.applicationState
    
    var signInAPIUrl = live_Driver_url
    typealias jsonSTD = NSArray
    
    typealias jsonSTDAny = [String : AnyObject]
    
    var firstTime = 1
    
    var getSome:Int = 0
    var getSome1:Int = 0
    var values:Int = 0
    
    var latMutArray = NSMutableArray()
    var longMutArray = NSMutableArray()
    var states:NSMutableArray = NSMutableArray()

    // for incoming request
    
    var acceptStatus = "no"
    var country = ""
    var trip_status = "nil"
    var trip_id = "nil"
    
    
    var arrayOfTripID:NSMutableArray = NSMutableArray()
    var tollfeeid:NSMutableArray = NSMutableArray()
    
    internal var arrayOfNonDuplicate:NSMutableArray = NSMutableArray()
    var arrayOfDuplicate:NSMutableArray = NSMutableArray()

    internal var arrayOfSample:NSMutableArray = NSMutableArray()

    var myArray = [[String]]()
    var myArrayNoDuplicate = [[String]]()

    var tagPass: String = ""

    var passTagRiderName: String = ""
    var passTagRiderTripId: String = ""

    var request_id:String! = ""
    var timer = Timer()
    var timer1 = Timer()
    var timer_speech = Timer()
    var stepper = UIStepper()
    var poseDuration = 20
    var indexProgressBar = 0
    var currentPoseIndex = 0
    var carcategoryname:String = ""

    // must be change for dynamic method
    var accepted = "1"
    
    var incoming = 0
    
//    var first = 0
    
    var justNowCompleted:String = "No"
    
    var progress: KDCircularProgress!
    
  //  var onlineStatus:String = "online"
    
    internal var onlineStatusNew :String!

  //  var statusOn = 0
    
    var statusOnNew : Int!

    
    @IBOutlet weak var viewCircle: KDCircularProgress!

    @IBOutlet weak var viewPhoneNumber: UIView!

    
    internal var riderShowName = ""
    
    let pulsator = Pulsator()

    var setphone = false
    
    var urlstring:String = live_Driver_url
    
    var getdirectionurlstring:String = ""

    var pulsing:String! = "start"
    
    var myOrigin = CLLocation()
    var myDestination = CLLocation()
    
    var dropDestination = CLLocation()
    var pickupLocation = CLLocation()

    var bearing:String = "default"

    
    var player : AVAudioPlayer!

    override var preferredStatusBarStyle: UIStatusBarStyle {
        
        return .lightContent
    }

    var routesArray:NSArray = []
    
    // for distance calculation
    
    var startLocation:CLLocation!
    var lastLocation: CLLocation!
    var traveledDistance:Double = 0

    var btwnLocation:CLLocation!
    
    var isPendingUpdate = "update"

    var polyline = GMSPolyline()
    var marker = GMSMarker()
    var marker1 = GMSMarker()
    var markerloc1 = GMSMarker()
    var markerloc2 = GMSMarker()
    var markerloc3 = GMSMarker()
    var markerloc4 = GMSMarker()
    
    var myloc1 = CLLocation()
    var myloc2 = CLLocation()
    var myloc3 = CLLocation()
    var myloc4 = CLLocation()
    
    var distance1:CLLocation! // to get pickup location. Use first time only
    var distance2:CLLocation! // to get updated/ currenct location
    var distance3:CLLocation! // to set dynamic update from current locaiton / end location
    

    var imageName:String! = "endPinRound.png"
    var imageName1:String! = "markerloc1"
    var imageName2:String! = "markerloc2"
    var imageName3:String! = "markerloc3"
    var imageName4:String! = "markerloc4"
  
    var total:Float = 0.0
    
    let markera = GMSMarker()


    var locationUpdate: LocationUpdate!
    var locationUpdateTimer: Timer!

    var homePassEditProfile : String!
    
    var driverClickedCancelPass = "none"
    
    var distancePass:Float! = 0.0
    var carCategoryPass = ""

    var arrayOfMaxSize:NSMutableArray=NSMutableArray()
    var arrayOfCarCategory:NSMutableArray=NSMutableArray()
    var arrayOfMinFare:NSMutableArray=NSMutableArray()
    var arrayOfPrice_MIN:NSMutableArray=NSMutableArray()
    var arrayOfPrice_KM:NSMutableArray=NSMutableArray()
    var arrayOftaxpercent:NSMutableArray=NSMutableArray()
    var arrayOfdropprice:NSMutableArray=NSMutableArray()
    
   // var labels = UILabel();
    var buttons = UIButton()
    
    @IBOutlet weak var btnvoiceonoff: UIButton!
    @IBOutlet weak var btnroute: UIButton!
    @IBOutlet weak var scrollViewArrive: UIScrollView!
    @IBOutlet weak var viewArriveInside: UIView!
    
    @IBOutlet weak var scrollViewArriveStartTrip: UIScrollView!
    @IBOutlet weak var viewArriveInsideStartTrip: UIView!
    
    @IBOutlet weak var scrollViewArriveEndTrip: UIScrollView!
    @IBOutlet weak var viewArriveInsideEndTrip: UIView!
    
    let animals1: [String] = ["bird", "cat", "cat", "fish", "bird"]
    
    
    //text to Speech
    let speechSynthesizer = AVSpeechSynthesizer();
    let audioSession = AVAudioSession.sharedInstance()
    var hablar = true;
    var sendMessage = false;
    
    var rate = Float(0.5);
    var pitch = Float(1);
    var volume = Float(1);
    var language = "";
    var mensaje = "";

    override func viewDidLoad() {
        super.viewDidLoad()
       // self.testpost()
        //self.textFieldAmount.becomeFirstResponder()
     
        self.tollfeeview.isHidden = true
//        self.loadspin.startAnimating()
//        self.loadview.isHidden = true
        self.getAllCredential()
        let first  = UserDefaults.standard.array(forKey: "arrayOfTripsData")
        let tirst1  = UserDefaults.standard.array(forKey: "arrayOfTollData")
        print("arrayofTripsData \(first)")
        print(self.trip_id)
        print(UserDefaults.standard.value(forKey: "TripID"))
        if first != nil{
            self.arrayOfNonDuplicate.addObjects(from: first!)
        }
        else{
        }
        if(tirst1 != nil){
            self.tollfeeid.addObjects(from: tirst1!)
        }
        print("final Tollfee Duplicate \(tollfeeid)")
        print("final non Duplicate \(arrayOfNonDuplicate)")
        
        let voicenavigation = UserDefaults.standard.object(forKey: "voicenavigation") as! String!
        if(voicenavigation != nil){
            voiceturnedon = voicenavigation!
            print(voiceturnedon)
            if(voiceturnedon == "1"){
                self.btnvoiceonoff.setTitle("Turn OFF voice",for: .normal)
            }
            else{
                self.btnvoiceonoff.setTitle("Turn ON voice",for: .normal)
            }
        }
        
        if arrayOfNonDuplicate.count > 0{
            
            self.viewOffline.isHidden = true
            self.btnroute.isHidden = false
            self.btnvoiceonoff.isHidden = false
            
            self.appDelegate.tostopcallingfunc = "1"
            
            self.appDelegate.toinsertid = "1"
            
            self.checkArrive()
            
            self.checkStart()
            
            self.checkEnd()
            
            self.firstKnowTripsStatus()
            
            self.appDelegate.trip_idwithname = ""
            
            let value = UserDefaults.standard.object(forKey: "userid")
            
            self.appDelegate.userid = value as! String!
            
            if(self.appDelegate.userid! != nil && self.appDelegate.userid! != ""){
                let ref2 = FIRDatabase.database().reference().child("drivers_data").child("\(self.appDelegate.userid!)").child("accept")
                ref2.updateChildValues(["status": 0])
            }
        }
        else{
            
            self.appDelegate.tostopcallingfunc = "0"
            self.arriveNowView.isHidden = true

            self.appDelegate.trip_idwithname = ""
            
            let value = UserDefaults.standard.object(forKey: "userid")
            self.appDelegate.userid = value as! String!
            
            if(self.appDelegate.userid! != nil && self.appDelegate.userid! != ""){
            let ref2 = FIRDatabase.database().reference().child("drivers_data").child("\(self.appDelegate.userid!)").child("accept")
            ref2.updateChildValues(["status": 0])
            }
            
        }
        if(self.appDelegate.tostopcallingfunc == "0"){
            self.checkOnOffFirebaseStatusWithAlert()
        }
    //    FIRCrashMessage("Analytics success...")
        
    //    fatalError()
        
        
        
        
        //5s  280 280
        //6s   
        self.tollfeebtn.layer.cornerRadius = 5
        self.btnGps.backgroundColor = UIColor.white
        self.btnGps.layer.borderWidth = 2.0
        self.btnGps.backgroundColor = UIColor.clear
        self.btnGps.layer.borderColor = UIColor.clear.cgColor
        self.btnGps.layer.shadowColor = UIColor.lightGray.cgColor
        self.btnGps.layer.shadowOpacity = 1.0
        self.btnGps.layer.shadowRadius = 5.0
        self.btnGps.layer.shadowOffset = CGSize(width: 0, height: 3)
        
        
        self.voiceTxt.layer.borderWidth = 2.0
        self.voiceTxt.layer.borderColor = UIColor.clear.cgColor
        self.voiceTxt.layer.shadowColor = UIColor.lightGray.cgColor
        self.voiceTxt.layer.shadowOpacity = 1.0
        self.voiceTxt.layer.shadowRadius = 5.0
        self.voiceTxt.layer.cornerRadius = 15
        self.voiceTxt.layer.masksToBounds = true
        self.voiceTxt.layer.shadowOffset = CGSize(width: 0, height: 3)
        self.voiceTxt.textColor = UIColor.black
        
        //self.tollheadlbl.layer.cornerRadius = 8 //your desire radius
        
        
       // self.tollheadlbl.layer.cornerRadius = 15
       /* let progressView1 = GMDCircularProgressView(frame: CGRect(origin: CGPoint.zero, size: CGSize(width:280, height:280)))
        progressView1.center = self.viewRequestNew.center
        self.viewCirlceNew.addSubview(progressView1)
        self.viewCirlceNew.addSubview(viewExtraMap)
        
        viewExtraMap.layer.cornerRadius = viewExtraMap.frame.size.width / 2
        viewExtraMap.clipsToBounds = true*/
        
        let value = UserDefaults.standard.object(forKey: "userid")
        
        self.appDelegate.userid = value as! String!
        
       /* self.labeledLargeProgressView.thicknessRatio = 0.05
        self.viewRequestNew.addSubview(self.labeledLargeProgressView)*/
        
      //  self.startAnimation()
        
        // for getting request
        self.incomingNotification()

        // for getting trip req_i
        
        
        // Do any additional setup after loading the view..

//        navigationController!.navigationBar.barStyle = .
        
        sourceView.layer.superlayer?.insertSublayer(pulsator, below: sourceView.layer)
        pulsator.backgroundColor = UIColor.black.cgColor
        
        
        completeTripView.isHidden=true
        labelValidAmount.isHidden = true
        voiceTxt.isHidden = true
        
        navigationController!.isNavigationBarHidden = true
        
        navigationController!.navigationBar.barStyle = .black
        
      //Top view
        
        goOnline.layer.cornerRadius = 15.0
        goOnline.layer.masksToBounds = false
        
        btnvoiceonoff.layer.cornerRadius = 15.0
        btnvoiceonoff.layer.masksToBounds = false
        
        locationManager.delegate = self
        textFieldAmount.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest

        locationManager.requestWhenInUseAuthorization()
        
        
        //        self.view.addSubview(homeBtnoutlet)
        //        self.view.addSubview(earningBtnoutlet)
        //        self.view.addSubview(ratingBtnoutlet)
        //        self.view.addSubview(accountBtnoutlet)
        //        self.view.addSubview(bottomview)
        //        self.view.addSubview(navigationBtn)
        //        self.view.addSubview(viewProfileOutlet)
        
        
        
        if(CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways)
        {
            if let loc = locationManager.location {
                currentLocation = loc
            }
            
        }
        
        
        self.updateLocationLabel(withText: "Unknown")
        
        
        let camera = GMSCameraPosition.camera(withLatitude: (self.appDelegate.locate.coordinate.latitude),longitude: (self.appDelegate.locate.coordinate.longitude),zoom: 16)
        let camera1 = GMSCameraPosition.camera(withLatitude: (self.appDelegate.locate.coordinate.latitude),longitude: (self.appDelegate.locate.coordinate.longitude),zoom: 16)
        do {
            // Set the map style by passing a valid JSON string.
//            viewMap.mapStyle = try GMSMapStyle(jsonString: maplocStyle)
//            viewExtraMap.mapStyle = try GMSMapStyle(jsonString: maplocStyle)
            
            
        } catch {
            NSLog("One or more of the map styles failed to load. \(error)")
        }
        
//        self.viewMap.animate(to: camera)
        self.viewMap.camera = camera
        self.viewExtraMap.camera = camera1

        DispatchQueue.main.async {
        
            self.locationTracker.addLocationChangeObserver { (result) -> () in
                switch result {
                case .success(let location):
                    let coordinate = location.physical.coordinate
                    let locationString = "\(coordinate.latitude), \(coordinate.longitude)"
                    
                    
                    let camera = GMSCameraPosition.camera(withLatitude: coordinate.latitude,longitude: coordinate.longitude,zoom: 16)
                    let camera1 = GMSCameraPosition.camera(withLatitude: coordinate.latitude,longitude: coordinate.longitude,zoom: 14)
                    
                    if(self.firstTime == 1){
                        
                        self.currentLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
                        
                        let camera = GMSCameraPosition.camera(withLatitude: (self.currentLocation.coordinate.latitude),longitude: (self.currentLocation.coordinate.longitude),zoom: 16)
                        
                        self.viewMap.animate(to: GMSCameraPosition.camera(withLatitude: coordinate.latitude, longitude: coordinate.longitude, zoom: 16))

                        do {
                            // Set the map style by passing a valid JSON string.
//                            self.viewMap.mapStyle = try GMSMapStyle(jsonString: maplocStyle)
//                            self.viewExtraMap.mapStyle = try GMSMapStyle(jsonString: maplocStyle)
                            
                        } catch {
                            NSLog("One or more of the map styles failed to load. \(error)")
                        }
                        
//                        self.viewMap.camera = camera
                        self.viewExtraMap.camera = camera1
                        
                        self.firstTime = 2
                        self.defaultLocation = self.currentLocation
                        self.updateLocation()
                    }
                    
                    let mapView = GMSMapView.map(withFrame: .zero, camera: camera)
                    mapView.isMyLocationEnabled = true
                    mapView.delegate = self
                    
//                  mapView.bringSubview(toFront: self.bottomview)
//                  let marker = GMSMarker()
                    
                    self.markera.position = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)//here you can give your current lat and long
                    self.markera.appearAnimation = kGMSMarkerAnimationPop
                    
                    if((UserDefaults.standard.object(forKey: "carCategoryRegister")) != nil){
                        let carCategory1 = UserDefaults.standard.object(forKey: "carCategoryRegister") as! String
                        if(carCategory1 == "6-Seater"){
                            self.markera.icon = UIImage(named: "map_lux.png")
                        }
                        else if(carCategory1 == "6-Seater_Luxury"){
                            self.markera.icon = UIImage(named: "map_suv.png")
                        }
                        else if(carCategory1 == "Taxi"){
                            self.markera.icon = UIImage(named: "map_taxi.png")
                        }
                        else{
                            self.markera.icon = UIImage(named: "Drivers.png")
                        }
          
                        //self.markera.icon = UIImage(named: "Drivers")
                        self.markera.map = self.viewMap
                        self.markera.groundAnchor = CGPoint(x: 0.5, y: 0.5)
                        self.markera.isFlat = true
                        self.markera.appearAnimation = kGMSMarkerAnimationNone

                        let marker1 = self.markera
                        marker1.map = self.viewExtraMap
                    
                    }

                    self.updateLocationLabel(withText: locationString)
                    
                case .failure:
                    self.updateLocationLabel(withText: "Failure")
                }
            }
            }
        
        
        
        self.viewMap.delegate = self
        self.viewExtraMap.delegate = self
        self.viewMap.addSubview(tripsView)
        self.tripsView.isHidden = false
        self.tripsViewButton.isEnabled = true
        self.tripsViewButton.isHidden = false
        self.viewMap.isMyLocationEnabled = true
        self.viewMap.settings.rotateGestures = true
        self.viewMap.settings.compassButton = false
        self.viewMap.settings.myLocationButton = false
        self.viewMap.settings.indoorPicker = true
        self.viewMap.isIndoorEnabled = true
        self.viewMap.addSubview(viewMainDown)
        self.viewMainDown.addSubview(tripsView)
        //self.viewMap.addSubview(test_view)
        self.viewMap.addSubview(viewPhone)
        
        self.view.addSubview(viewMap)
//        self.viewMap.addSubview(bottomview)
        self.viewMap.addSubview(requestView)
       // self.viewMap.addSubview(viewPhoneNumber)

     //   self.requestView.addSubview(viewPhone)
//        self.viewMap.addSubview(startTripView)
//        self.viewMap.addSubview(rideraddressview)
//        self.viewMap.addSubview(completeTripView)
//        self.viewMap.addSubview(sidemenuView)
//        self.viewMap.addSubview(sidemenuBtn)
        
        self.viewMap.addSubview(viewOffline)
        self.viewMap.addSubview(startTripView)
        self.viewMap.addSubview(arriveNowView)
        self.viewMap.addSubview(completeTripView)
        self.viewMap.addSubview(rideraddressview)
        self.viewMap.addSubview(markTestView)
        self.viewMap.addSubview(acceptingView)
        self.viewMap.addSubview(btnGps)
        self.viewMap.addSubview(voiceTxt)
        self.viewMap.addSubview(btnroute)
        self.viewMap.addSubview(btnvoiceonoff)
        self.viewMap.addSubview(viewContact)
        self.viewMap.addSubview(viewBlurCurrentTrip)
        self.viewMap.addSubview(tollfeeview)
       // self.viewMap.addSubview(loadview)
        
        //self.tollfeeview.addSubview(tollfee_inner)
        //self.tollfee_inner.addSubview(textFieldAmount)
        
        self.viewBlurCurrentTrip.backgroundColor = UIColor.black
        self.viewBlurCurrentTrip.alpha = 0.5
        
        
        self.acceptingView.isHidden = true
        self.btnroute.isHidden = true
        self.btnvoiceonoff.isHidden = true
        self.startTripView.isHidden = true
        self.completeTripView.isHidden = true
        
        ////self.rideraddressview.isHidden = true
        self.markTestView.isHidden = true   //rajkumar
    
       
        self.imageViewPickUpRider.layer.cornerRadius = imageViewPickUpRider.frame.size.width / 2
        self.imageViewPickUpRider.clipsToBounds = true
        
       /* self.buttonBackAddress.layer.borderWidth = 2.0
        self.buttonBackAddress.layer.cornerRadius = 3.0
        self.buttonBackAddress.backgroundColor = UIColor.white
        self.buttonBackAddress.layer.borderWidth = 2.0
        self.buttonBackAddress.layer.borderColor = UIColor.clear.cgColor
        self.buttonBackAddress.layer.shadowColor = UIColor.lightGray.cgColor
        self.buttonBackAddress.layer.shadowOpacity = 1.0
        self.buttonBackAddress.layer.shadowRadius = 5.0
        self.buttonBackAddress.layer.shadowOffset = CGSize(width: 0, height: 3)*/
        
    //    bottomview.frame.origin.x = 0
     //   bottomview.frame.origin.y = view.frame.size.height - bottomview.frame.size.height
        
        ////self.requestView.isHidden = true        //rajkumar
        self.viewRequestNew.isHidden = true
        self.distlbll.text = ""
        self.etalbll.text = ""
        self.dropaddrrlbl.text = ""
        self.pickupaddrrlbl.text = ""
        self.dropaddrrtv.text = ""
        self.pickupaddrrtv.text = ""
        self.estimatedfarelbl.text = ""

      //  player.stop()
        
       ////self.viewPhone.isHidden = true
     //   self.bottomview.isHidden = false
        self.progressView()

        self.cardview()
        
        
        //self.calcDistance()
        
//        NotificationCenter.default.addObserver(self, selector: #selector(ADHomePageVC.applicationDidEnterBackground(_:)), name: NSNotification.Name.UIApplicationDidEnterBackground, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(ADHomePageVC.applicationDidEnterForeground(_:)), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
        
        self.locationManager.allowsBackgroundLocationUpdates = true

        self.locationManager.startUpdatingHeading()

        self.locationUpdate = LocationUpdate()
        self.update()
    
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ADHomePageVC.hidekeyboard))
        
        tapGesture.numberOfTapsRequired = 1
        view.addGestureRecognizer(tapGesture)
        
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        if screenHeight == 568{
            self.viewOffline.frame = CGRect(x:0, y:0, width:320, height:50)
            self.goOnline.frame = CGRect(x:60, y:9, width:200, height:33)
            self.lockImageView.frame = CGRect(x:75, y:15, width:20, height:20)
            self.viewMap.frame = CGRect(x:0, y:20, width:320, height:548)
            self.viewMainDown.frame = CGRect(x:0,y:503, width:320,height:45)
            self.homeDownView.frame = CGRect(x:0, y:0, width:60, height:45)
            self.creditCardDownView.frame = CGRect(x:83, y:0, width:60, height:45)
            self.starDownView.frame = CGRect(x:250, y:0, width:60, height:45)
            self.accountDownView.frame = CGRect(x:0, y:0, width:60, height:45)
            self.tripsView.frame = CGRect(x:173,y:0,width:60,height:44)
          }
        
        if screenHeight == 736{
            
            self.viewOffline.frame = CGRect(x:0, y:0, width:414, height:50)
            self.goOnline.frame = CGRect(x:108, y:9, width:200, height:33)
            self.lockImageView.frame = CGRect(x:118, y:15, width:20, height:20)
            self.viewMap.frame = CGRect(x:0, y:20, width:screenWidth, height:screenHeight - 20)
            self.viewMainDown.frame = CGRect(x:0,y:671, width:414,height:45)
            self.homeDownView.frame = CGRect(x:0, y:0, width:83, height:45)
            self.creditCardDownView.frame = CGRect(x:112, y:0, width:83, height:45)
            self.starDownView.frame = CGRect(x:312, y:0, width:83, height:45)
            self.accountDownView.frame = CGRect(x:12, y:0, width:83, height:45)
            self.tripsView.frame =  CGRect(x:215, y:0, width:83, height:45)
                  }
        
        self.togetmultipledropprice()
    }
    
    @IBAction func voiceonoffact(_ sender: Any) {
        if(self.btnvoiceonoff.currentTitle == "Turn OFF voice"){
            self.btnvoiceonoff.setTitle("Turn ON voice",for: .normal)
            voiceturnedon = "0"
            UserDefaults.standard.setValue(voiceturnedon, forKey: "voicenavigation")
        }
        else{
            self.btnvoiceonoff.setTitle("Turn OFF voice",for: .normal)
            voiceturnedon = "1"
            UserDefaults.standard.setValue(voiceturnedon, forKey: "voicenavigation")
        }
    }
    @IBAction func tripsViewBtn(_ sender: Any) {
        
        print("Trips View Button Working")
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let subContentsVC = storyboard.instantiateViewController(withIdentifier: "yourTripsVC") as! ARMainYourTripsVC
        self.navigationController?.pushViewController(subContentsVC, animated: true)
        
        
        
    }
    func hidekeyboard()
    {
        self.view.endEditing(true)
    }
    @IBAction func btnSetNowAction(_ sender: Any) {
        
        self.navigationController?.pushViewController(ADEditProfileVC(), animated: true)

    }
    
    @IBAction func amount_focus(_ sender: Any) {
        self.textFieldAmount.becomeFirstResponder()
    }
    @IBAction func btntollclick(_ sender: Any) {
        
        self.tollfeeview.isHidden = false
        
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        if screenHeight == 568{
        tollfee_inner.frame = CGRect(x:25,y:180,width:269,height:189)
        }
        
        self.view.endEditing(true)
        self.textFieldAmount.text = ""
    }
    
    @IBAction func wazroute(_ sender: Any) {
        let latitude = myDestination.coordinate.latitude
        let longitude = myDestination.coordinate.longitude
        
        if UserDefaults.standard.value(forKey: "navoption") != nil{
            let navoption:NSNumber = UserDefaults.standard.value(forKey: "navoption") as! NSNumber
            if(navoption == 0){
                
            }else if(navoption == 2){
                let testURL = URL(string: "comgooglemaps://")!
                if UIApplication.shared.canOpenURL(testURL) {
                    
                    let directionsRequest = "comgooglemaps-x-callback://" +
                        "?daddr=\(Float(latitude)),\(Float(longitude))" +
                    "&x-success=sourceapp://?resume=true&x-source=AirApp"
                    
                    let directionsURL = URL(string: directionsRequest)!
                    UIApplication.shared.openURL(directionsURL)
                }
                else {
                    let warning = MessageView.viewFromNib(layout: .CardView)
                    warning.configureTheme(.warning)
                    warning.configureDropShadow()
                    let iconText = "" //"😶"
                    warning.configureContent(title: "", body: "Google map application is not available in your device", iconText: iconText)
                    warning.button?.isHidden = true
                    var warningConfig = SwiftMessages.defaultConfig
                    warningConfig.presentationContext = .window(windowLevel: UIWindowLevelStatusBar)
                    SwiftMessages.show(config: warningConfig, view: warning)
                }
            }else{
                if UIApplication.shared.canOpenURL(NSURL(string: "waze://")! as URL) {
                    //Waze is installed. Launch Waze and start navigation
                    let urlStr = "waze://?ll=\(latitude),\(longitude)&navigate=yes"
                    UIApplication.shared.openURL(NSURL(string: urlStr)! as URL)
                }
                else {
                    //Waze is not installed. Launch AppStore to install Waze app
                    //UIApplication.shared.openURL(NSURL(string: "http://itunes.apple.com/us/app/id323229106")! as URL)
                    let warning = MessageView.viewFromNib(layout: .CardView)
                    warning.configureTheme(.warning)
                    warning.configureDropShadow()
                    let iconText = "" //"😶"
                    warning.configureContent(title: "", body: "Waze map application is not available in your device", iconText: iconText)
                    warning.button?.isHidden = true
                    var warningConfig = SwiftMessages.defaultConfig
                    warningConfig.presentationContext = .window(windowLevel: UIWindowLevelStatusBar)
                    SwiftMessages.show(config: warningConfig, view: warning)
                }
            }
            
        }else{
            if UIApplication.shared.canOpenURL(NSURL(string: "waze://")! as URL) {
                //Waze is installed. Launch Waze and start navigation
                let urlStr = "waze://?ll=\(latitude),\(longitude)&navigate=yes"
                UIApplication.shared.openURL(NSURL(string: urlStr)! as URL)
            }
            else {
                //Waze is not installed. Launch AppStore to install Waze app
                //UIApplication.shared.openURL(NSURL(string: "http://itunes.apple.com/us/app/id323229106")! as URL)
                let warning = MessageView.viewFromNib(layout: .CardView)
                warning.configureTheme(.warning)
                warning.configureDropShadow()
                let iconText = "" //"😶"
                warning.configureContent(title: "", body: "Waze map application is not available in your device", iconText: iconText)
                warning.button?.isHidden = true
                var warningConfig = SwiftMessages.defaultConfig
                warningConfig.presentationContext = .window(windowLevel: UIWindowLevelStatusBar)
                SwiftMessages.show(config: warningConfig, view: warning)
            }

        }
        
              /*  let testURL = URL(string: "comgooglemaps://")!
       if UIApplication.shared.canOpenURL(testURL) {
            let latitude = 13.0827
            
            let longitude = 80.2707
            
            let directionsRequest = "comgooglemaps-x-callback://" +
                "?daddr=\(Float(latitude)),\(Float(longitude))" +
            "&x-success=sourceapp://?resume=true&x-source=AirApp"
            
            let directionsURL = URL(string: directionsRequest)!
            UIApplication.shared.openURL(directionsURL)
        }
        else {
            NSLog("Can't use comgooglemaps-x-callback:// on this device.")
            //let string: String = "http://maps.apple.com/?ll=\(latitude),\(longitude)"
           // UIApplication.shared.openURL(URL(string: string)!)
        }
        
        */

    }
    
    func togetmultipledropprice(){
        
        self.arrayOfdropprice.removeAllObjects()
        self.arrayOfdropprice.remove("")
        
        
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
                else{
                    
                    
                }
                for dataDict : Any in jsonObjects
                {
                    
                    if jsonObjects.count == 0{
                        
                    }
                    else{
                        
                        let drop_price = (dataDict as AnyObject).object(forKey: "drop_price") as? String
                        
                        if drop_price == nil{

                        }
                        else{
                            self.arrayOfdropprice.add(drop_price! as String)
                        }
                    }
                }
                
                //  self.multipleCar()
        },
            failure: { (operation: AFHTTPRequestOperation?,error: Error) in
                print("Error: " + error.localizedDescription)
                
        })
        
        
    }
    func tocalcdropprice(){
        let carType = UserDefaults.standard.object(forKey: "carCategoryRegister") as! String
    
        var dropprice = ""
    
        print(self.arrayOfdropprice)
        if(self.arrayOfdropprice.count == 0)
            {
                    self.arrayOfdropprice = ["5", "5", "5", "5"]
            }
        if carType == "Standard"{
    
            dropprice = self.arrayOfdropprice.firstObject as! String
    
            print(" hatch  min\(dropprice)")
    
        }
        else if carType == "6-Seater"{
    
            dropprice = "\(self.arrayOfdropprice[1])"
    
            print(" hatch  min\(dropprice)")
    
        }
        else if carType == "6-Seater_Luxury"{
            dropprice = "\(self.arrayOfdropprice[2])"
    
            print(" hatch  min\(dropprice)")
    
        }
        else{
            dropprice = self.arrayOfdropprice.lastObject as! String
    
            print(" hatch  min\(dropprice)")
    
        }
    
        self.dropprice1 = Float(dropprice)!
        print(self.dropprice1)
    }
    
    func autoUpdateforLocation(){
        print(self.waypointmerge)
        print(self.multipledestinationfare)
        self.tocalcdropprice()
        var ref1 = FIRDatabase.database().reference()
        
        ref1.child("riders_location").child(self.appDelegate.rider_id).child("Updatelocation").observe(.value, with: { (snapshot) in
            if(snapshot.exists()){
            if snapshot.value != nil{
                
                print("Snapshot value is not equal to nil")
               let d = snapshot.value!
                print(d)
                print("d.count:\((d as AnyObject).count)")
                
                if let value = snapshot.value as? NSArray {
                    if (d as AnyObject).count == 2{
                    
                        print("Values:")
                        
                        print(value)
                        
                        self.Updatedlat = value[0] as? NSString ?? ""
                        print("UpdatedLat:\(self.Updatedlat)")
                        self.Updatedlon = value[1] as? NSString ?? ""
                        print("UpdatedLon:\(self.Updatedlon)")
  if (self.Updatedlat != "") && (self.Updatedlon != "") && (self.Updatedlat != "0") && (self.Updatedlon != "0") {
     self.dropDestination = CLLocation(latitude: Double(self.Updatedlat as String)!,longitude: Double(self.Updatedlon as String)!)
    UserDefaults.standard.setValue(self.Updatedlat, forKey: "Droplat")
    UserDefaults.standard.setValue(self.Updatedlon, forKey: "Droplng")
     self.getCurrnentAddress(myLocation: self.dropDestination)
     self.updatedloc = "1"
    
    
}
    }
                    
  }
                else{
                
                print("Null value")
                
                }
                
                
            }
            else{
                
                print("Snapshot value is nil")
                
            }
            }
            
        }) { (error) in
            print(error.localizedDescription)
        }
        

        ref1.child("riders_location").child(self.appDelegate.rider_id).child("WayPointCount").observe(.value, with: { (snapshot) in
            if(snapshot.exists()){
            if snapshot.value != nil{
                print("Snapshot value is not equal to nil")
                
                print(snapshot.value)
                
                let waypointcount1 = snapshot.value!
                
                let waypointcount = Int((waypointcount1 as AnyObject) as! NSNumber)
                
                for var i in 1..<waypointcount+1 {
                    print(i)
                    var count = 0
                    FIRDatabase.database().reference().child("riders_location").child(self.appDelegate.rider_id).child("DestinationWaypoints").child("WayPoint \(i)").observeSingleEvent(of: .value, with: { (snapshot) in
                        if(snapshot.exists()){
                        print(snapshot.value)
                        
                        if snapshot.value != nil{
                            FIRDatabase.database().reference().child("riders_location").child(self.appDelegate.rider_id).child("DestinationWaypoints").child("WayPoint \(i)").child("Coordinates").observeSingleEvent(of: .value, with: { (snapshot) in
                                if(snapshot.exists()){
                               
                                print(snapshot.value)
                                
                                if snapshot.value != nil{
                                    let multidest = snapshot.value!
                                    print(multidest)
                                    print("multidest:\((multidest as AnyObject).count)")
                                     if(count == 0){
                                    if let value = snapshot.value as? NSArray {
                                        if (multidest as AnyObject).count == 2{

                                            print(value[0])
                                            print(value[1])
                                            print("via:\(value[0]),\(value[1])")
                                            if(self.waypointmerge == ""){
                                                self.waypointmerge =  "via:\(value[0]),\(value[1])" as NSString
                                                print(self.waypointmerge)
                                                self.multipledestinationfare = self.dropprice1
                                            }
                                            else{
                                                if(self.waypointmerge.contains("via:\(value[0]),\(value[1])")){
                                                    print("already added this location")
                                                }
                                                else{
                                                    self.waypointmerge =  "\(self.waypointmerge)|via:\(value[0]),\(value[1])" as NSString
                                                    print(self.waypointmerge)
                                                    
                                                    self.multipledestinationfare = self.multipledestinationfare + self.dropprice1
                                                    print(self.multipledestinationfare)
                                                }
                                            
                                            }
                                        }
                                    }
                                }
                                    count += 1
                                }
                            }
                            })
                            
                            
                            i = i + 1
                            
                        }
                    }
                    })
                    
                }
                if(waypointcount == 0){
                    self.waypointmerge = ""
                    self.multipledestinationfare = 0
                }
                else{
                    self.viewMap.clear()
                    self.waypointmerge1 = ""
                    self.notification(Status: "Rider added waypoints.")
                }
                print(self.waypointmerge)
               
            }
            else{
                print("Snapshot value is nil")
            }
        }
        }) { (error) in
            print(error.localizedDescription)
        }
    
    }
    
        
    
    
    @IBAction func btntollclose(_ sender: Any) {
        self.textFieldAmount.text = ""
        self.tollfeeview.isHidden = true
        self.view.endEditing(true)
            }
    @IBAction func btnRiderContactAction(_ sender: Any) {
        
        self.viewContact.isHidden = false
        self.cancelbtnview.isHidden = false
        self.viewBlurCurrentTrip.isHidden = false

    }
    
    @IBAction func backclose(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    @IBAction func btnEndtripAct(_ sender: Any) {
        self.viewContact.isHidden = false
        self.cancelbtnview.isHidden = true
        self.viewBlurCurrentTrip.isHidden = false
    }

    @IBAction func tollpayact(_ sender: Any) {
        
        
        let textFieldString = self.textFieldAmount.text! as NSString;
        
        let floatRegEx = "\\d{0,4}(\\.\\d{1,2})?"
        
        let floatExPredicate = NSPredicate(format:"SELF MATCHES %@", floatRegEx)
        
        if(!floatExPredicate.evaluate(with: textFieldString)){
            
            self.labelValidAmount.isHidden = false
            return
        }

        
        for var i in 0..<tollfeeid.count {
        //for (index,values) in tollfeeid.enumerated(){
            print(tollfeeid[i])
            
            //self.update_tollfee()
            FIRDatabase.database().reference().child("trips_data").child(tollfeeid[i] as! String).child("tollfee").observeSingleEvent(of: .value, with: { (snapshot) in
                print(snapshot.value)
                
                if snapshot.value != nil{
                    //print(snapshot.value)
                        self.appDelegate.previous_tollfee = snapshot.value as! String
                        var toll_total = 0.0
                        if(self.textFieldAmount.text! != ""){
                            toll_total = 1.0 * Double(self.textFieldAmount.text!)!
                        }else{
                            toll_total = 0.0
                        }
                        print(toll_total)
                        if(self.textFieldAmount.text! != "" && toll_total != 0.0){
                            self.labelValidAmount.isHidden = true
                            //var tollfee = textFieldAmount.text
                            let ref1 = FIRDatabase.database().reference().child("trips_data").child(self.tollfeeid[i] as! String)
                            var tollfee = Float(self.appDelegate.previous_tollfee)! + Float(self.textFieldAmount.text!)!
                            ref1.updateChildValues(["tollfee": "\(String(tollfee))"])
                            self.appDelegate.final_tollfee = String(tollfee)
                            print("enter toll fee\(self.appDelegate.final_tollfee)")
                            
                            self.tollfeeview.isHidden = true
                            self.view.endEditing(true)
                        }
                        else{
                            self.labelValidAmount.isHidden = false
                        }
                    
                    i = i + 1
                    
                }
            })
            
            
        }
    }
    
    @IBAction func btnCancelContactAction(_ sender: Any) {
        
        let optionMenu = UIAlertController(title: nil, message: "Are You Sure want to cancel the trip?", preferredStyle: .actionSheet)
        optionMenu.popoverPresentationController?.sourceView = self.view

        let sharePhoto = UIAlertAction(title: "YES", style: .default) { (alert : UIAlertAction) in
            
            self.driverClickedCancelPass = "clicked"
            
            if self.driverClickedCancelPass == "clicked"{
                
                self.appDelegate.cancelfromdriver = "1"
                self.callCancelTrip()

            }
            else{
                
                print("else")
            }
        
        }
        
        let cancel = UIAlertAction(title: "NO", style: .cancel) { (alert : UIAlertAction) in
            
            
            
        }
        
        //    optionMenu.addAction(takePhoto)
        optionMenu.addAction(sharePhoto)
        
        optionMenu.addAction(cancel)
        
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    @IBAction func tollfeeaction(_ sender: Any) {
        
    }
    @IBAction func btnCallRiderAction(_ sender: Any) {
        
        let acceptedRiderMobile = UserDefaults.standard.object(forKey: "acceptedRiderMobile") as! String!
        if acceptedRiderMobile == nil{
            
            self.phone(phoneNum: "")
            
        }
        else{
            
            self.phone(phoneNum: "\(acceptedRiderMobile!)")
            
        }
    }
    
    @IBAction func btnMsgRiderAction(_ sender: Any) {
        
        let acceptedRiderMobile = UserDefaults.standard.object(forKey: "acceptedRiderMobile") as! String!
        if acceptedRiderMobile == nil{
            
            self.msgAction(msgNum: "")
            
        }
        else{
            
            self.msgAction(msgNum: "\(acceptedRiderMobile)")
            
        }

    }
    @IBAction func btnCancelBlureCurrentTripViewAction(_ sender: Any) {
        
        self.viewBlurCurrentTrip.isHidden = true
        self.viewContact.isHidden = true

    }
    @IBAction func btnStartTripCurrentTripAction(_ sender: Any) {
        
        self.viewContact.isHidden = false
        self.cancelbtnview.isHidden = false
        self.viewBlurCurrentTrip.isHidden = false
    }
    
    @IBAction func btnBackContactAction(_ sender: Any) {
        
        self.viewContact.isHidden = true
        self.viewBlurCurrentTrip.isHidden = true

    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        textFieldAmount.borderActiveColor = UIColor.black
        textFieldAmount.borderInactiveColor = UIColor.black
        textFieldAmount.placeholderColor = UIColor.black
        self.labelValidAmount.isHidden = true
        return true
        }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField == textFieldAmount{
            textFieldAmount.borderActiveColor = UIColor.black
            textFieldAmount.borderInactiveColor = UIColor.black
            textFieldAmount.placeholderColor = UIColor.black
            self.labelValidAmount.isHidden = true
            
        }
        return true
    }
    func checkPhNumber(){
        
        var urlstring:String = "\(signInAPIUrl)editProfile/user_id/\(self.appDelegate.userid!)"
        
        urlstring = urlstring.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!
        
        //        urlstring = urlstring.removingPercentEncoding!
        
        print(urlstring)
        
        self.callviewPhAPI(url: "\(urlstring)")

    }
    
    func callviewPhAPI(url : String){
        
        
        Alamofire.request(url).responseJSON { (response) in
            
            self.parseDataPh(JSONData: response.data!)
        }
        
    }
    
    func parseDataPh(JSONData : Data){
        
        do{
            
            let readableJSon = try JSONSerialization.jsonObject(with: JSONData, options: .mutableContainers) as! jsonSTD
            
            print(" !!! \(readableJSon[0])")
            
            let value = readableJSon[0] as AnyObject
            
            if let final = value.object(forKey: "mobile"){
                print(final)
                
                    let mobile:String = value.object(forKey: "mobile") as! String

                    if mobile == nil{
                        
                        self.newPMAlert()
                    }
                    else if mobile == ""{
                        
                        self.newPMAlert()
                    }
                    else{
                        
                        
                    }
                    
             }
            else{
                
                
            }
        }
        catch{
            
            print(error)
            
            
            
        }
        
    }

    
    func removeDuplicates(array: [String]) -> [String] {
        var encountered = Set<String>()
        var result: [String] = []
        for value in array {
            if encountered.contains(value) {
                // Do not add a duplicate element.
            }
            else {
                // Add value to the set.
                encountered.insert(value)
                // ... Append the value.
                result.append(value)
            }
        }
        return result
    }
    
    // Test this array of animal names.
    
    // Call the method to dedupe the string array.
    
    func checkArrive(){
        
        
        print("sdasd \(self.arrayOfNonDuplicate)")
        
        print(arrayOfNonDuplicate)
        for (index,valuesPass) in arrayOfNonDuplicate.enumerated(){
            
            // i += 1
            let frame1 = CGRect(x: 10 + (index * 50), y: 2, width: 90, height: 30)
            let button = UIButton(frame: frame1)
            button.setTitle("trip \(index+1)", for: .normal)
            button.titleLabel?.tintColor = UIColor.white
            button.backgroundColor = UIColor.lightGray
            // button.titleLabel?.backgroundColor = UIColor.lightGray
            button.layer.borderColor = UIColor.clear.cgColor
            button.layer.borderWidth =  1.0
            button.addTarget(self, action: #selector(ADHomePageVC.CustomUserVideobtnTouched), for: UIControlEvents.touchUpInside)
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize:
                15)
            button.sizeToFit()
            button.tag = index
            print("raj \(valuesPass)")
            self.viewArriveInside.addSubview(button)
            self.scrollViewArrive.showsHorizontalScrollIndicator = true
            self.scrollViewArrive.backgroundColor = UIColor.clear
            self.scrollViewArrive.isScrollEnabled = true
            self.scrollViewArrive.contentSize.width = CGFloat(10 + (index * 50 + 90))
        }
        
    }
    
    
    func checkStart(){
        
        
        print("sdasd \(self.arrayOfNonDuplicate)")
        
        print(arrayOfNonDuplicate)
        for (index,valuesPass) in arrayOfNonDuplicate.enumerated(){
            
            // i += 1
            let frame1 = CGRect(x: 10 + (index * 50), y: 2, width: 90, height: 30)
            let button = UIButton(frame: frame1)
            button.setTitle("trip \(index+1)", for: .normal)
            button.titleLabel?.tintColor = UIColor.white
            button.backgroundColor = UIColor.lightGray
            // button.titleLabel?.backgroundColor = UIColor.lightGray
            button.layer.borderColor = UIColor.clear.cgColor
            button.layer.borderWidth =  1.0
            button.addTarget(self, action: #selector(ADHomePageVC.CustomUserVideobtnTouched), for: UIControlEvents.touchUpInside)
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize:
                15)
            button.sizeToFit()
            button.tag = index
            print("raj \(valuesPass)")
            self.viewArriveInsideStartTrip.addSubview(button)
            self.scrollViewArriveStartTrip.showsHorizontalScrollIndicator = true
            self.scrollViewArriveStartTrip.backgroundColor = UIColor.clear
            self.scrollViewArriveStartTrip.isScrollEnabled = true
            self.scrollViewArriveStartTrip.contentSize.width = CGFloat(10 + (index * 50 + 90))
        }
        
    }
    
    func checkEnd(){
        
        
        print("sdasd \(self.arrayOfNonDuplicate)")
        
        print(arrayOfNonDuplicate)
        for (index,valuesPass) in arrayOfNonDuplicate.enumerated(){
            
            // i += 1
            let frame1 = CGRect(x: 10 + (index * 50), y: 2, width: 90, height: 30)
            let button = UIButton(frame: frame1)
            button.setTitle("trip \(index+1)", for: .normal)
            button.titleLabel?.tintColor = UIColor.white
            button.backgroundColor = UIColor.lightGray
            // button.titleLabel?.backgroundColor = UIColor.lightGray
            button.layer.borderColor = UIColor.clear.cgColor
            button.layer.borderWidth =  1.0
            button.addTarget(self, action: #selector(ADHomePageVC.CustomUserVideobtnTouched), for: UIControlEvents.touchUpInside)
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize:
                15)
            button.sizeToFit()
            button.tag = index
            print("raj \(valuesPass)")
            self.viewArriveInsideEndTrip.addSubview(button)
            self.scrollViewArriveEndTrip.showsHorizontalScrollIndicator = true
            self.scrollViewArriveEndTrip.backgroundColor = UIColor.clear
            self.scrollViewArriveEndTrip.isScrollEnabled = true
            self.scrollViewArriveEndTrip.contentSize.width = CGFloat(10 + (index * 50 + 90))
        }
        
    }
    
    
    func loadTripsID(riderName : String) {
        
        
        print("first riderName \(riderName)")
        
        print("first tripID \(self.trip_id)")

        
        let dict  = ["\(riderName)"]
       
        let unique1 = Array(Set(dict))
        
        self.arrayOfSample.add(dict)
        
        //myArray.append(unique1 as [String])
        
        print("cool array \(arrayOfSample)")
        print(arrayOfNonDuplicate)

       // let hasDuplicates = NSArray(objects: arrayOfSample)

        for dics in arrayOfSample{
            
            if arrayOfNonDuplicate.contains(dics){
                
                
            }
            else{
                
                arrayOfNonDuplicate.add(dics)

            }
            
            
        }
        
        
        print(arrayOfDuplicate)

        print(arrayOfDuplicate.count)

        print(arrayOfNonDuplicate)
        
        print(arrayOfNonDuplicate.count)
        
        if(arrayOfNonDuplicate.count > 0){
        UserDefaults.standard.set(self.arrayOfNonDuplicate, forKey: "arrayOfTripsData")
            
            let first1  = UserDefaults.standard.array(forKey: "arrayOfTripsData")
            print("arrayofTripsData \(first1)")
        }
        
        

        print("my Array \(myArray)")
    
        print("my Array \(myArray.count)")
        
        //   for (index,values) in arrayOfTripID.enumerated(){

        print(arrayOfNonDuplicate)
        for (index,valuesPass) in arrayOfNonDuplicate.enumerated(){

            // i += 1
            let frame1 = CGRect(x: 10 + (index * 50), y: 2, width: 90, height: 30)
            let button = UIButton(frame: frame1)
            button.setTitle("trip \(index+1)", for: .normal)
            button.titleLabel?.tintColor = UIColor.white
            button.backgroundColor = UIColor.lightGray
           // button.titleLabel?.backgroundColor = UIColor.lightGray
            button.layer.borderColor = UIColor.clear.cgColor
            button.layer.borderWidth =  1.0
            button.addTarget(self, action: #selector(ADHomePageVC.CustomUserVideobtnTouched), for: UIControlEvents.touchUpInside)
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize:
                15)
            button.sizeToFit()
            button.tag = index
            print("raj \(valuesPass)")
            self.viewArriveInside.addSubview(button)
            self.scrollViewArrive.showsHorizontalScrollIndicator = true
            self.scrollViewArrive.backgroundColor = UIColor.clear
            self.scrollViewArrive.isScrollEnabled = true
            self.scrollViewArrive.contentSize.width = CGFloat(10 + (index * 50 + 90))
        }
       /* let ref1 = FIRDatabase.database().reference().child("drivers_data").child("\(self.appDelegate.userid!)").child("accept")
        ref1.updateChildValues(["trip_id": ""])*/
    }

//     func loadTripsID1(profile_pic : String) {
//        print("riderimage\(profile_pic)")
//        
//    }
    
    
    func loadTripsIDStartTrip(riderName : String) {
        
        /*let dict  = ["\(riderName) : \(self.trip_id)"]
        let unique1 = Array(Set(dict))
        myArray.append(unique1 as [String])
        
        
        print("my Array startTrip \(myArray)")
        
        print("my Array startTrip \(myArray.count)")
        
        //   for (index,values) in arrayOfTripID.enumerated(){
        
        for (index,valuesPass) in myArray.enumerated(){
            
            // i += 1
            let frame1 = CGRect(x: 10 + (index * 50), y: 2, width: 90, height: 30)
            let button = UIButton(frame: frame1)
            button.setTitle("trip \(index+1)", for: .normal)
            button.titleLabel?.tintColor = UIColor.white
            button.backgroundColor = UIColor.lightGray
            // button.titleLabel?.backgroundColor = UIColor.lightGray
            button.layer.borderColor = UIColor.clear.cgColor
            button.layer.borderWidth =  1.0
            button.addTarget(self, action: #selector(ADHomePageVC.CustomUserVideobtnTouched), for: UIControlEvents.touchUpInside)
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize:
                15)
            button.sizeToFit()
            button.tag = index
            print("raj start Trip \(valuesPass)")
            self.viewArriveInsideStartTrip.addSubview(button)
            self.scrollViewArriveStartTrip.showsHorizontalScrollIndicator = true
            self.scrollViewArriveStartTrip.isScrollEnabled = true
            self.scrollViewArriveStartTrip.contentSize.width = CGFloat(10 + (index * 50 + 90))
        }
        */
        
        print("first riderName \(riderName)")
        
        print("first tripID \(self.trip_id)")
        
        
        let dict  = ["\(riderName)"]
        
        let unique1 = Array(Set(dict))
        
        self.arrayOfSample.add(dict)
        
        //myArray.append(unique1 as [String])
        
        print("cool array \(arrayOfSample)")
        
        // let hasDuplicates = NSArray(objects: arrayOfSample)
        
        for dics in arrayOfSample{
            
            if arrayOfNonDuplicate.contains(dics){
                
                
            }
            else{
                
                arrayOfNonDuplicate.add(dics)
                
            }
            
            
        }
        
        
        print(arrayOfDuplicate)
        
        print(arrayOfDuplicate.count)
        
        print(arrayOfNonDuplicate)
        
        print(arrayOfNonDuplicate.count)
        
        
        
        print("my Array \(myArray)")
        
        print("my Array \(myArray.count)")
        
        //   for (index,values) in arrayOfTripID.enumerated(){
        print(arrayOfNonDuplicate)
        for (index,valuesPass) in arrayOfNonDuplicate.enumerated(){
            
            // i += 1
            let frame1 = CGRect(x: 10 + (index * 50), y: 2, width: 90, height: 30)
            let button = UIButton(frame: frame1)
            button.setTitle("trip \(index+1)", for: .normal)
            button.titleLabel?.tintColor = UIColor.white
            button.backgroundColor = UIColor.lightGray
            // button.titleLabel?.backgroundColor = UIColor.lightGray
            button.layer.borderColor = UIColor.clear.cgColor
            button.layer.borderWidth =  1.0
            button.addTarget(self, action: #selector(ADHomePageVC.CustomUserVideobtnTouched), for: UIControlEvents.touchUpInside)
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize:
                15)
            button.sizeToFit()
            button.tag = index
            print("raj \(valuesPass)")
            self.viewArriveInsideStartTrip.addSubview(button)
            self.scrollViewArriveStartTrip.showsHorizontalScrollIndicator = true
            self.scrollViewArriveStartTrip.backgroundColor = UIColor.clear
            self.scrollViewArriveStartTrip.isScrollEnabled = true
            self.scrollViewArriveStartTrip.contentSize.width = CGFloat(10 + (index * 50 + 90))
        }
    }
    
    func loadTripsIDEndTrip(riderName : String) {
        
        /*let dict  = ["\(riderName) : \(self.trip_id)"]
         let unique1 = Array(Set(dict))
         myArray.append(unique1 as [String])
         
         
         print("my Array startTrip \(myArray)")
         
         print("my Array startTrip \(myArray.count)")
         
         //   for (index,values) in arrayOfTripID.enumerated(){
         
         for (index,valuesPass) in myArray.enumerated(){
         
         // i += 1
         let frame1 = CGRect(x: 10 + (index * 50), y: 2, width: 90, height: 30)
         let button = UIButton(frame: frame1)
         button.setTitle("trip \(index+1)", for: .normal)
         button.titleLabel?.tintColor = UIColor.white
         button.backgroundColor = UIColor.lightGray
         // button.titleLabel?.backgroundColor = UIColor.lightGray
         button.layer.borderColor = UIColor.clear.cgColor
         button.layer.borderWidth =  1.0
         button.addTarget(self, action: #selector(ADHomePageVC.CustomUserVideobtnTouched), for: UIControlEvents.touchUpInside)
         button.titleLabel?.font = UIFont.boldSystemFont(ofSize:
         15)
         button.sizeToFit()
         button.tag = index
         print("raj start Trip \(valuesPass)")
         self.viewArriveInsideStartTrip.addSubview(button)
         self.scrollViewArriveStartTrip.showsHorizontalScrollIndicator = true
         self.scrollViewArriveStartTrip.isScrollEnabled = true
         self.scrollViewArriveStartTrip.contentSize.width = CGFloat(10 + (index * 50 + 90))
         }
         */
        
        print("first riderName \(riderName)")
        
        print("first tripID \(self.trip_id)")
        
        
        let dict  = ["\(riderName)"]
        
        let unique1 = Array(Set(dict))
        
        self.arrayOfSample.add(dict)
        
        //myArray.append(unique1 as [String])
        
        print("cool array \(arrayOfSample)")
        
        // let hasDuplicates = NSArray(objects: arrayOfSample)
        
        for dics in arrayOfSample{
            
            if arrayOfNonDuplicate.contains(dics){
                
                
            }
            else{
                
                arrayOfNonDuplicate.add(dics)
                
            }
            
            
        }
        
        
        print(arrayOfDuplicate)
        
        print(arrayOfDuplicate.count)
        
        print(arrayOfNonDuplicate)
        
        print(arrayOfNonDuplicate.count)
        
        
        
        print("my Array \(myArray)")
        
        print("my Array \(myArray.count)")
        
        //   for (index,values) in arrayOfTripID.enumerated(){
        print(arrayOfNonDuplicate)
        for (index,valuesPass) in arrayOfNonDuplicate.enumerated(){
            
            // i += 1
            let frame1 = CGRect(x: 10 + (index * 50), y: 2, width: 90, height: 30)
            let button = UIButton(frame: frame1)
            button.setTitle("trip \(index+1)", for: .normal)
            button.titleLabel?.tintColor = UIColor.white
            button.backgroundColor = UIColor.lightGray
            // button.titleLabel?.backgroundColor = UIColor.lightGray
            button.layer.borderColor = UIColor.clear.cgColor
            button.layer.borderWidth =  1.0
            button.addTarget(self, action: #selector(ADHomePageVC.CustomUserVideobtnTouched), for: UIControlEvents.touchUpInside)
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize:
                15)
            button.sizeToFit()
            button.tag = index
            print("raj \(valuesPass)")
            self.viewArriveInsideEndTrip.addSubview(button)
            self.scrollViewArriveEndTrip.showsHorizontalScrollIndicator = true
            self.scrollViewArriveEndTrip.backgroundColor = UIColor.clear
            self.scrollViewArriveEndTrip.isScrollEnabled = true
            self.scrollViewArriveEndTrip.contentSize.width = CGFloat(10 + (index * 50 + 90))
        }
    }
    
    
    func firstKnowTripsStatus(){
        
        
        var getIndex = "\(arrayOfNonDuplicate[(arrayOfNonDuplicate.count) - 1])"
        
        print(arrayOfNonDuplicate)
        print("values got \(getIndex)")
        
        if(arrayOfNonDuplicate.count > 0){
            self.getSome = self.arrayOfNonDuplicate.count - 1
            
            print("\(getSome)")
        }
        
        getIndex = getIndex.replacingOccurrences(of: "[", with: "")
        getIndex = getIndex.replacingOccurrences(of: "\"", with: "")
        getIndex = getIndex.replacingOccurrences(of: "]", with: "")
        getIndex = getIndex.replacingOccurrences(of: "\n", with: "")
        getIndex = getIndex.replacingOccurrences(of: "(", with: "")
        getIndex = getIndex.replacingOccurrences(of: ")", with: "")
        
        
        let finalString = "\(getIndex)"
        
        
        print("values got \(finalString)")
        
        
        var newlink = finalString.components(separatedBy: ":").first
        
        print(newlink! as String)
        
        newlink = newlink?.replacingOccurrences(of: " ", with: "")
        
        self.passTagRiderTripId = newlink!
        
        
        var newlink1 = finalString.components(separatedBy: ":").last
        
        // let newlink1 = finalString.components(separatedBy: "\"  ").first
        
        newlink1 = newlink1?.replacingOccurrences(of: " ", with: "")
        
        print(newlink1! as String)
        
        self.passTagRiderName = newlink1!
        
        print(self.passTagRiderName)
        
        UserDefaults.standard.set(self.passTagRiderTripId, forKey: "TripID")
        
        var tripID = UserDefaults.standard.value(forKey: "TripID") as! String
        tripID = tripID.replacingOccurrences(of: "Optional(", with: "")
        tripID = tripID.replacingOccurrences(of: ")", with: "")
        tripID = tripID.replacingOccurrences(of: "\"", with: "")
        
        print("got tripID\(tripID)")
        
         //UserDefaults.standard.setValue(profile_pic, forKey: "rpRiderImage")
        let pic = UserDefaults.standard.value(forKey: "rpRiderImage")
        print("\(pic)")
        self.arrivenowLabel.text! = self.passTagRiderName
        self.startTripLabel.text! = self.passTagRiderName
        self.completeTripLabel.text! = self.passTagRiderName
        self.labelPickUpRider.text! = self.passTagRiderName
        
        if let runningDistance = UserDefaults.standard.value(forKey:"tripRunningDistance") as? Double
        {
            self.tripDistance = runningDistance

        }

        
        print(self.arrivenowLabel.text!)
        
        self.appDelegate.cancelfromrider = ""
        self.checkValuesFromFirebase()
        
    }
    
    
    func CustomUserVideobtnTouched(sender: UIButton, i: Int){
        
        self.appDelegate.usertouchdtrip = "1"
        self.appDelegate.usertouchdtrip1 = "1"
        self.appDelegate.usertouchdtrip2 = "1"
        self.imageViewPickUpRider.image = nil

        print("Array tripsID \(self.arrayOfNonDuplicate)")

        print("Array tripsID count \(self.arrayOfNonDuplicate.count)")

      //  UserDefaults.standard.set(self.arrayOfNonDuplicate, forKey: "arrayOfTripsData")
        
     //   let first = UserDefaults.standard.array(forKey: "arrayOfTripsData")

      //  print("arrayofTripsData \(first)")
        
        print(i)
        
        
        self.values = sender.tag
        
        print(sender.tag)
        
        UserDefaults.standard.set(values, forKey: "passTripsIndex")
        
        self.getSome = UserDefaults.standard.integer(forKey: "passTripsIndex")
        
        print("getSome\(getSome)")

        var getIndex = "\(arrayOfNonDuplicate[values])"
    
        print("values got \(getIndex)")
        
        
        getIndex = getIndex.replacingOccurrences(of: "[", with: "")
        getIndex = getIndex.replacingOccurrences(of: "\"", with: "")
        getIndex = getIndex.replacingOccurrences(of: "]", with: "")
        getIndex = getIndex.replacingOccurrences(of: "\n", with: "")
        getIndex = getIndex.replacingOccurrences(of: "(", with: "")
        getIndex = getIndex.replacingOccurrences(of: ")", with: "")

        
        let finalString = "\(getIndex)"
        
        
        print("values got \(finalString)")

        
        var newlink = finalString.components(separatedBy: ":").first
            
        print(newlink! as String)
      //tripid
        newlink = newlink?.replacingOccurrences(of: " ", with: "")
        let tripid = newlink!
        print("newlink\(String(describing: tripid))")
        
        let ref = FIRDatabase.database().reference()
        ref.child("trips_data").child("\(String(describing: tripid))").child("riderid").observe(.value, with: { (snapshot) in
        let riderid = snapshot.value as Any
            print("riderid~~\(riderid)")
            self.appDelegate.pictripid = riderid as! String
            self.profilepic()
            
             })
        
        
        
        self.passTagRiderTripId = newlink!
    

        
        
        var newlink1 = finalString.components(separatedBy: ":").last
        
       // let newlink1 = finalString.components(separatedBy: "\"  ").first

        newlink1 = newlink1?.replacingOccurrences(of: " ", with: "")
        
        print(newlink1! as String)
        
        self.passTagRiderName = newlink1!
        
        print(self.passTagRiderName)
        
        self.appDelegate.riderName1 = self.passTagRiderName

        print("\(sender.titleLabel?.text)")
        
        UserDefaults.standard.set(self.passTagRiderTripId, forKey: "TripID")

        var tripID = UserDefaults.standard.value(forKey: "TripID") as! String
        tripID = tripID.replacingOccurrences(of: "Optional(", with: "")
        tripID = tripID.replacingOccurrences(of: ")", with: "")
        tripID = tripID.replacingOccurrences(of: "\"", with: "")
        
        print("got tripID\(tripID)")
//        let pic = UserDefaults.standard.value(forKey: "rpRiderImage")
//        print("\(pic)")
        
        self.arrivenowLabel.text! = self.passTagRiderName
        self.startTripLabel.text! = self.passTagRiderName
        self.completeTripLabel.text! = self.passTagRiderName
        self.labelPickUpRider.text! = self.passTagRiderName
        
        print(self.arrivenowLabel.text!)
        
        self.appDelegate.cancelfromrider = ""
        self.checkValuesFromFirebase()
        self.onclickridercheckcancel()
    }
    func profilepic(){
        
        
        var urlstring:String = "\(live_rider_url)editProfile/user_id/\(self.appDelegate.pictripid)"
        
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
                   var profile_pic = result["profile_pic"] as? String //profile_pic
                    
                    if profile_pic == nil ||  profile_pic == ""
                    {
                        
                       self.imageViewPickUpRider.image = UIImage(named : "UserPic.png")
                        //self.imageViewPickUpRider.image = UIImage(named : "contact.png")

                    }
                    else
                    {
                        profile_pic = (profile_pic as AnyObject).replacingOccurrences(of: "Optional(", with: "")
                        profile_pic = (profile_pic as AnyObject).replacingOccurrences(of: ")", with: "")
                        profile_pic = (profile_pic as AnyObject).replacingOccurrences(of: "\"", with: "")
                        profile_pic = (profile_pic as AnyObject).replacingOccurrences(of: "%20", with: " ")
                        let imageURL1 = profile_pic
                        print("sample")
                        print("imageURL1~\(String(describing: imageURL1))")
                        let url = URL(string: imageURL1!)
                        self.imageViewPickUpRider.setImageWithUrl(url!)

                        
                    }

                    
                    
                }
        },
            failure: { (operation: AFHTTPRequestOperation?,error: Error) in
                print("Error: " + error.localizedDescription)
        })
        

        

        
    }
    
   
    func checkValuesFromFirebase(){
        
        if UserDefaults.standard.value(forKey: "TripID") != nil{
            
            var tripID = UserDefaults.standard.value(forKey: "TripID") as! String
            tripID = tripID.replacingOccurrences(of: "Optional(", with: "")
            tripID = tripID.replacingOccurrences(of: ")", with: "")
            tripID = tripID.replacingOccurrences(of: "\"", with: "")
            
            self.trip_id = tripID
        }
        
        print("dynamic pass tripID \(self.trip_id)")
        
        
        let ref = FIRDatabase.database().reference()
        
        ref.child("trips_data").child("\(self.trip_id)").child("status").observe(.value, with: { (snapshot) in
            //let dict = snapshot.value as! NSString
            if(snapshot.exists()){
                print("updating")
                let status1 = snapshot.value as! String
                print("trip id is here\(status1)")
                var trip_id = "\(status1)"
                trip_id = trip_id.replacingOccurrences(of: "Optional(", with: "")
                trip_id = trip_id.replacingOccurrences(of: ")", with: "")
                print(status1)
                //if("\(status1)" == "1"){
                if("\(trip_id)" != ""){
                    
                    if (status1 == "1"){
                        
                        self.arriveNowView.isHidden = false
                        self.startTripView.isHidden = true
                        self.completeTripView.isHidden = true
                        self.urlstring = "\(live_request_url)requests/updateTrips/trip_id/\(self.trip_id)/trip_status/off/accept_status/1/total_amount/0"
                        if(trip_id != "nil"){
                            self.tripStatusUpdating(urlString: self.urlstring)
                        }
                    }
                    else if (status1 == "2"){
                        
                        self.arriveNowView.isHidden = true
                        self.startTripView.isHidden = false
                        self.completeTripView.isHidden = true
                        //self.getCurrnentAddress(myLocation : self.dropDestination)
                        self.urlstring = "\(live_request_url)requests/updateTrips/trip_id/\(self.trip_id)/trip_status/off/accept_status/2/total_amount/0"
                        self.imageName = "endPinRound.png"
                        self.imageName1 = "markerloc1"
                        self.imageName2 = "markerloc2"
                        self.imageName3 = "markerloc3"
                        self.imageName4 = "markerloc4"
                        if(trip_id != "nil"){
                            self.tripStatusUpdating(urlString: self.urlstring)
                        }
                        print("Arriving now")
                        self.startTrip()
                        
                    }
                    else if (status1 == "3"){
                        
                        self.arriveNowView.isHidden = true
                        self.startTripView.isHidden = true
                        self.completeTripView.isHidden = false
                        self.urlstring = "\(live_request_url)requests/updateTrips/trip_id/\(self.trip_id)/trip_status/on/accept_status/3/total_amount/0"
                        print("Begin Trip")
                        if(trip_id != "nil"){
                            self.tripStatusUpdating(urlString: self.urlstring)
                        }
                        self.startTripView.isHidden = true
                        self.completeTrip()
                    }
                    else if (status1 == "4"){
                        
                        self.arriveNowView.isHidden = true
                        self.startTripView.isHidden = true
                        self.completeTripView.isHidden = true
                    }
                        
                    else{
                        
                        /*if(self.arrayOfNonDuplicate.count < 2 ){
                            if(self.appDelegate.cancelfromdriver != "1"){
                                UserDefaults.standard.removeObject(forKey: "rider_id")
                                
                                self.notification(Status: "Rider Cancelled the trip")
                                
                                let pass = self.arrayOfNonDuplicate
                                
                                pass.removeObject(at: self.getSome)
                                
                                print("remove array element \(self.arrayOfNonDuplicate)")
                                
                                UserDefaults.standard.set(self.arrayOfNonDuplicate, forKey: "arrayOfTripsData")
                                
                                let check  = UserDefaults.standard.array(forKey: "arrayOfTripsData")
                                
                                print("arrayofTripsData \(check)")
                                
                                self.appDelegate.callMapVC()
                            }
                            self.appDelegate.cancelfromdriver = ""
                        }*/
                    }
                    
                    
                }
                else{
                    
                    
                    
                }
            }
            
            
            
        }) { (error) in
            
            print(error.localizedDescription)
        }
        
    }
    
        func newPMAlert(){
        
        let alertVC = PMAlertController(title: "WITHOUT PHONE NUMBER", description: "You need to set your phone number in profile without phone number rider can't able to contact you", image: UIImage(named: "AppIcon.png"), style: .alert) //Image by freepik.com, taken on flaticon.com
        
        alertVC.addAction(PMAlertAction(title: "Cancel", style: .cancel, action: { () -> Void in
            print("Cancel")
        }))
        
        alertVC.addAction(PMAlertAction(title: "Set now", style: .default, action: { () in
            print("Set now")
            
            let editProfileVC = ADEditProfileVC()
            self.homePassEditProfile = "No Phone Number Alert"
            editProfileVC.passEditProfile = self.homePassEditProfile
            self.navigationController?.pushViewController(editProfileVC, animated: true)

        }))
        
        self.present(alertVC, animated: true, completion: nil)
    }
    
    var time: TimeInterval = 2.0

    func abc(){
        
        
        self.locationUpdate.startLocationTracking()
        //Send the best location to server every 60 seconds
        //You may adjust the time interval depends on the need of your app.
        self.locationUpdateTimer = Timer.scheduledTimer(timeInterval: time, target: self, selector: #selector(self.upd), userInfo: nil, repeats: true)


    }
    
    func upd(){
        

        if self.locationUpdate != nil{
            
            self.locationUpdate.updateLocationToServer()

            
        }
    }
    func update(){
        
        var alert: UIAlertView?
        //We have to make sure that the Background app Refresh is enabled for the Location updates to work in the background.
        if UIApplication.shared.backgroundRefreshStatus == .denied {
            // The user explicitly disabled the background services for this app or for the whole system.
            //alert = UIAlertView(title: "", message: "The app doesn't work without the Background app Refresh enabled. To turn it on, go to Settings > General > Background app Refresh", delegate: nil, cancelButtonTitle: "Ok")
            //alert?.show()
        }
        else if UIApplication.shared.backgroundRefreshStatus == .restricted {
            // Background services are disabled and the user cannot turn them on.
            // May occur when the device is restricted under parental control.
            //alert = UIAlertView(title: "", message: "The functions of this app are limited because the Background app Refresh is disable.", delegate: nil, cancelButtonTitle: "Ok")
        }
        else{
            
            
        }
        
    }
  /*  func startAnimation() {
        
        self.timer = Timer.scheduledTimer(timeInterval: 0.03, target: self, selector: #selector(self.progressChange), userInfo: nil, repeats: true)
        
    }*/
   /* func progressChange() {
        
        
            labeledLargeProgressView.setProgress(5.0, animated: true)
        
            var labeledProgressViews = [self.labeledLargeProgressView]
            var labeledProgressView : DALabeledCircularProgressView!
            var progress1: CGFloat!
        
            for labeledProgressView in labeledProgressViews{
            
                var progress: CGFloat = !self.timer.isValid ? Double(self.stepper.value / 10.0) : labeledProgressView!.progress + 0.01
                
                if labeledProgressView!.progress >= 1.0 && self.timer.isValid {
                    
                    labeledProgressView?.setProgress(0.0, animated: true)
                }
                labeledProgressView?.progressLabel.text = String(format: "%.2f", (labeledProgressView?.progress)!)

            }
          /*  let progress: CGFloat = 1.0
            labeledLargeProgressView.setProgress(progress, animated: true)
            if labeledLargeProgressView.progress >= 1.0 && self.timer.isValid {
                labeledLargeProgressView.setProgress(0.0, animated: true)
            }
            labeledLargeProgressView.progressLabel.text = String(format: "%.2f", labeledLargeProgressView.progress)*/
    }*/
    
    func getCurrentLocation(){
        
        // this function is used for update current location using location tracker

        

        
    }
    
   /* func scroll(){
        
        self.autoScrollLabel.text = @"This text may be clipped, but now it will be scrolled. This text will be scrolled even after device rotation.";
        self.autoScrollLabel.textColor = [UIColor blueColor];
        self.autoScrollLabel.labelSpacing = 30; // distance between start and end labels
        self.autoScrollLabel.pauseInterval = 1.7; // seconds of pause before scrolling starts again
        self.autoScrollLabel.scrollSpeed = 30; // pixels per second
        self.autoScrollLabel.textAlignment = NSTextAlignmentCenter; // centers text when no auto-scrolling is applied
        self.autoScrollLabel.fadeLength = 12.f;
        self.autoScrollLabel.scrollDirection = CBAutoScrollDirectionLeft;
        [self.autoScrollLabel observeApplicationNotifications];
        
        // navigation bar auto scroll label
        self.navigationBarScrollLabel.text = @"Navigation Bar Title... Scrolling... And scrolling.";
        self.navigationBarScrollLabel.pauseInterval = 3.f;
        self.navigationBarScrollLabel.font = [UIFont boldSystemFontOfSize:20];
        self.navigationBarScrollLabel.textColor = [UIColor blackColor];
        [self.navigationBarScrollLabel observeApplicationNotifications];
    }*/
    
    func cardview(){
        
//        self.arriveNowView.layer.shadowColor = UIColor.gray.cgColor
//        arriveNowView.layer.shadowOffset = CGSize(width: CGFloat(0.0), height: CGFloat(0.0))
//        arriveNowView.layer.shadowOpacity = 0.7
//        arriveNowView.layer.shadowRadius = 4.0
        
        self.arrivenow1.layer.shadowColor = UIColor.darkGray.cgColor
        arrivenow1.layer.shadowOffset = CGSize(width: CGFloat(0.0), height: CGFloat(0.0))
        arrivenow1.layer.shadowOpacity = 0.9
        arrivenow1.layer.shadowRadius = 4.0
        arrivenow1.layer.cornerRadius = 5
        
        self.arrivenow2.layer.shadowColor = UIColor.gray.cgColor
        arrivenow2.layer.shadowOffset = CGSize(width: CGFloat(0.0), height: CGFloat(0.0))
        arrivenow2.layer.shadowOpacity = 0.9
        arrivenow2.layer.shadowRadius = 4.0
        arrivenow2.layer.cornerRadius = 5

        self.arrivenow3.layer.shadowColor = UIColor.gray.cgColor
        arrivenow3.layer.shadowOffset = CGSize(width: CGFloat(0.0), height: CGFloat(0.0))
        arrivenow3.layer.shadowOpacity = 0.9
        arrivenow3.layer.shadowRadius = 4.0
        arrivenow3.layer.cornerRadius = 5

        
        self.starttip1.layer.shadowColor = UIColor.gray.cgColor
        starttip1.layer.shadowOffset = CGSize(width: CGFloat(0.0), height: CGFloat(0.0))
        starttip1.layer.shadowOpacity = 0.9
        starttip1.layer.shadowRadius = 4.0
        starttip1.layer.cornerRadius = 5
        
        self.starttip2.layer.shadowColor = UIColor.gray.cgColor
        starttip2.layer.shadowOffset = CGSize(width: CGFloat(0.0), height: CGFloat(0.0))
        starttip2.layer.shadowOpacity = 0.9
        starttip2.layer.shadowRadius = 4.0
        starttip2.layer.cornerRadius = 5
        
        self.completetrip1.layer.shadowColor = UIColor.gray.cgColor
        completetrip1.layer.shadowOffset = CGSize(width: CGFloat(0.0), height: CGFloat(0.0))
        completetrip1.layer.shadowOpacity = 0.9
        completetrip1.layer.shadowRadius = 4.0
        completetrip1.layer.cornerRadius = 5

        
        self.completetrip2.layer.shadowColor = UIColor.gray.cgColor
        completetrip2.layer.shadowOffset = CGSize(width: CGFloat(0.0), height: CGFloat(0.0))
        completetrip2.layer.shadowOpacity = 0.9
        completetrip2.layer.shadowRadius = 4.0
        completetrip2.layer.cornerRadius = 5
        
        self.tollfee_inner.layer.shadowColor = UIColor.gray.cgColor
        tollfee_inner.layer.shadowOffset = CGSize(width: CGFloat(0.0), height: CGFloat(0.0))
        tollfee_inner.layer.shadowOpacity = 0.9
        tollfee_inner.layer.shadowRadius = 4.0
        tollfee_inner.layer.cornerRadius = 5
        
        tollheadlbl.layer.cornerRadius = 5
        self.tollheadlbl.layer.masksToBounds = true
        
        tollfeepaybtn.layer.cornerRadius = 5
        
    }
    
    func notification(Status : String){
        
        UNUserNotificationCenter.current().getNotificationSettings { (notificationSettings) in
            switch notificationSettings.authorizationStatus {
            case .notDetermined:
                self.requestAuthorization(completionHandler: { (success) in
                    guard success else { return }
                    
                    // Schedule Local Notification
                    self.scheduleLocalNotification(Status : Status)
                })
            case .authorized:
                // Schedule Local Notification
                self.scheduleLocalNotification(Status : Status)
            case .denied:
                print("Application Not Allowed to Display Notifications")
            }
        }
    }
    
    
    internal func scheduleLocalNotification(Status : String) {
        // Create Notification Content
        let notificationContent = UNMutableNotificationContent()
        
        // Configure Notification Content
       // notificationContent.title = "Arcane Rider" //"You have received a request."
        notificationContent.subtitle = ""
        notificationContent.body = "\(Status)"
        notificationContent.sound = UNNotificationSound.default()
        
        
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
    
   internal func requestAuthorization(completionHandler: @escaping (_ success: Bool) -> ()) {
        // Request Authorization
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (success, error) in
            if let error = error {
                print("Request Authorization Failed (\(error), \(error.localizedDescription))")
            }
            
            completionHandler(success)
        }
    }


   internal func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }
    
  internal func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        print("didReceive")
        completionHandler()
    }

    
    func incomingNotification(){
        
        let ref = FIRDatabase.database().reference()
        
        
        //        let geoFire = GeoFire(firebaseRef: ref.child("drivers_data").child("\(self.appDelegate.userid!)").child("accept"))
        let geoFire = GeoFire(firebaseRef: ref.child("drivers_data").child("\(self.appDelegate.userid!)").child("request"))
        
        // let geoFire = GeoFire(firebaseRef: ref.child("drivers_data/5857c2bada71b4d9708b4567/"))
        
       // print(geoFire!.firebaseRef(forLocationKey: "geolocation"))
        
        // updated
        
        ref.child("drivers_data").child("\(self.appDelegate.userid!)").child("request").observe(.childChanged, with: { (snapshot) in
            
            print("updating")
            let status1 = snapshot.value as Any
            print(status1)
            var status = "\(status1)"
            status = status.replacingOccurrences(of: "Optional(", with: "")
            status = status.replacingOccurrences(of: ")", with: "")
            print(status)
            if(status == "1"){
                //start
                let ref2 = FIRDatabase.database().reference().child("drivers_data").child("\(self.appDelegate.userid!)").child("accept")
                ref2.updateChildValues(["trip_id": ""])
                ref2.updateChildValues(["trip_id_rider_name": ""])
                
                //make progressbar to start count from first
                self.indexProgressBar = 0
                
                //end
                self.notification(Status: "You have received a request.")
                //self.setphone = true
                
                //  if self.setphone == true{
                
                ////self.viewPhone.isHidden = false
                ////self.requestView.isHidden = false
                self.viewRequestNew.isHidden = false
                var distanceforrequest:String = ""
                ref.child("drivers_data").child("\(self.appDelegate.userid!)").child("request").child("distance").observeSingleEvent(of: .value, with: { (snapshot) in
                    let distance1 = snapshot.value as Any
                    var distance11 = "\(distance1)"
                    distance11 = distance11.replacingOccurrences(of: "Optional(", with: "")
                    distance11 = distance11.replacingOccurrences(of: ")", with: "")
                    print(distance11)
                    self.distlbll.text = "Distance:\(distance11)"
                    distanceforrequest = distance11
                })
                ref.child("drivers_data").child("\(self.appDelegate.userid!)").child("request").child("dropAddress").observeSingleEvent(of: .value, with: { (snapshot) in
                    let dropaddr1 = snapshot.value as Any
                    var dropaddr = "\(dropaddr1)"
                    dropaddr = dropaddr.replacingOccurrences(of: "Optional(", with: "")
                    dropaddr = dropaddr.replacingOccurrences(of: ")", with: "")
                    print(dropaddr)
                    self.dropaddrrlbl.text = "\(dropaddr)"
                    self.dropaddrrtv.text = "\(dropaddr)"
                })
                ref.child("drivers_data").child("\(self.appDelegate.userid!)").child("request").child("eta").observeSingleEvent(of: .value, with: { (snapshot) in
                    let eta1 = snapshot.value as Any
                    var eta = "\(eta1)"
                    eta = eta.replacingOccurrences(of: "Optional(", with: "")
                    eta = eta.replacingOccurrences(of: ")", with: "")
                    print(eta)
                    self.etalbll.text = "ETA:\(eta)"
                })
                ref.child("drivers_data").child("\(self.appDelegate.userid!)").child("request").child("pickupAddress").observeSingleEvent(of: .value, with: { (snapshot) in
                    let pickupaddrr1 = snapshot.value as Any
                    var pickupaddrr = "\(pickupaddrr1)"
                    pickupaddrr = pickupaddrr.replacingOccurrences(of: "Optional(", with: "")
                    pickupaddrr = pickupaddrr.replacingOccurrences(of: ")", with: "")
                    print(pickupaddrr)
                    self.pickupaddrrlbl.text = "\(pickupaddrr)"
                    self.pickupaddrrtv.text = "\(pickupaddrr)"
                })
                ref.child("drivers_data").child("\(self.appDelegate.userid!)").child("request").child("estFare").observeSingleEvent(of: .value, with: { (snapshot) in
                    let estFare1 = snapshot.value as Any
                    var estFare = "\(estFare1)"
                    estFare = estFare.replacingOccurrences(of: "Optional(", with: "")
                    estFare = estFare.replacingOccurrences(of: ")", with: "")
                    print(estFare)
                    self.estimatedfarelbl.text = "Estimated fare : $\(estFare)"
                })
               // self.playSound()
                
                self.pulsator.start()
                self.pulsator.radius = 100
                self.pulsator.numPulse = 4
                
                //  }
                /*  else{
                 
                 self.requestView.isHidden = true
                 self.viewPhone.isHidden = true
                 self.pulsator.stop()
                 
                 // }  */
                self.accepted = "1"
                // here incoming contains a request for the logged in driver
                
                DispatchQueue.main.async {
                
                    self.progress.animate(fromAngle: 0, toAngle: 360, duration: 15) { completed in
                        if completed {
                            print("animation stopped, completed")
                            self.timer.invalidate()
                            self.timer1.invalidate()
                        } else {
                            print("animation stopped, was interrupted")
                            self.timer.invalidate()
                            self.timer1.invalidate()
                        }
                }
                }
                //self.getNextPoseData()
                self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ADHomePageVC.setProgressBar), userInfo: nil, repeats: true)
                self.timer1 = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ADHomePageVC.self.playAlertSound), userInfo: nil, repeats: true)
                self.incoming = 1  // for existed request
                

                self.getRequestID()
                //accept
                //get values from firebase after accepting
                
            }
            else if(status == "0"){
                //not accept or busy
                self.cancel()
            }
            else{
                self.cancel()
                // empty
            }
            
            //
            
            
        })
        
        
    }
    func listenerCancelTripAlert(){
        
        let ref = FIRDatabase.database().reference()

        ref.child("drivers_data").child("\(self.appDelegate.userid!)").child("accept").observe(.childChanged, with: { (snapshot) in
            
            let status1 = snapshot.value as Any
            print(status1)
            var statusClr = "\(status1)"
            statusClr = statusClr.replacingOccurrences(of: "Optional(", with: "")
            statusClr = statusClr.replacingOccurrences(of: ")", with: "")
            print(statusClr)
            
            if(statusClr == "5"){
                
                print("test \(self.driverClickedCancelPass)")
                
                self.observeCancelTripWithPutNotification()

//                if self.driverClickedCancelPass == "clicked"{
//                    
//                    self.observeCancelTrip()
//                    //self.observeCancelTripWithPutNotification()
//                    
//                }
//                else{
//                    
//                    self.observeCancelTripWithPutNotification()
//                    
//                }
//                
                
            }
            else{
                
                
            }
            
        })
    }
    func playAlertSound() {
        if  !isnotify {
            isnotify = true
            var soundID: SystemSoundID = 1003
            guard let soundPath = Bundle.main.path(forResource: "beep", ofType: ".mp3") else { return }
            let requesturl = NSURL(fileURLWithPath: soundPath)
            AudioServicesCreateSystemSoundID(requesturl, &soundID)
            AudioServicesPlaySystemSound(soundID)
            let pointer = Unmanaged.passUnretained(self).toOpaque()
            AudioServicesAddSystemSoundCompletion(soundID, nil, nil, { (soundID, pointer) in
                print("Alert notify")
                let mySelf = Unmanaged<ADHomePageVC>.fromOpaque(pointer!).takeUnretainedValue()
                mySelf.isnotify = false
                AudioServicesRemoveSystemSoundCompletion(soundID)
                AudioServicesDisposeSystemSoundID(soundID)
            }, pointer)
        }
    }
    
    func playSound() {
        
        let url = Bundle.main.url(forResource: "alarm_iphone", withExtension: "mp3")!
        
        do {
            
            player = try AVAudioPlayer(contentsOf: url)
            guard let player = player else { return }
            
            player.prepareToPlay()
            player.play()
            
        } catch let error as NSError {
            
            print(error.description)
        }
        
    }
    
    func tripID(){
        
        let ref = FIRDatabase.database().reference()
        
        
        //        let geoFire = GeoFire(firebaseRef: ref.child("drivers_data").child("\(self.appDelegate.userid!)").child("accept"))
        let geoFire = GeoFire(firebaseRef: ref.child("drivers_data").child("\(self.appDelegate.userid!)").child("accept"))
        
        // let geoFire = GeoFire(firebaseRef: ref.child("drivers_data/5857c2bada71b4d9708b4567/"))
        
        print(geoFire!.firebaseRef(forLocationKey: "geolocation"))
        
        // updated
        ref.child("drivers_data").child("\(self.appDelegate.userid!)").child("accept").observe(.childChanged, with: { (snapshot) in
            
            print("updating")
            let status1 = snapshot.value as Any
            print(status1)
            var status = "\(status1)"
            status = status.replacingOccurrences(of: "Optional(", with: "")
            status = status.replacingOccurrences(of: ")", with: "")
            print(status)
            if(status == "1"){
                
                
            
                //accept
                //get values from firebase after accepting
                
            }
            else if(status == "0"){
                //not accept or busy
                self.cancel()
            }
            else if(status == "5") || (status == ""){
                
                
                self.observeCancelTrip()
            }
            else{
                self.cancel()
                // empty
            } // */
            
            //
            
            
        })
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        UIApplication.shared.statusBarStyle = .default

        let value = UserDefaults.standard.object(forKey: "maintain") as? String
        print(value)
        
        
        self.getTripStatus()
        self.callCarListCategoryValues()

       /* self.viewMap.addSubview(self.viewContact)
        self.viewContact.backgroundColor = UIColor.black
        self.viewContact.alpha = 0.5*/
        
        UNUserNotificationCenter.current().delegate = self
        
        locationManager.startUpdatingLocation()
        
        self.checkPhNumber()
        
        UIApplication.shared.isIdleTimerDisabled = true

        navigationController!.isNavigationBarHidden = true
        
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        
        locationManager.delegate = self
        locationManager.activityType = .fitness
        
        if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.notDetermined{
            
            locationManager.requestWhenInUseAuthorization()
        }
        else if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse{
            
            if let loc = locationManager.location {
                currentLocation = loc
                locationManager.startUpdatingLocation()
            }
        }
        else if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways{
            
            if let loc = locationManager.location {
                currentLocation = loc
                locationManager.startUpdatingLocation()
            }
            
        }
        else if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.restricted{
            
            
        }
        else
        {
            //denied
            
            var alertController = UIAlertController (title: "Location Service Permission Denied", message: "please open settings and set location access to 'While Using the App'", preferredStyle: .alert)
            
            var settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
                let settingsUrl = NSURL(string: UIApplicationOpenSettingsURLString)
                if let url = settingsUrl {
                    
                    UIApplication.shared.openURL(url as URL)
                }
            }
            
            var cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
            alertController.addAction(settingsAction)
            alertController.addAction(cancelAction)
            
            present(alertController, animated: true, completion: nil)
        }

        self.markTestInsideView.textColor = UIColor(red: 91.0/255.0, green: 91.0/255.0, blue: 91.0/255.0, alpha: 1.0)
        //   self.markTestInsideView.textColor = UIColor.darkGray
        self.markTestView.alpha = 0.6
        
        self.markTestInsideView.backgroundColor = UIColor.clear
        self.markTestInsideView.textColor = UIColor.black
        self.markTestInsideView.scrollSpeed = 30
        self.markTestInsideView.textAlignment = .center
        self.markTestInsideView.scrollDirection = .left
        self.markTestInsideView.pauseInterval = 0.1
        
        self.markTestView.layer.cornerRadius = 2.0
        self.markTestView.layer.borderWidth = 1.0
        self.markTestView.layer.borderColor = UIColor.clear.cgColor
        self.markTestView.clipsToBounds = true
        
        
        let oneTime = UserDefaults.standard.object(forKey: "oneTime") as! String!
        
        print("oneTime\(oneTime)")
        
        if oneTime == nil{
            
            self.viewMap.addSubview(viewRequestNew)

            self.callOneTime()

        }
        else{
            
          /*  let progressView1 = GMDCircularProgressView(frame: CGRect(origin: CGPoint.zero, size: CGSize(width:280, height:280)))
            progressView1.center = self.viewRequestNew.center
          //  progressView1.animateProgressView()
            self.viewCirlceNew.addSubview(progressView1)
            self.viewCirlceNew.addSubview(viewExtraMap)
            
            viewExtraMap.layer.cornerRadius = viewExtraMap.frame.size.width / 2
            viewExtraMap.clipsToBounds = true*/
            
        }
        let ref = FIRDatabase.database().reference()

        ref.child("drivers_data").child("\(self.appDelegate.userid!)").child("accept").child("tollfee").observeSingleEvent(of:.value, with: { (snapshot) in
                
                print("updating toll status")
                if(snapshot.exists()){
                    let status1 = snapshot.value as Any
                    print(status1)
                    var status = "\(status1)"
                    status = status.replacingOccurrences(of: "Optional(", with: "")
                    status = status.replacingOccurrences(of: ")", with: "")
                    print(status)                    
                    self.appDelegate.final_tollfee = String(status)
                    self.appDelegate.previous_tollfee = String(status)
                }
                else{
                    self.appDelegate.final_tollfee = "0"
                }
                print(self.appDelegate.final_tollfee)
            })
        

        // if the onlinestatusnew is on then the user is approved by admin and it has checked already.
        self.locationManager.startUpdatingLocation()

  
    }
    
    
    func callCarListCategoryValues(){
        
        self.arrayOfMaxSize.removeAllObjects()
        self.arrayOfMaxSize.remove("")
        self.arrayOfMinFare.removeAllObjects()
        self.arrayOfMinFare.remove("")
        self.arrayOfPrice_MIN.removeAllObjects()
        self.arrayOfPrice_MIN.remove("")
        self.arrayOfPrice_KM.removeAllObjects()
        self.arrayOfPrice_KM.remove("")
        self.arrayOfCarCategory.removeAllObjects()
        self.arrayOfCarCategory.remove("")
        self.arrayOftaxpercent.removeAllObjects()
        self.arrayOftaxpercent.remove("")
       // self.loadview.isHidden = false
        
        var urlstring:String = "\(live_request_url)Settings/getCategory"
        
        
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
                else{
                    
                }
                print("KMMM")
                print(jsonObjects)
                for dataDict : Any in jsonObjects
                {
                    
                    if jsonObjects.count == 0{
                        
                        
                        
                    }
                    else{
                        
                        let maxSize = (dataDict as AnyObject).object(forKey: "max_size") as? String
                        let minFare = (dataDict as AnyObject).object(forKey: "price_fare") as? String
                        let perMIN = (dataDict as AnyObject).object(forKey: "price_minute") as? String
                        let perKM = (dataDict as AnyObject).object(forKey: "price_km") as? String
                        let taxpercentage = (dataDict as AnyObject).object(forKey: "tax_percentage") as? String
                        
                        print("\(maxSize),\(minFare),\(perMIN),\(perKM),\(taxpercentage)")
                        if maxSize == nil{
                            
                            let value1 = 0
                            self.arrayOfMaxSize.add(value1)
                        }
                        else{
                            
                            self.arrayOfMaxSize.add(maxSize! as String)
                        }
                        
                        if minFare == nil{
                            
                            let value2 = 0
                            self.arrayOfMinFare.add(value2)
                        }
                        else{
                            
                            self.arrayOfMinFare.add(minFare! as String)
                            
                        }
                        
                        if perMIN == nil{
                            
                            let value3 = 0
                            self.arrayOfPrice_MIN.add(value3)
                        }
                        else{
                            
                            self.arrayOfPrice_MIN.add(perMIN! as String)
                        }
                        
                        if perKM == nil{
                            
                            let value4 = 0
                            self.arrayOfPrice_KM.add(value4)
                            
                        }
                        else{
                            
                            self.arrayOfPrice_KM.add(perKM! as String)
                            
                            
                        }
                        if taxpercentage == nil{
                            
                            let value5 = 0
                            self.arrayOftaxpercent.add(value5)
                        }
                        else{
                            
                            self.arrayOftaxpercent.add(taxpercentage! as String)
                        }
                    }
                    
                    
                }
                
                print("\(self.arrayOfMaxSize),\(self.arrayOfMinFare),\(self.arrayOfPrice_MIN),\(self.arrayOfPrice_KM),\(self.arrayOftaxpercent)")
                //self.loadview.isHidden = true
                
        },
            failure: { (operation: AFHTTPRequestOperation?,error: Error) in
                print("Error: " + error.localizedDescription)
                
                
        })
        
    }

    func testpost(){
        var urlstring:String = "http://datamall2.mytransport.sg/ltaodataservice/ERPRates"
        
        var parametr = ["Accountkey" : "MH/khxMxSbq0OTgUqJ0lxQ=="]
        urlstring = urlstring.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!
        
        print(urlstring)
        
        let manager : AFHTTPRequestOperationManager = AFHTTPRequestOperationManager()
        
        manager.responseSerializer.acceptableContentTypes =  NSSet(objects: "text/plain", "text/html", "application/json", "audio/wav", "application/octest-stream") as Set<NSObject>
        
        manager.post("\(urlstring)",
            parameters: parametr,
            success: { (operation: AFHTTPRequestOperation?,responseObject: Any?) in
                
                let jsonObjects:NSArray = responseObject as! NSArray
                print(jsonObjects)
        },
            failure: { (operation: AFHTTPRequestOperation?,error: Error) in
                print("Error: " + error.localizedDescription)
                
                
        })
    }
    func checkGoOnline(){
        
        goOnline.setTitle("GO ONLINE",for: .normal)
        //self.onlineStatusNew = "off"
        UserDefaults.standard.set(self.onlineStatusNew, forKey: "maintain")
        self.locationUpdate.stopLocationTracking()
        self.locationManager.stopUpdatingLocation()
        callApiMaintainStatusOff()
    }
    
    func callOneTime(){
        
        let progressView1 = GMDCircularProgressView(frame: CGRect(origin: CGPoint.zero, size: CGSize(width:280, height:280)))
        progressView1.center = self.viewRequestNew.center
        progressView1.animateProgressView()
        self.viewCirlceNew.addSubview(progressView1)
        self.viewCirlceNew.addSubview(viewExtraMap)
        viewExtraMap.layer.cornerRadius = viewExtraMap.frame.size.width / 2
        viewExtraMap.clipsToBounds = true
        let oneTime = "1"
        UserDefaults.standard.setValue(oneTime, forKey: "oneTime")
    
    }
    
    func setDropLoc(){

        if UserDefaults.standard.value(forKey: "Droplat") != nil{
            if UserDefaults.standard.value(forKey: "Droplng") != nil{
                print("not empty")
                var dropLat = UserDefaults.standard.value(forKey: "Droplat") as? String
                var dropLng = UserDefaults.standard.value(forKey: "Droplng") as? String
                
                dropLat = dropLat?.replacingOccurrences(of: "Optional(", with: "")
                dropLat = dropLat?.replacingOccurrences(of: ")", with: "")
                dropLat = dropLat?.replacingOccurrences(of: "\"", with: "")

                dropLng = dropLng?.replacingOccurrences(of: "Optional(", with: "")
                dropLng = dropLng?.replacingOccurrences(of: ")", with: "")
                dropLng = dropLng?.replacingOccurrences(of: "\"", with: "")
                    if (dropLat != "") || (dropLng != ""){
                        self.dropDestination = CLLocation(latitude: Double(dropLat!)!,longitude: Double(dropLng!)!)
                        self.getCurrnentAddress(myLocation: self.dropDestination)
                        self.updatedloc = "0"
                        
                    }
            }
        }
    }
    
    func setPickupLoc(){
        
        
        if UserDefaults.standard.value(forKey: "pickuplat") != nil{
            if UserDefaults.standard.value(forKey: "pickuplng") != nil{
                print("not empty")
                var pickuplat = UserDefaults.standard.value(forKey: "pickuplat") as? String
                var pickuplng = UserDefaults.standard.value(forKey: "pickuplng") as? String
                
                pickuplat = pickuplat?.replacingOccurrences(of: "Optional(", with: "")
                pickuplat = pickuplat?.replacingOccurrences(of: ")", with: "")
                pickuplat = pickuplat?.replacingOccurrences(of: "\"", with: "")
                
                pickuplng = pickuplng?.replacingOccurrences(of: "Optional(", with: "")
                pickuplng = pickuplng?.replacingOccurrences(of: ")", with: "")
                pickuplng = pickuplng?.replacingOccurrences(of: "\"", with: "")
                
                if (pickuplat != "") || (pickuplng != ""){
                    self.pickupLocation = CLLocation(latitude: Double(pickuplat!)!,longitude: Double(pickuplng!)!)
                    self.getCurrnentAddress(myLocation: self.pickupLocation)
                    self.updatedloc = "0"
                }
            }
        }
    }
    
    
    func setPolylineDrop(){
        
        if UserDefaults.standard.value(forKey: "pickuplat") != nil{
            if UserDefaults.standard.value(forKey: "pickuplng") != nil{
                
                print("not empty")
               var pickuplat = UserDefaults.standard.value(forKey: "pickuplat") as? String
                var pickuplng = UserDefaults.standard.value(forKey: "pickuplng") as? String
               
                pickuplat = pickuplat?.replacingOccurrences(of: "Optional(", with: "")
                pickuplat = pickuplat?.replacingOccurrences(of: ")", with: "")
                pickuplat = pickuplat?.replacingOccurrences(of: "\"", with: "")
                
                pickuplng = pickuplng?.replacingOccurrences(of: "Optional(", with: "")
                pickuplng = pickuplng?.replacingOccurrences(of: ")", with: "")
                pickuplng = pickuplng?.replacingOccurrences(of: "\"", with: "")
                
                if (pickuplat != "") || (pickuplng != ""){
                    self.myDestination = CLLocation(latitude: Double(pickuplat!)!,longitude: Double(pickuplng!)!)
                    
                }
            }
        }
        
        if UserDefaults.standard.value(forKey: "Droplat") != nil{
            if UserDefaults.standard.value(forKey: "Droplng") != nil{
                
                print("not empty")
                var dropLat = UserDefaults.standard.value(forKey: "Droplat") as? String
                var dropLng = UserDefaults.standard.value(forKey: "Droplng") as? String
                
                dropLat = dropLat?.replacingOccurrences(of: "Optional(", with: "")
                dropLat = dropLat?.replacingOccurrences(of: ")", with: "")
                dropLat = dropLat?.replacingOccurrences(of: "\"", with: "")
                
                dropLng = dropLng?.replacingOccurrences(of: "Optional(", with: "")
                dropLng = dropLng?.replacingOccurrences(of: ")", with: "")
                dropLng = dropLng?.replacingOccurrences(of: "\"", with: "")
                if self.acceptBtnTapped == 1 {
                        self.autoUpdateforLocation()
                    }
                    else{
                    if (dropLat != "") || (dropLng != ""){
                        self.dropDestination = CLLocation(latitude: Double(dropLat!)!,longitude: Double(dropLng!)!)
                    }
                }
            }
        }
    }



    func callApiMaintainStatusOn(){
        
        statusOnNew = 1
        
        self.getTripStatus()

        self.locationManager.startUpdatingLocation()
        
        var urlstring:String = "\(signInAPIUrl)updateOnlineStatus/userid/\(self.appDelegate.userid!)/online_status/\(statusOnNew!)"
        
        urlstring = urlstring.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!
        print(urlstring)
        

        
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

    func callApiMaintainStatusOff(){
        
        let offlineLocation = CLLocation(latitude: 0.00, longitude: 0.00)

        self.locationManager.stopUpdatingLocation()
        
        var carCategory = UserDefaults.standard.object(forKey: "carCategoryRegister") as! String

        let ref1 = FIRDatabase.database().reference()
        let geofire = GeoFire(firebaseRef: ref1.child("drivers_location").child("\(carCategory)"))
        
        geofire?.setLocation(CLLocation(latitude: offlineLocation.coordinate.latitude, longitude: offlineLocation.coordinate.longitude), forKey: "\(self.appDelegate.userid!)", forBearing: "0.0" , withCompletionBlock:
            { (error) in
                
                print(error)
                if (error != nil) {
                    
                    print("Your are now offline")
                    
                }
                else{
                    
                }
        })
        
        self.locationManager.stopUpdatingLocation()
        self.locationManager.stopUpdatingHeading()
        statusOnNew = 0
        
        var urlstring:String = "\(signInAPIUrl)updateOnlineStatus/userid/\(self.appDelegate.userid!)/online_status/\(statusOnNew!)"
        
        urlstring = urlstring.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!
        print(urlstring)
        
        
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
    
    @IBAction func sidemenuBtnAction(_ sender: Any) {
        
        self.navigationController?.pushViewController(ADEditProfileVC(), animated: true)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        sourceView.layer.layoutIfNeeded()
        pulsator.position = sourceView.layer.position
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func btnProfilePageAction(_ sender: Any) {
        
        if(self.appDelegate.tostopcallingfunc == "0"){
        self.checkOnOffFirebaseStatusWithOutAlert()
           self.appDelegate.gotosettings = "1"
        }
        self.locationManager.stopUpdatingLocation()
        self.navigationController?.pushViewController(ADViewProfileVC(), animated: true)

    }
    
    @IBAction func btnEarningsAction(_ sender: Any) {
        
        //self.playAlertSound()
        if(goOnline.currentTitle != "GO ONLINE"){
            self.appDelegate.timeatonline = timeatonline
            self.appDelegate.testvalue = "1"
        }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let subContentsVC = storyboard.instantiateViewController(withIdentifier: "AREarnVC") as! ARReferalVC
        self.navigationController?.pushViewController(subContentsVC, animated: true)
        
        //self.navigationController?.pushViewController(AREarningsVC(), animated: true)
        
    }
    @IBAction func btnRatingsVC(_ sender: Any) {
        
        self.navigationController?.pushViewController(ADRatingsVC(), animated: true)
    }
    
    
    @IBAction func btnGoOnline(_ sender: Any) {
        locationManager.startUpdatingHeading()

        
        let value = UserDefaults.standard.object(forKey: "maintain") as? String
        
        print(value)
        if value == nil{
            
            self.checkOnOffFirebaseStatusWithAlert()
            
        }
        else if value == "on"{
            count += 1
           self.goOfflineAlert()
            let ref1 = FIRDatabase.database().reference().child("drivers_data").child(self.appDelegate.userid!)
            ref1.updateChildValues(["online_status": "0"])
        }
        else if value == "off"{
            self.makeDriverOnline()
            
        }
        else {
            
            // on to off while button is clicking
            // on to on while will appear
            // check here user is approved or not
            // call approve url self.approveStatus()
            
            
            self.checkOnOffFirebaseStatusWithAlert()
            
            
          //  self.approveStatus()

            
        }

        
       // progress.isHidden = false
       
    }
 
 func makeDriverOnline() {
    
    let ref1 = FIRDatabase.database().reference().child("drivers_data").child(self.appDelegate.userid!)
    ref1.child("block_status").observeSingleEvent(of: .value, with:{ (snapshot) in
        
        if(snapshot.exists()){
            let blockStatus = snapshot.value as Any
            print(blockStatus)
            var status = "\(blockStatus)"
            status = status.replacingOccurrences(of: "Optional(", with: "")
            status = status.replacingOccurrences(of: ")", with: "")
            
            if Int(status) == 0 {
                self.count1 += 1
                self.goOnlineAlert()
                ref1.updateChildValues(["online_status": "1"])
            }
            else{
                let warning = MessageView.viewFromNib(layout: .CardView)
                warning.configureTheme(.warning)
                warning.configureDropShadow()
                let iconText = "" //"😶"
                warning.configureContent(title: "", body: "Your access has been deactivated. If you have any questions, email us at - info@sixtnc.com", iconText: iconText)
                warning.button?.isHidden = true
                var warningConfig = SwiftMessages.defaultConfig
                warningConfig.presentationContext = .window(windowLevel: UIWindowLevelStatusBar)
                SwiftMessages.show(config: warningConfig, view: warning)
            }
        }
        else{
            self.count1 += 1
            self.goOnlineAlert()
            ref1.updateChildValues(["online_status": "1"])
        }

    } )
    

 }
    func checkOnOffFirebaseStatusWithOutAlert(){
        
        let ref = FIRDatabase.database().reference()
        
        let userId = self.appDelegate.userid!
        
        if(userId != ""){
            
            ref.child("drivers_data").child("\(userId)").child("proof_status").observeSingleEvent(of:.value, with: { (snapshot) in
                print("updating proof status \(snapshot.value)")
                let status1 = snapshot.value as Any
                print(status1)
                var status = "\(status1)"
                status = status.replacingOccurrences(of: "Optional(", with: "")
                status = status.replacingOccurrences(of: ")", with: "")
                print(status)
                
                if status == "Pending" {
                    self.checkGoOnline()
                }else{
                     self.approvedWithOutAlert()
                }
                
            })
            
        }
        else{
            
            
        }
    }

    func checkOnOffFirebaseStatusWithAlert(){
        
        let ref = FIRDatabase.database().reference()
        
        let userId = self.appDelegate.userid!
        
        if(userId != ""){
            
            
            ref.child("drivers_data").child("\(userId)").child("proof_status").observe(.value, with: { (snapshot) in
                
                let status1 = snapshot.value as Any
                print(status1)
                var status = "\(status1)"
                status = status.replacingOccurrences(of: "Optional(", with: "")
                status = status.replacingOccurrences(of: ")", with: "")
                print(status)

                if status == "Pending" {
                    self.notApproved()
                }
                else{
                    
                    self.approved()
                }
            })
            
        }
        else{
            
            
        }
    }
    
  /*  func approveStatus(){
        
        
        Alamofire.request("\(signInAPIUrl)checkProofStatus/userid/\(self.appDelegate.userid!)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON(completionHandler: { (response) in
            //            print(response)
            do{
                
                let readableJSon:NSArray! = try JSONSerialization.jsonObject(with: response.data!, options: .mutableContainers) as? NSArray
                
                //print(" !!! \(readableJSon["results"]!)")
                
                if let value:NSDictionary = readableJSon[0] as? NSDictionary{
                    print(value)
                    var proof:String! = value["proof_status"] as? String
                    proof = proof.removingPercentEncoding
                    proof = proof.replacingOccurrences(of: "Optional(", with: "")
                    proof = proof.replacingOccurrences(of: ")", with: "")
                    
                    if proof == "Accepted"{
                        
                      /*  self.goOnline.setTitle("GO OFFLINE",for: .normal)
                        
                        self.onlineStatusNew = "on"
                        UserDefaults.standard.set(self.onlineStatusNew, forKey: "maintain")
                        
                        let iconText = "" //"🤔"
                        let success = MessageView.viewFromNib(layout: .CardView)
                        success.configureTheme(.success)
                        success.configureDropShadow()
                        success.configureContent(title: "", body: "You are now online", iconText: iconText)
                        success.button?.isHidden = true
                        var successConfig = SwiftMessages.defaultConfig
                        successConfig.presentationStyle = .top
                        successConfig.presentationContext = .window(windowLevel: UIWindowLevelNormal)
                        
                        SwiftMessages.show(config: successConfig, view: success)
                        
                        self.callApiMaintainStatusOn()*/

                        //end viewwill appear
                        
                        self.approved()
                    }
                    else if proof == "Pending"{
                        
                        self.notApproved()
                        
                    }
                    else{
                        
                        self.approved()
                    }
                }
            }
            catch{
                
                print(error)
                
            }
            
        })
        
    }*/

    func approved(){
        let ref = FIRDatabase.database().reference()
        let userId = self.appDelegate.userid!

        ref.child("drivers_data").child("\(userId)").child("online_status").observe(.value, with: { (snapshot) in
            if (snapshot.exists()) {
                let status1 = snapshot.value as Any
                print(status1)
                var status = "\(status1)"
                status = status.replacingOccurrences(of: "Optional(", with: "")
                status = status.replacingOccurrences(of: ")", with: "")
                print(status)
                print("updating proof status \(status)")
                if(status == "1"){
                    self.makeDriverOnline()

                }else{
                    self.count += 1
                    self.goOfflineAlert()
                }
            }else{
                self.makeDriverOnline()
            }
        })
        
    }
    
    func notApprovedWithOutAlert(){
        
        goOnline.setTitle("GO ONLINE",for: .normal)
        
        self.onlineStatusNew = "off"
        UserDefaults.standard.set(self.onlineStatusNew, forKey: "maintain")
        callApiMaintainStatusOff()
        
        
    }

    func approvedWithOutAlert(){
        
        self.goOnline.setTitle("GO OFFLINE",for: .normal)
        if(self.appDelegate.gotosettings != "1"){
        self.onlineStatusNew = "on"
        }
        UserDefaults.standard.set(self.onlineStatusNew, forKey: "maintain")

        self.callApiMaintainStatusOn()

    }
    
    func notApproved(){
        
        goOnline.setTitle("GO ONLINE",for: .normal)
        
      //  self.onlineStatusNew = "off"
      //  UserDefaults.standard.set(self.onlineStatusNew, forKey: "maintain")
        
        let warning = MessageView.viewFromNib(layout: .CardView)
        warning.configureTheme(.warning)
        warning.configureDropShadow()
        let iconText = "" //"😶"
        warning.configureContent(title: "", body: "Your proof status was pending", iconText: iconText)
        warning.button?.isHidden = true
        var warningConfig = SwiftMessages.defaultConfig
        warningConfig.presentationContext = .window(windowLevel: UIWindowLevelStatusBar)
        SwiftMessages.show(config: warningConfig, view: warning)
        
        callApiMaintainStatusOff()
        

    }
    
    func goOfflineAlert(){
        
        self.count1 = 0
        
        goOnline.setTitle("GO ONLINE",for: .normal)
        
        self.onlineStatusNew = "off"
        UserDefaults.standard.set(self.onlineStatusNew, forKey: "maintain")
        
        let warning = MessageView.viewFromNib(layout: .CardView)
        warning.configureTheme(.warning)
        warning.configureDropShadow()
        let iconText = "" //"😶"
        warning.configureContent(title: "", body: "You are offline now", iconText: iconText)
        warning.button?.isHidden = true
        var warningConfig = SwiftMessages.defaultConfig
        warningConfig.presentationContext = .window(windowLevel: UIWindowLevelStatusBar)
        SwiftMessages.show(config: warningConfig, view: warning)
        
        callApiMaintainStatusOff()
        
        if(count == 1){
        onlineduration = Int(NSDate().timeIntervalSince(timeatonline as Date))
           // onlineduration = Int(NSDate().value(forKey: <#T##String#>)//timeIntervalSince(timeatonline as Date))

        self.calculatedduration = self.calculatedduration + onlineduration
        self.appDelegate.toupdateonlogout = self.calculatedduration
        UserDefaults.standard.setValue(self.appDelegate.toupdateonlogout, forKey: "online1duration")
        self.appDelegate.calculatedduration = self.calculatedduration

        self.Duration(Int(self.calculatedduration))
        UserDefaults.standard.setValue("1", forKey: "onlinealert")
        }
        else{
            
        }
    }
    
    func Duration(_ seconds: Int) {
        print(seconds)
        
        let second = Int(seconds / 60) % 60
        if(second == 00){
            self.setStatusText(text: String(format: "%0.2d sec", Int(seconds % 60)))
        }
        else{
            self.setStatusText(text: String(format: "%0.2d hr %0.2d min", Int(seconds / 3600) % 24, Int(seconds / 60) % 60))
        }
    }
    
    func setStatusText(text: String) {
        self.appDelegate.tothoursonline = text
        print("tothoursonline in home page\(self.appDelegate.tothoursonline)")
        let userdefaults = UserDefaults.standard.set(self.appDelegate.tothoursonline, forKey: "throughonline")
        let result = UserDefaults.standard.value(forKey: "throughonline")
        print("userdefault in home page\(result)")
        let olduserdefaults = UserDefaults.standard.set(result, forKey: "result")
        let oldresult  = UserDefaults.standard.value(forKey: "result")
        print("oldresult:\(oldresult)")
    
    }

    
    func goOnlineAlert(){
        
        self.goOnline.setTitle("GO OFFLINE",for: .normal)
         
         self.onlineStatusNew = "on"
         UserDefaults.standard.set(self.onlineStatusNew, forKey: "maintain")
         
         let iconText = "" //"🤔"
         let success = MessageView.viewFromNib(layout: .CardView)
         success.configureTheme(.success)
         success.configureDropShadow()
         success.configureContent(title: "", body: "You are now online", iconText: iconText)
         success.button?.isHidden = true
         var successConfig = SwiftMessages.defaultConfig
         successConfig.presentationStyle = .top
         successConfig.presentationContext = .window(windowLevel: UIWindowLevelNormal)
         
         SwiftMessages.show(config: successConfig, view: success)

         self.callApiMaintainStatusOn()
        print(count1)
        if(count1 == 1){
        var alert = UserDefaults.standard.object(forKey: "onlinealert") as? String
        if alert != nil{
            print(alert)
            if(alert == "0"){
            self.timeatonline = (UserDefaults.standard.object(forKey: "timeatonline") as? NSDate)!
            }
            else{
                self.timeatonline = NSDate()
            }
        }
        else{
         self.timeatonline = NSDate()
        }
        }
        
         UserDefaults.standard.setValue(timeatonline, forKey: "timeatonline")
         UserDefaults.standard.setValue("0", forKey: "onlinealert")
        
         self.count = 0
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    func updateLocationLabel(withText text: String) -> Void {
        
     //   self.locationLabel.text = "Location: \(text)"
        
    }
    // MARK: CLLocationManagerDelegate method implementation
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.authorizedWhenInUse {
            
            locationManager.startUpdatingLocation()
            
            viewMap.isMyLocationEnabled = true
            viewExtraMap.isMyLocationEnabled = true
            viewMap.settings.myLocationButton = false
        }
    }
    
    // MARK: GMSMapViewDelegate method implementation
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        
        self.btnGps.isHidden = false
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        
        
    }
    
    
    @IBAction func btnGpsAction(_ sender: Any) {
        
        
      //  self.notification()  //check
        
        self.btnGps.isHidden = true
        
        if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.denied{
            
            var alertController = UIAlertController (title: "Location Service Permission Denied", message: "please open settings and set location access to 'While Using the App'", preferredStyle: .alert)
            
            var settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
                let settingsUrl = NSURL(string: UIApplicationOpenSettingsURLString)
                if let url = settingsUrl {
                    
                    UIApplication.shared.openURL(url as URL)
                }
            }
            
            var cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
            alertController.addAction(settingsAction)
            alertController.addAction(cancelAction)
            
            present(alertController, animated: true, completion: nil)
            
            self.btnGps.isHidden = false
        }
        else
        {
            let camera = GMSCameraPosition.camera(withLatitude: (currentLocation.coordinate.latitude),longitude: (currentLocation.coordinate.longitude),zoom: 16)
            
            self.viewMap.camera = camera
            
            self.viewMap.padding = UIEdgeInsetsMake(64,10,0,0)

            self.btnGps.isHidden = false
        }

    }
    func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {
        
        if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.denied{
            
            var alertController = UIAlertController (title: "Location Service Permission Denied", message: "please open settings and set location access to 'While Using the App'", preferredStyle: .alert)
            
            var settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
                let settingsUrl = NSURL(string: UIApplicationOpenSettingsURLString)
                if let url = settingsUrl {
                    
                    UIApplication.shared.openURL(url as URL)
                }
            }
            
            var cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
            alertController.addAction(settingsAction)
            alertController.addAction(cancelAction)
            
            present(alertController, animated: true, completion: nil)
            
        }
        else
        {
            let camera = GMSCameraPosition.camera(withLatitude: (currentLocation.coordinate.latitude),longitude: (currentLocation.coordinate.longitude),zoom: 16)
            
            self.viewMap.camera = camera
        }
        
        return true
    }
    // 6
    
   
    
    var tripIsStarted = "no"
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.first {
            
            if location != nil{
               
//                self.abc()


                self.currentLocation = location
                
                self.appDelegate.currlocation = self.currentLocation
            }
            
            let ref = FIRDatabase.database().reference()
            //print("locations are \(location.coordinate.latitude) and \(location.coordinate.longitude)")
            //let geoFire = GeoFire(firebaseRef: ref.child("drivers_location/\(self.appDelegate.userid!)"))
//            let geoFire = GeoFire(firebaseRef: ref.child("drivers_location/\(self.appDelegate.userid!)")) // old
            
            //carCategoryRegister
            if((UserDefaults.standard.object(forKey: "carCategoryRegister")) != nil){
                let carCategory = UserDefaults.standard.object(forKey: "carCategoryRegister") as! String
                let geoFire = GeoFire(firebaseRef: ref.child("drivers_location").child("\(carCategory)"))
                let final_bear = Double(round(100*self.course!)/100)
                
                geoFire!.setLocation(CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude), forKey: "\(self.appDelegate.userid!)", forBearing: "\(final_bear)") { (error) in
                    if (error != nil) {
                        //  print("An error occured: \(error)")
                    }
                    else{
                        
                        ref.child("drivers_location").observeSingleEvent(of: .value, with: { (snapshot) in
                            if snapshot.value != nil{
                                
                                let dict = snapshot.value as? NSDictionary
                                if snapshot.children.allObjects is [FIRDataSnapshot] {
                                    
                                    if let gandoValues = dict?["\(self.appDelegate.userid!)"] as? NSDictionary{
                                        
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
                                        if let reqStatus = gandoValues["request"] as? NSDictionary{
                                            if let status = reqStatus["status"]{
                                                // print(status)
                                                if(Int("\(status)") != Int("1")){
                                                    // print(Int("\(status)") != Int("1"))
                                                    //self.cancel()
                                                }
                                                else {
                                                    
                                                    //      if(self.incoming == 0){  // static
                                                    
                                                    
                                                    if(reqStatus["req_id"] as! String != ""){
                                                        self.request_id = reqStatus["req_id"] as! String
                                                        //   self.appDelegate.request_id = self.request_id
                                                        //    print("appdelegate request")
                                                    }
                                                    
                                                    /*    self.setphone = true
                                                     
                                                     if self.setphone == true{
                                                     
                                                     self.viewPhone.isHidden = false
                                                     self.pulsator.start()
                                                     self.pulsator.radius = 100
                                                     self.pulsator.numPulse = 4
                                                     
                                                     }
                                                     else{
                                                     
                                                     self.viewPhone.isHidden = true
                                                     self.pulsator.stop()
                                                     
                                                     }
                                                     self.requestView.isHidden = false
                                                     self.accepted = "1"
                                                     self.incoming = 1  // for existed request
                                                     // here incoming contains a request for the logged in driver
                                                     self.progress.animate(fromAngle: 0, toAngle: 360, duration: 15) { completed in
                                                     if completed {
                                                     print("animation stopped, completed")
                                                     self.timer.invalidate()
                                                     } else {
                                                     print("animation stopped, was interrupted")
                                                     }
                                                     }
                                                     self.getNextPoseData()
                                                     self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ADHomePageVC.setProgressBar), userInfo: nil, repeats: true)
                                                     */
                                                    
                                                    
                                                    
                                                    //     } // static
                                                    
                                                }
                                            }
                                            
                                        }
                                        if let acceptStatus = gandoValues["accept"] as? NSDictionary{
                                            if let status = acceptStatus["status"] as? String{
                                                //print(status)
                                                self.trip_status = status
                                                
                                            }
                                            if let tripid = acceptStatus["trip_id"] as? String{
                                                //print(tripid)
                                                self.trip_id = tripid
                                                
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
                        
                       
                        
                    } /* else {
                     print(snapshot.value)
                     print("Saved location successfully!")
                     
                     }*/
                }
                
               // let ref1 = FIRDatabase.database().reference().child("drivers_location").child("\(carCategory)").child(self.appDelegate.userid!)
                
                //ref1.updateChildValues(["Bearing": "\(self.angle!)"])
            }
              //// */
            
           /* if(bearing == true){
                
                print("locations are \(location.coordinate.latitude) and \(location.coordinate.longitude)")

                self.myOrigin = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                
                let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,longitude: location.coordinate.longitude,zoom: 16)

                print(currentLocation.coordinate.latitude)
                print(self.myOrigin.coordinate.latitude)
                print("check")
                if(self.currentLocation.coordinate.latitude == self.myOrigin.coordinate.latitude){
                    
                    // curent location not changes in this value because the value set as default for set for maker in the mapview.
                    // No changes need in map where the locaiton is same for start and current locaiton.
                    
                }
                else{
                    
                    // to update our current location where we turned out of path from polyline.
                    

                    self.getting DirectionsAPI()
                    
                    let marker = GMSMarker()
                    
                    marker.position = CLLocationCoordinate2D(latitude: self.myOrigin.coordinate.latitude, longitude: self.myOrigin.coordinate.longitude)
                    
                    marker.snippet = "Bearing Location"
                    marker.appearAnimation = kGMSMarkerAnimationNone
                    marker.icon = UIImage(named: "Drivers.png")
                    marker.map = self.viewMap
                    
                    //   marker.rotation = marker2.position.latitude
                    
                    
                    self.viewMap.animate(toBearing: self.getBearing(toPoint: marker.position))
                    //self.viewMap.camera = camera
                    //self.viewMap.animate(to: camera)
                    
                    
                    //                self.getCurrentLocation()
                }

            } */
            
            // for below conditions to check offline and online status
            if (self.accepted == "yes"){
                
            }
            else{
               
                let value = UserDefaults.standard.object(forKey: "maintain") as? String
                if value == nil{
                
                }
                else if value == "on"{
                    
                }
                else {
                    
                    self.locationUpdate.stopLocationTracking()
                    self.locationManager.stopUpdatingLocation()
                    self.locationManager.stopUpdatingHeading()
                    self.callApiMaintainStatusOff()

                    
                }

                
            }
            
            // for below condition to check trip updates
            
            if(self.bearing == "started"){
                
                // after trip started
                if self.isPendingUpdate == "update"{
                    print(location.coordinate.longitude)
                    print(location.coordinate.latitude)
                    
                    self.myOrigin = location
                    self.myDestination = self.dropDestination
                    self.isPendingUpdate = "updating"

                    

                    self.gettingDirectionsAPI()
                    
                    // 3 locations to calculate distance 
                    //1. static pickup 2. update from pickup changing dynamically 3. end location/where we are now

                }
                

            }
            else if(self.bearing == "default"){
                
                // for normal mode without trip
                self.markera.position = CLLocationCoordinate2D(latitude: (locations.first?.coordinate.latitude)!, longitude: (locations.first?.coordinate.longitude)!)//here you can give your current lat and long
                self.markera.appearAnimation = kGMSMarkerAnimationPop
                var carCategory1 = "test"
                if((UserDefaults.standard.object(forKey: "carCategoryRegister")) != nil){
                    carCategory1 = UserDefaults.standard.object(forKey: "carCategoryRegister") as! String
                }
                
                
                
                if(carCategory1 == "6-Seater"){
                    self.markera.icon = UIImage(named: "map_lux.png")
                }
                else if(carCategory1 == "6-Seater_Luxury"){
                    self.markera.icon = UIImage(named: "map_suv.png")
                }
                else if(carCategory1 == "Taxi"){
                    self.markera.icon = UIImage(named: "map_taxi.png")
                }
                else{
                    self.markera.icon = UIImage(named: "Drivers.png")
                }
                self.markera.map = self.viewMap
                self.markera.groundAnchor = CGPoint(x: 0.5, y: 0.5)
                self.markera.isFlat = true
                self.markera.rotation = self.course
                self.markera.appearAnimation = kGMSMarkerAnimationNone
            }
            else if(self.bearing == "request"){
                // handle after accepted status within trip started
                // disable it to set default or started by the driver status
                self.myOrigin = location
                self.myDestination = self.pickupLocation
                self.gettingDirectionsAPI()

            }
            else{
                
                self.markera.position = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.latitude)//here you can give your current lat and long
                self.markera.appearAnimation = kGMSMarkerAnimationPop
                var carCategory1 = "test"
                if((UserDefaults.standard.object(forKey: "carCategoryRegister")) != nil){
                    carCategory1 = UserDefaults.standard.object(forKey: "carCategoryRegister") as! String
                }
                if(carCategory1 == "6-Seater"){
                    self.markera.icon = UIImage(named: "map_lux.png")
                }
                else if(carCategory1 == "6-Seater_Luxury"){
                    self.markera.icon = UIImage(named: "map_suv.png")
                }
                else if(carCategory1 == "Taxi"){
                    self.markera.icon = UIImage(named: "map_taxi.png")
                }
                else{
                    self.markera.icon = UIImage(named: "Drivers.png")
                }
                self.markera.map = self.viewMap
                self.markera.groundAnchor = CGPoint(x: 0.5, y: 0.5)
                self.markera.isFlat = true
                self.markera.appearAnimation = kGMSMarkerAnimationNone


            }
            
            /*if locations.first != nil {
             
             let ref1 = FIRDatabase.database().reference()
             let geofire = GeoFire(firebaseRef: ref1.child("drivers_location"))
             
             geoFire?.setLocation(CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude), forKey: "\(self.appDelegate.userid!)")
             
             geoFire?.setLocation(CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude), forKey: "\(self.appDelegate.userid!)", withCompletionBlock:
             { (error) in
             
             print(error)
             if (error != nil) {
             //  print("An error occured: \(error)")
             }
             else{
             
             }
             })
             
             
             
             } */
            
            

        }
        
        // check if trip is started then calculate distance per km
        
        if(self.tripIsStarted == "yes"){
            // start updating calculation.
            
            if(self.tripIsStarted == "done"){
                // stop updating calculation.
                self.tripIsStarted = "no"
            }
            else{

                if self.tripLocation != nil
                {
                    let distanceTravelled = self.currentLocation.distance(from: self.tripLocation!)
                    tripDistance += distanceTravelled
                    UserDefaults.standard.set(tripDistance, forKey: "tripRunningDistance")

                }
                self.tripLocation = self.currentLocation
                
//                self.distance3 = locations.first
//                if locations.first != nil {
//                    if distance3 == distance2{
//                        
//                    }
//                    else{
//                        self.calcDistacneDynamic()
//                    }
//
//                }

            }
        }
    }
    
    var angle:Double! = 0.0
    var course:Double! = 0.0
    
  /*  func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        
        
        self.angle = 0.0
        let  heading:Double = newHeading.trueHeading;
        marker.groundAnchor = CGPoint(x: 0.5, y: 0.5)
        marker.rotation = heading
        marker.map = self.viewMap
        print(self.angle)
        print("angel is angle")
        print(marker.rotation)
        self.angle = heading
    }*/
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        
        
        
        let direction = -newHeading.trueHeading as Double
        
        print(direction)
        
        angle = Double(newHeading.magneticHeading)
        
        course = currentLocation.course
        
       // self.marker.map = self.viewMap
        
        print(angle)
        print(course)
        
        if self.angle != nil {
            
            print("markera.groundAnchor = CGPoint(x: 0.5, y: 0.5)")
            
           // markera.rotation = self.angle
           
            
        }
        
    }
    
  //Starttrip action
    
  
    @IBAction func acceptNewBtnAction(_ sender: Any) {
        
      

        
        // view is accepting
        self.acceptingView.isHidden = false
        
            //   LoadingIndicatorView.show(self.acceptingView, loadingText: "Accepting...")
        
        LoadingIndicatorView.showClearLoader(self.acceptingView, loadingText: "Accepting...")
        
        // Driver accepted the rider's request
        self.acceptStatus = "yes"
        print(self.request_id)
        self.incoming = 2
        UIApplication.shared.setStatusBarStyle(.lightContent, animated: true)
        
        //       self.setRequestStatus()
        self.timer.invalidate()
        self.timer1.invalidate()
        self.pulsator.stop()
        self.progress.stopAnimation()
        ////self.requestView.isHidden = true
        self.viewRequestNew.isHidden = true
        self.distlbll.text = ""
        self.etalbll.text = ""
        self.estimatedfarelbl.text = ""
        self.dropaddrrlbl.text = ""
        self.pickupaddrrlbl.text = ""
        self.dropaddrrtv.text = ""
        self.pickupaddrrtv.text = ""
      //  player.stop()
        self.viewOffline.isHidden = true
        self.btnroute.isHidden = false
        self.btnvoiceonoff.isHidden = false
        ////self.viewPhone.isHidden = true
        
        
        
        
        //self.updateStatusChild()
        // to update request status in db
        
        // to update accept staus in firebase
        //        updateTotalNoOfPost {
        //
        //            let ref = FIRDatabase.database().reference()
        //
        //            let geoFire = GeoFire(firebaseRef: ref.child("drivers_data/\(self.appDelegate.userid!)/"))
        //
        //        }
        
        /*
         first get request id from incoming notification
         1. update accept status as 1
         2. update request status
         3. trip id from accept status
         4. display arrive now view
         5. next arrive now action
         */
        
        
        // 1.
        self.callCarListCategoryValues()
        self.updateStatusChild()
     
        self.listenerCancelTripAlert()
//self.autoUpdateforLocation()
        
    }
    
    func updateStatusChild(){
        
        let ref1 = FIRDatabase.database().reference().child("drivers_data").child(self.appDelegate.userid!).child("accept")
        ref1.updateChildValues(["status": "1"])
        
        print("Request id is")
        print(self.request_id!)
        
        
        self.updateRequestStatus()
        
        
        //////
        
            }

    
    func getLatLong(){
        
        
        var urlstring:String = "\(live_request_url)requests/getRequest/request_id/\(self.request_id!)"
        
        urlstring = urlstring.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!
        print(urlstring)
        
        
        
        
        let manager : AFHTTPRequestOperationManager = AFHTTPRequestOperationManager()
        
        //manager.responseSerializer.acceptableContentTypes =  Set<AnyHashable>(["application/json", "text/json", "text/javascript", "text/html"])
        
        manager.get( "\(urlstring)",
            parameters: nil,
            success: { (operation: AFHTTPRequestOperation?,responseObject: Any?) in
                
                let jsonObjects=responseObject as? NSArray
                //                var dataDict: NSDictionary?
                
                let value = jsonObjects?[0] as AnyObject
             
                if((value["request_status"] as? String) != nil){
                    
                let request_status:String = (value["request_status"] as? String)!

                print(request_status)
                if request_status == "cancel"{
                    
                    print(request_status)
                    // handle request is cancelled by rider
                
                }
                else if (request_status == "processing"){
                    
                }
                else{
                    
                    //handle accepted by driver and continue the trip.
                }
                
                let pickup:NSDictionary = (value["pickup"] as? NSDictionary)!
                let destination:NSDictionary = (value["destination"] as? NSDictionary)!
                
                print(pickup["lat"]!)
                print(pickup["long"]!)
                
                print(destination["lat"]!)
                print(destination["long"]!)
                
                let pickupLat:String = (pickup["lat"] as? String)!
                let pickupLong:String = (pickup["long"] as? String)!
                
                let destLat:String = (destination["lat"] as? String)!
                let destLong:String = (destination["long"] as? String)!
                
                
                self.pickupLocation = CLLocation(latitude: Double(pickupLat)!,longitude: Double(pickupLong)!)
                self.dropDestination = CLLocation(latitude: Double(destLat)!,longitude: Double(destLong)!)
                
                //self.myOrigin = CLLocation(latitude: Double(pickupLat)!,longitude: Double(pickupLong)!)
                //self.myDestination = CLLocation(latitude: Double(destLat)!,longitude: Double(destLong)!)
                

                
                self.getCurrnentAddress(myLocation : self.pickupLocation)
                    self.updatedloc = "0"
                //self.getting DirectionsAPI()
        }
        },
            failure: { (operation: AFHTTPRequestOperation?,error: Error) in
                print("Error: " + error.localizedDescription)
        })
        
        
    }
    
    
    func updateRequestStatus(){
        

 
        // url
        if(self.request_id! != ""){
 
            // setting polyline for driver
 
            var urlstring:String = "\(live_request_url)requests/updateRequest/request_id/\(self.request_id!)/driver_id/\(self.appDelegate.userid!)/request_status/accept/lat/\(self.currentLocation.coordinate.latitude)/long/\(self.currentLocation.coordinate.longitude)"
            
            /*
             urlstring = urlstring.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!
             print(urlstring)
             
             self.callUpdateRequest(url: "\(urlstring)")  */
            
            urlstring = urlstring.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!
            print(urlstring)
            
            let manager : AFHTTPRequestOperationManager = AFHTTPRequestOperationManager()
            
            manager.responseSerializer.acceptableContentTypes =  Set<AnyHashable>(["application/json", "text/json", "text/javascript", "text/html"])

            manager.get( "\(urlstring)",
                parameters: nil,
                success: { (operation: AFHTTPRequestOperation?,responseObject: Any?) in
//                    let jsonObjects=responseObject as! NSArray
                    
                    let jsonObjects:NSArray = responseObject as! NSArray
                    //                var dataDict: NSDictionary?
                    let value:NSDictionary = jsonObjects[0] as! NSDictionary
                    print(value)
                    let carcategory:String = (value["category"] as? String)!
                    print("carcategory~~\(carcategory)")
                    self.carcategoryname = carcategory
                    if let request_status:String = value["request_status"] as? String{
                        if(request_status == "processing"){
                            self.appDelegate.req_status = request_status
                            
                        }
                        else if(request_status == "no_driver"){
                            self.appDelegate.req_status = request_status
                            
                            
                        }
                        else if(request_status == "accept"){
                            
                            self.pulsing = "stop"
                            self.appDelegate.req_status = request_status
                            let rider_id:String = (value["rider_id"] as? String)!
                            self.appDelegate.rider_id = rider_id
                            
                            UserDefaults.standard.setValue(rider_id, forKey: "rider_id")
                            
                            if let driver_location:NSDictionary = (value["driver_location"] as? NSDictionary){
                                print("Driver_Location_lat:\(driver_location["lat"]!)")
                                print("Driver_Location_lon:\(driver_location["long"]!)")
                            
                            
                            }
                            
                            let pickup:NSDictionary = (value["pickup"] as? NSDictionary)!
                            let destination:NSDictionary = (value["destination"] as? NSDictionary)!
                            
                            print("Pickup_Lat:\(pickup["lat"]!)")
                            print("Pickup_lon:\(pickup["long"]!)")
                            
                            print("Destination_Lat:\(destination["lat"]!)")
                            print("Destination_Lon:\(destination["long"]!)")
                            
                            let pickupLat:String = (pickup["lat"] as? String)!
                            let pickupLong:String = (pickup["long"] as? String)!
                            
                            let destLat:String = (destination["lat"] as? String)!
                            let destLong:String = (destination["long"] as? String)!
                            
                            //self.myOrigin = CLLocation(latitude: Double(pickupLat)!,longitude: Double(pickupLong)!)
                            //self.myDestination = CLLocation(latitude: Double(destLat)!,longitude: Double(destLong)!)
                            

                            
                            self.myOrigin = self.currentLocation
                            self.myDestination = CLLocation(latitude: Double(pickupLat)!,longitude: Double(pickupLong)!)
                            self.dropDestination = CLLocation(latitude: Double(destLat)!,longitude: Double(destLong)!)
                            self.imageName = "endPinRound.png"
                            self.imageName1 = "markerloc1"
                            self.imageName2 = "markerloc2"
                            self.imageName3 = "markerloc3"
                            self.imageName4 = "markerloc4"
                            self.getTripID()
                            
                            // set drop loaction
                            
                            let droplat = "\(self.dropDestination.coordinate.latitude)"
                            let droplng = "\(self.dropDestination.coordinate.longitude)"
                            print("droplat:\(droplat)")
                            print("droplng:\(droplng)")
                            UserDefaults.standard.setValue(droplat, forKey: "Droplat")
                            UserDefaults.standard.setValue(droplng, forKey: "Droplng")
                            
                            // set pickup location

                            let pickuplat = "\(self.myDestination.coordinate.latitude)"
                            let pickuplng = "\(self.myDestination.coordinate.longitude)"
                            
                            UserDefaults.standard.setValue(pickuplat, forKey: "pickuplat")
                            UserDefaults.standard.setValue(pickuplng, forKey: "pickuplng")
                            // driver_id is logged user
                            // rider_id is Clinet user
                            
                            
                            self.autoUpdateforLocation()
                            
                            
                            
                                                }
                        else{
                            
                        }
                    }
                    //                var dataDict: NSDictionary?

            },
                failure: { (operation: AFHTTPRequestOperation?,error: Error) in
                    print("Error: " + error.localizedDescription)
            })
            self.getLatLong()

        
        }
    }
    
    func callUpdateRequest(url : String){
        
        Alamofire.request(url).responseJSON { (response) in
            
            self.parseData(JSONData: response.data!)
            
        }
        

    }
    
    func parseUpdateRequest(JSONData : Data){
        
        do{
            
            let readableJSon = try JSONSerialization.jsonObject(with: JSONData, options: .mutableContainers) as! jsonSTD
            
            print(" !!! \(readableJSon[0])")
            
            let value = readableJSon[0] as AnyObject
            
            let final = value.object(forKey: "status")
            print(final!)
            //self.setRequestStatus()
            
            
        }
        catch{
            
            print(error)
            
        }

    }
    
    override func viewDidAppear(_ animated: Bool) {
        // This padding will be observed by the mapView
        let screenSize = UIScreen.main.bounds
     //   self.viewMap.padding = UIEdgeInsetsMake(64, 0, 64, 0)
    
        self.viewMap.padding = UIEdgeInsetsMake(64,10,0,0)
        
        // top left bottom right

    }
    
    
    
    func updateLocation(){
        
        
        var urlstring:String = "\(signInAPIUrl)updateLocation/userid/\(self.appDelegate.userid!)/lat/\(self.defaultLocation.coordinate.latitude)/long/\(self.defaultLocation.coordinate.longitude)"
        
        urlstring = urlstring.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!
        print(urlstring)
        
        self.callSiginAPI(url: "\(urlstring)")
    }
    
    
    
    func callSiginAPI(url : String){
        
        
        
        Alamofire.request(url).responseJSON { (response) in
            
         //   self.parseData(JSONData: response.data!)
            
        }
        
    }
    
    
    func parseData(JSONData : Data){
        
        do{
            
            let readableJSon = try JSONSerialization.jsonObject(with: JSONData, options: .mutableContainers) as! jsonSTD
            
            print(" !!! \(readableJSon[0])")
            
            let value = readableJSon[0] as AnyObject
            
            let final = value.object(forKey: "status")
            print(final!)
            //self.setRequestStatus()

            
        }
        catch{
            
            print(error)
            
        }
        
    }
    
    
    

    
    func setProgressBar()
    {
        if indexProgressBar == poseDuration
        {
           // getNextPoseData()
            
            // reset the progress counter
            indexProgressBar = 0
        }
        print(indexProgressBar)
        indexProgressBar += 1
        if(indexProgressBar == 15){
            self.timer.invalidate()
            self.timer1.invalidate()
            self.cancel()
        }
        
    
    }
    
    
    func getNextPoseData()
    {
        // do next pose stuff
        currentPoseIndex += 1
        print(currentPoseIndex)
    }
    
    func cancel(){
        
        ////self.viewPhone.isHidden = true
        self.pulsator.stop()
        ////self.requestView.isHidden = true
        self.viewRequestNew.isHidden = true
        self.distlbll.text = ""
        self.etalbll.text = ""
        self.estimatedfarelbl.text = ""
        self.dropaddrrlbl.text = ""
        self.pickupaddrrlbl.text = ""
        self.dropaddrrtv.text = ""
        self.pickupaddrrtv.text = ""
     //   player.stop()
        self.acceptStatus = "no" //  the driver is accepted or not the incoming request
        self.accepted = "" // it can be removed for dynamic methods
        self.timer.invalidate()
        self.timer1.invalidate()// time is stopped after 15 seconds
//        self.setRequestStatus() // set default value after cancelled the request
        if(incoming == 2){
            
        }
        else{
            self.incoming = 0 // here driver is available by cancelled the request
            // blocking incoming request notification for auto update
        }

    }
    
    func progressView(){
        
        view.backgroundColor = UIColor(white: 0.22, alpha: 1)
        
        let verticalCenter: CGFloat = UIScreen.main.bounds.size.height / 2.0
        let horizontalCenter: CGFloat = UIScreen.main.bounds.size.width / 2.0
        
       // progress = KDCircularProgress(frame: CGRect(x: 16, y: 0, width: 343, height: 324))
        
        progress = viewCircle

//        requestView.frame = CGRect(dictionaryRepresentation: progress as! CFDictionary)!
        requestView.center.x = view.center.x
        progress.startAngle = -90
        progress.progressThickness = 0.1
        progress.trackThickness = 0.3
        progress.clockwise = true
        progress.gradientRotateSpeed = 2
        progress.roundedCorners = false
        progress.glowMode = .forward
        progress.glowAmount = 0.5
        //        progress.set(colors: UIColor.cyan ,UIColor.white, UIColor.magenta, UIColor.white, UIColor.orange)
        progress.set(colors: UIColor.white ,UIColor.white, UIColor.white, UIColor.white, UIColor.white)
     //   progress.center = CGPoint(x: view.center.x, y: view.center.y)
//        progress.frame = CGRect(x:20,y:40,width:300,height:300)
          requestView.center = CGPoint(x: view.center.x, y: view.center.y)

        self.requestView.addSubview(progress)
        


    }
    
    
    
    
    
    
    func getRequestID(){
            // using GEOfire
            
            
            let ref = FIRDatabase.database().reference()
            
            //let geoFire = GeoFire(firebaseRef: ref.child("drivers_data/\(self.appDelegate.userid!)"))
            let geoFire = GeoFire(firebaseRef: ref.child("drivers_data/\(self.appDelegate.userid!)"))
        
            // request id changing
            
        ref.child("drivers_data").child("\(self.appDelegate.userid!)").child("request").child("req_id").observe(.value, with: { (snapshot) in
                
                print("updating")
                let status1 = snapshot.value as Any
                print(status1)
                var req_id = "\(status1)"
                req_id = req_id.replacingOccurrences(of: "Optional(", with: "")
                req_id = req_id.replacingOccurrences(of: ")", with: "")
                print(req_id)
                self.request_id = req_id
            //Start
               
            //End
            
                if(self.request_id == ""){
                    
                }
                else{
                    // request status

                    

                }
            }){ (error) in
                
                print(error.localizedDescription)
            }
            
            
            
        }
    
    
    func getTripStatus(){
        // using GEOfire
        print(UserDefaults.standard.value(forKey: "rider_id"))
        if UserDefaults.standard.value(forKey: "rider_id") != nil {
            
            self.getRiderDetails()

        }
        else
        {
            
        }

        let ref = FIRDatabase.database().reference()
        
        //let geoFire = GeoFire(firebaseRef: ref.child("drivers_data/\(self.appDelegate.userid!)"))
        let geoFire = GeoFire(firebaseRef: ref.child("drivers_data/\(self.appDelegate.userid!)"))
        
        if UserDefaults.standard.value(forKey: "TripID") != nil{
            
            var tripID = UserDefaults.standard.value(forKey: "TripID") as! String
            tripID = tripID.replacingOccurrences(of: "Optional(", with: "")
            tripID = tripID.replacingOccurrences(of: ")", with: "")
            tripID = tripID.replacingOccurrences(of: "\"", with: "")

            self.trip_id = tripID
        }
        
        let some = self.trip_id
        
        print("after accept trip Is Pass \(some)")

        
        //accept
        //get values from firebase after accepting
        ref.child("trips_data").child("\(self.trip_id)").child("status").observe(.value, with: { (snapshot) in
            //let dict = snapshot.value as! NSString
            
            print("updating")
            let status1 = snapshot.value as Any
            print(status1)
            var status = "\(status1)"
            
            status = status.replacingOccurrences(of: "Optional(", with: "")
            status = status.replacingOccurrences(of: ")", with: "")
            self.trip_status = status
            
            self.trip_status = self.trip_status.replacingOccurrences(of: "Optional(", with: "")
            self.trip_status = self.trip_status.replacingOccurrences(of: ")", with: "")

            print(status1)
            print(self.trip_status)
            //if("\(status1)" == "1"){
            
            if("\(self.trip_status)" != ""){
                if(self.trip_status == "1"){
                    
                    self.bearing = "request"
                    self.setPickupLoc()
                    
                    self.arriveNow()

                    self.listenerCancelTripAlert()
                }
                else if(self.trip_status == "2"){
                    
                    self.bearing = "request"
                    self.setPickupLoc()
                    self.startTrip()

                    self.listenerCancelTripAlert()
                }
                else if(self.trip_status == "3"){
                    
                    self.bearing = "started"
                    self.setDropLoc()
                    self.completeTrip()

                    
                }
                else if(self.trip_status == "4"){
                    
//                    self.completeTripBtn(self.completebtnoutlet)
                    UserDefaults.standard.setValue("", forKey: "Droplat")
                    UserDefaults.standard.setValue("", forKey: "Droplng")
                    
                    UserDefaults.standard.setValue("", forKey: "pickuplat")
                    UserDefaults.standard.setValue("", forKey: "pickuplng")

                    
                }
                else{
                    
                }
            }
            //accept
            //get values from firebase after accepting
            //}
            
        }) { (error) in
            
            print(error.localizedDescription)
        }
        
        
        // trip status changing

        
    }
    
    
    
    func getTripID(){
        // using GEOfire
        
        
        
        self.gettingDirectionsAPI()
        self.getSurgePrice()

        
        let ref = FIRDatabase.database().reference()
        
        //let geoFire = GeoFire(firebaseRef: ref.child("drivers_data/\(self.appDelegate.userid!)"))
        let geoFire = GeoFire(firebaseRef: ref.child("drivers_data/\(self.appDelegate.userid!)"))
        
        

        //accept
        //get values from firebase after accepting
        ref.child("drivers_data").child("\(self.appDelegate.userid!)").child("accept").child("trip_id").observe(.value, with: { (snapshot) in
            //let dict = snapshot.value as! NSString
            
            print("updating")
            let status1 = snapshot.value as Any
            print("trip id is here\(status1)")
            var trip_id = "\(status1)"
            trip_id = trip_id.replacingOccurrences(of: "Optional(", with: "")
            trip_id = trip_id.replacingOccurrences(of: ")", with: "")
            print(status1)
            //if("\(status1)" == "1"){
            if("\(trip_id)" != ""){
                
                if("\(trip_id)" != "0"){
                
                print("\(trip_id)")
                print(self.trip_id)
                
                if("\(trip_id)" != self.trip_id){
                self.appDelegate.trip_id = trip_id
                self.trip_id = trip_id
                print(self.appDelegate.trip_id!)
                    
                    ref.child("drivers_data").child("\(self.appDelegate.userid!)").child("accept").child("trip_id_rider_name").observeSingleEvent(of: .value, with: { (snapshot) in
                        //let dict = snapshot.value as! NSString
                        
                        print("updating")
                        let status11 = snapshot.value as Any
                        print("trip id is here\(status11)")
                        var trip_id1 = "\(status11)"
                        trip_id1 = trip_id1.replacingOccurrences(of: "Optional(", with: "")
                        trip_id1 = trip_id1.replacingOccurrences(of: ")", with: "")
                        print(status11)
                        //if("\(status1)" == "1"){
                         if("\(trip_id1)" != ""){
                            
                            if("\(trip_id1)" != "0"){
                                
                                print("\(trip_id1)")
                                
                                self.appDelegate.trip_idwithname = trip_id1
                                print(" self.appDelegate.\( self.appDelegate.trip_idwithname)")
                
               // self.arrayOfTripID.add(self.trip_id)
                
               
                                      self.arriveNow()
                
                                      LoadingIndicatorView.hide()
                
                                      self.acceptingView.isHidden = true
                            }
                        }
                    })

                }

                }
            }
            else{
                ref.child("drivers_data").child("\(self.appDelegate.userid!)").child("accept").child("trip_id").observe(.childChanged, with: { (snapshot) in
                    //let dict = snapshot.value as! NSString
                    
                    print("updating")
                    let status1 = snapshot.value as Any
                    print(status1)
                    print("trip id is not empty\(status1)")
                    
                    var trip_id = "\(status1)"
                    trip_id = trip_id.replacingOccurrences(of: "Optional(", with: "")
                    trip_id = trip_id.replacingOccurrences(of: ")", with: "")
                    print(status1)
                    //if("\(status1)" == "1"){
                    if("\(trip_id)" != ""){
                        self.appDelegate.trip_id = trip_id
                        self.trip_id = trip_id
                        print(self.appDelegate.trip_id!)
                        
                        ref.child("drivers_data").child("\(self.appDelegate.userid!)").child("accept").child("trip_id_rider_name").observe(.childChanged, with: { (snapshot) in
                            //let dict = snapshot.value as! NSString
                            
                            print("updating")
                            let status11 = snapshot.value as Any
                            print("trip id is here\(status11)")
                            var trip_id1 = "\(status11)"
                            trip_id1 = trip_id1.replacingOccurrences(of: "Optional(", with: "")
                            trip_id1 = trip_id1.replacingOccurrences(of: ")", with: "")
                            print(status11)
                            //if("\(status1)" == "1"){
                            if("\(trip_id1)" != ""){
                                
                                if("\(trip_id1)" != "0"){
                                    
                                    print("trip_id1~\(trip_id1)")
                                    
                                    self.appDelegate.trip_idwithname = trip_id1
                                     print(" self.appDelegate.\( self.appDelegate.trip_idwithname)")
                                     self.arriveNow()
                        
                                      LoadingIndicatorView.hide()
                                      self.acceptingView.isHidden = true

                                }
                            }
                        })
                        
                        // check it on view will appear

                    }
                    //accept
                    //get values from firebase after accepting
                    //}
                    
                }) { (error) in
                    
                    print(error.localizedDescription)
                }

            }
                //accept
                //get values from firebase after accepting
            //}

        }) { (error) in
            
            print(error.localizedDescription)
        }
        
        
        
        
        
        
        // trip id changing
        

    }
    func getSurgePrice(){
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let hourmin = "\(hour):\(minutes)"
        var urlstring:String! = "\(live_request_url)home/getpercentage?start_time=\(hourmin)&end_time=\(hourmin)"
        urlstring = urlstring.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!
        print(urlstring)
        let manager : AFHTTPRequestOperationManager = AFHTTPRequestOperationManager()
        manager.responseSerializer.acceptableContentTypes =  Set<AnyHashable>(["application/json", "text/json", "text/javascript", "text/html"])
        manager.get( "\(urlstring!)",
            parameters: nil,
            success: { (operation: AFHTTPRequestOperation?,responseObject: Any?) in
                let jsonObjects=responseObject as! NSArray
                let value = jsonObjects[0] as AnyObject
                if((value["status"] as? String) == "Success"){
                    let surge_percent:String = (value["percentage"] as? String)!
                    print("Surge Price\(surge_percent)")
                    UserDefaults.standard.setValue(surge_percent , forKey: "Surgeprice")
                }
        },
            failure: { (operation: AFHTTPRequestOperation?,error: Error) in
                print("Error: " + error.localizedDescription)
        })
    }
    func arriveNow(){
        
        
        // call url for arrivenow
        
        // this function is used to un hide the arrive now view

        self.markTestView.isHidden = true

        self.viewOffline.isHidden = true
        self.btnroute.isHidden = false
        self.btnvoiceonoff.isHidden = false

        self.appDelegate.toinsertid = "0"
        
        self.getCurrnentAddress(myLocation : self.myDestination)
        self.updatedloc = "0"

        self.getRiderDetails()

        
       // self.loadTripsID(riderName: riderShowName)
        
        
        self.arriveNowView.isHidden = false
        self.startTripView.isHidden = true
        self.completeTripView.isHidden = true
        
        self.viewOffline.isHidden = true
        self.btnroute.isHidden = false
        self.btnvoiceonoff.isHidden = false
        
        self.bearing = "request"
        
        //self.rideraddressview.isHidden = false
        
        

    }
    
    // one loop completed for accepting
    
    
    @IBAction func arriveNowAction(_ sender: Any) {
        
         let refh = FIRDatabase.database().reference()
        
         refh.child("trips_data").child("\(self.trip_id)").child("status").observeSingleEvent(of: .value, with: { (snapshot) in
            //let dict = snapshot.value as! NSString
            if (snapshot.exists()) {
            print("updating")
            let status1 = snapshot.value as! String
            print("trip id is here\(status1)")
            var trip_id = "\(status1)"
            trip_id = trip_id.replacingOccurrences(of: "Optional(", with: "")
            trip_id = trip_id.replacingOccurrences(of: ")", with: "")
            print(status1)
            //if("\(status1)" == "1"){
            if("\(trip_id)" != ""){
                
                    
                    if (status1 == "5"){
                        
                        
                        
                        UserDefaults.standard.removeObject(forKey: "rider_id")
                        
                        self.notification(Status: "Rider Cancelled the trip")
                        
                        let pass = self.arrayOfNonDuplicate
                        
                        pass.removeObject(at: self.getSome)
                        
                        print("remove array element \(self.arrayOfNonDuplicate)")
                        
                        UserDefaults.standard.set(self.arrayOfNonDuplicate, forKey: "arrayOfTripsData")
                        
                        let first1  = UserDefaults.standard.array(forKey: "arrayOfTripsData")
                        print("arrayofTripsData \(first1)")
                        
                        let check  = UserDefaults.standard.array(forKey: "arrayOfTripsData")
                        
                        print("arrayofTripsData \(check)")
                        self.locationManager.stopUpdatingLocation()
                        self.appDelegate.callMapVC()
                    }
                        
                        
                    else{
                        
                        
                        self.arriveNowView.isHidden = true
                        
                        if UserDefaults.standard.value(forKey: "TripID") != nil{
                            
                            
                            
                            var tripID = UserDefaults.standard.value(forKey: "TripID") as! String
                            
                            tripID = tripID.replacingOccurrences(of: "Optional(", with: "")
                            
                            tripID = tripID.replacingOccurrences(of: ")", with: "")
                            
                            tripID = tripID.replacingOccurrences(of: "\"", with: "")
                            
                            
                            
                            self.trip_id = tripID
                            
                        }
                        
                        print("got tripID arrive btn \(self.trip_id)")
                        
                        self.urlstring = "\(live_request_url)requests/updateTrips/trip_id/\(self.trip_id)/trip_status/off/accept_status/2/total_amount/0"
                         // var carcategory = urlstring["car_category"] as? String
                        // Arrive now status
                        var ref1 = FIRDatabase.database().reference().child("trips_data").child(self.trip_id)
                        ref1.updateChildValues(["status": "2"])
                        
                        self.imageName = "endPinRound.png"
                        self.imageName1 = "markerloc1"
                        self.imageName2 = "markerloc2"
                        self.imageName3 = "markerloc3"
                        self.imageName4 = "markerloc4"
                        
                        
                        if(trip_id != "nil"){
                            self.tripStatusUpdating(urlString: self.urlstring)
                        }
                        print("Arriving now")
                        self.startTrip()
                    }
                    
                }

            }
        })
        
    }

    
    func startTrip(){
        
        
        // this function is used to un hide the start trip view

        self.viewOffline.isHidden = true
        self.btnroute.isHidden = false
        self.btnvoiceonoff.isHidden = false

        // call url for start trip
        //self.myOrigin = self.myDestination
        //self.myDestination = self.dropDestination
        
        self.getCurrnentAddress(myLocation : self.myDestination)
        self.updatedloc = "0"

        //self.startBearing(location: location)
        self.gettingDirectionsAPI()

        self.startTripView.isHidden = false
        
        self.bearing = "request"
    }
    
    // second loop completed for arriving now. The driver is arrived

    
    @IBAction func startTripButton(_ sender: Any) {
        
        
        
        let ref = FIRDatabase.database().reference()
        
        ref.child("trips_data").child("\(self.trip_id)").child("status").observeSingleEvent(of: .value, with: { (snapshot) in
            //let dict = snapshot.value as! NSString
            if (snapshot.exists()) {
            print("updating")
            let status1 = snapshot.value as! String
            print("trip id is here\(status1)")
            var trip_id = "\(status1)"
            trip_id = trip_id.replacingOccurrences(of: "Optional(", with: "")
            trip_id = trip_id.replacingOccurrences(of: ")", with: "")
            print(status1)
            //if("\(status1)" == "1"){
            if("\(trip_id)" != ""){
                
                if (status1 == "5"){
                    
                    self.arrayOfSample.removeAllObjects()
                    
                    UserDefaults.standard.removeObject(forKey: "rider_id")
                    
                    self.notification(Status: "Rider Cancelled the trip")
                    
                    let pass = self.arrayOfNonDuplicate
                    
                    pass.removeObject(at: self.getSome)
                    
                    print("remove array element \(self.arrayOfNonDuplicate)")
                    
                    UserDefaults.standard.set(self.arrayOfNonDuplicate, forKey: "arrayOfTripsData")
                    
                    let first1  = UserDefaults.standard.array(forKey: "arrayOfTripsData")
                    print("arrayofTripsData \(first1)")
                    
                    let check  = UserDefaults.standard.array(forKey: "arrayOfTripsData")
                    
                    print("arrayofTripsData \(check)")
                    self.locationManager.stopUpdatingLocation()
                    self.appDelegate.callMapVC()
                }
                else{
        
                    if UserDefaults.standard.value(forKey: "TripID") != nil{
                    
            
            
            var tripID = UserDefaults.standard.value(forKey: "TripID") as! String
            
            tripID = tripID.replacingOccurrences(of: "Optional(", with: "")
            
            tripID = tripID.replacingOccurrences(of: ")", with: "")
            
            tripID = tripID.replacingOccurrences(of: "\"", with: "")
            
            
            
            self.trip_id = tripID
            
        }
        
        print("got tripID start btn \(self.trip_id)")
        self.tollfeeid.add(self.trip_id)
        UserDefaults.standard.set(self.tollfeeid, forKey: "arrayOfTollData")
        let tirst1  = UserDefaults.standard.array(forKey: "arrayOfTollData")
        print("arrayofTollData \(tirst1)")
        print(self.tollfeeid)
        self.urlstring = "\(live_request_url)requests/updateTrips/trip_id/\(self.trip_id)/trip_status/on/accept_status/3/total_amount/0"
        // begin trip status

        var ref1 = FIRDatabase.database().reference().child("trips_data").child(self.trip_id)
        ref1.updateChildValues(["status": "3"])

        print("Begin Trip")
        if(trip_id != "nil"){
            self.tripStatusUpdating(urlString: self.urlstring)
        }
        self.startTripView.isHidden = true
        self.completeTrip()
        
                }
            }
            }
            })
            
    }
   
     
   
     
     
 
    
    func completeTrip(){
        
        // this function is used to un hide the complete trip view
        
        self.viewOffline.isHidden = true
        self.btnroute.isHidden = false
        self.btnvoiceonoff.isHidden = false
        self.bearing = "started"
        
        self.tripIsStarted = "yes"
        
        self.imageName = "endPinSquare.png"
        self.imageName1 = "markerloc1"
        self.imageName2 = "markerloc2"
        self.imageName3 = "markerloc3"
        self.imageName4 = "markerloc4"
        
        self.distance1 = self.pickupLocation
        self.distance2 = self.pickupLocation
        
        self.completeTripView.isHidden=false
        ////self.rideraddressview.isHidden = false
        self.getCurrnentAddress(myLocation : self.dropDestination)
        self.updatedloc = "0"

        self.markTestView.isHidden = true
        
            }
    
    
   
    
    // complete trip visibled
    
    //Complete trip action

    @IBAction func completeTripBtn(_ sender: Any) {
        
        self.arrayOfSample.removeAllObjects()
        
        
        if UserDefaults.standard.value(forKey: "TripID") != nil{
            
            var tripID = UserDefaults.standard.value(forKey: "TripID") as! String
            
            tripID = tripID.replacingOccurrences(of: "Optional(", with: "")
            
            tripID = tripID.replacingOccurrences(of: ")", with: "")
            
            tripID = tripID.replacingOccurrences(of: "\"", with: "")
            
            
           // self.setUsersClosestCity()
            self.tripLocation = nil
            self.trip_id = tripID
            
        }
        
        print(self.trip_id)
        let ref = FIRDatabase.database().reference()
        
        ref.child("trips_data").child("\(self.trip_id)").child("tollfee").observeSingleEvent(of: .value, with: { (snapshot) in
            //let dict = snapshot.value as! NSString
            if (snapshot.exists()) {
                print("updating")
                let status1 = snapshot.value as! String
                print("trip id is here\(status1)")
                var trip_id = "\(status1)"
                trip_id = trip_id.replacingOccurrences(of: "Optional(", with: "")
                trip_id = trip_id.replacingOccurrences(of: ")", with: "")
                print(status1)
                //if("\(status1)" == "1"){
                if("\(trip_id)" != ""){
                    print(trip_id)
                    self.appDelegate.final_tollfee = trip_id
                    
                    print("got tripID complete btn \(self.trip_id)")
                    
                    print("end trip non dup array \(self.arrayOfNonDuplicate)")
                    
                    if(self.appDelegate.usertouchdtrip1 != "0"){
                        
                        self.getSome = UserDefaults.standard.integer(forKey: "passTripsIndex")
                        
                        print("\(self.getSome)")
                        
                        self.appDelegate.usertouchdtrip1 = "0"
                        
                    }
                    else{
                        if(self.arrayOfNonDuplicate.count > 0){
                            self.getSome = self.arrayOfNonDuplicate.count - 1
                            
                            print("\(self.getSome)")
                        }
                    }
                    
                    
                    if(self.arrayOfNonDuplicate.count > 0){
                        
                        print(self.getSome)
                        
                        let pass = self.arrayOfNonDuplicate
                        let pass1 = self.tollfeeid
                        pass.removeObject(at: self.getSome)
                        
                        self.tollfeeid.removeObject(at: self.getSome)
                        UserDefaults.standard.set(self.tollfeeid, forKey: "arrayOfTollData")
                        let tirst1  = UserDefaults.standard.array(forKey: "arrayOfTollData")
                        print("arrayofTollData \(tirst1)")
                        
                        print("remove array element \(self.arrayOfNonDuplicate)")
                        
                        
                        let passThroughArray = self.arrayOfNonDuplicate
                        
                        print("pass through \(passThroughArray)")
                        
                        
                        UserDefaults.standard.set(self.arrayOfNonDuplicate, forKey: "arrayOfTripsData")
                        
                        let check  = UserDefaults.standard.array(forKey: "arrayOfTripsData")
                        
                        print("arrayofTripsData \(check)")
                        
                    }
                    //self.justNowCompleted = "Yes"
                    self.startTripView.isHidden=true
                    //self.startbtnoutlet.isHidden=true
                    
                    
                    
                    
                    var ref1 = FIRDatabase.database().reference().child("trips_data").child(self.trip_id)
                    ref1.updateChildValues(["status": "4"])
                    
                    
                    let totalDistanceInt = Int(self.total)
                    print(totalDistanceInt)
                    print(totalDistanceInt / 1000)
                    var distancePass = self.total / 1000.0
                    
                    print("url pass amount \(distancePass)")
                    
                    let carType = UserDefaults.standard.object(forKey: "carCategoryRegister") as! String
                    
                    var pricePerKM = ""
                    var basePerFare = ""
                    var pricePermin = ""
                    var taxpercent = ""
                    print(self.arrayOfPrice_KM)
                    print("\(self.arrayOfMaxSize),\(self.arrayOfMinFare),\(self.arrayOfPrice_MIN),\(self.arrayOfPrice_KM),\(self.arrayOftaxpercent)")
                    if(self.arrayOfPrice_KM.count == 0)
                    {
                        self.arrayOfPrice_KM = ["9", "9", "9", "9"]
                        self.arrayOfMinFare = ["9", "9", "9", "9"]
                        self.arrayOfPrice_MIN = ["9", "9", "9", "9"]
                        self.arrayOftaxpercent = ["0", "0", "0", "0"]
                    }
                    if carType == "Standard"{
                        
                        pricePerKM = self.arrayOfPrice_KM.firstObject as! String
                        basePerFare = self.arrayOfMinFare.firstObject as! String
                        pricePermin = self.arrayOfPrice_MIN.firstObject as! String
                        taxpercent = self.arrayOftaxpercent.firstObject as! String
                        print(" hatch km \(pricePerKM)")
                        print(" hatch  fare\(basePerFare)")
                        print(" hatch  min\(pricePermin)")
                        print(" hatch  min\(taxpercent)")
                        
                    }
                    else if carType == "6-Seater"{
                        
                        pricePerKM = "\(self.arrayOfPrice_KM[1])"
                        basePerFare = "\(self.arrayOfMinFare[1])"
                        pricePermin = "\(self.arrayOfPrice_MIN[1])"
                        taxpercent = "\(self.arrayOftaxpercent[1])"
                        print(" sedan km \(pricePerKM)")
                        print(" sedan  fare\(basePerFare)")
                        print(" sedan  min\(pricePermin)")
                        print(" hatch  min\(taxpercent)")
                        
                    }
                    else if carType == "6-Seater_Luxury"{
                        pricePerKM = "\(self.arrayOfPrice_KM[2])"
                        basePerFare = "\(self.arrayOfMinFare[2])"
                        pricePermin = "\(self.arrayOfPrice_MIN[2])"
                        taxpercent = "\(self.arrayOftaxpercent[2])"
                        print(" sedan km \(pricePerKM)")
                        print(" sedan  fare\(basePerFare)")
                        print(" sedan  min\(pricePermin)")
                        print(" hatch  min\(taxpercent)")
                        
                    }
                    else{
                        pricePerKM = self.arrayOfPrice_KM.lastObject as! String
                        basePerFare = self.arrayOfMinFare.lastObject as! String
                        pricePermin = self.arrayOfPrice_MIN.lastObject as! String
                        taxpercent = self.arrayOftaxpercent.lastObject as! String
                        print(" suv km \(pricePerKM)")
                        print(" suv  fare\(basePerFare)")
                        print(" suv  min\(pricePermin)")
                        print(" hatch  min\(taxpercent)")
                        
                    }
                    
                    let value1 : Float = Float(pricePerKM)!
                    
                    let myInt = Float(distancePass)
                    
                    var distanceAndPriceKm = myInt * value1
                    
                    print("distane * price/km \(distanceAndPriceKm)")
                    
                    let baseFareValue : Float = Float(basePerFare)!
                    
                    let pricePerMinValue : Float = Float(pricePermin)!
                    
                    let totalbaseAndPriceFare  = baseFareValue + pricePerMinValue
                    
                    print("base fare + price/min \(distanceAndPriceKm)")
                    
                    //Adding Surge price
                    
                    //adding Tollfee amount
                    let totalToll:Float = Float(self.appDelegate.final_tollfee)!
                    
                    var finalTotalPricesample : Float = Float(distanceAndPriceKm + totalbaseAndPriceFare + totalToll)
                    print(finalTotalPricesample)
                    print(self.multipledestinationfare)
                    
                    var taxcalc = Float(Float(taxpercent)! / 100)
                    print(taxcalc)
                    
                    var finalTotalPrice : Float = Float(distanceAndPriceKm + totalbaseAndPriceFare + totalToll + self.multipledestinationfare + taxcalc)
                    print(finalTotalPrice)
                    
                    if UserDefaults.standard.value(forKey: "Surgeprice") != nil{
                        let surge_price:NSString = UserDefaults.standard.value(forKey: "Surgeprice") as! NSString
                        
                       // print(finalTotalPrice/100)
                       // print(Float(surge_price as String))
                        let test_amount = (finalTotalPrice/100) * Float((surge_price as String) as String)!
                        finalTotalPrice = Float(finalTotalPrice + test_amount)
                        UserDefaults.standard.removeObject(forKey: "Surgeprice")
                        
                    }

                    
                    
                    var finalFormat = String(format: "%.2f", finalTotalPrice)
                    
                    var finalFormat2 = String(format: "%.2f", finalTotalPrice * 100/100)
                    
                    var finalFormat1 = String(format: "%.f", finalTotalPrice)
                    //  self.updateLocation()
                    
                    let totalAmount = self.total/1000
                    
                    let some = Double(totalAmount)
                    
                    let totalAmountFormatNew = String(format: "%.1f", some * 100/100)
                    
                    let totalAmountFormat = String(format: "%.2f", some)
                    
                    //String url = Constants.LIVEURL_REQUEST + "updateTrips/trip_id/" + Tripid + "/trip_status/end/accept_status/4/distance/" + strTotalDistance + "/total_amount/" + getTotalPrice() + "/user_id/" + driverId+"/drop_address/"+endAddress+"/end_lat/"+endLat+"/end_long/"+endLng;
                    //Poorna Complex Vakkil New St Arajar Salai
                    
                    let latitude :CLLocationDegrees = self.currentLocation.coordinate.latitude
                    let longitude :CLLocationDegrees = self.currentLocation.coordinate.longitude
                    print(self.appDelegate.str1)
                    
                    let droploc = ("\(self.appDelegate.str1!)\(self.appDelegate.city1!)\(self.appDelegate.zip1!)\(self.appDelegate.con1!)")
                    print("\(droploc)")
                    
                    
                    self.urlstring = "\(live_request_url)requests/updateTrips/trip_id/\(self.trip_id)/trip_status/end/accept_status/4/distance/\(self.tripDistance/1000)/user_id/\(self.appDelegate.userid!)/end_lat/\(latitude)/end_long/\(longitude)/toll_fee/\(totalToll)"
                    // end traip status  removed trip amount /total_amount/\(finalFormat)
                    
                    self.urlstring = self.urlstring.replacingOccurrences(of: " ", with: "%20")
                    print("check \(self.urlstring)")
                    
                    ref1.removeAllObservers()
                    self.locationManager.stopUpdatingLocation()
                    
                    self.tripIsStarted = "done"
                    
                    print("total distance in meters  \(self.total)")
                    print("total distance in KM  \(self.total/1000)")
                    let floatValue : CFloat = self.total/1000
                    
                    let valueInteger = Int(floatValue)
                    
                    
                    UserDefaults.standard.setValue("\(self.total/1000)", forKey: "completeTripPassDistance")
                    
                    UserDefaults.standard.setValue("\(finalFormat)", forKey: "completePrice")
                    
                    UserDefaults.standard.setValue("\(totalAmountFormatNew)", forKey: "completeDistance")
                    
                    let asdasd = UserDefaults.standard.object(forKey: "completePrice")
                    
                    
                    let asdas = UserDefaults.standard.object(forKey: "completeDistance")
                    
                    
                    
                    UserDefaults.standard.setValue("\(finalTotalPrice)", forKey: "completeTripPassPrice")
                    
                    print("complete trip")
                    if(trip_id != "nil"){
                        
                        
                        //   self.appDelegate.distance = self.total / 1000.0  // old hided
                        
                        self.appDelegate.distance = finalTotalPrice
                        
                        print(self.appDelegate.trip_id)
                        self.appDelegate.trip_id = self.trip_id
                        
                        
                        
                        
                        if(trip_id != "nil"){
                            self.tripStatusUpdating(urlString: self.urlstring)
                        }
                        
                        self.tripDistance = 0
                        UserDefaults.standard.removeObject(forKey: "tripRunningDistance")

                        /*  self.viewOffline.isHidden = false
                         self.completeTripView.isHidden=true
                         self.incoming = 0
                         
                         self.rideraddressview.isHidden = true
                         
                         self.rideraddressview.isHidden = true*/
                        self.multipledestinationfare = 0
                        self.viewMap.clear()
                        
                        //            self.navigationController?.pushViewController(ARCompleteTripVC(), animated: true)
                        
                        
                        
                        
                        // self.resetReqID()
                        
                    }
                    
                    UserDefaults.standard.setValue("", forKey: "Droplat")
                    UserDefaults.standard.setValue("", forKey: "Droplng")
                    
                    UserDefaults.standard.setValue("", forKey: "pickuplat")
                    UserDefaults.standard.setValue("", forKey: "pickuplng")
                    UserDefaults.standard.removeObject(forKey: "TripID")
                    if(self.arrayOfNonDuplicate.count == 0){
                        let ref11 = FIRDatabase.database().reference().child("drivers_data").child(self.appDelegate.userid!).child("accept")
                        ref11.updateChildValues(["tollfee": "0"])
                        self.appDelegate.final_tollfee = "0"
                        self.appDelegate.previous_tollfee = "0"
                    }
                    

                }
            }
        })

        
            }
    func setUsersClosestCity()
    {
        let geoCoder = CLGeocoder()
        let latitude :CLLocationDegrees = currentLocation.coordinate.latitude
        let longitude :CLLocationDegrees = currentLocation.coordinate.longitude
        let location = CLLocation(latitude: latitude, longitude: longitude)
        geoCoder.reverseGeocodeLocation(location)
        {
            (placemarks, error) -> Void in
            
            let placeArray = placemarks as [CLPlacemark]!
            
            // Place details
            var placeMark: CLPlacemark!
            placeMark = placeArray?[0]
            
            if(placeMark != nil){
            
            // Address dictionary
            print("\(placeMark.addressDictionary!)")
            
            // Location name
            if let locationName = placeMark.addressDictionary?["Name"] as? NSString
            {
                print(locationName)
                
            }
            // Street address
            if let street = placeMark.addressDictionary?["Thoroughfare"] as? NSString
            {
                print(street)
                self.country = street as String
                print(self.country)
                self.appDelegate.str1 = street as String!
                
            }
            
            // City
            if let city = placeMark.addressDictionary?["City"] as? NSString
            {
                print(city)
                self.appDelegate.city1 = city as String!
            }
            
            // Zip code
            if let zip = placeMark.addressDictionary?["ZIP"] as? NSString
            {
                print(zip)
                
                self.appDelegate.zip1 = zip as String
                
            }
            
            // Country
            if let country = placeMark.addressDictionary?["Country"] as? NSString
            {
                print(country)
                
                self.appDelegate.con1 = country as String
                print("mmm\(self.appDelegate.con1!)")
            }
            
          }
            
        }
    }
    
    func observeCancelTrip(){
        
        /*self.startTripView.isHidden=true
        self.arriveNowView.isHidden = true
        self.viewContact.isHidden = true
        self.viewBlurCurrentTrip.isHidden = true
        self.viewMap.clear()
        var ref = FIRDatabase.database().reference()
        ref.removeAllObservers()
        locationManager.stopUpdatingLocation()
        appDelegate.callMapVC()*/
        
    }
    
    func observeCancelTripWithPutNotification(){
        
        self.notification(Status: "Rider Cancelled the trip")

         self.arrayOfSample.removeAllObjects()
        
        self.viewRequestNew.isHidden = false
        self.viewOffline.isHidden = false
        
        self.btnroute.isHidden = true
        self.btnvoiceonoff.isHidden = true
        self.startTripView.isHidden=true
        self.arriveNowView.isHidden = true
        self.viewContact.isHidden = true
        self.viewBlurCurrentTrip.isHidden = true
        self.markTestView.isHidden = true

        self.viewMap.clear()
        
        var ref = FIRDatabase.database().reference()
        ref.removeAllObservers()
        
        locationManager.stopUpdatingLocation()
        UserDefaults.standard.removeObject(forKey: "TripID")
//        appDelegate.callMapVC()
        
    }
    
    func callCancelTrip(){
        
        UserDefaults.standard.removeObject(forKey: "rider_id")
        self.arrayOfSample.removeAllObjects()
        if(arrayOfNonDuplicate.count < 2 && arrayOfNonDuplicate.count > 0){
      
        // UserDefaults.standard.setValue("", forKey: "rider_id")
        
        self.startTripView.isHidden=true
        self.arriveNowView.isHidden = true
        self.viewContact.isHidden = true
        self.viewBlurCurrentTrip.isHidden = true
        
        let ref1 = FIRDatabase.database().reference().child("drivers_data").child(self.appDelegate.userid!).child("accept")
        ref1.updateChildValues(["status": "5"])

        let refClearRequest = FIRDatabase.database().reference().child("drivers_data").child(self.appDelegate.userid!).child("request")
        let zero = 0
        refClearRequest.updateChildValues(["eta": zero])
        refClearRequest.updateChildValues(["req_id": ""])
        refClearRequest.updateChildValues(["status": zero])
        
        urlstring = "\(live_request_url)requests/updateTrips/trip_id/\(self.trip_id)/trip_status/cancel/accept_status/5/distance/0/total_amount/0"
        // cancel trip status
        
        
        if(trip_id != "nil"){
            
            self.tripStatusUpdating(urlString: urlstring)
            
            
        }
        else{
            
        }
        
        ref1.updateChildValues(["trip_id": ""])
        ref1.updateChildValues(["trip_id_rider_name": ""])

        self.viewMap.clear()
    
        var ref2 = FIRDatabase.database().reference().child("drivers_data").child(self.appDelegate.userid!).child("accept")
        ref2.updateChildValues(["status": ""])

        
        ref1.removeAllObservers()
        ref2.removeAllObservers()

        locationManager.stopUpdatingLocation()
        
        
      // self.tripIsStarted = "done"
        
        print("cancel trip")
            
            if(self.appDelegate.usertouchdtrip1 != "0"){
                
                UserDefaults.standard.set(values, forKey: "passTripsIndex")
                
                self.getSome1 = UserDefaults.standard.integer(forKey: "passTripsIndex")
                
                print("\(getSome1)")
                
                self.appDelegate.usertouchdtrip1 = "0"
                
            }
            else{
                if(arrayOfNonDuplicate.count > 0){
                    self.getSome1 = self.arrayOfNonDuplicate.count - 1
                    
                    print("\(getSome1)")
                    
                }
            }
            
            
            
            print(getSome1)
            
           
            
            //to get tripid to cancel particular trip
            if(arrayOfNonDuplicate.count > 0){
            var getIndex = "\(arrayOfNonDuplicate[0])"
            
            print("values got \(getIndex)")
            
            
            getIndex = getIndex.replacingOccurrences(of: "[", with: "")
            getIndex = getIndex.replacingOccurrences(of: "\"", with: "")
            getIndex = getIndex.replacingOccurrences(of: "]", with: "")
            getIndex = getIndex.replacingOccurrences(of: "\n", with: "")
            getIndex = getIndex.replacingOccurrences(of: "(", with: "")
            getIndex = getIndex.replacingOccurrences(of: ")", with: "")
            
            
            let finalString = "\(getIndex)"
            
            
            print("values got \(finalString)")
            
            
            var newlink = finalString.components(separatedBy: ":").first
            
            print(newlink! as String)
                
                newlink = newlink?.replacingOccurrences(of: " ", with: "")
            
            self.passTagRiderTripId = newlink!
                
                var ref1 = FIRDatabase.database().reference().child("trips_data").child(self.passTagRiderTripId)
                ref1.updateChildValues(["status": "5"])
            }
            let pass = self.arrayOfNonDuplicate
            
            pass.removeObject(at: getSome1)
            
            print("remove array element \(self.arrayOfNonDuplicate)")
            
            UserDefaults.standard.set(self.arrayOfNonDuplicate, forKey: "arrayOfTripsData")
            
            let check  = UserDefaults.standard.array(forKey: "arrayOfTripsData")
            
            print("arrayofTripsData \(check)")
        
        UserDefaults.standard.setValue("", forKey: "Droplat")
        UserDefaults.standard.setValue("", forKey: "Droplng")
        
        UserDefaults.standard.setValue("", forKey: "pickuplat")
        UserDefaults.standard.setValue("", forKey: "pickuplng")
         UserDefaults.standard.removeObject(forKey: "TripID")

        appDelegate.callMapVC()
        }
        else{
            if(arrayOfNonDuplicate.count > 1){
                if(self.appDelegate.usertouchdtrip1 != "0"){
                    
                    UserDefaults.standard.set(values, forKey: "passTripsIndex")
                    
                    self.getSome1 = UserDefaults.standard.integer(forKey: "passTripsIndex")
                    
                    print("\(getSome1)")
                    
                    self.appDelegate.usertouchdtrip1 = "0"
                    
                }
                else{
                    if(arrayOfNonDuplicate.count > 0){
                        self.getSome1 = self.arrayOfNonDuplicate.count - 1
                        
                        print("\(getSome1)")
                        
                    }
                }
                
              
                
                print(getSome1)
                
                
                
                //to get tripid to cancel particular trip
                if(arrayOfNonDuplicate.count > 1){
                    var getIndex = "\(arrayOfNonDuplicate[getSome1])"
                    
                    print("values got \(getIndex)")
                    
                    
                    getIndex = getIndex.replacingOccurrences(of: "[", with: "")
                    getIndex = getIndex.replacingOccurrences(of: "\"", with: "")
                    getIndex = getIndex.replacingOccurrences(of: "]", with: "")
                    getIndex = getIndex.replacingOccurrences(of: "\n", with: "")
                    getIndex = getIndex.replacingOccurrences(of: "(", with: "")
                    getIndex = getIndex.replacingOccurrences(of: ")", with: "")
                    
                    
                    let finalString = "\(getIndex)"
                    
                    
                    print("values got \(finalString)")
                    
                    
                    var newlink = finalString.components(separatedBy: ":").first
                    
                    print(newlink! as String)
                    
                    newlink = newlink?.replacingOccurrences(of: " ", with: "")
                    
                    self.passTagRiderTripId = newlink!
                    
                    var ref1 = FIRDatabase.database().reference().child("trips_data").child(self.passTagRiderTripId)
                    ref1.updateChildValues(["status": "5"])
                }

                let pass = self.arrayOfNonDuplicate
                
                pass.removeObject(at: getSome1)
                
                print("remove array element \(self.arrayOfNonDuplicate)")
                
                UserDefaults.standard.set(self.arrayOfNonDuplicate, forKey: "arrayOfTripsData")
                
                let check  = UserDefaults.standard.array(forKey: "arrayOfTripsData")
                
                print("arrayofTripsData \(check)")
                UserDefaults.standard.removeObject(forKey: "TripID")
                
                appDelegate.callMapVC()
                
            }
            
        }
    }

    
    func phone(phoneNum: String) {
        
        if let url = URL(string: "tel://\(phoneNum)") {
            if #available(iOS 10, *) {
                
                if UIApplication.shared.canOpenURL(url){
                    
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    
                }
                else{
                    
                    self.callNotSupportAlert(error: "This device not support to call")
                }
            } else {
                
                UIApplication.shared.openURL(url as URL)
            }
        }
    }
    
    func callNotSupportAlert(error : String){
        
        let warning = MessageView.viewFromNib(layout: .CardView)
        warning.configureTheme(.warning)
        warning.configureDropShadow()
        let iconText = "" //"🤔"
        warning.configureContent(title: "", body: "\(error)", iconText: iconText)
        warning.button?.isHidden = true
        var warningConfig = SwiftMessages.defaultConfig
        warningConfig.presentationContext = .window(windowLevel: UIWindowLevelStatusBar)
        SwiftMessages.show(config: warningConfig, view: warning)
        
    }

    func msgAction(msgNum : String){
        
        if (MFMessageComposeViewController.canSendText()) {
            let controller = MFMessageComposeViewController()
            controller.body = " "
            controller.recipients = ["\(msgNum)"]
            controller.messageComposeDelegate = self
            self.present(controller, animated: true, completion: nil)
        }else{
            
            self.callNotSupportAlert(error: "This device not support to message")
        }
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        //... handle sms screen actions
        self.dismiss(animated: true, completion: nil)
    }

    func insertTripsData(distancePassTh : String , pricePassTh : String){
    
        // To insert default data for trips data
        
        
            //            var total  = String(format: "%.2f", (self.appDelegate.distance))
            //            total = total.replacingOccurrences(of: "Optional(", with: "")
            //            total = total.replacingOccurrences(of: ")", with: "")
            //            total = total.replacingOccurrences(of: "\"", with: "")
            
            let total = self.appDelegate.distance
        
        
            var trimTotal = String(format: "%.2f", total!)
            trimTotal = trimTotal.replacingOccurrences(of: "Optional(", with: "")
            trimTotal = trimTotal.replacingOccurrences(of: ")", with: "")
            trimTotal = trimTotal.replacingOccurrences(of: "\"", with: "")
        
            let myDistance = Int(total!)
        
            let amount = (self.appDelegate.distance) * 4
            
            var trimAmount = String(format: "%.2f", amount)
            trimAmount = trimAmount.replacingOccurrences(of: "Optional(", with: "")
            trimAmount = trimAmount.replacingOccurrences(of: ")", with: "")
            trimAmount = trimAmount.replacingOccurrences(of: "\"", with: "")
            
            let ref = FIRDatabase.database().reference().child("trips_data")
        
            var valueInteger = self.total/1000
        
        
            let amountNew = self.appDelegate.distance
        
            var trimTotalNew = String(format: "%.2f", amountNew!)
            //var trimTotalNew = String(format: "%.0f", amountNew!)
            trimTotalNew = trimTotalNew.replacingOccurrences(of: "Optional(", with: "")
            trimTotalNew = trimTotalNew.replacingOccurrences(of: ")", with: "")
            trimTotalNew = trimTotalNew.replacingOccurrences(of: "\"", with: "")
        
            let trimDistanceNew = String(format: "%.1f", valueInteger)


            let newUser = [
                
                "Distance" : "\(trimDistanceNew)",
                "Price" : "\(trimTotalNew)",
               // "rider_rating" : "0",
               // "driver_rating" : "0",
            ]
            
            let appendingPath = ref.child(byAppendingPath: "\(self.appDelegate.trip_id!)")
            appendingPath.updateChildValues(newUser)
           // appendingPath.setValue(newUser)
    }
    

    
    
    func payment(){
        
    }
    

    
    func tripStatusUpdating(urlString: String){
        if(trip_id != "nil"){
            print(urlString)
            var urlstring:String! = urlString
            print(urlstring)
            urlstring = urlstring.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!
            print("\(urlstring)")
            
            
            let manager : AFHTTPRequestOperationManager = AFHTTPRequestOperationManager()
            
            manager.responseSerializer.acceptableContentTypes =  Set<AnyHashable>(["application/json", "text/json", "text/javascript", "text/html"])
            
            manager.get( "\(urlstring!)",
                parameters: nil,
                success: { (operation: AFHTTPRequestOperation?,responseObject: Any?) in
                    let jsonObjects=responseObject as! NSArray
                    //                var dataDict: NSDictionary?
                    
                    let value = jsonObjects[0] as AnyObject
                    
                    if(((value["rider_id"] as? String)) != nil){
                        self.appDelegate.rider_id = (value["rider_id"] as? String)!
                    }
                    if((value["accept_status"] as? String) == "1"){
                        let sta:String = (value["accept_status"] as? String)!
                        print("\(sta)")
                        let pickup:NSDictionary = (value["pickup"] as? NSDictionary)!
                        let destination:NSDictionary = (value["destination"] as? NSDictionary)!
                        
                        print("Pickup_Lat:\(pickup["lat"]!)")
                        print("Pickup_lon:\(pickup["long"]!)")
                        
                        print("Destination_Lat:\(destination["lat"]!)")
                        print("Destination_Lon:\(destination["long"]!)")
                        
                        let pickupLat:String = (pickup["lat"] as? String)!
                        let pickupLong:String = (pickup["long"] as? String)!
                        
                        let destLat:String = (destination["lat"] as? String)!
                        let destLong:String = (destination["long"] as? String)!
                        self.myOrigin = self.currentLocation
                        self.myDestination = CLLocation(latitude: Double(pickupLat)!,longitude: Double(pickupLong)!)
                        self.pickupLocation = CLLocation(latitude: Double(pickupLat)!,longitude: Double(pickupLong)!)
                        //self.dropDestination = CLLocation(latitude: Double(destLat)!,longitude: Double(destLong)!)
                        self.getCurrnentAddress(myLocation: self.myDestination)
                        self.updatedloc = "0"
                    }
                    else if((value["accept_status"] as? String) == "2"){
                        let sta:String = (value["accept_status"] as? String)!
                        print("\(sta)")
                        let pickup:NSDictionary = (value["pickup"] as? NSDictionary)!
                        let destination:NSDictionary = (value["destination"] as? NSDictionary)!
                        
                        print("Pickup_Lat:\(pickup["lat"]!)")
                        print("Pickup_lon:\(pickup["long"]!)")
                        
                        print("Destination_Lat:\(destination["lat"]!)")
                        print("Destination_Lon:\(destination["long"]!)")
                        
                        let pickupLat:String = (pickup["lat"] as? String)!
                        let pickupLong:String = (pickup["long"] as? String)!
                        
                        let destLat:String = (destination["lat"] as? String)!
                        let destLong:String = (destination["long"] as? String)!
                        self.myOrigin = self.currentLocation
                        self.myDestination = CLLocation(latitude: Double(pickupLat)!,longitude: Double(pickupLong)!)
                        self.pickupLocation = CLLocation(latitude: Double(pickupLat)!,longitude: Double(pickupLong)!)
                        //self.dropDestination = CLLocation(latitude: Double(destLat)!,longitude: Double(destLong)!)
                       self.updatedloc = "0"
                        self.getCurrnentAddress(myLocation: self.myDestination)
                    }else if((value["accept_status"] as? String) == "3"){
                        let sta:String = (value["accept_status"] as? String)!
                        print("\(sta)")
                        let pickup:NSDictionary = (value["pickup"] as? NSDictionary)!
                        let destination:NSDictionary = (value["destination"] as? NSDictionary)!
                        
                        print("Pickup_Lat:\(pickup["lat"]!)")
                        print("Pickup_lon:\(pickup["long"]!)")
                        
                        print("Destination_Lat:\(destination["lat"]!)")
                        print("Destination_Lon:\(destination["long"]!)")
                        let pickupLat:String = (pickup["lat"] as? String)!
                        let pickupLong:String = (pickup["long"] as? String)!
                        let destLat:String = (destination["lat"] as? String)!
                        let destLong:String = (destination["long"] as? String)!
                        self.myOrigin = self.currentLocation
                        self.myDestination = CLLocation(latitude: Double(pickupLat)!,longitude: Double(pickupLong)!)
                        self.dropDestination = CLLocation(latitude: Double(destLat)!,longitude: Double(destLong)!)
                        self.updatedloc = "0"
                        self.getCurrnentAddress(myLocation: self.dropDestination)
                    }
                    else if((value["accept_status"] as? String) == "4")
                    {
                        let pickup:NSDictionary = (value["pickup"] as? NSDictionary)!
                        let destination:NSDictionary = (value["destination"] as? NSDictionary)!

                        let pickupLat:String = (pickup["lat"] as? String)!
                        let pickupLong:String = (pickup["long"] as? String)!
                        let destLat:String = (destination["lat"] as? String)!
                        let destLong:String = (destination["long"] as? String)!
                        
                        self.myOrigin = self.currentLocation
                        self.myDestination = CLLocation(latitude: Double(pickupLat)!,longitude: Double(pickupLong)!)
                        self.dropDestination = CLLocation(latitude: Double(destLat)!,longitude: Double(destLong)!)
                        self.updatedloc = "0"
                        self.getCurrnentAddress(myLocation: self.dropDestination)
                        
                        var tripAmount = "0.0"
                        if let floatAmt = value["total_price"] as? Float{
                            tripAmount = String(format: "%.1f", floatAmt)
                        }
                        else if let doubleAmt = value["total_price"] as? Double{
                            tripAmount = String(format: "%.1d", doubleAmt)
                        }
                        else if let strAmt = value["total_price"] as? String{
                            tripAmount = String(format: "%@", strAmt)
                        }
                        
                        
                        //Inserting the trip data in the Firebase
                        let ref = FIRDatabase.database().reference().child("trips_data")
                        
                       let trimDistanceNew = String(format: "%.1f", self.tripDistance/1000)
                        
                        
                        let newUser = [
                            
                            "Distance" : "\(trimDistanceNew)",
                            "Price" : "\(tripAmount)",
                        ]
                        
                        let appendingPath = ref.child(byAppendingPath: "\(self.appDelegate.trip_id!)")
                        appendingPath.updateChildValues(newUser)
//                        self.insertTripsData(distancePassTh: "\(self.tripDistance/1000)", pricePassTh: "\(tripAmount)")

                        
                        //Update internally as well to use in Complete trip screen
                        
                        UserDefaults.standard.setValue("\(tripAmount)", forKey: "completePrice")
                        
                        UserDefaults.standard.setValue("\(trimDistanceNew)", forKey: "completeDistance")

                        let vC = ARCompleteTripVC()
                        vC.passSampleFinalArray = self.arrayOfSample
                        vC.passNonDuplicateFinalArray = self.arrayOfNonDuplicate
                        vC.modalPresentationStyle = .formSheet
                        vC.modalTransitionStyle = .coverVertical
                        self.present(vC, animated: true, completion: nil)


                    }

                    print(value)
                    self.autoUpdateforLocation()
                    self.updatedloc = "0"
                    
            },
                failure: { (operation: AFHTTPRequestOperation?,error: Error) in
                    print("Error: " + error.localizedDescription)
            })
 
        }
        
    }
    
    func getRiderDetails(){
        
        // calling driver profile url
        // self.appDelegate.rider_id
        
        if UserDefaults.standard.value(forKey: "rider_id") != nil {
            var rider_id = UserDefaults.standard.value(forKey: "rider_id") as? String

            rider_id = rider_id?.replacingOccurrences(of: "Optional(", with: "")
            rider_id = rider_id?.replacingOccurrences(of: ")", with: "")
            rider_id = rider_id?.replacingOccurrences(of: "\"", with: "")
            
            if rider_id != "" {
                self.appDelegate.rider_id = rider_id
            }

        }


        var urlstring:String = "\(live_rider_url)editProfile/user_id/\(self.appDelegate.rider_id!)"
        
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
                    var country_code = result["country_code"] as? String
                    var firstname = result["firstname"] as? String
                    var lastname = result["lastname"] as? String
                    var profile_pic = result["profile_pic"] as? String
                    var car_category = result["car_category"] as? String
                    var mobile = result["mobile"] as? String

                  print("car_category\(car_category)")

                    if profile_pic == nil ||  profile_pic == ""
                    {
                        
                        self.imageViewPickUpRider.image = UIImage(named : "UserPic.png")
                    }
                    else
                    {
                        profile_pic = (profile_pic as AnyObject).replacingOccurrences(of: "Optional(", with: "")
                        profile_pic = (profile_pic as AnyObject).replacingOccurrences(of: ")", with: "")
                        profile_pic = (profile_pic as AnyObject).replacingOccurrences(of: "\"", with: "")
                        profile_pic = (profile_pic as AnyObject).replacingOccurrences(of: "%20", with: " ")
                        let imageURL1 = profile_pic
                        print("sample")
                        print("imageURL1~\(String(describing: imageURL1))")
                        let url = URL(string: imageURL1!)
                        self.imageViewPickUpRider.setImageWithUrl(url!)


                        
                                          }
                    
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
                    
                    if self.carcategoryname == nil{
                        
                        car_category = ""
                         // self.carcategoryname = carcategory
                    }
                    else{
                        
//                        car_category = (car_category as AnyObject).replacingOccurrences(of: "Optional(", with: "")
//                        car_category = (car_category as AnyObject).replacingOccurrences(of: ")", with: "")
//                        car_category = (car_category as AnyObject).replacingOccurrences(of: "%20", with: " ")

                        self.labelPickUpRiderCar.text! = self.carcategoryname
                        
                    }
                    
                    var carCategory = UserDefaults.standard.object(forKey: "carCategoryRegister") as! String
                    
                    if carCategory == nil || carCategory == ""{
                        
                        self.labelPickUpRiderCar.text = ""
                    }
                        
                    else{
                        
                        self.labelPickUpRiderCar.text = carCategory
                        
                    }
                    
                    if mobile == nil{
                        
                        mobile = ""
                    }
                    else{
                        
                        mobile = (mobile as AnyObject).replacingOccurrences(of: "Optional(", with: "")
                        mobile = (mobile as AnyObject).replacingOccurrences(of: ")", with: "")
                        mobile = (mobile as AnyObject).replacingOccurrences(of: "%20", with: " ")
                        
                        UserDefaults.standard.set(mobile, forKey: "acceptedRiderMobile")

                    }
                    
                    if(self.trip_id != "nil" && self.trip_id != ""){
                        self.arrayOfTripID.add(self.trip_id)
                    }
                    //var fullName:String! = "\(firstname) \(lastname)"
                    var fullName:String! = "\(firstname)"
                    
                    fullName = (fullName as AnyObject).replacingOccurrences(of: "Optional(", with: "")
                    fullName = (fullName as AnyObject).replacingOccurrences(of: ")", with: "")
                    fullName = (fullName as AnyObject).replacingOccurrences(of: "\"", with: "")
                    fullName = (fullName as AnyObject).replacingOccurrences(of: "%20", with: " ")
                    
                   // self.imageViewPickUpRider.setImageWithUrl(url!)
                    
                   
                    
                   
                    
                    
                    
                    print("self.appDelegate.trip_idwithname\(self.appDelegate.trip_idwithname)")
                    
                    if(self.appDelegate.trip_idwithname != "" && self.appDelegate.trip_idwithname != "null" && self.appDelegate.trip_idwithname != nil){
//                        let imageURL1 = profile_pic
//                        print("sample")
//                        print("imageURL1~\(String(describing: imageURL1))")
//                        let url = URL(string: imageURL1!)
                        
                        
                        UserDefaults.standard.setValue(profile_pic, forKey: "rpRiderImage")

                        UserDefaults.standard.set(self.trip_id, forKey: "TripID")
                        self.arrivenowLabel.text! = fullName
                        self.startTripLabel.text! = fullName
                        self.completeTripLabel.text! = fullName
                        self.labelPickUpRider.text! = fullName
                        self.appDelegate.riderName = fullName
//                        self.imageViewPickUpRider.setImageWithUrl(url!)
                        print(self.arrivenowLabel.text!)
                        
                        print(self.trip_id)
                        print(self.arrayOfTripID)
                        print(self.arrivenowLabel.text!)
                        
                        self.loadTripsID(riderName: self.appDelegate.trip_idwithname!)
                    
                        self.loadTripsIDStartTrip(riderName: self.appDelegate.trip_idwithname!)
                    
                        self.loadTripsIDEndTrip(riderName: self.appDelegate.trip_idwithname!)
                        
                        
                        
                    }
//                       if(self.appDelegate.trip_idwithname != "" && self.appDelegate.trip_idwithname != "null" && self.appDelegate.trip_idwithname != nil){
//                         self.loadTripsID1(profile_pic: profile_pic!)
//                    }
                    
                    print("array of tripID 1 : \(self.arrayOfTripID)")
                    print("array of tripID count : \(self.arrayOfTripID.count)")
                    
                    
                    print("arriving now")

                  //  self.riderShowName = self.arrivenowLabel.text!
                    let getRiderTripsArray = self.arrayOfNonDuplicate
                    
                    print("get riders details func \(getRiderTripsArray)")
                    
                    if self.arrayOfNonDuplicate.count > 0{
                        if(self.appDelegate.toinsertid == "0")
                        {
                            self.setTripIdsInFirebase()
                           // UserDefaults.standard.removeObject(forKey: "rider_id")
                        }
                    }
                    else{
                        
                        
                    }

                }
        },
            failure: { (operation: AFHTTPRequestOperation?,error: Error) in
                print("Error: " + error.localizedDescription)
        })
        
        
    }
    
    func setTripIdsInFirebase(){
        
        
        print(self.trip_id)
       /* if UserDefaults.standard.value(forKey: "TripID") != nil{
            
            var tripID = UserDefaults.standard.value(forKey: "TripID") as! String
            tripID = tripID.replacingOccurrences(of: "Optional(", with: "")
            tripID = tripID.replacingOccurrences(of: ")", with: "")
            tripID = tripID.replacingOccurrences(of: "\"", with: "")
            
            self.trip_id = tripID
        }
        */
        if(self.trip_id != nil){
        let ref1 = FIRDatabase.database().reference()
        
        let userId = self.appDelegate.userid
        
        let riderID = self.appDelegate.rider_id
        
        
        let newUser = [
            
            "Distance": "0",
            
            "Price": "0",
            
            "driver_rating" : "0" ,
            
            "driverid" : "\(userId!)" ,

            "rider_rating" : "0" ,
            
            "tollfee" : "0" ,

            "riderid" : "\(riderID!)" ,

            "status" : "1" ,

            ]
        
         ref1.child(byAppendingPath: "trips_data").child(self.trip_id).setValue(newUser)
        }else{
            print("trip id is  NULL")
        }
        self.firstKnowTripsStatus()
        //self.getTripStatus()
        
    }
     //Speaking function
    
    func speakString(phrase : String){
        print("[speakString]")
        if(voiceturnedon == "1"){
        if (hablar){
            if #available(iOS 10.2, *) {
//                let speechUtterance = AVSpeechUtterance(string: String(describing: INSpeakableString.init(spokenPhrase: phrase)))
//                speechUtterance.voice = AVSpeechSynthesisVoice(language: language);
//                speechUtterance.rate = Float(rate);
//                speechUtterance.pitchMultiplier = Float(pitch);
//                speechUtterance.volume = Float(volume);
//                speechSynthesizer.delegate = self
//                speechSynthesizer.speak(speechUtterance);

            } else {
                // Fallback on earlier versions
                
            };
                    }
        }
    }
    
    func gettingDirectionsAPI(){
        
        // myOrigin = CLLocation(latitude: 9.9252, longitude: 78.1198)
        // myDestination = CLLocation(latitude: 13.0827, longitude: 80.2707)
        
        let originString = "\(myOrigin.coordinate.latitude),\(myOrigin.coordinate.longitude)"
        let destinationString = "\(myDestination.coordinate.latitude),\(myDestination.coordinate.longitude)"
        
        // old Key == > &key=AIzaSyD_nwCI7RqGsWkwWeEoJb-KkdVaIfDhFxc
        
        /*if(self.waypointmerge != ""){
            self.getdirectionurlstring = "https://maps.googleapis.com/maps/api/directions/json?&origin=\(originString)&destination=\(destinationString)&waypoints=\(waypointmerge)&mode=driving&key=\(self.googleKey)"
        }
        else{*/
            self.getdirectionurlstring = "https://maps.googleapis.com/maps/api/directions/json?&origin=\(originString)&destination=\(destinationString)&mode=driving&key=\(self.googleKey)"
        //}
        
        self.getdirectionurlstring = self.getdirectionurlstring.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!
        print(self.getdirectionurlstring)
        
        let manager : AFHTTPRequestOperationManager = AFHTTPRequestOperationManager()
        
        manager.responseSerializer.acceptableContentTypes =  Set<AnyHashable>(["application/json", "text/json", "text/javascript", "text/html"])
        
        manager.get( "\(self.getdirectionurlstring)",
            parameters: nil,
            success: { (operation: AFHTTPRequestOperation?,responseObject: Any?) in
                let jsonObjects:NSDictionary = responseObject as! NSDictionary
                
                if(jsonObjects["status"] as! String != "NOT_FOUND"){
                    
                    let routesArray:NSArray = jsonObjects["routes"] as! NSArray
                    //self.viewMap.clear()
                    
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
                            // For changes in PolylineColor use this code
                          //  self.polyline.strokeColor = UIColor(red:0.0/255.0, green:128.0/255.0, blue:227.0/255.0, alpha: 1.0)
                            self.polyline.geodesic = true
                            self.polyline.map = self.viewMap
                            
                            self.markera.map = self.viewMap
                            //self.marker.snippet = "Pickup Location"
                            self.markera.appearAnimation = kGMSMarkerAnimationNone
                            let carCategory1 = UserDefaults.standard.object(forKey: "carCategoryRegister") as! String
                            if(carCategory1 == "6-Seater"){
                                self.markera.icon = UIImage(named: "map_lux.png")
                            }
                            else if(carCategory1 == "6-Seater_Luxury"){
                                self.markera.icon = UIImage(named: "map_suv.png")
                            }
                            else if(carCategory1 == "Taxi"){
                                self.markera.icon = UIImage(named: "map_taxi.png")
                            }
                            else{
                                self.markera.icon = UIImage(named: "map_taxi.png")
                            }
                            self.markera.map = self.viewMap
                            self.markera.position = CLLocationCoordinate2D(latitude: self.myOrigin.coordinate.latitude, longitude: self.myOrigin.coordinate.longitude)
                            self.markera.groundAnchor = CGPoint(x: 0.5, y: 0.5)
                            self.markera.tracksViewChanges = false
                            
                            if let routeDict:NSDictionary = (routesArray[0] as? NSDictionary){
                                
                                if let legsArray:NSArray = (routeDict["legs"] as? NSArray){
                                    
                                    if let legs:NSDictionary = (legsArray[0] as? NSDictionary){
                                        
                                        if let stepsArray:NSArray = (legs["steps"] as? NSArray){
                                            
                                            if let startLocation:NSDictionary = (stepsArray[0] as? NSDictionary){
                                                
                                                if((startLocation["html_instructions"]) != nil){
                                                    if var maneuver:String = (startLocation["html_instructions"] as! String){
                                                        
                                                        maneuver = maneuver.html2String
                                                        print(maneuver)
                                                        
                                                        if(self.previous_route != maneuver){
                                                        self.voiceTxt.text = maneuver
                                                           self.voiceTxt.isHidden = false
                                                           self.timer_speech = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(self.hideVoiceMsg), userInfo: nil, repeats: true)
                                                           self.speakString(phrase: maneuver)
                                                           self.previous_route = maneuver
                                                        }
                                                        
                                                    }
                                                }
                                                
                                                if let start_location:NSDictionary = (startLocation["end_location"] as? NSDictionary){
                                                    
                                                    let lat = (start_location["lat"])
                                                    let lng = (start_location["lng"])
                                                    
                                                   // self.setUsersClosestCity()
                                                    
                                                    print("\(lat!) , \(lng!)")
                                                    
                                                    let bearingPosition = self.getBearing(toPoint: CLLocationCoordinate2D(latitude: lat as! CLLocationDegrees, longitude: lng as! CLLocationDegrees))
                                                    let anglePosition = self.angle
                                                    self.locationManager.startUpdatingHeading()
                                                    self.markera.rotation = self.course
                                                   
                                                    if self.isPendingUpdate == "updating"{
                                                        self.isPendingUpdate = "update"
                                                    }
                                                    
                                                    if self.tripIsStarted == "yes"{


                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            } 
                      
                            let fancy = GMSCameraPosition.camera(withLatitude: self.myOrigin.coordinate.latitude, longitude: self.myOrigin.coordinate.longitude, zoom: 17, bearing: self.course, viewingAngle: 30)
                            self.viewMap.animate(to: fancy)
                            
                            
                            //self.marker1.map = nil
//                            self.marker1.snippet = "Drop Location"
                            self.marker1.appearAnimation = kGMSMarkerAnimationNone
                            self.marker1.icon = UIImage(named: self.imageName) //  to set pickup location
                            self.marker1.map = self.viewMap
                            self.marker1.position = CLLocationCoordinate2D(latitude: self.myDestination.coordinate.latitude, longitude: self.myDestination.coordinate.longitude)
                            self.markercount = 0
                            
                            var ref1 = FIRDatabase.database().reference()
                            ref1.child("riders_location").child(self.appDelegate.rider_id!).child("WayPointCount").observeSingleEvent(of: .value, with: { (snapshot) in
                                if(snapshot.exists()){
                                    if snapshot.value != nil{
                                        print("Snapshot value is not equal to nil")
                                        print(snapshot.value)
                                        
                                        let waypointcount1 = snapshot.value!
                                        
                                        let waypointcount = Int((waypointcount1 as AnyObject) as! NSNumber)
                                        
                                        
                                        
                                        for var i in 1..<waypointcount+1 {
                                            print(i)
                                            var count = 0
                                            FIRDatabase.database().reference().child("riders_location").child(self.appDelegate.rider_id!).child("DestinationWaypoints").child("WayPoint \(i)").observeSingleEvent(of: .value, with: { (snapshot) in
                                                if(snapshot.exists()){
                                                    print(snapshot.value)
                                                    
                                                    if snapshot.value != nil{
                                                        FIRDatabase.database().reference().child("riders_location").child(self.appDelegate.rider_id!).child("DestinationWaypoints").child("WayPoint \(i)").child("Coordinates").observeSingleEvent(of: .value, with: { (snapshot) in
                                                            if(snapshot.exists()){
                                                                if(count == 0){
                                                                    print(snapshot.value)
                                                                    
                                                                    if snapshot.value != nil{
                                                                        let multidest = snapshot.value!
                                                                        print(multidest)
                                                                        print("multidest:\((multidest as AnyObject).count)")
                                                                        
                                                                        if let value = snapshot.value as? NSArray {
                                                                            if (multidest as AnyObject).count == 2{
                                                                                
                                                                                self.imageName1 = "markerloc1"
                                                                                self.imageName2 = "markerloc2"
                                                                                self.imageName3 = "markerloc3"
                                                                                self.imageName4 = "markerloc4"
                                                                                
                                                                                print(value[0])
                                                                                print(value[1])
                                                                                print("Waypoint is\("WayPoint \(i)")")
                                                                                if(self.waypointmerge1 == ""){
                                                                                    self.waypointmerge1 =  "via:\(value[0]),\(value[1])" as NSString
                                                                                    print(self.waypointmerge1)
                                                                                    
                                                                                    self.markerloc1.appearAnimation = kGMSMarkerAnimationNone
                                                                                    self.markerloc1.icon = UIImage(named: self.imageName1)
                                                                                    self.markerloc1.map = self.viewMap
                                                                                    self.myloc1 = CLLocation(latitude: value[0] as! CLLocationDegrees , longitude: value[1] as! CLLocationDegrees)
                                                                                    self.markerloc1.position = CLLocationCoordinate2D(latitude: self.myloc1.coordinate.latitude, longitude: self.myloc1.coordinate.longitude)
                                                                                    print(self.imageName1)
                                                                                    print(self.myloc1)
                                                                                }
                                                                                else{
                                                                                    if(self.waypointmerge1.contains("via:\(value[0]),\(value[1])")){
                                                                                        print("already added this location")
                                                                                    }
                                                                                    else{
                                                                                        self.waypointmerge1 =  "\(self.waypointmerge1)|via:\(value[0]),\(value[1])" as NSString
                                                                                        print(self.waypointmerge1)
                                                                                        self.markercount += 1
                                                                                        
                                                                                        if(self.markercount == 1){
                                                                                            self.markerloc2.appearAnimation = kGMSMarkerAnimationNone
                                                                                            self.markerloc2.icon = UIImage(named: self.imageName2)
                                                                                            self.markerloc2.map = self.viewMap
                                                                                            self.myloc2 = CLLocation(latitude: value[0] as! CLLocationDegrees, longitude: value[1] as! CLLocationDegrees)
                                                                                            self.markerloc2.position = CLLocationCoordinate2D(latitude: self.myloc2.coordinate.latitude, longitude: self.myloc2.coordinate.longitude)
                                                                                        }
                                                                                        else if(self.markercount == 2){
                                                                                            self.markerloc3.appearAnimation = kGMSMarkerAnimationNone
                                                                                            self.markerloc3.icon = UIImage(named: self.imageName3)
                                                                                            self.markerloc3.map = self.viewMap
                                                                                            self.myloc3 = CLLocation(latitude: value[0] as! CLLocationDegrees, longitude: value[1] as! CLLocationDegrees)
                                                                                            self.markerloc3.position = CLLocationCoordinate2D(latitude: self.myloc3.coordinate.latitude, longitude: self.myloc3.coordinate.longitude)
                                                                                        }
                                                                                        else if(self.markercount == 3){
                                                                                            self.markerloc4.appearAnimation = kGMSMarkerAnimationNone
                                                                                            self.markerloc4.icon = UIImage(named: self.imageName4)
                                                                                            self.markerloc4.map = self.viewMap
                                                                                            self.myloc4 = CLLocation(latitude: value[0] as! CLLocationDegrees, longitude: value[1] as! CLLocationDegrees)
                                                                                            self.markerloc4.position = CLLocationCoordinate2D(latitude: self.myloc4.coordinate.latitude, longitude: self.myloc4.coordinate.longitude)
                                                                                        }
                                                                                        else{
                                                                                            
                                                                                        }
                                                                                    }
                                                                                }
                                                                                
                                                                            }
                                                                        }
                                                                    }
                                                                    count += 1
                                                                }
                                                            }
                                                        })
                                                        
                                                        
                                                        i = i + 1
                                                        
                                                    }
                                                }
                                            })
                                            
                                            
                                        }
                                        if(waypointcount == 0){
                                            self.waypointmerge1 = ""
                                        }
                                        else{
                                            //self.gettingDirectionsAPI()
                                        }
                                        print(self.waypointmerge1)
                                        
                                    }
                                    else{
                                        print("Snapshot value is nil")
                                    }
                                    
                                }
                                
                                
                                
                            }) { (error) in
                                print(error.localizedDescription)
                            }
                            
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
    func hideVoiceMsg(){
        print("hidemsg")
        self.voiceTxt.isHidden = true
        self.timer_speech.invalidate()
    }
    
    func calcDistacneDynamic(){
    
        
        let d1 = distance1.coordinate.latitude
        let d2 = distance2.coordinate.latitude
        let d3 = distance3.coordinate.latitude
        
        let d11 = String(format: "%.2f", d1)
        let d21 = String(format: "%.2f", d2)
        let d31 = String(format: "%.2f", d3)
        print(d11)
        print(d21)
        print(d31)
        
        if d21 == "0.00" || d31 == "0.00" {
            
            self.distance2 = self.distance3
            
        }
        else{
            
            let distanceInMeters = self.distance2.distance(from: self.distance3) // result is in meters
            print("distanceInMeters from 2 to 3 \(distanceInMeters)")
            total = total + Float(distanceInMeters)
            print("total is \(total/1000)")
            self.distance2 = self.distance3
//self.autoUpdateforLocation()
       
        
        }

    
    }
    
    
    
    // this function is used to calc distance without 0.0
    
    /*func calcDistacneDynamic_00(){
        
        print(distance1)
        print(distance2)
        print(distance3)
        
        let d1 = distance1.coordinate.latitude
        let d2 = distance2.coordinate.latitude
        let d3 = distance3.coordinate.latitude
        
        let d11 = String(format: "%.2f", d1)
        let d21 = String(format: "%.2f", d2)
        let d31 = String(format: "%.2f", d3)
        print(d11)
        print(d21)
        print(d31)
        
        if d21 == "0.00" || d31 == "0.00" {
            
            self.distance2 = self.distance3

        }
        else{
            
            var total1 = ""
            
            if UserDefaults.standard.value(forKey: "DistanceKM") != nil {
                total1 = (UserDefaults.standard.value(forKey: "DistanceKM") as? String)!
                total1 = total1.replacingOccurrences(of: "Optional(", with: "")
                total1 = total1.replacingOccurrences(of: ")", with: "")
                total1 = total1.replacingOccurrences(of: "\"", with: "")
            }
            
            if total1 == "" || total1 == "0.0"{
                
                //calculate distance from starting
                
                let distanceInMeters = self.distance2.distance(from: self.distance3) // result is in meters
                print("distanceInMeters from 2 to 3 \(distanceInMeters)")
                total = total + distanceInMeters
                print("total is \(total/1000)")
                
            }
            else{
                
                // calculate distance from between or continued from closed.
                
                let distanceInMeters = self.distance2.distance(from: self.distance3) // result is in meters
                print("distanceInMeters from 2 to 3 \(distanceInMeters)")
                total = total + distanceInMeters
                print("total is \(total/1000)")
                
            }
            
            
            UserDefaults.standard.setValue("\(total/1000)" , forKey: "DistanceKM")
            self.distance2 = self.distance3

        }
        

        /*
         By changing previous as next and next as upnext using distance 2,3
         */

        
    } */
    

    
   
    
    
    func getBearing(toPoint point: CLLocationCoordinate2D) -> Double {
        func degreesToRadians(degrees: Double) -> Double { return degrees * M_PI / 180.0 }
        func radiansToDegrees(radians: Double) -> Double { return radians * 180.0 / M_PI }
        
        let lat1 = degreesToRadians(degrees: myOrigin.coordinate.latitude)
        let lon1 = degreesToRadians(degrees: myOrigin.coordinate.longitude)
        
        let lat2 = degreesToRadians(degrees: point.latitude);
        let lon2 = degreesToRadians(degrees: point.longitude);

        //19.017950, 72.856395
//        let lat2 = degreesToRadians(degrees: 19.017950);
//        let lon2 = degreesToRadians(degrees: 72.856395);

        let dLon = lon2 - lon1;
        
        let y = sin(dLon) * cos(lat2);
        let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon);
        let radiansBearing = atan2(y, x);
        
        self.viewMap.settings.compassButton = false
        self.viewMap.settings.rotateGestures = true
        
       /* let marker = GMSMarker()
        marker.snippet = "Bearing Location"
        marker.appearAnimation = kGMSMarkerAnimationNone
        marker.icon = UIImage(named: "Drivers.png")
        marker.map = self.viewMap
        marker.position = CLLocationCoordinate2D(latitude: lat1, longitude: lon1) */


        //self.viewMap.animate(toViewingAngle: radiansBearing)
        
//        return radiansToDegrees(radians: radiansBearing)
        return radiansToDegrees(radians: radiansBearing)
    }

    
    
    
    func getCurrnentAddress(myLocation : CLLocation){
        
        var dynamicLocation1 = CLLocation()
        
        dynamicLocation1 = myLocation
        
        // https://maps.googleapis.com/maps/api/geocode/json?latlng=9.9239,78.1140&sensor=true
        
        var urlstring:String = "https://maps.googleapis.com/maps/api/geocode/json?latlng=\(dynamicLocation1.coordinate.latitude),\(dynamicLocation1.coordinate.longitude)&sensor=true/"
        
        urlstring = urlstring.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!
        print(urlstring)
        
        self.callCurrenctLocation(url: "\(urlstring)")
        
        
    }
    
    var formattedAddress:String! = ""
    
    
    func callCurrenctLocation(url : String){
        
        Alamofire.request(url).responseJSON { (response) in
            print(url)
            //            print(response)
            do{
                
                let readableJSon:NSDictionary! = try JSONSerialization.jsonObject(with: response.data!, options: .mutableContainers) as! NSDictionary
                
                //print(" !!! \(readableJSon["results"]!)")
                
                if let value:NSArray = readableJSon["results"]! as? NSArray{
                    
                    //print(value[1])
                    if(value.count == 0){
                        
                    }
                    else{
                        if let zipArray: NSDictionary = value[0] as? NSDictionary{
                            //   print(zipArray)
                            if let zip:String = zipArray["formatted_address"] as? String{
                                // print(zip)
                                self.formattedAddress = zip
                          //      self.addressLabel.text = zip
                                print(self.previousaddr)
                                print(zip)
                                       print("zip\(self.formattedAddress)")
                                self.appDelegate.updatelocationname = self.formattedAddress
                                if(self.markTestView.isHidden == false && self.previousaddr != "" && self.previousaddr != zip && self.updatedloc == "1"){
                                    self.notification(Status: "Rider changed drop location.")
                                    self.appDelegate.updatelocatiostatus = 1
                                }
                            self.markTestView.isHidden = false
                            self.markTestInsideView.text = zip
                            print(self.markTestInsideView.text!)
                            self.previousaddr = self.markTestInsideView.text!
                                
                                var ref1 = FIRDatabase.database().reference()
                                
                                ref1.child("riders_location").child(self.appDelegate.rider_id).child("pickup_terminal").observe(.value, with: { (snapshot) in
                                    if(snapshot.exists()){
                                        if snapshot.value != nil{
                                            
                                            print("Snapshot value is not equal to nil")
                                            let d = snapshot.value!
                                            print(d)
                                            if("\(d)" != "" && "\(d)" != "None"){
                                                if(self.trip_id != nil && self.trip_id != "nil" && self.trip_id != ""){
                                                ref1.child("trips_data").child(self.trip_id).child("status").observeSingleEvent(of: .value, with: { (snapshot) in
                                                    if(snapshot.exists()){
                                                        if snapshot.value != nil{
                                                            let status1 = snapshot.value as Any
                                                            print(status1)
                                                            var status = "\(status1)"
                                                            status = status.replacingOccurrences(of: "Optional(", with: "")
                                                            status = status.replacingOccurrences(of: ")", with: "")
                                                            print(status)
                                                            if(status == "2" || status == "1"){
                                                            print("added terminal \(d) | \(zip)")
                                                            self.markTestInsideView.text = "\(d) | \(zip)"
                                                            }
                                                        }
                                                    }
                                                })
                                                { (error) in
                                                    print(error.localizedDescription)
                                                }
                                            }
                                            }

                                        }
                                    }
                                })
                                { (error) in
                                    print(error.localizedDescription)
                                }
                                //rajkumar
                            }
                        }
                    }
                }
            }
               
            catch{
                
                print(error)
                
            }
            
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
                        //let reqDuration = (dataDict as AnyObject).object(forKey: "request_duration") as? String
                        //let nearDist = (dataDict as AnyObject).object(forKey: "nearby_distance") as? String
                        let google_api = (dataDict as AnyObject).object(forKey: "google_api_key") as? String
                        self.googleKey = google_api!

                    }
                }
        },
            failure: { (operation: AFHTTPRequestOperation?,error: Error) in
                print("Error: " + error.localizedDescription)
                
        })
    }
    func onclickridercheckcancel(){
        let refh = FIRDatabase.database().reference()
        
        refh.child("trips_data").child("\(self.trip_id)").child("status").observeSingleEvent(of: .value, with: { (snapshot) in
            //let dict = snapshot.value as! NSString
            if (snapshot.exists()) {
                
            print("updating")
            let status1 = snapshot.value as! String
            print("trip id is here\(status1)")
            var trip_id = "\(status1)"
            trip_id = trip_id.replacingOccurrences(of: "Optional(", with: "")
            trip_id = trip_id.replacingOccurrences(of: ")", with: "")
            print(status1)
            //if("\(status1)" == "1"){
            if("\(trip_id)" != ""){
                
                if (status1 == "5"){
                    
                    self.arrayOfSample.removeAllObjects()
                        
                        UserDefaults.standard.removeObject(forKey: "rider_id")
                        
                        self.notification(Status: "Rider Cancelled the trip")
                        
                        let pass = self.arrayOfNonDuplicate
                        
                        pass.removeObject(at: self.getSome)
                        
                        print("remove array element \(self.arrayOfNonDuplicate)")
                        
                        UserDefaults.standard.set(self.arrayOfNonDuplicate, forKey: "arrayOfTripsData")
                        
                        let check  = UserDefaults.standard.array(forKey: "arrayOfTripsData")
                        
                        print("arrayofTripsData \(check)")
                        self.locationManager.stopUpdatingLocation()
                        self.appDelegate.callMapVC()
                    }
                        
                        
                    else{
                    }
                    
                }
            }
        })
    }
    
}
/*extension ADHomePageVC: UNUserNotificationCenterDelegate {
 let fancy = GMSCameraPosition.camera(withLatitude: self.myOrigin.coordinate.latitude,
 longitude: self.myOrigin.coordinate.longitude,
 zoom: 16)
 self.viewMap.camera = fancy
 
}*/

extension String {
    func index(from: Int) -> Index {
        return self.index(startIndex, offsetBy: from)
    }
    
    func substring(from: Int) -> String {
        let fromIndex = index(from: from)
        return substring(from: fromIndex)
    }
    
    func substring(to: Int) -> String {
        let toIndex = index(from: to)
        return substring(to: toIndex)
    }
    
    func substring(with r: Range<Int>) -> String {
        let startIndex = index(from: r.lowerBound)
        let endIndex = index(from: r.upperBound)
        return substring(with: startIndex..<endIndex)
    }
    var html2AttributedString: NSAttributedString? {
        do {
            return try NSAttributedString(data: Data(utf8), options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            print(error)
            return nil
        }
    }
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
}

