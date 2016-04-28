//
//  CreateViewController.swift
//  GEmock
//
//  Created by 陈昊 on 4/5/16.
//  Copyright © 2016 Yushi xiao. All rights reserved.
//

import UIKit
import CoreData


class CreateViewController: UIViewController {
    
    
    @IBOutlet weak var eventName: UITextField!
    @IBOutlet weak var eventLocation: UITextField!
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    @IBAction func createEvent(sender: AnyObject) {
        let description = NSEntityDescription.entityForName("Event", inManagedObjectContext: managedObjectContext)
        let event = Event(entity: description!, insertIntoManagedObjectContext: managedObjectContext)
        event.name = eventName.text
        event.location = eventLocation.text
        try! managedObjectContext.save()
        
        navigationController?.popViewControllerAnimated(true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.init(colorLiteralRed: 187/255.0, green: 205/255.0, blue: 227/255.0, alpha: 1)
        
        let leftBtn:UIButton = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 40))
        leftBtn.setImage(UIImage.init(imageLiteral: "icon_7"), forState: UIControlState.Normal)
        leftBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
        leftBtn.addTarget(self, action:#selector(CreateViewController.back), forControlEvents: UIControlEvents.TouchUpInside)
        let leftItem = UIBarButtonItem.init(customView: leftBtn)
        self.navigationItem.leftBarButtonItem = leftItem;
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func back() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
