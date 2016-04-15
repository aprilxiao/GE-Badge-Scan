//
//  CreateViewController.swift
//  GEmock
//
//  Created by user116761 on 4/5/16.
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

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
