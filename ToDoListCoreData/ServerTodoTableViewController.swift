//
//  ServerTodoTableViewController.swift
//  ToDoListCoreData
//
//  Created by Channat Tem on 9/29/16.
//  Copyright © 2016 Channat Tem. All rights reserved.
//

import UIKit

class ServerTodoTableViewController: UITableViewController {
    var todos: [[String: AnyObject]]?
    
    func deleteTodo(id: Int) {
        let endpoint = "https://channat-todolist.herokuapp.com/api/tasks/\(id)"
        let url = NSURL(string: endpoint)
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "DELETE"
        let dataTask = NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, respond, error) in
            self.getTodoListAndUpdateTableView()
        }
        
        dataTask.resume()

    }
    
    func markToDoFinished(index: Int){
        let endpoint = "https://channat-todolist.herokuapp.com/api/tasks/\(index)/finished"
        let url = NSURL(string: endpoint)
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "PATCH"
        let dataTask = NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, respond, error) in
            self.getTodoListAndUpdateTableView()
        }
        
        dataTask.resume()


    }
    
    func getTodoListAndUpdateTableView() {
        let endpoint = "https://channat-todolist.herokuapp.com/api/tasks"
        let url = NSURL(string: endpoint)
        let request = NSMutableURLRequest(URL: url!)
        
        let dataTask = NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, respond, error) in
            do {
                if let tasks = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions(rawValue: 0)) as? [[String: AnyObject]] {
                    
                    let sorted = tasks.sort({$0["id"] as! Int > $1["id"] as! Int})
                    self.todos = sorted

                    dispatch_async(dispatch_get_main_queue(), { 
                        self.tableView.reloadData()
                    })
                    
                }
                    
                else {
                    print("Cannot cast to [[String: AnyObject]]")
                }
                
                
            } catch let nsJson as NSError {
                print(nsJson)
            }
        }
        
        dataTask.resume()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        getTodoListAndUpdateTableView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let todos = self.todos {
            return todos.count
        }
        
        return 0
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("todolistIdentifier", forIndexPath: indexPath)
        print(self.todos)
        if let todos = self.todos {
            let todo = todos[indexPath.row]
            cell.textLabel?.text = todo["content"] as? String
            
            let finished = todo["finished"] as! Bool
            if (finished) {
                cell.accessoryType = .Checkmark
            }
            
            else {
                cell.accessoryType = .None
            }
        }

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
            let todoDicationary = self.todos![indexPath.row]
            let id = todoDicationary["id"] as! Int
            self.deleteTodo(id)
            getTodoListAndUpdateTableView()
            //tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            
            
            
            
            
            
            
            
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        let alert = UIAlertController(title: "ToDo List", message: "Is this event done?", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Done", style: .Default, handler: { (action) in
            let todoDicationary = self.todos![indexPath.row]
            let index = todoDicationary["id"] as! Int

            self.markToDoFinished(index)
             self.dismissViewControllerAnimated(true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Not Yet", style: .Cancel, handler: { (action) in
            self.dismissViewControllerAnimated(true, completion: nil)
            
            
        }))
        presentViewController(alert, animated: true, completion: nil)
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
