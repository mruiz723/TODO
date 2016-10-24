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
    var title:String
    var priority:Int
    var descriptionTask: String
    
    //MARK: - Init
    
    //Designated Initializer
    init(title:String, priority:Int, descriptionTask:String) {
        self.title = title
        self.priority = priority
        self.descriptionTask = descriptionTask
        
        super.init()
    }
    
   
    required convenience init(coder aDecoder: NSCoder) {
        let title = aDecoder.decodeObjectForKey("title") as! String
        let priority = aDecoder.decodeIntForKey("priority")
        let descriptionTask = aDecoder.decodeObjectForKey("descriptionTask") as! String
        
        self.init(title:title, priority:Int(priority), descriptionTask:descriptionTask)
    }
    
    //Convenience Initializer
    convenience override init() {
        self.init(title:"", priority:0, descriptionTask:"")
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(title, forKey: "title")
        aCoder.encodeInt(Int32(priority), forKey: "priority")
        aCoder.encodeObject(descriptionTask, forKey: "descriptionTask")
    }
    
    static func save(tasks:[Task]) {
        let data = NSKeyedArchiver.archivedDataWithRootObject(tasks)
        NSUserDefaults.standardUserDefaults().setObject(data, forKey: "Tasks")
    }
    
    class func tasks() -> [Task] {
        var tasks = [Task]()
        
        if let data = NSUserDefaults.standardUserDefaults().objectForKey("Tasks") as? NSData {
            if let objectTasks = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? [Task] {
                tasks = objectTasks
            }
        }
        
        return tasks
    }
    
    class func priorities() -> [String] {
        return ["","Alta", "Media", "Baja"]
    }
    
}
