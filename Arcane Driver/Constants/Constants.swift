//
//  Constants.swift
//  Arcane Driver
//
//  Created by Apple on 16/12/16.
//  Copyright © 2016 Apple. All rights reserved.
//

import Foundation
import UIKit

let LICENSE_FRONT_DOC = 0
let LICENSE_BACK_DOC = 1
let COMM_INS_DOC = 2
let ACRA_DOC = 3
let VEHC_REG_DOC = 4
let VOC_LIC_DOC = 5
let PRIV_HIRE_DOC = 6
let NRIC_FRONT_DOC = 7
let NRIC_BACK_DOC = 8

//let driverDocumentTypes = [LICENSE_FRONT_DOC,LICENSE_BACK_DOC,COMM_INS_DOC,ACRA_DOC,VEHC_REG_DOC,PRIV_HIRE_DOC,NRIC_FRONT_DOC,NRIC_BACK_DOC]


let appDelegate = UIApplication.shared.delegate as! AppDelegate

class Constant: NSObject {
    
    // make your constant like this get rid from macros
    static let SIGNIN = "SIGN IN"
    static let REGISTER = "REGISTER"
    
    
}

class Camera {
    
    var delegate: (UINavigationControllerDelegate & UIImagePickerControllerDelegate)?
    
    init(delegate_: UINavigationControllerDelegate & UIImagePickerControllerDelegate) {
        delegate = delegate_
    }
    
    func presentPhotoLibrary(target: UIViewController, canEdit: Bool) {
        
        if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) && !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.savedPhotosAlbum) {
            
            return
            
        }
        
        let type = kUTTypeImage as String
        let imagePicker = UIImagePickerController()
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            
            imagePicker.sourceType = .photoLibrary
            
            if let availableTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary) {
                
                if (availableTypes as NSArray).contains(type) {
                    
                    imagePicker.mediaTypes = [type]
                    imagePicker.allowsEditing = canEdit
                }
            }
        } else if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            
            imagePicker.sourceType = .savedPhotosAlbum
            
            if let availableTypes = UIImagePickerController.availableMediaTypes(for: .savedPhotosAlbum) {
                
                if (availableTypes as NSArray).contains(type) {
                    
                    imagePicker.mediaTypes = [type]
                }
                
            }
        } else {
            
            return
        }
        
        imagePicker.allowsEditing = canEdit
        imagePicker.delegate = delegate
        target.present(imagePicker, animated: true, completion: nil)
    }
    
    func presentPhotoCamera(target: UIViewController, canEdit: Bool) {
        
        if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            
            return
        }
        
        let type1 = kUTTypeImage as String
        let imagePicker = UIImagePickerController()
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            
            if let availableTypes = UIImagePickerController.availableMediaTypes(for: .camera) {
                
                if (availableTypes as NSArray).contains(type1) {
                    
                    imagePicker.mediaTypes = [type1]
                    imagePicker.sourceType = UIImagePickerControllerSourceType.camera
                }
            }
            
            if UIImagePickerController.isCameraDeviceAvailable(.rear) {
                
                imagePicker.cameraDevice = UIImagePickerControllerCameraDevice.rear
                
            } else if UIImagePickerController.isCameraDeviceAvailable(.front) {
                
                imagePicker.cameraDevice = UIImagePickerControllerCameraDevice.front
            }
            
        } else {
            
            return
        }
        
        imagePicker.allowsEditing = canEdit
        imagePicker.showsCameraControls = true
        imagePicker.delegate = delegate
        target.present(imagePicker, animated: true, completion: nil)
    }
}
