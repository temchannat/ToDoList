//
//  ViewController.swift
//  ToDoListCoreData
//
//  Created by Channat Tem on 9/26/16.
//  Copyright © 2016 Channat Tem. All rights reserved.
//

import UIKit
import CoreData
import PKRevealController


class ViewController: UIViewController {
    var managedObjectContext: NSManagedObjectContext?
    
    @IBOutlet weak var contentTextField: UITextField!
    
    @IBAction func addAction(sender: AnyObject) {
        
        
        
        
        
        
        let todo = NSEntityDescription.insertNewObjectForEntityForName("ToDo", inManagedObjectContext: managedObjectContext!) as! ToDo
        todo.content = contentTextField.text!
        todo.finished = false
        do {
            try managedObjectContext!.save()
        } catch {
            fatalError("Failure to save context: \(error)")
        }
        self.dismissViewControllerAnimated(true, completion: nil)
 
        
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
   
        //setUpCoreData()
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
                
                self.getAllToDoList()
            } catch {
                fatalError("Error migrating store: \(error)")
            }
        }
 
 
    }
   
    
    func getAllToDoList(){
        
        
        let toDoFechRequest = NSFetchRequest(entityName: "ToDo")
        do{
            let fetchTodo = try managedObjectContext?.executeFetchRequest(toDoFechRequest) as! [ToDo]
            for eachFetch in fetchTodo {
                print(eachFetch.content!)
                print(eachFetch.finished!)
            }
        }catch{
            fatalError("Failed to fetch ToDo: \(error)")
        }
 
 
    }

}

