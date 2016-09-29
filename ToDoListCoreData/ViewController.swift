//
//  ViewController.swift
//  ToDoListCoreData
//
//  Created by Channat Tem on 9/26/16.
//  Copyright © 2016 Channat Tem. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    var managedObjectContext: NSManagedObjectContext?
    
    @IBOutlet weak var contentTextField: UITextField!
    
    @IBAction func addAction(sender: AnyObject) {
        addTodo(self.contentTextField.text!)
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addTodo(content: String) {
        print("creating...")
        
        let endpoint = "https://channat-todolist.herokuapp.com/api/tasks"
        let url = NSURL(string: endpoint)
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "POST"
        request.HTTPBody = "tasks_content=\(content)&".dataUsingEncoding(NSUTF8StringEncoding)
        
        let dataTask = NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, respond, error) in
            do {
                let result = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions(rawValue: 0))
                print(result)
                self.dismissViewControllerAnimated(true, completion: nil)
                
            } catch let nsJson as NSError {
                print(nsJson)
            }
        }
        
        dataTask.resume()
    }

}

