//
//  DetailViewController.swift
//  GEmock
//
//  Created by user116761 on 4/5/16.
//  Copyright © 2016 Yushi xiao. All rights reserved.
//

import UIKit
import MessageUI

class DetailViewController: UIViewController, MFMailComposeViewControllerDelegate {
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var selectedQuoteIndex = 0
    
    // declare MIME types (Multipurpose Internet Mail Extension)
    // it defines which kind of information to send via email
    
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
    
    // MARK: - Share Quotes via Email
    
    func showMailComposerWith(attachmentName: String)
    {
        if MFMailComposeViewController.canSendMail() {
            let subject = "Attendance"
            let messageBody = "Hello, the attendance file is attached."
            let toRecipients = ["me@ge.com"]
            
            let mailComposer = MFMailComposeViewController()
            mailComposer.mailComposeDelegate = self
            mailComposer.setSubject(subject)
            mailComposer.setMessageBody(messageBody, isHTML: false)
            mailComposer.setToRecipients(toRecipients)
            
            let fileParts = attachmentName.componentsSeparatedByString(".")
            let fileName = fileParts[0]
            let fileExtension = fileParts[1]
            
            if let filePath = NSBundle.mainBundle().pathForResource(fileName, ofType: fileExtension) {
                if let fileData = NSData(contentsOfFile: filePath), mimeType = MIMEType(type: fileExtension) {
                    mailComposer.addAttachmentData(fileData, mimeType: mimeType.rawValue, fileName: fileName)
                    
                    presentViewController(mailComposer, animated: true, completion: nil)
                }
            }
        }
    }
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?)
    {
        switch result.rawValue
        {
        case MFMailComposeResultCancelled.rawValue:
            alert("Ooops", msg: "Mail canceled")
        case MFMailComposeResultSent.rawValue:
            alert("Yes!", msg: "Mail sent")
        case MFMailComposeResultSaved.rawValue:
            alert("Yes!", msg: "Mail saved")
        case MFMailComposeResultFailed.rawValue:
            alert("Oooops!", msg: "Mail failed")
        default: break
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func exportButtonClicked(sender: UIButton)
    {
        let csvName = "attendance.csv"
        showMailComposerWith(csvName)
    }
    
    private func alert(title: String, msg: String)
    {
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    
    // Default Project - Discover it at your pleasure :)
    
    // IB: Interface Builder
   // @IBOutlet weak var quoteLabel: UILabel!
    //@IBOutlet weak var backgroundImageView: UIImageView!
    
    @IBOutlet weak var scanButton: UIButton!
    @IBOutlet weak var exportButton: UIButton!
    
    // gets called when the view is loaded
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        scanButton.layer.cornerRadius = 4.0
//        scanButton.layer.masksToBounds = true
//        
//        exportButton.layer.cornerRadius = 4.0
//        exportButton.layer.masksToBounds = true
    }
    
    // MARK: - Change Quotes
    
       /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
