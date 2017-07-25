//
//  ARReferalVC.swift
//  SIX Rider
//
//  Created by Apple on 08/03/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit
import Alamofire

class ARReferalVC: UIViewController {
    
    
let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var totalcount: UILabel!
    
    @IBOutlet weak var dailycount: UILabel!
  
    @IBOutlet var viewbtn: UIButton!
  
    @IBOutlet weak var hideview: UIView!
   
   
    @IBOutlet weak var extline5: UILabel!
    @IBOutlet weak var extline4: UILabel!
    @IBOutlet weak var yearlyview: UILabel!
    @IBOutlet weak var weekearnbtn: UIButton!
    @IBOutlet weak var totearingbtn: UIButton!
    @IBOutlet weak var weeklycount: UILabel!
    
    @IBOutlet weak var weeklyview: UILabel!
    @IBOutlet weak var monthlyview: UILabel!
    
    @IBOutlet weak var extline: UILabel!
    @IBOutlet weak var extline1: UILabel!
    
    @IBOutlet weak var extline3: UILabel!
    @IBOutlet weak var extline2: UIView!
    @IBOutlet weak var dailyview: UILabel!
    @IBOutlet weak var monthlyearningbtn: UIButton!
    @IBOutlet weak var yearearnbtn: UIButton!
    @IBOutlet weak var monthlycount: UILabel!
    
    @IBOutlet weak var dailyearningbtn: UIButton!
    @IBOutlet weak var yearlycount: UILabel!
    
    @IBOutlet weak var usersusedcount: UILabel!
    
    
    @IBOutlet weak var totallblearn: UILabel!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    var viewAPIUrl = live_rider_url
    var ref_drive = "drive"
    typealias jsonSTD = NSArray
    
    typealias jsonSTDImage = NSDictionary
    
    typealias jsonSTDAny = [String : AnyObject]
    @IBOutlet weak var loadingview: UIView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var usedlbl: UILabel!
    
    @IBOutlet weak var scrollview: UIScrollView!
    
    var onlineduration = 0
    var calculatedduration1 = 0
    var durationfromurl = 0
    

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController!.isNavigationBarHidden = false
        
        navigationController!.navigationBar.barStyle = .black
        
