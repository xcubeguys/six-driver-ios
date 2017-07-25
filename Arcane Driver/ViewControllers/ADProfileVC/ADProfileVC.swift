//
//  ADProfileVC.swift
//  Arcane Driver
//
//  Created by Apple on 16/12/16.
//  Copyright © 2016 Apple. All rights reserved.
//

import UIKit
import Foundation
import MobileCoreServices
import SwiftMessages

class ADProfileVC: UIViewController {

    @IBOutlet weak var btnPFTakePhoto: UIButton!
var timer = Timer()
    var croppingEnabled: Bool = false
    var libraryEnabled: Bool = true
    
    @IBOutlet weak var imageView: UIImageView!

    @IBOutlet weak var viewImage: UIView!

    @IBOutlet weak var viewActivity: UIView!

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var viewAPIUrl = live_Driver_url

    typealias jsonSTD = NSArray
    
    typealias jsonSTDAny = [String : AnyObject]
    
    let picker = UIImagePickerController()
    var pickedImagePath: URL?
    var pickedImageData: Data?
    
    var button = UIButton()
    
    var localPath: String?
    
    var selectedPic : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        UIApplication.shared.isIdleTimerDisabled = false

        self.viewActivity.isHidden = true

         navigationController!.isNavigationBarHidden = false
        
