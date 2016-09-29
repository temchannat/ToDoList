//
//  ToDoListTableViewController.swift
//  ToDoListCoreData
//
//  Created by Channat Tem on 9/26/16.
//  Copyright © 2016 Channat Tem. All rights reserved.
//

import UIKit
import CoreData

class ToDoListTableViewController: UITableViewController {
    var fetchTodo: [ToDo] = []
    var managedObjectContext: NSManagedObjectContext?
    
  
    @IBOutlet weak var contentLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCoreData()
       
        getAllToDoList()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        getAllToDoList()
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
                return fetchTodo.count
    }
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete{
            
            tableView.beginUpdates()
            
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            let todo =  fetchTodo[indexPath.row]
            managedObjectContext?.deleteObject(todo)
            do{
                try managedObjectContext?.save()
            }catch{
                print("\(error)")
            }
            getAllToDoList()
            tableView.endUpdates()
            tableView.reloadData()
            
        }
    }
    
   
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("todolistIdentifier", forIndexPath: indexPath)
     
        let todo = fetchTodo[indexPath.row]
        cell.textLabel?.text = todo.content
        if todo.finished == true {
            cell.accessoryType = .Checkmark
        }else{
            cell.accessoryType = .None
        }
        
        
        return cell
    }
    
    
    
    func setUpCoreData() {
        // This resource is the same name as your xcdatamodeld contained in your project.
        guard let modelURL = NSBundle.mainBundle().URLForResource("ToDoListCoreData", withExtension:"momd") else {
            fatalError("Error loading model from bundle")
        }
        // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
        guard let mom = NSManagedObjectModel(contentsOfURL: modelURL) else {
            fatalError("Error initializing mom from: \(modelURL)")
        }
        let psc = NSPersistentStoreCoordinator(managedObjectModel: mom)
        managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext!.persistentStoreCoordinator = psc
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) {
            let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
            let docURL = urls[urls.endIndex-1]
            /* The directory the application uses to store the Core Data store file.
             This code uses a file named "DataModel.sqlite" in the application's documents directory.
             */
            let storeURL = docURL.URLByAppendingPathComponent("ToDoListCoreData.sqlite")
            do {
                try psc.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: storeURL, options: nil)
                print("Success")
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.getAllToDoList()
                    self.tableView.reloadData()
                })
                
                
            } catch {
                fatalError("Error migrating store: \(error)")
            }
        }
    }
   
    
    
    func getAllToDoList(){
        let toDoFechRequest = NSFetchRequest(entityName: "ToDo")
        do {
            self.fetchTodo = try managedObjectContext!.executeFetchRequest(toDoFechRequest) as! [ToDo]
            
        } catch {
            fatalError("Failed to fetch employees: \(error)")
        }
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        let alert = UIAlertController(title: "ToDo List", message: "Is this event done?", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Done", style: .Default, handler: { (action) in
            self.dismissViewControllerAnimated(true, completion: nil)
            
            let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate
            self.fetchTodo[indexPath.row].finished = true
            appDelegate?.saveContext()
            print("done")
            tableView.reloadData()
            
        }))
        alert.addAction(UIAlertAction(title: "Not Yet", style: .Cancel, handler: { (action) in
            self.dismissViewControllerAnimated(true, completion: nil)
           
            
        }))
        presentViewController(alert, animated: true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // this method is called when the the new segue is pressed.
        let destination = segue.destinationViewController as! ViewController
        destination.managedObjectContext = managedObjectContext
    }

}
