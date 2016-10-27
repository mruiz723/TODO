//
//  ViewController.swift
//  TODO
//
//  Created by Luis F Ruiz Arroyave on 10/23/16.
//  Copyright © 2016 UdeM. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NewTaskViewControllerDelegate, TaskViewControllerDelegate {

    //MARK: - IBOutlets
    @IBOutlet weak var taskTableView: UITableView!
    
    //MARK: - Properties
    var tasks : [Task]?
    var currentIndex : Int?
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tasks = Task.tasks()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "task" {
            
            let dataDict = sender  as! Dictionary<String, AnyObject>
            currentIndex = (dataDict["index"] as? Int)!
            
            if let taskVC = segue.destinationViewController as? TaskViewController {
                taskVC.type = dataDict["type"] as? String
                taskVC.task = tasks![currentIndex!]
                taskVC.delegate = self
            }
        }else {
            if let newTaskVC = segue.destinationViewController as? NewTaskViewController {
                newTaskVC.delegate = self
            }
        }
        
    }

    //MARK: - UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (tasks?.count)!
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let task = tasks![indexPath.row]
        
        let cell = tableView.dequeueReusableCellWithIdentifier("TaskCell")
        cell?.textLabel?.text = task.title
        cell?.detailTextLabel?.text = Task.priorities()[task.priority]
        
        return cell!
        
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool
    {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath)
    {
        if editingStyle == .Delete
        {
            tasks?.removeAtIndex(indexPath.row)
            Task.save(tasks!)
            tableView.reloadData()
        }
    }
    
    //MARK: - UITableViewDelegate
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let detailAction = UITableViewRowAction(style: .Normal, title: "Detail") { (action, indexPath) in
            dispatch_async(dispatch_get_main_queue(), { 
                self.performSegueWithIdentifier("task", sender: ["index":indexPath.row, "type":"detail"])
            })
            
        }
        
        detailAction.backgroundColor = UIColor.greenColor()
        
        let editAction = UITableViewRowAction(style: .Normal, title: "Edit") { (action, indexPath) in
            dispatch_async(dispatch_get_main_queue(), {
                self.performSegueWithIdentifier("task", sender: ["index":indexPath.row, "type":"edit"])
            })
        }
        
        editAction.backgroundColor = UIColor.blueColor()
        
        let deleteAction = UITableViewRowAction(style: .Default, title: "Delete") { (action, indexPath) in
            dispatch_async(dispatch_get_main_queue(), {
                self.tasks?.removeAtIndex(indexPath.row)
                Task.save(self.tasks!)
                self.taskTableView.reloadData()
            })
        }
        
        deleteAction.backgroundColor = UIColor.redColor()
        
        return [detailAction,editAction,deleteAction]
    }
    
    //MARK: - NewTaskViewControllerDelegate
    func didCreate(task: Task) {
        tasks?.append(task)
        Task.save(tasks!)
        taskTableView.reloadData()
    }
    
    //MARK: - TaskViewControllerDelegate
    func didUpdate(task: Task) {
        tasks![currentIndex!] = task
        Task.save(tasks!)
        taskTableView.reloadData()
    }
    
}

