//
//  DetailViewController.swift
//  GEmock
//
//  Created by 陈昊 on 4/5/16.
//  Copyright © 2016 Yushi xiao. All rights reserved.
//

import UIKit
import MessageUI
import Foundation
import CoreData

class DetailViewController: UIViewController, MFMailComposeViewControllerDelegate, NSFetchedResultsControllerDelegate  {
    //
    private enum MIMEType: String {
        case csv = "text/csv"
        case jpg = "image/jpeg"
        case png = "image/png"
        case doc = "application/msword"
        case ppt = "application/vnd.ms-powerpoint"
        case html = "text/html"
        case pdf = "application/pdf"
        
        init?(type: String) {
            switch type.lowercaseString {
            case "csv": self = .csv
            case "jpg": self = .jpg
            case "png": self = .png
            case "doc": self = .doc
            case "ppt": self = .ppt
            case "html": self = .html
            case "pdf": self = .pdf
            default: return nil
            }
        }
    }
    
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    var resultsController: NSFetchedResultsController = NSFetchedResultsController()
    
    var event: Event? = nil
    
    @IBOutlet weak var eventLocation: UILabel!
    @IBOutlet weak var eventName: UILabel!
    
    func generateEventCSV() -> String {
        resultsController = NSFetchedResultsController(fetchRequest: fetchRequest(), managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        resultsController.delegate = self
        try! resultsController.performFetch()
        
        var csv = "id, first, last\n"
        for record in resultsController.fetchedObjects as! [AttendanceRecord] {
            csv += record.employee_id! + ","
            csv += record.first_name! + ","
            csv += record.last_name! + "\n"
        }
        
        return csv;
    }
    
    func fetchRequest() -> NSFetchRequest {
        let request = NSFetchRequest(entityName: "AttendanceRecord")
        let sortDescriptor = NSSortDescriptor(key: "employee_id", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        let predicate = NSPredicate(format: "attended = %@", event!)
        request.predicate = predicate
        
        return request
    }
    
    @IBAction func export(sender: AnyObject) {
    
        
        //Check to see the device can send email.
        if( MFMailComposeViewController.canSendMail() ) {
            
            let mailComposer = MFMailComposeViewController()
            mailComposer.mailComposeDelegate = self
            
            //Set the subject and message of the email
            mailComposer.setSubject("Attendance data for " + (event?.name)!)
            mailComposer.setMessageBody("", isHTML: false)
            
            let csvString = generateEventCSV()
            mailComposer.addAttachmentData(csvString.dataUsingEncoding(NSUTF8StringEncoding)!, mimeType: "csv", fileName: "attendence.csv")
            
            self.presentViewController(mailComposer, animated: true, completion: nil)
        }
    }
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    
    /*
     //
     let mailComposeViewController = configuredMailComposeViewController(attachmentName: String)
     //
     let csvName = "attendance.csv"
     //
     configuredMailComposeViewController(csvName)
     if MFMailComposeViewController.canSendMail() {
     self.presentViewController(mailComposeViewController, animated: true, completion: nil)
     } else {
     self.showSendMailErrorAlert()
     }
     }
     
     func configuredMailComposeViewController(attachmentName: String) -> MFMailComposeViewController {
     let mailComposerVC = MFMailComposeViewController()
     mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
     
     mailComposerVC.setToRecipients(["someone@somewhere.com"])
     mailComposerVC.setSubject("Sending you an in-app e-mail...")
     mailComposerVC.setMessageBody("Sending e-mail in-app is not so bad!", isHTML: false)
     
     //
     let fileParts = attachmentName.componentsSeparatedByString(".")
     let fileName = fileParts[0]
     let fileExtension = fileParts[1]
     
     if let filePath = NSBundle.mainBundle().pathForResource(fileName, ofType: fileExtension) {
     print("file path loaded")
     if let fileData = NSData(contentsOfFile: filePath), mimeType = MIMEType(type: fileExtension) {
     print("file data loaded")
     mailComposerVC.addAttachmentData(fileData, mimeType: mimeType.rawValue, fileName: fileName)
     
     self.presentViewController(mailComposerVC, animated: true, completion: nil)
     }
     return mailComposerVC
     }
     
     func showSendMailErrorAlert() {
     /*let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
     sendMailErrorAlert.show()*/
     }
     
     // MARK: MFMailComposeViewControllerDelegate Method
     func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
     controller.dismissViewControllerAnimated(true, completion: nil)
     }
     
     */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.init(colorLiteralRed: 187/255.0, green: 205/255.0, blue: 227/255.0, alpha: 1)
        
        let rightBtn:UIButton = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 40))
        rightBtn.setImage(UIImage.init(imageLiteral: "icon_fabu"), forState: UIControlState.Normal)
        rightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Right
        rightBtn.addTarget(self, action: #selector(DetailViewController.export(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        let rightItem = UIBarButtonItem.init(customView: rightBtn)
        self.navigationItem.rightBarButtonItem = rightItem;
        
        let leftBtn:UIButton = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 40))
        leftBtn.setImage(UIImage.init(imageLiteral: "icon_7"), forState: UIControlState.Normal)
        leftBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
        leftBtn.addTarget(self, action: #selector(DetailViewController.back), forControlEvents: UIControlEvents.TouchUpInside)
        let leftItem = UIBarButtonItem.init(customView: leftBtn)
        self.navigationItem.leftBarButtonItem = leftItem;
        
        if event != nil {
            eventName.text = event?.name
            eventLocation.text = event?.location
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func back() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "scan" {
            let controller: ScanViewController = segue.destinationViewController as! ScanViewController
            controller.event = event
        }
    }


}
