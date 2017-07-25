//
//  ADRatingsVC.swift
//  Arcane Driver
//
//  Created by Apple on 09/01/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit
import Alamofire

class ADRatingsVC: UIViewController {

    @IBOutlet weak var ratingView: HCSStarRatingView!

    @IBOutlet weak var labelNotes: UILabel!

    @IBOutlet weak var labelNoRatings: UILabel!

    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var smileimg: UIImageView!

    @IBOutlet weak var activityView: UIActivityIndicatorView!

    var ratingValue : String!

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    typealias jsonSTD = NSArray
    
    typealias jsonSTDAny = [String : AnyObject]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.labelNotes.text = " "
        
        UIApplication.shared.isIdleTimerDisabled = false

        navigationController!.navigationBar.barStyle = .black
        
        navigationController!.isNavigationBarHidden = false
        
        ratingView.maximumValue = 5
        ratingView.minimumValue = 0
      //  ratingView.tintColor = UIColor(red: 185.0, green: 124.0, blue: 0.0, alpha: 1.0)
        ratingView.allowsHalfStars = true
        
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "arrow-left.png")!, for: .normal)
        button.addTarget(self, action: #selector(ADRatingsVC.profileBtn(_:)), for: .touchUpInside)
        //CGRectMake(0, 0, 53, 31)
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        //(frame: CGRectMake(3, 5, 50, 20))
        let label = UILabel(frame: CGRect(x: 15, y: 5, width: 100, height: 20))
        // label.font = UIFont(name: "Arial-BoldMT", size: 13)
        label.text = "Ratings"
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.backgroundColor = UIColor.clear
        button.addSubview(label)
        let barButton = UIBarButtonItem(customView: button)
        self.navigationItem.leftBarButtonItem = barButton

        rightNaviCallBtn()
        
        self.callRatingsApi()
        
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
        
        
      //  appDelegate.callMapVC()
        UserDefaults.standard.removeObject(forKey: "oneTime")
        self.navigationController?.pushViewController(ADHomePageVC(), animated: true)
    }

    @IBAction func changeRateValue(_ sender: HCSStarRatingView) {
        
        print(String(format: "Changed driver rating", sender.value))
        
        self.ratingValue = String(describing: sender.value)
        
        let value = self.ratingValue!

        if value <= "0"{
            
            self.labelNotes.text = " "
        }
        else if value <= "3"{
            
            self.labelNotes.text = "You need to workhard!!!!"

        }
        else{
            
            self.labelNotes.text = "Great work! you have good reputation"
        }
        
      
    }
    
    func rightNaviCallBtn(){
        
        let btnName: UIButton = UIButton()
        btnName.setImage(UIImage(named: "starWhite.png"), for: UIControlState())
        btnName.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btnName.addTarget(self, action: #selector(ADViewProfileVC.callHistoryBtn(_:)), for: .touchUpInside)
        
        let leftBarButton:UIBarButtonItem = UIBarButtonItem()
        leftBarButton.customView = btnName
        self.navigationItem.rightBarButtonItem = leftBarButton
        
    }
    
    func callHistoryBtn(_ Selector: AnyObject) {
        
        
        
    }

    func callRatingsApi(){
        
        //demo.cogzidel.com/arcane_lite/driver/overallRating/userid/58736346da71b405078b4567
        
        self.activityView.startAnimating()
        
        var urlstring:String = "\(live_Driver_url)overallRating/userid/\(self.appDelegate.userid!)"
        
      //  var urlstring:String = "\(live_Driver_url)overallRating/userid/587360bfda71b4f0758b4567"
        
        urlstring = urlstring.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!
        
        urlstring = urlstring.removingPercentEncoding!
        
        print(urlstring)
        
        self.callRatingsAPI(url: "\(urlstring)")
        
    }
    
    func callRatingsAPI(url : String){
        
        
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
                if(final as! String == "Fail"){
                    
                    print("error")
                    
                    self.activityView.stopAnimating()
                    
                    self.labelNoRatings.isHidden = false
                    self.labelNotes.isHidden = true
                    self.ratingView.isHidden = true
                    self.viewTop.isHidden = true
                }
                else{
                    
                    if let finalValue = value.object(forKey: "total_star"){
                        
                        let someValue = UserDefaults.standard.set(finalValue, forKey: "driverRatingsPage")
                        
                        let some = UserDefaults.standard.double(forKey: "driverRatingsPage")
                        
                        self.ratingView.value = CGFloat(some)
                        
                        print("Success")
                        
                        let value = String(some)
                        
                        print("\(value)")
                        
                        if value <= "0"{
                            
                            self.labelNotes.text = " "
                        }
                        else if value <= "3"{
                            
                            self.labelNotes.text = "You need to workhard!!!!"
                            
                        }
                        else{
                            
                            self.labelNotes.text = "Great work! you have good reputation"
                        }
                        
                        let rate:Double = Double(value)!
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
                        
                        self.activityView.stopAnimating()
                        
                        self.labelNoRatings.isHidden = true
                        self.labelNotes.isHidden = false
                        self.ratingView.isHidden = false
                        self.viewTop.isHidden = false

                    }
                    else{
                        
                        
                    }
                    
                }
            }
        }
        catch{
            
            
            print(error)
            
        }
        
    }


}