        self.extline.isHidden = true
        self.extline1.isHidden = true
        self.extline2.isHidden = true
        self.extline3.isHidden = true
        self.extline4.isHidden = true
        self.extline5.isHidden = true
        
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "arrow-left.png")!, for: .normal)
        button.addTarget(self, action: #selector(ARReferalVC.profileBtn(_:)), for: .touchUpInside)
        //CGRectMake(0, 0, 53, 31)
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        //(frame: CGRectMake(3, 5, 50, 20))
        let label = UILabel(frame: CGRect(x: 40, y: 5, width: 160, height: 20))
        // label.font = UIFont(name: "Arial-BoldMT", size: 13)
        label.text = "Earnings"
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.backgroundColor = UIColor.clear
        button.addSubview(label)
        rightNaviCallBtn()
        let barButton = UIBarButtonItem(customView: button)
        self.navigationItem.leftBarButtonItem = barButton
        segmentedControl.addUnderlineForSelectedSegment()
        self.Referralearning()
        self.loadingview.isHidden = false
        self.viewbtn.isHidden = true
        
        self.spinner.startAnimating()
        // Do any additional setup after loading the view.
        
    }
    func rightNaviCallBtn(){
        
        let btnName: UIButton = UIButton()
        btnName.setImage(UIImage(named: "cashImage.png"), for: UIControlState())
        btnName.frame = CGRect(x: 0, y: 0, width: 30, height: 20)
        btnName.addTarget(self, action: #selector(ARReferalVC.callHistoryBtn(_:)), for: .touchUpInside)
        
        let leftBarButton:UIBarButtonItem = UIBarButtonItem()
        leftBarButton.customView = btnName
        self.navigationItem.rightBarButtonItem = leftBarButton
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func profileBtn(_ Selector: AnyObject) {
        
        UserDefaults.standard.removeObject(forKey: "oneTime")
        self.navigationController?.pushViewController(ADHomePageVC(), animated: true)
        self.appDelegate.testvalue = "0"
    }
    
    func callHistoryBtn(_ Selector: AnyObject) {
        
        //self.navigationController?.popViewController(animated: true)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let subContentsVC = storyboard.instantiateViewController(withIdentifier: "ARBankVC") as! ARBankVC
        self.navigationController?.pushViewController(subContentsVC, animated: true)
    }
    @IBAction func segmentedControlDidChange(_ sender: UISegmentedControl){
        segmentedControl.changeUnderlinePosition()
        switch segmentedControl.selectedSegmentIndex
        {
        case 0:
            self.ref_drive = "drive"
            self.Referralearning()
           self.viewbtn.isHidden = true
            self.monthlyearningbtn.isHidden = false
            self.yearearnbtn.isHidden = false
            self.dailyearningbtn.isHidden = false
            self.dailyview.isHidden = false
            self.monthlyview.isHidden = false
            self.dailyview.isHidden = false
            self.yearlyview.isHidden = false
            self.dailyview.isHidden = false
            self.weekearnbtn.isHidden  = false
            self.extline.isHidden = true
            self.extline1.isHidden = true
            self.extline2.isHidden = true
            self.extline3.isHidden = true
            self.extline4.isHidden = true
            self.extline5.isHidden = true
            self.weeklyview.isHidden = false
            


//
        case 1:
            self.ref_drive = "referral"
            self.viewbtn.isHidden = false
            self.monthlyearningbtn.isHidden = true
            self.yearearnbtn.isHidden = true
            self.dailyearningbtn.isHidden = true
            self.dailyview.isHidden = true
            self.weeklyview.isHidden = true
            self.monthlyview.isHidden = true
            self.dailyview.isHidden = true
            self.yearlyview.isHidden = true
            self.dailyview.isHidden = true
            self.weekearnbtn.isHidden  = true
            self.extline.isHidden = false
            self.extline1.isHidden = false
            self.extline2.isHidden = false
            self.extline3.isHidden = false
            self.extline4.isHidden = false
            self.extline5.isHidden = false
            
            self.Referralearning()
        default:
            break; 
        }
    }
    
    
    
    @IBAction func viewuserbtnact(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let subContentsVC = storyboard.instantiateViewController(withIdentifier: "ReferalVC") as! ReferalVC
        self.navigationController?.pushViewController(subContentsVC, animated: true)
        
    }
    
    func Referralearning()
    {
        self.loadingview.isHidden = false
        print(self.appDelegate.userid)
        
        //http://demo.cogzideltemplates.com/tommy/rider/refrel_detail/user_id/58b69164da71b494448b4567
        print("\(self.appDelegate.timestatus)")
        var urlstring:NSString = "\(live_Driver_url)yourEarnings/userid/\(self.appDelegate.userid!)" as NSString
        
        ///online_duration/\(self.appDelegate.timestatus)
        
        print(urlstring)
        
        
        
        urlstring = urlstring.replacingOccurrences(of: "Optional", with: "") as NSString
        
        urlstring = urlstring.replacingOccurrences(of: "(", with: "") as NSString
        
        urlstring = urlstring.replacingOccurrences(of: ")", with: "") as NSString
         urlstring = urlstring.replacingOccurrences(of: "\"", with: "") as NSString
       
        
        urlstring = urlstring.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)! as NSString
        
        
        
        urlstring = urlstring.removingPercentEncoding! as NSString
        
        
        
        //   urlstring = UTF8.decode(urlstring)
        
        print(urlstring)
        
        
        
        self.callTotalReferral(url: "\(urlstring)")
        

    }
    func callTotalReferral(url : String){
        
        
        Alamofire.request(url).responseJSON { (response) in
            
            
            
            self.parseData(JSONData: response.data!)
            
            
            
        }
        
        
        
    }
    
    func parseData(JSONData : Data){
        
        
        
        do{
            
            
            
            let readableJSon = try JSONSerialization.jsonObject(with: JSONData, options: .mutableContainers) as! jsonSTD
            
            
            
            print(" !!! \(readableJSon[0])")
            

            let value = readableJSon[0] as AnyObject

            for dataDict : Any in readableJSon
                
            {
                
                
                let status1: NSString? = (dataDict as AnyObject).object(forKey: "status") as? NSString
                
                if(status1 == "Success"){
                    
                    if(self.ref_drive == "referral"){
                        let referd_users: NSString? = (dataDict as AnyObject).object(forKey: "referd_users") as? NSString
                        print("referd_users~~\(referd_users)")
                         print("referd_users~~\(referd_users)")
                        
                        let referd_amount: NSString? = (dataDict as AnyObject).object(forKey: "referd_amount") as? NSString
                        
                        let referd_amount_date: NSString? = (dataDict as AnyObject).object(forKey: "referd_amount_date") as? NSString
                        
                        let referd_amount_week: NSString? = (dataDict as AnyObject).object(forKey: "referd_amount_week") as? NSString
                        
                        let referd_amount_month: NSString? = (dataDict as AnyObject).object(forKey: "referd_amount_month") as? NSString
                        
                        let referd_amount_year: NSString? = (dataDict as AnyObject).object(forKey: "referd_amount_year") as? NSString
                                               if (referd_users != "" && referd_users != nil)
                        {
                            self.usersusedcount.text = "\(referd_users!)" as String?
                        }
                        else{
                            
                        }
                        
                        if (referd_amount != "" && referd_amount != nil)
                        {
                            let doubleStr = String(format: "%.2f", Double(String(referd_amount!))!)
                            self.totalcount.text = "$\(doubleStr)" as String?
                            
                        }
                        else{
                            
                        }
                        
                        if (referd_amount_date != "" && referd_amount_date != nil)
                        {
                            let doubleStr = String(format: "%.2f", Double(String(referd_amount_date!))!)
                            self.dailycount.text = "$\(doubleStr)" as String?
                        }
                        else{
                            
                        }
                        
                        if (referd_amount_week != "" && referd_amount_week != nil)
                        {
                            let doubleStr = String(format: "%.2f", Double(String(referd_amount_week!))!)
                            self.weeklycount.text = "$\(doubleStr)" as String?
                        }
                        else{
                            
                        }
                        
                        if (referd_amount_month != "" && referd_amount_month != nil)
                        {
                            let doubleStr = String(format: "%.2f", Double(String(referd_amount_month!))!)
                            self.monthlycount.text = "$\(doubleStr)" as String?
                        }
                        else{
                            
                        }
                        
                        if (referd_amount_year != "" && referd_amount_year != nil)
                        {
                            let doubleStr = String(format: "%.2f", Double(String(referd_amount_year!))!)
                            self.yearlycount.text = "$\(doubleStr)" as String?
                        }
                        else{
                            
                        }
                        self.totallblearn.text = "Total Referral Earnings"
                        self.usersusedcount.isHidden = false
                        self.usedlbl.isHidden = false
                        
                    }
                    else{
                         let referd_users: NSString? = (dataDict as AnyObject).object(forKey: "referd_users") as? NSString
                        
                        
                        let referd_amount: NSString? = (dataDict as AnyObject).object(forKey: "drive_amount_yearly") as? NSString
                        
                        let referd_amount_date: NSString? = (dataDict as AnyObject).object(forKey: "drive_amount_daily") as? NSString
                       
                        
                        let referd_amount_week: NSString? = (dataDict as AnyObject).object(forKey: "drive_amount_weekly") as? NSString
                        
                        let referd_amount_month: NSString? = (dataDict as AnyObject).object(forKey: "drive_amount_monthly") as? NSString
                        
                        let referd_amount_year: NSString? = (dataDict as AnyObject).object(forKey: "drive_amount_yearly") as? NSString
                        let admin_comission_daily: NSString? = (dataDict as AnyObject).object(forKey: "admin_commission_daily") as? NSString
                       
                        
                        let admin_comission_week: NSString? = (dataDict as AnyObject).object(forKey: "admin_commission_weekly") as? NSString
                      
                        
                        let admin_comission_month: NSString? = (dataDict as AnyObject).object(forKey: "admin_commission_monthly") as? NSString
                        
                        let admin_comission_year: NSString? = (dataDict as AnyObject).object(forKey: "admin_commission_yearly") as? NSString
                    
                        
                        let total_trips_daily: NSString? = (dataDict as AnyObject).object(forKey: "total_trips_daily") as? NSString
                        
                        let total_trips_week: NSString? = (dataDict as AnyObject).object(forKey: "total_trips_weekly") as? NSString
                       
                        let total_trips_month: NSString? = (dataDict as AnyObject).object(forKey: "total_trips_monthly") as? NSString
                       
                        
                        let total_trips_year: NSString? = (dataDict as AnyObject).object(forKey: "total_trips_yearly") as? NSString
                        let online_duration_daily: NSString? = (dataDict as AnyObject).object(forKey: "online_duration_daily") as? NSString
                        print("online_duration_daily\(online_duration_daily)")
                       
                        
                        if (referd_users != "" && referd_users != nil)
                        {
                            self.usersusedcount.text = "\(referd_users!)" as String?
                        }
                        else{
                            
                        }
                        
                        if (referd_amount != "" && referd_amount != nil)
                        {
                            let doubleStr = String(format: "%.2f", Double(String(referd_amount!))!)
                            self.totalcount.text = "$\(doubleStr)" as String?
                            self.appDelegate.tripsweekly = total_trips_week! as String
                            self.appDelegate.tripsmonthly = total_trips_month! as String
                            self.appDelegate.tripsyearly = total_trips_year! as String
                            self.appDelegate.tripsdaily = total_trips_daily! as String

                        }
                        else{
                            
                        }
                        
                        if (referd_amount_date != "" && referd_amount_date != nil)
                        {
                            let doubleStr = String(format: "%.2f", Double(String(referd_amount_date!))!)
                            self.dailycount.text = "$\(doubleStr)" as String?
                             self.appDelegate.amountdaily = referd_amount_date! as String
                             self.appDelegate.admincomdaily = admin_comission_daily! as String
                        }
                        else{
                            
                        }
                        
                        if (referd_amount_week != "" && referd_amount_week != nil)
                        {
                            let doubleStr = String(format: "%.2f", Double(String(referd_amount_week!))!)
                            self.weeklycount.text = "$\(doubleStr)" as String?
                            self.appDelegate.amountweekly = referd_amount_week! as String
                              self.appDelegate.admincomweekly = admin_comission_week! as String

                        }
                        else{
                            
                        }
                        if (online_duration_daily != "" && online_duration_daily != nil){
                            
                            let dailytime = online_duration_daily! as String
                            let dailytimeinInt = Int(dailytime)
                            let milliscttosec = dailytimeinInt! / 1000
                            print("\(self.appDelegate.timeinsec)")
                            let inteval:Int = Int(milliscttosec)
                            let intergervalue2 = Int(self.appDelegate.timeinsec)
                            var intergerValue3 = 0;
//                            if let getValue = intergervalue2 {
//                                intergerValue3 = getValue
//                            }
                            let dailytimes = inteval + intergervalue2
                            print("dailytimes\(dailytimes)")
                            //let dailytimesinstr = (dailytimes as! String).intValue
                            self.appDelegate.dailytimes = String(dailytimes)
                            print("self.appDelegate.dailytimes in refferal page\(self.appDelegate.dailytimes)")
                            let duration1=self.Durations(Int(dailytimes))
                            print("duration1\(duration1)")

                            
                            
                        }else
                        {
                            
                        }

                        
                        if (referd_amount_month != "" && referd_amount_month != nil)
                        {
                            let doubleStr = String(format: "%.2f", Double(String(referd_amount_month!))!)
                            self.monthlycount.text = "$\(doubleStr)" as String?
                            self.appDelegate.amountmonthly = referd_amount_month! as String
                            self.appDelegate.amdincommonthly = admin_comission_month! as String


                        }
                        else{
                            
                        }
                        
                        if (referd_amount_year != "" && referd_amount_year != nil)
                        {
                            let doubleStr = String(format: "%.2f", Double(String(referd_amount_year!))!)
                            self.yearlycount.text = "$\(doubleStr)" as String?
                             self.appDelegate.amountyearly = referd_amount_year! as String
                                self.appDelegate.admincomyearly = admin_comission_year! as String
                        }
                        else{
                            
                        }
                        self.totallblearn.text = " Total Drives Earnings "
                        self.usersusedcount.isHidden = true
                        self.usedlbl.isHidden = true
                    }
                   
                    self.loadingview.isHidden = true
                    
                    
                }
                else{
                    self.loadingview.isHidden = true
                }
                
                //JSON Valuue
                
            }
            //self.loadingview.isHidden = true
        }
        catch{
            self.loadingview.isHidden = true
            print(error)
        }

    }
    
    func Durations(_ seconds: Int) {
        print(seconds)
        
        //        let seconds = ti % 60
        //        let minutes = (ti / 60) % 60
        //        let hours = (ti / 3600)
        //        return NSString(format: "%0.2d:%0.2d:%0.2d.%0.3d",hours,minutes,seconds,ms)
        
        let second = Int(seconds / 60) % 60
        print("appDelegate.finaldec\(second)")
        self.appDelegate.finaldec = second
        if(second == 00){
            self.setStatusText1(text: String(format: "%0.2d sec", Int(seconds % 60)))
            //self.setStatusText1(text: String(format: "%0.2d hr %0.2d min", Int(seconds / 3600) % 24, Int(seconds / 60) % 60))
        }
        else{
            self.setStatusText1(text: String(format: "%0.2d hr %0.2d min", Int(seconds / 3600) % 24, Int(seconds / 60) % 60))
        }
    }
    func setStatusText1(text: String) {
        
        //self.duration.text! = text
        print("StatusText\(text)")
        self.appDelegate.finaltime = text
        UserDefaults.standard.set(self.appDelegate.finaltime, forKey: "finaltime")
    }
    


    @IBAction func totearnact(_ sender: Any) {
        let detailsVC = EarningdetailsViewController()
        self.navigationController?.pushViewController(detailsVC, animated: true)
    }
    @IBAction func weekearnact(_ sender: Any) {
        if(self.appDelegate.testvalue != "0"){
            onlineduration = Int(NSDate().timeIntervalSince(self.appDelegate.timeatonline as Date))
            self.calculatedduration1 = self.appDelegate.calculatedduration + onlineduration
            self.appDelegate.toupdateonlogout = self.calculatedduration1
            UserDefaults.standard.setValue(self.appDelegate.toupdateonlogout, forKey: "onlineduration")
            Duration(Int(self.calculatedduration1))
        }
        self.appDelegate.selectedearning = "week"
        let detailsVC = EarningdetailsViewController()
        self.navigationController?.pushViewController(detailsVC, animated: true)
    }
    @IBAction func dailyearnact(_ sender: Any) {
        
        if(self.appDelegate.testvalue != "0"){
            onlineduration = Int(NSDate().timeIntervalSince(self.appDelegate.timeatonline as Date))
            self.calculatedduration1 = self.appDelegate.calculatedduration + onlineduration
            self.appDelegate.toupdateonlogout = self.calculatedduration1
            UserDefaults.standard.setValue(self.appDelegate.toupdateonlogout, forKey: "onlineduration")
            Duration(Int(self.calculatedduration1))
        }
        self.appDelegate.selectedearning = "daily"
        let detailsVC = EarningdetailsViewController()
        self.navigationController?.pushViewController(detailsVC, animated: true)
    }
    @IBAction func yearearnact(_ sender: Any) {
        if(self.appDelegate.testvalue != "0"){
            onlineduration = Int(NSDate().timeIntervalSince(self.appDelegate.timeatonline as Date))
            self.calculatedduration1 = self.appDelegate.calculatedduration + onlineduration
            self.appDelegate.toupdateonlogout = self.calculatedduration1
            UserDefaults.standard.setValue(self.appDelegate.toupdateonlogout, forKey: "onlineduration")
            Duration(Int(self.calculatedduration1))
        }
        self.appDelegate.selectedearning = "year"
        let detailsVC = EarningdetailsViewController()
        self.navigationController?.pushViewController(detailsVC, animated: true)
    }
    @IBAction func monthearnact(_ sender: Any) {
        if(self.appDelegate.testvalue != "0"){
            onlineduration = Int(NSDate().timeIntervalSince(self.appDelegate.timeatonline as Date))
            self.calculatedduration1 = self.appDelegate.calculatedduration + onlineduration
            self.appDelegate.toupdateonlogout = self.calculatedduration1
            print(self.appDelegate.toupdateonlogout)
            UserDefaults.standard.setValue(self.appDelegate.toupdateonlogout, forKey: "onlineduration")
            Duration(Int(self.calculatedduration1))
        }
        self.appDelegate.selectedearning = "month"
        let detailsVC = EarningdetailsViewController()
        self.navigationController?.pushViewController(detailsVC, animated: true)
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
       print("tothoursonline in referral page\(self.appDelegate.tothoursonline)")    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
extension UISegmentedControl{
    func removeBorder(){
        let backgroundImage = UIImage.getColoredRectImageWith(color: UIColor.white.cgColor, andSize: self.bounds.size)
        self.setBackgroundImage(backgroundImage, for: .normal, barMetrics: .default)
        self.setBackgroundImage(backgroundImage, for: .selected, barMetrics: .default)
        self.setBackgroundImage(backgroundImage, for: .highlighted, barMetrics: .default)
        
        let deviderImage = UIImage.getColoredRectImageWith(color: UIColor.white.cgColor, andSize: CGSize(width: 1.0, height: self.bounds.size.height))
        self.setDividerImage(deviderImage, forLeftSegmentState: .selected, rightSegmentState: .normal, barMetrics: .default)
        self.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.gray], for: .normal)
        self.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1.0)], for: .selected)
    }
    
    func addUnderlineForSelectedSegment(){
        removeBorder()
        let underlineWidth: CGFloat = self.bounds.size.width / CGFloat(self.numberOfSegments)
        let underlineHeight: CGFloat = 2.0
        let underlineXPosition = CGFloat(selectedSegmentIndex * Int(underlineWidth))
        let underLineYPosition = self.bounds.size.height - 1.0
        let underlineFrame = CGRect(x: underlineXPosition, y: underLineYPosition, width: underlineWidth, height: underlineHeight)
        let underline = UIView(frame: underlineFrame)
        underline.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1.0)
        underline.tag = 1
        self.addSubview(underline)
        
       /* let segmentBottomBorder = CALayer()
        segmentBottomBorder.borderColor = UIColor.blue.cgColor
        segmentBottomBorder.borderWidth = 3
        let x = CGFloat(selectedSegmentIndex * Int(underlineWidth))
        let y = self.bounds.size.height - 1.0
        let width: CGFloat = self.bounds.size.width / CGFloat(self.numberOfSegments)
        segmentBottomBorder.frame = CGRect(x: x, y: y, width: width, height: (segmentBottomBorder.borderWidth))
        self.layer.addSublayer(segmentBottomBorder)*/
       // segmentCn.layer.addSublayer(segmentBottomBorder!)
    }
    
    func changeUnderlinePosition(){
        removeBorder()
        guard let underline = self.viewWithTag(1) else {return}
        let underlineFinalXPosition = (self.bounds.width / CGFloat(self.numberOfSegments)) * CGFloat(selectedSegmentIndex)
        UIView.animate(withDuration: 0.1, animations: {
            underline.frame.origin.x = underlineFinalXPosition
        })
    }
}

extension UIImage{
    
    class func getColoredRectImageWith(color: CGColor, andSize size: CGSize) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        let graphicsContext = UIGraphicsGetCurrentContext()
        graphicsContext?.setFillColor(color)
        let rectangle = CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height)
        graphicsContext?.fill(rectangle)
        let rectangleImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return rectangleImage!
    }
}