        button = UIButton(type: .custom)
        button.setImage(UIImage(named: "arrow-left.png")!, for: .normal)
        button.addTarget(self, action: #selector(ADProfileVC.profileBtn(_:)), for: .touchUpInside)
        //CGRectMake(0, 0, 53, 31)
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        //(frame: CGRectMake(3, 5, 50, 20))
        let label = UILabel(frame: CGRect(x: 30, y: 5, width: 150, height: 20))
        // label.font = UIFont(name: "Arial-BoldMT", size: 13)
        label.text = "SIX DRIVER"
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.backgroundColor = UIColor.clear
        button.addSubview(label)
        let barButton = UIBarButtonItem(customView: button)
        self.navigationItem.leftBarButtonItem = barButton
        
        viewImage.layer.cornerRadius = viewImage.frame.size.width / 2
        viewImage.clipsToBounds = true

        imageView.tag = 0
        
        btnPFTakePhoto.setTitle("TAKE A PHOTO", for: UIControlState.normal)
        
        timer = Timer.scheduledTimer(timeInterval: 1200, target: self, selector: #selector(ADProfileVC.terminateApp), userInfo: nil, repeats: true)
        let resetTimer = UITapGestureRecognizer(target: self, action: #selector(ADProfileVC.resetTimer));
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(resetTimer)
    }
    func resetTimer(){
        // invaldidate the current timer and start a new one
        print("User Interacted")
        timer.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1200, target: self, selector: #selector(ADProfileVC.terminateApp), userInfo: nil, repeats: true)
    }
    func terminateApp(){
        // Do your segue and invalidate the timer
        print("No User Interaction")
        timer.invalidate()
        let alertController = UIAlertController(title: "Time Out", message: "Please retry your registration", preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
            print("Showing Alert")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let subContentsVC = storyboard.instantiateViewController(withIdentifier: "homePage") as! ViewController
            self.navigationController?.pushViewController(subContentsVC, animated: true)
        }))
        self.present(alertController, animated: true, completion: nil)
 
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
    @IBAction func btnTakePhotoAction(_ sender: Any) {


        if imageView.tag == 0{
            
            
            self.optionsMenu()

        }
        else{
            
          /*  self.btnPFTakePhoto.titleLabel?.text = "TAKE A PHOTO"
            let libraryViewController = CameraViewController.imagePickerViewController(croppingEnabled: croppingEnabled) { image, asset in
                self.imageView.image = image
                self.dismiss(animated: true, completion: nil)
                self.imageView.tag = 1
                self.btnPFTakePhoto.titleLabel?.text = "NEXT"

            }
            
            present(libraryViewController, animated: true, completion: nil)*/
            
            self.navigationController?.pushViewController(ADUploadDocVC(), animated: true)

        }
        
        
    }
    
    @IBAction func openCamera(_ sender: AnyObject) {
        
        let cameraViewController = CameraViewController(croppingEnabled: croppingEnabled, allowsLibraryAccess: libraryEnabled) { [weak self] image, asset in
            self?.imageView.image = image
            self?.dismiss(animated: true, completion: nil)
        }
        
        present(cameraViewController, animated: true, completion: nil)
    }
    
    @IBAction func openLibrary(_ sender: AnyObject) {
        
        let libraryViewController = CameraViewController.imagePickerViewController(croppingEnabled: croppingEnabled) { image, asset in
            self.imageView.image = image
            self.dismiss(animated: true, completion: nil)
            
        }
        
        present(libraryViewController, animated: true, completion: nil)
    }
    
    
    
}

extension ADProfileVC
: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func optionsMenu() {
        
        let camera = Camera(delegate_: self)
        
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        optionMenu.popoverPresentationController?.sourceView = self.view
        
        let takePhoto = UIAlertAction(title: "Camera", style: .default) { (alert : UIAlertAction!) in
            camera.presentPhotoCamera(target: self, canEdit: true)
            
            self.imageView.tag = 1

        }
        let sharePhoto = UIAlertAction(title: "Library", style: .default) { (alert : UIAlertAction) in
            camera.presentPhotoLibrary(target: self, canEdit: true)
            
            self.imageView.tag = 1

        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (alert : UIAlertAction) in
            //
            
            self.imageView.tag = 0
            
            self.btnPFTakePhoto.setTitle("TAKE A PHOTO", for: UIControlState.normal)

        }
        
        optionMenu.addAction(takePhoto)
        optionMenu.addAction(sharePhoto)
        
        optionMenu.addAction(cancel)
        
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        
        self.button.isEnabled = false
        self.imageView.tag = 1
        
       /* let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        imageView.image = image
        
        self.dismiss(animated: true, completion: nil)*/
        
        let image = info[UIImagePickerControllerEditedImage] as? UIImage
        imageView.image = image
        if let data = UIImagePNGRepresentation(image!) {
            
            let filename = getDocumentsDirectory().appendingPathComponent("profile.png")
            try? data.write(to: filename)
            
            print("im \(filename)")
            self.selectedPic = String(describing: filename)
        }
        self.dismiss(animated: true, completion: nil)
        
        self.btnPFTakePhoto.setTitle("NEXT", for: UIControlState.normal)

        self.viewActivity.isHidden = false
        
        LoadingIndicatorView.show(self.viewActivity, loadingText: "Uploading...")
        
        let rimage:UIImage = self.imageRotatedByDegrees(0.0,image: image!)
        
        let imgdata:Data = UIImageJPEGRepresentation(rimage,90)!
                
        let viewImageUrl = "\(self.viewAPIUrl)imageUpload/"

        let request:NSMutableURLRequest = NSMutableURLRequest(url: URL(string:"\(viewImageUrl)\(self.selectedPic!)")!)
        
        print("\(request)")
        
        request.httpMethod = "POST"
        
        let boundary = NSString(format: "---------------------------14737809831466499882746641449")
        
        let contentType = NSString(format: "multipart/form-data; boundary=%@",boundary)
        
        request.addValue(contentType as String, forHTTPHeaderField: "Content-Type")
        
        let body = NSMutableData()
        
        body.append(NSString(format: "\r\n--%@\r\n",boundary).data(using: String.Encoding.utf8.rawValue)!)
        
        body.append(NSString(format:"Content-Disposition: form-data; name=\"title\"\r\n\r\n").data(using: String.Encoding.utf8.rawValue)!)
        
        body.append("Hello World".data(using: String.Encoding.utf8, allowLossyConversion: true)!)
        
        body.append(NSString(format: "\r\n--%@\r\n", boundary).data(using: String.Encoding.utf8.rawValue)!)
        
        body.append(NSString(format:"Content-Disposition: form-data; name=\"uploadedfile\"; filename=\"bklblk.jpg\"\r\n").data(using: String.Encoding.utf8.rawValue)!)
        
        body.append(NSString(format: "Content-Type: application/octet-stream\r\n\r\n").data(using: String.Encoding.utf8.rawValue)!)
        
        body.append(imgdata)
        
        body.append(NSString(format: "\r\n--%@\r\n", boundary).data(using: String.Encoding.utf8.rawValue)!)
        
        request.httpBody = body as Data
        
        // dispatch
        DispatchQueue.main.async {
            
            let operation : AFHTTPRequestOperation = AFHTTPRequestOperation(request: request as URLRequest!)
            
            //        operation.responseSerializer.acceptableContentTypes = NSSet(object: "text/html") as Set<NSObject>
            operation.responseSerializer.acceptableContentTypes =  Set<AnyHashable>(["application/json", "text/json", "text/javascript", "text/html"])
            
            operation.setCompletionBlockWithSuccess(
                
                { (operation : AFHTTPRequestOperation?, responseObject: Any?) in
                    
                    
                    let response : NSString = operation!.responseString as NSString
                    let data:Data = response.data(using: String.Encoding.utf8.rawValue)!
                    
                    let json = try! JSONSerialization.jsonObject(with: data, options: []) as AnyObject
                    let imageStatus = json.value(forKey: "status")
                    var tmpimg:NSString="\(imageStatus!)" as NSString
                    tmpimg=tmpimg.replacingOccurrences(of: "(", with: "") as NSString
                    tmpimg=tmpimg.replacingOccurrences(of: ")", with: "") as NSString
                    tmpimg=tmpimg.replacingOccurrences(of: "\"", with: "") as NSString
                    tmpimg=tmpimg.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) as NSString
                    if(tmpimg == "Success"){
                        let imageurl = json.value(forKey: "imageurl")
                        
                        let imageName = json.value(forKey: "image_name")
                        
                        var tmpstr:NSString="\(imageName!)" as NSString
                        tmpstr=tmpstr.replacingOccurrences(of: "(", with: "") as NSString
                        tmpstr=tmpstr.replacingOccurrences(of: ")", with: "") as NSString
                        tmpstr=tmpstr.replacingOccurrences(of: "\"", with: "") as NSString
                        tmpstr=tmpstr.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) as NSString
                        
                        print(" !! \(String(describing: imageurl))")
                        
                        print(" final \(tmpstr)")
                        
                        print("image uploaded")
                        
                        self.selectedPic = tmpstr as String!
                        
                        self.appDelegate.signUpUserProfile = tmpstr as String!
                        
                        LoadingIndicatorView.hide()
                        
                        self.viewActivity.isHidden = true
                        self.button.isEnabled = true
                    }
                    else{
                        LoadingIndicatorView.hide()
                        
                        self.imageView.tag = 0
                        
                        self.viewActivity.isHidden = true
                        
                        let warning = MessageView.viewFromNib(layout: .CardView)
                        warning.configureTheme(.warning)
                        warning.configureDropShadow()
                        let iconText = "" //"🤔"
                        warning.configureContent(title: "", body: "Network error image upload failed", iconText: iconText)
                        warning.button?.isHidden = true
                        var warningConfig = SwiftMessages.defaultConfig
                        warningConfig.presentationContext = .window(windowLevel: UIWindowLevelStatusBar)
                        SwiftMessages.show(config: warningConfig, view: warning)
                        self.button.isEnabled = true
                    }
                    
                    
                    
            }, failure: { (operation, error) -> Void in
                print("image uploaded failed")
                
                LoadingIndicatorView.hide()
                
                self.imageView.tag = 0
                
                self.viewActivity.isHidden = true
                
                let warning = MessageView.viewFromNib(layout: .CardView)
                warning.configureTheme(.warning)
                warning.configureDropShadow()
                let iconText = "" //"🤔"
                warning.configureContent(title: "", body: "Network error image upload failed", iconText: iconText)
                warning.button?.isHidden = true
                var warningConfig = SwiftMessages.defaultConfig
                warningConfig.presentationContext = .window(windowLevel: UIWindowLevelStatusBar)
                SwiftMessages.show(config: warningConfig, view: warning)
                self.button.isEnabled = true
                
            })
            
            operation.start()
        }

    }
    
    func imageRotatedByDegrees(_ degrees: CGFloat, image: UIImage) -> UIImage{
        
        let size = image.size
        
        
        
        UIGraphicsBeginImageContext(size)
        
        let context = UIGraphicsGetCurrentContext()
        
        
        
        context?.translateBy(x: 0.5*size.width, y: 0.5*size.height)
        
        context?.rotate(by: CGFloat(DegreesToRadians(Double(degrees))))
        
        
        
        image.draw(in: CGRect(origin: CGPoint(x: -size.width*0.5, y: -size.height*0.5), size: size))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        
        
        return newImage!
        
    }
    func DegreesToRadians(_ degrees: Double) -> Double {
        
        return degrees * M_PI / 180.0
        
    }
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        

        self.imageView.tag = 0
        
        if imageView.tag == 0{
            
            self.btnPFTakePhoto.setTitle("TAKE A PHOTO", for: UIControlState.normal)

        }
        else{
            
            self.btnPFTakePhoto.setTitle("NEXT", for: UIControlState.normal)

        }

        dismiss(animated: true, completion: nil)

    }
    
}
