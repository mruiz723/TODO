//
//  Task.swift
//  TODO
//
//  Created by Luis F Ruiz Arroyave on 10/23/16.
//  Copyright © 2016 UdeM. All rights reserved.
//

import Foundation

class Task: NSObject, NSCoding {

    //MARK: - Properties
    var _id: String
    var title: String
    var priority: Int
    var descriptionTask: String
    
    //MARK: - Init
    
    //Designated Initializer
    init(_id: String, title:String, priority:Int, descriptionTask:String) {
        self._id = _id
        self.title = title
        self.priority = priority
        self.descriptionTask = descriptionTask
        
        super.init()
    }
    
   
    required convenience init(coder aDecoder: NSCoder) {
        let _id = aDecoder.decodeObjectForKey("idTask") as! String
        let title = aDecoder.decodeObjectForKey("title") as! String
        let priority = aDecoder.decodeIntForKey("priority")
        let descriptionTask = aDecoder.decodeObjectForKey("descriptionTask") as! String
        
        self.init(_id: _id, title: title, priority:Int(priority), descriptionTask:descriptionTask)
    }
    
    //Convenience Initializer
    convenience override init() {
        self.init(_id: "", title:"", priority:0, descriptionTask:"")
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(_id, forKey: "_id")
        aCoder.encodeObject(title, forKey: "title")
        aCoder.encodeInt(Int32(priority), forKey: "priority")
        aCoder.encodeObject(descriptionTask, forKey: "descriptionTask")
    }
    
//    static func save(tasks:[Task]) {
//        let data = NSKeyedArchiver.archivedDataWithRootObject(tasks)
//        NSUserDefaults.standardUserDefaults().setObject(data, forKey: "Tasks")
//    }
    
    
    class func tasks() -> [Task] {
        var tasks = [Task]()
        
        if let data = NSUserDefaults.standardUserDefaults().objectForKey("Tasks") as? NSData {
            if let objectTasks = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? [Task] {
                tasks = objectTasks
            }
        }
        
        return tasks
    }

    static func save(task:[String: AnyObject], completionHandler: CompletionHandler) {
        Services.save(task) { (success, response) in
            if success {
                if let taskSaved = response["response"] {
                    let idTask = taskSaved["_id"] as! String
                    let title = taskSaved["title"] as! String
                    let priority = Int(taskSaved["priority"] as! String)!
                    let descriptionTask = taskSaved["title"] as! String
                    
                    let task = Task(_id:idTask , title: title, priority: priority, descriptionTask: descriptionTask)
                    
                    completionHandler(success: success, response: ["task": task])
                }
                
            }else {
                completionHandler(success: success, response: response)
            }
        }
    }
    
    static func update(task:[String: AnyObject], completionHandler: CompletionHandler) {
        Services.update(task) { (success, response) in
            if success {
                if let taskSaved = response["response"] {
                    let idTask = taskSaved["_id"] as! String
                    let title = taskSaved["title"] as! String
                    let priority = Int(taskSaved["priority"] as! String)!
                    let descriptionTask = taskSaved["title"] as! String
                    
                    let task = Task(_id:idTask , title: title, priority: priority, descriptionTask: descriptionTask)
                    
                    completionHandler(success: success, response: ["task": task])
                }
                
            }else {
                completionHandler(success: success, response: response)
            }
        }
    }
    
    static func delete(task:[String: AnyObject], completionHandler: CompletionHandler) {
        Services.delete(task) { (success, response) in
            if success {
                completionHandler(success: success, response: response)
            }else {
                completionHandler(success: success, response: response)
            }
        }
    }

    
    static func tasks(completionHandler: CompletionHandler){
        Services.tasks { (success, response) in
            if success {
                var tasks = [Task]()
                for(_, value) in response {  // response = [String: AnyObject]
                    let array = value as! NSArray
                    for itemTask in array {
                        let task = Task()
                        let dictTask = itemTask as! NSDictionary // itemTask representa una tarea
                        for(keyTask, valueTask) in dictTask{
                            if task.respondsToSelector(NSSelectorFromString(keyTask as! String)) {
                                task.setValue(valueTask, forKey: keyTask as! String) //KVC key value Coding Key-value coding is a mechanism for accessing an object’s properties indirectly, using strings to identify properties, rather than through invocation of an accessor method or accessing them directly through instance variables.
                                
                            }
                        }
                        tasks.append(task)
                    }
                }
                completionHandler(success:success, response: ["tasks":tasks])
            }else {
                completionHandler(success: success, response: response)
            }
        }
    }
    
    class func priorities() -> [String] {
        return ["","Alta", "Media", "Baja"]
    }
    
    func taskDictionary() -> [String: AnyObject] {
        return ["_id": self._id, "title": self.title, "priority": self.priority, "descriptionTask": self.descriptionTask]
    }
}
