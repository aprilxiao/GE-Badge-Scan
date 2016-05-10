//
//  ScanViewController.swift
//  GEmock

import UIKit
import Foundation
import CoreData

class ScanViewController: UIViewController, UITextViewDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var emloyeeId: UITextField!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var eventName: UILabel!
    
    @IBOutlet weak var topMarginConstraint: NSLayoutConstraint!
    
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
        
        // Set up UI including back button
        self.view.backgroundColor = UIColor.init(colorLiteralRed: 187/255.0, green: 205/255.0, blue: 227/255.0, alpha: 1)
        
        let leftBtn:UIButton = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 40))
        leftBtn.setImage(UIImage.init(imageLiteral: "icon_7"), forState: UIControlState.Normal)
        leftBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
        leftBtn.addTarget(self, action:#selector(ScanViewController.back), forControlEvents: UIControlEvents.TouchUpInside)
        let leftItem = UIBarButtonItem.init(customView: leftBtn)
        self.navigationItem.leftBarButtonItem = leftItem;
        
        self.eventName.text = event?.name
    }
    
    func back() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    @IBAction func Confirm(sender: AnyObject) {
        saveRecord();
    }
    
    
    func saveRecord() {
        // Save the record to the database
        let description = NSEntityDescription.entityForName("AttendanceRecord", inManagedObjectContext: managedObjectContext)
        let record = AttendanceRecord(entity: description!, insertIntoManagedObjectContext: managedObjectContext)
        record.attended = event
        record.employee_id = emloyeeId.text
        record.first_name = firstName.text
        record.last_name = lastName.text
        try! managedObjectContext.save()
        
        // Afterwards, clear the fields
        emloyeeId.text = ""
        firstName.text = ""
        lastName.text = ""
    }
    
    
    @IBAction func takePhoto(sender: AnyObject) {
        emloyeeId.text = ""
        firstName.text = ""
        lastName.text = ""
        
        view.endEditing(true)
        
        // Set up scan interface
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            let imagePicker = UIImagePickerController()
            self.imagePikerViewController = imagePicker;
            imagePicker.delegate = self
            imagePicker.sourceType = .Camera
            imagePicker.showsCameraControls = false
            NSBundle.mainBundle().loadNibNamed("CustomOverLayview", owner: self, options: nil)[0]
            self.overlayView.frame = imagePicker.cameraOverlayView!.frame;
            self.overlayView.backgroundColor = UIColor.clearColor()
            imagePicker.cameraOverlayView = self.overlayView
            self.overlayView = nil
            self.presentViewController(imagePicker, animated: true, completion: nil)
            
            let line = UIImageView(image:UIImage(named:"scan_line"))
            self.line = line
            line.frame = CGRectMake(self.view.frame.size.width - (self.view.frame.size.width - 60*2) - 60,95,self.view.frame.size.width - 60*2,2)
            self.pickBg.addSubview(line)
            
            self.time = NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: #selector(ScanViewController.timerFireMethod), userInfo: nil, repeats: true)
        }
    }
    
    // Scale the image to the desired dimensions
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
    
    // Do OCR using Tessereact
    func performImageRecognition(image: UIImage) {
        let tesseract = G8Tesseract()
        tesseract.language = "eng"
        tesseract.engineMode = .TesseractCubeCombined
        tesseract.pageSegmentationMode = .Auto
        tesseract.maximumRecognitionTime = 60.0
        tesseract.image = image.g8_blackAndWhite()
        tesseract.recognize()
        
        eventName.text = event!.name
        
        // Get recognized text from image
        let data = String(tesseract.recognizedText)
        
        // Split by lines and exclude empty lines
        var myStrings = data.componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet())
        myStrings = myStrings.filter({$0 != ""})
        
        // Find line that is numbers: employee ID
        var idPosition = 0
        for (index,line) in myStrings.enumerate(){
            if let nineDigit = Int(line) {
                emloyeeId.text = String(nineDigit)
                idPosition = index
            }
        }
        
        // First and last names are immediately after emplyoee ID
        if idPosition >= 2 {
            firstName.text = myStrings[idPosition - 2]
            lastName.text = myStrings[idPosition - 1]
        }
        
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
    
    // Perform scanning animation
    func timerFireMethod () {
        UIView.beginAnimations("animationID", context: nil)
        
        UIView.setAnimationDuration(2)
        UIView.setAnimationCurve(UIViewAnimationCurve.Linear)
        
        UIView.setAnimationRepeatCount(9999999)
        self.line.frame = CGRectMake(self.view.frame.size.width - (self.view.frame.size.width - 60*2) - 60,280,self.view.frame.size.width - 60*2,2)
        UIView.commitAnimations()
    }
    
    // Save fields if not empty
    @IBAction func save(sender: AnyObject) {
        if emloyeeId.text != "" || firstName.text != "" || lastName.text != ""{
            saveRecord()
        }
        self.back()
    }
    
}


extension ScanViewController: UIImagePickerControllerDelegate {
    // When photo is taken
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
