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
    var idTask: String
    var title: String
    var priority: Int
    var descriptionTask: String
    
    //MARK: - Init
    
    //Designated Initializer
    init(idTask: String, title:String, priority:Int, descriptionTask:String) {
        self.idTask = idTask
        self.title = title
        self.priority = priority
        self.descriptionTask = descriptionTask
        
        super.init()
    }
    
   
    required convenience init(coder aDecoder: NSCoder) {
        let idTask = aDecoder.decodeObjectForKey("idTask") as! String
        let title = aDecoder.decodeObjectForKey("title") as! String
        let priority = aDecoder.decodeIntForKey("priority")
        let descriptionTask = aDecoder.decodeObjectForKey("descriptionTask") as! String
        
        self.init(idTask: idTask, title: title, priority:Int(priority), descriptionTask:descriptionTask)
    }
    
    //Convenience Initializer
    convenience override init() {
        self.init(idTask: "", title:"", priority:0, descriptionTask:"")
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(idTask, forKey: "idTask")
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
                let idTask = response["_id"] as! String
                let title = response["title"] as! String
                let priority = Int(response["priority"] as! String)!
                let descriptionTask = response["title"] as! String
                
                let task = Task(idTask:idTask , title: title, priority: priority, descriptionTask: descriptionTask)
                
                completionHandler(success: success, response: ["task": task])
            }else {
                completionHandler(success: success, response: response)
            }
        }
    }

    
    static func tasks(completionHandler: CompletionHandler){
        Services.tasks { (success, response) in
            if success {
                var tasks = [Task]()
                for(_, value) in response {
                    let array = value as! NSArray
                    for itemTask in array {
                        let task = Task()
                        let dictTask = itemTask as! NSDictionary
                        for(keyTask, valueTask) in dictTask{
                            if task.respondsToSelector(NSSelectorFromString(keyTask as! String)) {
                                task.setValue(valueTask, forKey: keyTask as! String)
                            }
                        }
                        tasks.append(task)
                    }
                }
                completionHandler(success:success, response: ["tasks":tasks])
            }
        }
    }
    
    class func priorities() -> [String] {
        return ["","Alta", "Media", "Baja"]
    }
    
}
