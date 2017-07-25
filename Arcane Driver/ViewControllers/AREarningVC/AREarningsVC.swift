//
//  AREarningsVC.swift
//  Arcane Driver
//
//  Created by Apple on 09/01/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit
import Alamofire

class AREarningsVC: UIViewController {

    @IBOutlet weak var labelEarningsAmount: UILabel!

    @IBOutlet weak var labelLastTrip: UILabel!

    @IBOutlet weak var activityView: UIActivityIndicatorView!

    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    var viewAPIUrl = live_Driver_url
    
    typealias jsonSTD = NSArray
    
    typealias jsonSTDAny = [String : AnyObject]
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        UIApplication.shared.isIdleTimerDisabled = false

        navigationController!.navigationBar.barStyle = .black
        
        navigationController!.isNavigationBarHidden = false
        
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "arrow-left.png")!, for: .normal)
        button.addTarget(self, action: #selector(AREarningsVC.profileBtn(_:)), for: .touchUpInside)
        //CGRectMake(0, 0, 53, 31)
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        //(frame: CGRectMake(3, 5, 50, 20))
        let label = UILabel(frame: CGRect(x: 15, y: 5, width: 120, height: 20))
        // label.font = UIFont(name: "Arial-BoldMT", size: 13)
        label.text = "Earnings"
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.backgroundColor = UIColor.clear
        button.addSubview(label)
        let barButton = UIBarButtonItem(customView: button)
        self.navigationItem.leftBarButtonItem = barButton
        
        rightNaviCallBtn()

        self.activityView.startAnimating()
        
        var urlstring:String = "\(viewAPIUrl)yourEarnings/userid/\(self.appDelegate.userid!)"
        
        urlstring = urlstring.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!
        
        urlstring = urlstring.removingPercentEncoding!
        
        print("yourEarnings urlstring:\(urlstring)")
        
        self.callEarningsUrl(url: "\(urlstring)")
        
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
        appDelegate.callMapVC()
        
        self.navigationController?.popViewController(animated: true)
    }

    func rightNaviCallBtn(){
        
        let btnName: UIButton = UIButton()
        btnName.setImage(UIImage(named: "cashImage.png"), for: UIControlState())
        btnName.frame = CGRect(x: 0, y: 0, width: 35, height: 25)
        btnName.addTarget(self, action: #selector(AREarningsVC.callHistoryBtn(_:)), for: .touchUpInside)
        
        let leftBarButton:UIBarButtonItem = UIBarButtonItem()
        leftBarButton.customView = btnName
        self.navigationItem.rightBarButtonItem = leftBarButton
        
    }

    func callHistoryBtn(_ Selector: AnyObject) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let subContentsVC = storyboard.instantiateViewController(withIdentifier: "ARBankVC") as! ARBankVC
        self.navigationController?.pushViewController(subContentsVC, animated: true)
    }
    
    func callEarningsUrl(url : String){
        
   
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
            
      
            if value.count == 0{
                
                print("no Value")
                
                self.activityView.stopAnimating()
                
                labelEarningsAmount.text = "No Earnings yet."
            }
            else{
                
                
                let priceValue = value.object(forKey: "total_price") as? Int
                
                if priceValue == nil{
                    
                    labelEarningsAmount.text = "$"
                    
                }
                else{
                    
                    labelEarningsAmount.text = "$\(priceValue!)"
                    
                }
                
                
                let timeFormat = value.object(forKey: "last_tripDate") as? Double
                
                if timeFormat == nil{
                    
                    labelLastTrip.text = "Last Trip : "
                }
                else{
                    
                    let date = NSDate(timeIntervalSince1970: timeFormat!)
                    let dateFormatter = DateFormatter()
                    dateFormatter.timeStyle = DateFormatter.Style.medium //Set time style
                    dateFormatter.dateStyle = DateFormatter.Style.medium //Set date style
                    //  dateFormatter.dateFormat = "dd/MM/yyyy" //Specify your format that you want
                    let localDate = dateFormatter.string(from: date as Date)
                    print("date \(date)")
                    print("our date \(localDate)")
                    
                    labelLastTrip.text = "Last Trip : \(localDate)"
                }
                
                self.activityView.stopAnimating()
                
            }

        }
        catch{
            
            print(error)
            
            self.activityView.stopAnimating()
            
            
        }
        
    }

}
