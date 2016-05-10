//
//  EventTableViewController.swift
//  GEmock

import UIKit
import CoreData

class EventTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    var resultsController: NSFetchedResultsController = NSFetchedResultsController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up UI, including putting GE logo at top-left
        let leftBtn:UIButton = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 40))
        leftBtn.setImage(UIImage.init(imageLiteral: "logo"), forState: UIControlState.Normal)
        leftBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
        let leftItem = UIBarButtonItem.init(customView: leftBtn)
        self.navigationItem.leftBarButtonItem = leftItem;
        
        self.navigationController?.navigationBar.barTintColor = UIColor.init(colorLiteralRed: 97/255.0, green: 149/255.0, blue: 192/255.0, alpha: 1)
        
        self.tableView.backgroundColor = UIColor.init(colorLiteralRed: 187/255.0, green: 205/255.0, blue: 227/255.0, alpha: 1)
        
        // Execute event list fetching
        resultsController = NSFetchedResultsController(fetchRequest: fetchRequest(), managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        resultsController.delegate = self
        try! resultsController.performFetch()
    }
    
    // The fetch request used to generate the event list
    func fetchRequest() -> NSFetchRequest {
        let request = NSFetchRequest(entityName: "Event")
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        
        return request
    }
    
    // Refresh the list if necessary
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.reloadData()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return (resultsController.sections?.count)!
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (resultsController.sections?[section].numberOfObjects)!
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Set up cell for a particular event in results set
        let cell : UserDataCell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UserDataCell
        
        let event = resultsController.objectAtIndexPath(indexPath) as! Event
        cell.nameLabel.text = event.name
        cell.locationLabel.text = event.location
        return cell
    }
    
    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete action with confirmation
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
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // When going to event details page, pass the chosen event object to that controller
        if segue.identifier == "details" {
            let path = tableView.indexPathForCell(sender as! UITableViewCell)
            let controller: DetailViewController = segue.destinationViewController as! DetailViewController
            let event:Event = resultsController.objectAtIndexPath(path!) as! Event
            controller.event = event
        }
    }
    
}
