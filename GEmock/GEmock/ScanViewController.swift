//
//  ScanViewController.swift
//  GEmock
//
//  Created by Yushi Xiao on 4/19/16.
//  Copyright © 2016 Yushi xiao. All rights reserved.
//

import UIKit
import Foundation
import CoreData

class ScanViewController: UIViewController, UITextViewDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var emloyeeId: UITextField!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var topMarginConstraint: NSLayoutConstraint!
    @IBOutlet weak var eventName: UILabel!
    
    @IBOutlet weak var overlayView: UIView!
    
    @IBOutlet weak var pickBg: UIImageView!
    
    
    weak var line: UIImageView!
    weak var imagePikerViewController : UIImagePickerController!
    
    var time : NSTimer!
    
    var event: Event? = nil
    
    var activityIndicator:UIActivityIndicatorView!
    var originalTopMargin:CGFloat!
    
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        takePhoto();
    }
    /*override func viewDidAppear(animated: Bool) {
     super.viewDidAppear(animated)
     originalTopMargin = topMarginConstraint.constant
     }*/
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    /*@IBAction func takePhoto(sender: AnyObject) {
        
        if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera){
            return
        }
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera;
        
        //Create camera overlay
        let pickerFrame = CGRectMake(0, UIApplication.sharedApplication().statusBarFrame.size.height, imagePicker.view.bounds.width, imagePicker.view.bounds.height - imagePicker.navigationBar.bounds.size.height - imagePicker.toolbar.bounds.size.height)
        let squareFrame = CGRectMake(0, 0, 200, 200)
        UIGraphicsBeginImageContext(pickerFrame.size)
        
        let context = UIGraphicsGetCurrentContext()
        CGContextSaveGState(context)
        CGContextAddRect(context, CGContextGetClipBoundingBox(context))
        CGContextMoveToPoint(context, squareFrame.origin.x, squareFrame.origin.y)
        CGContextAddLineToPoint(context, squareFrame.origin.x + squareFrame.width, squareFrame.origin.y)
        CGContextAddLineToPoint(context, squareFrame.origin.x + squareFrame.width, squareFrame.origin.y + squareFrame.size.height)
        CGContextAddLineToPoint(context, squareFrame.origin.x, squareFrame.origin.y + squareFrame.size.height)
        CGContextAddLineToPoint(context, squareFrame.origin.x, squareFrame.origin.y)
        CGContextEOClip(context)
        CGContextMoveToPoint(context, pickerFrame.origin.x, pickerFrame.origin.y)
        CGContextSetRGBFillColor(context, 0, 0, 0, 1)
        CGContextFillRect(context, pickerFrame)
        CGContextRestoreGState(context)
        
        let overlayImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        
        let overlayView = UIImageView(frame: pickerFrame)
        overlayView.image = overlayImage
        imagePicker.cameraOverlayView = overlayView
        self.presentViewController(imagePicker, animated: true, completion: nil)
        
    }*/
    
    
    @IBAction func scanNext(sender: AnyObject) {
        saveRecord();
        
        takePhoto();
    }
    
    func saveRecord() {
        let description = NSEntityDescription.entityForName("AttendanceRecord", inManagedObjectContext: managedObjectContext)
        let record = AttendanceRecord(entity: description!, insertIntoManagedObjectContext: managedObjectContext)
        record.attended = event
        record.employee_id = emloyeeId.text
        record.first_name = firstName.text
        record.last_name = lastName.text
        try! managedObjectContext.save()
        
        emloyeeId.text = ""
        firstName.text = ""
        lastName.text = ""
    }
    
    func takePhoto() {
        // 1
        view.endEditing(true)
        //moveViewDown()
        // 2
        let imagePickerActionSheet = UIAlertController(title: "Snap/Upload Photo",
            message: nil, preferredStyle: .ActionSheet)
        // 3
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            let cameraButton = UIAlertAction(title: "Take Photo",
                style: .Default) { (alert) -> Void in
                    let imagePicker = UIImagePickerController()
                    imagePicker.delegate = self
                    imagePicker.sourceType = .Camera
                    self.presentViewController(imagePicker,
                        animated: true,
                        completion: nil)
            }
            imagePickerActionSheet.addAction(cameraButton)
        }
        // 4
        let libraryButton = UIAlertAction(title: "Choose Existing",
            style: .Default) { (alert) -> Void in
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = .PhotoLibrary
                self.presentViewController(imagePicker,
                    animated: true,
                    completion: nil)
        }
        imagePickerActionSheet.addAction(libraryButton)
        // 5
        let cancelButton = UIAlertAction(title: "Cancel",
            style: .Cancel) { (alert) -> Void in
        }
        imagePickerActionSheet.addAction(cancelButton)
        // 6
        presentViewController(imagePickerActionSheet, animated: true,
            completion: nil)
    }
    
       
    func scaleImage(image: UIImage, maxDimension: CGFloat) -> UIImage {
        
        var scaledSize = CGSizeMake(maxDimension, maxDimension)
        var scaleFactor:CGFloat
        
        if image.size.width > image.size.height {
            scaleFactor = image.size.height / image.size.width
            scaledSize.width = maxDimension
            scaledSize.height = scaledSize.width * scaleFactor
        } else {
            scaleFactor = image.size.width / image.size.height
            scaledSize.height = maxDimension
            scaledSize.width = scaledSize.height * scaleFactor
        }
        
        UIGraphicsBeginImageContext(scaledSize)
        image.drawInRect(CGRectMake(0, 0, scaledSize.width, scaledSize.height))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return scaledImage
    }
    
    // Activity Indicator methods
    
    func addActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(frame: view.bounds)
        activityIndicator.activityIndicatorViewStyle = .WhiteLarge
        activityIndicator.backgroundColor = UIColor(white: 0, alpha: 0.25)
        activityIndicator.startAnimating()
        view.addSubview(activityIndicator)
    }
    
    func removeActivityIndicator() {
        activityIndicator.removeFromSuperview()
        activityIndicator = nil
    }
    
    
    // The remaining methods handle the keyboard resignation/
    // move the view so that the first responders aren't hidden
    
    /*func moveViewUp() {
     if topMarginConstraint.constant != originalTopMargin {
     return
     }
     
     topMarginConstraint.constant -= 135
     UIView.animateWithDuration(0.3, animations: { () -> Void in
     self.view.layoutIfNeeded()
     })
     }
     
     func moveViewDown() {
     if topMarginConstraint.constant == originalTopMargin {
     return
     }
     
     topMarginConstraint.constant = originalTopMargin
     UIView.animateWithDuration(0.3, animations: { () -> Void in
     self.view.layoutIfNeeded()
     })
     
     }*/
    
    /*@IBAction func backgroundTapped(sender: AnyObject) {
     view.endEditing(true)
     moveViewDown()
     }*/
    
    func performImageRecognition(image: UIImage) {
        // 1
        let tesseract = G8Tesseract()
        // 2
        tesseract.language = "eng"
        // 3
        tesseract.engineMode = .TesseractCubeCombined
        // 4
        tesseract.pageSegmentationMode = .Auto
        // 5
        tesseract.maximumRecognitionTime = 60.0
        // 6
        tesseract.image = image.g8_blackAndWhite()
        tesseract.recognize()
        // 7
        eventName.text = event!.name
        let data = String(tesseract.recognizedText)
        var myStrings = data.componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet())
        myStrings = myStrings.filter({$0 != ""})
        var idPosition = 0
        for (index,line) in myStrings.enumerate(){
            if let nineDigit = Int(line) {
                emloyeeId.text = String(nineDigit)
                idPosition = index
            }
        }
        if idPosition >= 2 {
            firstName.text = myStrings[idPosition - 2]
            lastName.text = myStrings[idPosition - 1]
        }
        //let employeeid = NSCharacterSet.decimalDigitCharacterSet(tesseract.recognizedText);
        // 8
        removeActivityIndicator()
    }
    
    @IBAction func takePicture(sender: AnyObject) {
        self.imagePikerViewController.takePicture()
        self.time.invalidate()
    }
    
    @IBAction func cancelTakePicture(sender: AnyObject) {
        self.time.invalidate()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func timerFireMethod () {
        
        UIView.beginAnimations("animationID", context: nil)
        
        UIView.setAnimationDuration(2)
        UIView.setAnimationCurve(UIViewAnimationCurve.Linear)
        
        UIView.setAnimationRepeatCount(100)
        self.line.frame = CGRectMake(30, 250, 190, 5)
        UIView.commitAnimations()
    }
}

/*extension ScanViewController: UITextFieldDelegate {
 func textFieldDidBeginEditing(textField: UITextField) {
 moveViewUp()
 }
 
 @IBAction func textFieldEndEditing(sender: AnyObject) {
 view.endEditing(true)
 moveViewDown()
 }
 
 func textViewDidBeginEditing(textView: UITextView) {
 moveViewDown()
 }
 }*/

extension ScanViewController: UIImagePickerControllerDelegate {
    func imagePickerController(picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let selectedPhoto = info[UIImagePickerControllerOriginalImage] as! UIImage
        let scaledImage = scaleImage(selectedPhoto, maxDimension: 640)
        
        addActivityIndicator()
        
        dismissViewControllerAnimated(true, completion: {
            self.performImageRecognition(scaledImage)
        })
    }
}


/*
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
 // Get the new view controller using segue.destinationViewController.
 // Pass the selected object to the new view controller.
 }
 */


