//
//  EventTableViewController.swift
//  GEmock
//
//  Created by 陈昊 on 4/5/16.
//  Copyright © 2016 Yushi xiao. All rights reserved.
//

import UIKit
import CoreData

class EventTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    var resultsController: NSFetchedResultsController = NSFetchedResultsController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let leftBtn:UIButton = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 40))
        leftBtn.setImage(UIImage.init(imageLiteral: "logo"), forState: UIControlState.Normal)
        leftBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
        let leftItem = UIBarButtonItem.init(customView: leftBtn)
        self.navigationItem.leftBarButtonItem = leftItem;
        
        self.navigationController?.navigationBar.barTintColor = UIColor.init(colorLiteralRed: 97/255.0, green: 149/255.0, blue: 192/255.0, alpha: 1)
        
        self.tableView.backgroundColor = UIColor.init(colorLiteralRed: 187/255.0, green: 205/255.0, blue: 227/255.0, alpha: 1)
        
        resultsController = NSFetchedResultsController(fetchRequest: fetchRequest(), managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        resultsController.delegate = self
        try! resultsController.performFetch()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func fetchRequest() -> NSFetchRequest {
        let request = NSFetchRequest(entityName: "Event")
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        
        return request
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return (resultsController.sections?.count)!
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (resultsController.sections?[section].numberOfObjects)!
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell : UserDataCell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UserDataCell

        let event = resultsController.objectAtIndexPath(indexPath) as! Event
        cell.nameLabel.text = event.name
        cell.locationLabel.text = event.location
        return cell
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == .Delete {
            
            let managedObject:Event = resultsController.objectAtIndexPath(indexPath) as! Event
            
            let  deleteActionSheet = UIAlertController(title: "Delete?", message: "\(managedObject.name!)", preferredStyle: .ActionSheet)
        
            let cancel: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel) { action -> Void in
            self.tableView.setEditing(false, animated: true)
            }
            
            deleteActionSheet.addAction(cancel)
        
            let delete: UIAlertAction = UIAlertAction(title: "Delete Event", style: .Destructive) { action -> Void in
            self.managedObjectContext.deleteObject(managedObject)
            try! self.managedObjectContext.save()
            }
        
            deleteActionSheet.addAction(delete)

            presentViewController(deleteActionSheet, animated: true, completion: nil)
        
    }
     /*
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    */
    }
 

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "details" {
            let path = tableView.indexPathForCell(sender as! UITableViewCell)
            let controller: DetailViewController = segue.destinationViewController as! DetailViewController
            let event:Event = resultsController.objectAtIndexPath(path!) as! Event
            controller.event = event
        }
    }

}
