//
//  EarningdetailsViewController.swift
//  Arcane Rider
//
//  Created by Apple on 13/01/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit
import Alamofire
import Firebase


class EarningdetailsViewController: UIViewController,UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var activityView: UIActivityIndicatorView!
  
    @IBOutlet weak var currentdate: UILabel!
    @IBOutlet weak var scrollview: UIScrollView!
    
    @IBOutlet weak var fareLabel: UILabel!
    @IBOutlet weak var totalFareGreen: UILabel!
    
    @IBOutlet weak var commissionFeeLabel: UILabel!
    
    @IBOutlet weak var duration: UILabel!
    @IBOutlet weak var completedtrips: UILabel!
    
    @IBOutlet weak var labelPayment: UILabel!
    @IBOutlet weak var tableTrips: UITableView!
    
    @IBOutlet weak var notripslabel: UILabel!
    @IBOutlet weak var tripslabel: UILabel!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    typealias jsonSTD = NSArray
    
    typealias jsonSTDAny = [String : AnyObject]
    
    internal var tripId : String!
    
    var arrayDates:NSMutableArray=NSMutableArray()
    var arrayOfPrice:NSMutableArray=NSMutableArray()
    var onlineduration1 = 0
    var timeatonline = NSDate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let screenSize: CGRect = UIScreen.main.bounds
        
        screenSize.origin
        
        let screenHeight = screenSize.height;
        
        if((screenSize.width == 320.00) && (screenSize.height == 480.00))
            
        {
            //scrollview.contentSize.height=1050
        }
        
        if((screenSize.width == 320.00) && (screenSize.height == 568.00))
            
        {
           // scrollview.contentSize.height=750
        }
        
        if((screenSize.width == 414) && (screenSize.height == 736))
        {
            //scrollview.contentSize.height=1050
        }
        
        if((screenSize.width == 375) && (screenSize.height == 667))
            
        {
            //scrollview.contentSize.height=750
        }
        
        
        navigationController!.navigationBar.barStyle = .black
        
        navigationController!.isNavigationBarHidden = false
        
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "arrow-left.png")!, for: .normal)
        button.addTarget(self, action: #selector(ARTripsDetailsVC.profileBtn(_:)), for: .touchUpInside)
        //CGRectMake(0, 0, 53, 31)
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        //(frame: CGRectMake(3, 5, 50, 20))
        let label = UILabel(frame: CGRect(x: 10, y: 5, width: 150, height: 20))
        // label.font = UIFont(name: "Arial-BoldMT", size: 13)
        if(self.appDelegate.selectedearning == "daily"){
        label.text = "Daily earnings"
        }
        else if(self.appDelegate.selectedearning == "week"){
            label.text = "   Weekly earnings"
        }
        else if(self.appDelegate.selectedearning == "month"){
             label.text = "    Monthly earnings"
        }
        else{
            label.text = " Yearly earnings"
        }
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.backgroundColor = UIColor.clear
        button.addSubview(label)
        let barButton = UIBarButtonItem(customView: button)
        self.navigationItem.leftBarButtonItem = barButton
        
        tableTrips.register((UINib(nibName: "EarningtripsCell", bundle: nil)), forCellReuseIdentifier: "earningtripscell")
        
        self.notripslabel.isHidden = true
        self.activityView.isHidden = true
        self.showDetails()
        self.tripdetails()
    }
    
    
    func tripdetails(){

        
        arrayDates.removeAllObjects()
        arrayDates.remove("")
        arrayOfPrice.removeAllObjects()
        arrayOfPrice.remove("")
        
        spinner.startAnimating()
        var urlstring:String = "\(live_request_url)requests/yourTripsDriver/userid/\(self.appDelegate.userid!)"
        // var urlstring:String = "http://54.172.2.238/requests/yourTripsDriver/userid/58e1ce55192d2e96107cc3da"
        
        
        urlstring = urlstring.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!
        print(urlstring)
        let manager : AFHTTPRequestOperationManager = AFHTTPRequestOperationManager()
        manager.responseSerializer.acceptableContentTypes =  NSSet(objects: "text/plain", "text/html", "application/json", "audio/wav", "application/octest-stream") as Set<NSObject>
        manager.get("\(urlstring)",
            parameters: nil,
            success: { (operation: AFHTTPRequestOperation?,responseObject: Any?) in
                let jsonObjects:NSArray = responseObject as! NSArray

                for dataDict : Any in jsonObjects.reversed()
                {
                    var status: NSString = (dataDict as AnyObject).object(forKey: "status") as! NSString!
                    if(status == "Fail"){
                        

                        
                    }

                    else{

                        
                        let totalPrice = (dataDict as AnyObject).object(forKey: "total_price") as? Double
                        
                        let timeFormat = (dataDict as AnyObject).object(forKey: "created_timestamp") as? Double
                        
                       
                        
                        if timeFormat == nil{
                        }
                        else{
                            
                            
                            let date = NSDate(timeIntervalSince1970: timeFormat!)
                            let dateFormatter = DateFormatter()
                            dateFormatter.timeStyle = DateFormatter.Style.medium //Set time style
                            dateFormatter.dateStyle = DateFormatter.Style.medium //Set date style
                            dateFormatter.dateFormat = "hh:mm a"
                            let localDate = dateFormatter.string(from: date as Date)
                            print("date \(date)")
                            print("our date \(localDate)")
                            
                            var date1 = NSDate()
                            var calendar = Calendar.current
                            let datesAreInTheSameDay = calendar.isDate(date1 as Date, equalTo: date as Date, toGranularity:.day)
                            let datesAreInTheSamemonth = calendar.isDate(date1 as Date, equalTo: date as Date, toGranularity:.month)
                            let datesAreInTheSameyear = calendar.isDate(date1 as Date, equalTo: date as Date, toGranularity:.year)
                            let datesAreInTheSameweek = calendar.isDate(date1 as Date, equalTo: date as Date, toGranularity:.weekOfYear)
                            print(datesAreInTheSameDay)
                            print(datesAreInTheSamemonth)
                            print(datesAreInTheSameyear)
                            print(datesAreInTheSameweek)
                            
                            if(self.appDelegate.selectedearning == "daily"){
                                if(datesAreInTheSameDay == true && datesAreInTheSamemonth == true && datesAreInTheSameyear == true){
                                    self.arrayDates.add(localDate as String!)
                                    if totalPrice == nil{
                                        
                                        let value = 0
                                        self.arrayOfPrice.add(value)
                                        
                                    }
                                    else{
                                        
                                        self.arrayOfPrice.add(totalPrice! as Double)
                                        
                                    }
                                }
                                
                            }
                            else if(self.appDelegate.selectedearning == "month"){
                                if(datesAreInTheSamemonth == true && datesAreInTheSameyear == true){
                                    self.arrayDates.add(localDate as String!)
                                    if totalPrice == nil{
                                        
                                        let value = 0
                                        self.arrayOfPrice.add(value)
                                        
                                    }
                                    else{
                                        
                                        self.arrayOfPrice.add(totalPrice! as Double)
                                        
                                    }
                                }
                            }
                            else if(self.appDelegate.selectedearning == "week"){
                                if(datesAreInTheSamemonth == true && datesAreInTheSameyear == true && datesAreInTheSameweek == true){
                                    self.arrayDates.add(localDate as String!)
                                    if totalPrice == nil{
                                        
                                        let value = 0
                                        self.arrayOfPrice.add(value)
                                        
                                    }
                                    else{
                                        
                                        self.arrayOfPrice.add(totalPrice! as Double)
                                        
                                    }
                                }
                            }
                            else if(self.appDelegate.selectedearning == "year"){
                                if(datesAreInTheSameyear == true){
                                    self.arrayDates.add(localDate as String!)
                                    if totalPrice == nil{
                                        
                                        let value = 0
                                        self.arrayOfPrice.add(value)
                                        
                                    }
                                    else{
                                        
                                        self.arrayOfPrice.add(totalPrice! as Double)
                                        
                                    }
                                }
                            }
                            
                        }
                        
                        
                    }
                    
                    
                }
                print(self.arrayDates)
                self.completedtrips.text = String(self.arrayOfPrice.count)
                if(self.arrayOfPrice.count > 0){
                    self.spinner.stopAnimating()
                    self.spinner.isHidden = true

                }
                else{
                    self.tableTrips.isHidden = true
                    self.notripslabel.isHidden = false
                    self.spinner.stopAnimating()
                    self.spinner.isHidden = true
                    self.completedtrips.text = "0"
                }
                
                self.tableTrips.reloadData()
        },
            failure: { (operation: AFHTTPRequestOperation?,error: Error) in
                print("Error: " + error.localizedDescription)
                
                self.activityView.stopAnimating()
        })
        
    }
    
    func showDetails(){
        
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium //Set date style
        //  dateFormatter.dateFormat = "dd/MM/yyyy" //Specify your format that you want
        let localDate = dateFormatter.string(from: date as Date)
        self.currentdate.text = "\(localDate)"
        
        print("date \(date)")
        print("our date \(localDate)")
        
        
       print("tothoursonline in earning page \(self.appDelegate.tothoursonline)")
        if(self.appDelegate.tothoursonline != ""){
           // self.duration.text = self.appDelegate.tothoursonline!
            //self.duration.text = self.appDelegate.finaltime
            if self.appDelegate.timestatuslogout == "1"{
                self.duration.text = self.appDelegate.finaltime
                self.appDelegate.timestatuslogout = "0"
                print("before")
            }else{
                 //self.duration.text = self.appDelegate.tothoursonline
            print("else\(self.appDelegate.tothoursonline)")
                
            }
       

            let userdefault = UserDefaults.standard.set( self.appDelegate.tothoursonline, forKey: "duration")
            var result = UserDefaults.standard.value(forKey: "duration") as! String
             print("\(result)")
            result = result.replacingOccurrences(of: "%20", with: " ")
            print("\(result)")
            result = result .replacingOccurrences(of: "hr", with: "")
             print("\(result)")
            result = result .replacingOccurrences(of: "min", with: "")
             print("\(result)")
            result = result .replacingOccurrences(of: "sec", with: "")
             print("\(result)")
            result = result.removingPercentEncoding!
           // result = result.trimmingCharacters(in: .whitespaces)
            result = result.replacingOccurrences(of: " ", with: "", options:[], range: nil)
            print(result)


            self.appDelegate.timestatus = result
            print("userdefault in Earning page\(String(describing: result))")
             print("userdefault in Earning page\(String(describing:   self.appDelegate.timestatus))")
            let duration1=self.Duration(Int(result)!)
            print("duration1\(duration1)")

            
            
        }
        
        var fareprice = 0.0
        
        if(self.appDelegate.selectedearning == "daily"){
            if self.appDelegate.amountdaily != nil && self.appDelegate.amountdaily != "" {
                print("\(self.appDelegate.amountdaily)")
                self.labelPayment.text = "$\(self.appDelegate.amountdaily!)"
                fareprice = Double(self.appDelegate.amountdaily!)!
            }
            else{
                 self.labelPayment.text = "$"
               
            }
            if self.appDelegate.tripsdaily == ""{
                
                self.completedtrips.text = "0"
            }
            else{
                
                //self.completedtrips.text = "\(self.appDelegate.tripsdaily!)"
            }
            if self.appDelegate.admincomdaily != nil && self.appDelegate.admincomdaily != ""{
                
               
                self.fareLabel.text = "- $ \(self.appDelegate.admincomdaily!)"
                let totalprice = fareprice - Double(self.appDelegate.admincomdaily!)!
                self.totalFareGreen.text = "$\(totalprice)"
                self.commissionFeeLabel.text = "$\(totalprice)"
            }
            else{
                 self.fareLabel.text = "- $0"
                
               
            }
        }
        else if(self.appDelegate.selectedearning == "week"){
            if self.appDelegate.amountweekly != nil && self.appDelegate.amountweekly != ""{
                
                self.labelPayment.text = "$\(self.appDelegate.amountweekly!)"
                fareprice = Double(self.appDelegate.amountweekly!)!

            }
            else{
                  self.labelPayment.text = "$"
                
                           }
            if self.appDelegate.tripsweekly == ""{
                
                self.completedtrips.text = "0"
            }
            else{
                
                //self.completedtrips.text = "\(self.appDelegate.tripsweekly!)"
            }
            if self.appDelegate.admincomweekly != nil && self.appDelegate.admincomweekly != ""{
                
                
                self.fareLabel.text = "- $ \(self.appDelegate.admincomweekly!)"
                let totalprice = fareprice - Double(self.appDelegate.admincomweekly!)!
                self.totalFareGreen.text = "$\(totalprice)"
                self.commissionFeeLabel.text = "$\(totalprice)"

            }
            else{
                self.fareLabel.text = "- $0"
                
                          }
        }
        else if(self.appDelegate.selectedearning == "month"){
            if self.appDelegate.amountmonthly != nil && self.appDelegate.amountmonthly != ""{
                
                
                self.labelPayment.text = "$\(self.appDelegate.amountmonthly!)"
                fareprice = Double(self.appDelegate.amountmonthly!)!

            }
            else{
                self.labelPayment.text = "$"
                            }
            if self.appDelegate.tripsmonthly == ""{
                
                self.completedtrips.text = "0"
            }
            else{
                
                //self.completedtrips.text = "\(self.appDelegate.tripsmonthly!)"
            }
            if self.appDelegate.amdincommonthly != nil && self.appDelegate.amdincommonthly != ""{
                
               
                self.fareLabel.text = "- $ \(self.appDelegate.amdincommonthly!)"
                let totalprice = fareprice - Double(self.appDelegate.amdincommonthly!)!
                self.totalFareGreen.text = "$\(totalprice)"
                self.commissionFeeLabel.text = "$\(totalprice)"

            }
            else{
                 self.fareLabel.text = "- $0"
                
                           }
        }
        else if(self.appDelegate.selectedearning == "year"){
            if self.appDelegate.amountyearly != nil && self.appDelegate.amountyearly != ""{
                
              
                self.labelPayment.text = "$\(self.appDelegate.amountyearly!)"
                fareprice = Double(self.appDelegate.amountyearly!)!

            }
            else{
                  self.labelPayment.text = "$"
                
                            }
            if self.appDelegate.tripsyearly == ""{
                
                self.completedtrips.text = "0"
            }
            else{
                
                //self.completedtrips.text = "\(self.appDelegate.tripsyearly!)"
            }
            if self.appDelegate.admincomyearly != nil && self.appDelegate.admincomyearly != ""{
                
               
                self.fareLabel.text = "- $\(self.appDelegate.admincomyearly!)"
                let totalprice = fareprice - Double(self.appDelegate.admincomyearly!)!
                self.totalFareGreen.text = "$\(totalprice)"
                self.commissionFeeLabel.text = "$\(totalprice)"
            }
            else{
                 self.fareLabel.text = "- $0"
                
               
            }
        }
        else{
            
        }
        
    }
    
    func Duration(_ seconds: Int) {
        print(seconds)
        
        //        let seconds = ti % 60
        //        let minutes = (ti / 60) % 60
        //        let hours = (ti / 3600)
        //        return NSString(format: "%0.2d:%0.2d:%0.2d.%0.3d",hours,minutes,seconds,ms)
        
        //let second = Int(seconds / 60) % 60
        let second = seconds * 60
        
        self.appDelegate.timeinsec = second
        print("timeinsec\(self.appDelegate.timeinsec)")
         print("self.appDelegate.finaldec\(self.appDelegate.finaldec)")
         //onlineduration1 = Int(NSDate().timeIntervalSince(timeatonline as Date))
        //onlineduration1 = Int(NSDate().value(forKey: "duration"))let now = NSDate().timeIntervalSince1970 // current time
        let now = Int(NSDate().timeIntervalSince(self.appDelegate.timeatonline as Date))
        print("\(now)")
            //NSDate().timeIntervalSince1970( self.appDelegate.timeatonline as Data)
        let timeAfterXInterval = NSDate().addingTimeInterval(TimeInterval(self.appDelegate.finaldec)).timeIntervalSince(self.appDelegate.timeatonline as Date) // time after x sec
        print("timeAfterXInterval\(timeAfterXInterval)")
        let lastdec = onlineduration1 + self.appDelegate.finaldec
      //        let inttostring = String(lastdec)
//        self.appDelegate.lasttime = inttostring
        print("last dec\(lastdec)")
        print(" second in duratio func\(second)")
        if(timeAfterXInterval == 00){
             self.setStatusText1(text: String(format: "%0.2d sec", Int(lastdec % 60)))
            //self.setStatusText1(text: String(format: "%0.2d hr %0.2d min", Int(seconds / 3600) % 24, Int(seconds / 60) % 60))
        }
        else{
             //self.setStatusText1(text: String(format: "%0.2d sec", Int(seconds % 60)))
            self.setStatusText1(text: String(format: "%0.2d hr %0.2d min", Int(timeAfterXInterval / 3600) % 24, Int(timeAfterXInterval / 60) % 60))
        }
    }
    func setStatusText1(text: String) {
        
        //self.duration.text! = text
        print("StatusText for  finaltime\(text)")
        
        self.appDelegate.lasttime = text
        if self.appDelegate.timestatuslogout == "0"{
            assign()
        }
        
    }
    func assign(){
        self.duration.text = self.appDelegate.lasttime
        
    }


    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(arrayOfPrice.count)
        return arrayOfPrice.count
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:EarningtripsCell = tableView.dequeueReusableCell(withIdentifier: "earningtripscell") as! EarningtripsCell!
        
        if(arrayOfPrice.count > 0){
            
            let timeFormat1 = arrayDates.object(at: indexPath.row) as? String
            
            print("Time Format:\(timeFormat1!)")
            
            let priceValue : Double = arrayOfPrice.object(at: indexPath.row) as! Double
            
           
            if priceValue == 0{
                
                cell.price.text = "$0"
            }
            else{
                
                cell.price.text = "$\(priceValue)"
                
            }
            
            if timeFormat1 == nil || String(describing: timeFormat1) == ""{
                print("null time")
            }
            else{
                
                cell.date.text = "\(timeFormat1!)"
                
            }
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            
        }
        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 55.0
        
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

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
