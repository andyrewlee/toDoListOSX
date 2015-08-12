//
//  Task.swift
//  toDoListOSX
//
//  Created by Jae Hoon Lee on 8/9/15.
//  Copyright © 2015 Jae Hoon Lee. All rights reserved.
//

import Foundation
class Task: NSObject, NSCoding {
    static var key: String = "Tasks"
    static var schema: String = "theList"
    var objective: String
    var createdAt: NSDate
    
    // use this init for creating a new Task
    init(obj: String) {
        objective = obj
        createdAt = NSDate()
    }
    
    // MARK: - NSCoding protocol
    // used for encoding (saving) objects
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(objective, forKey: "objective")
        aCoder.encodeObject(createdAt, forKey: "createdAt")
    }
    
    // used for decoding (loading) objects
    required init?(coder aDecoder: NSCoder) {
        objective = aDecoder.decodeObjectForKey("objective") as! String
        createdAt = aDecoder.decodeObjectForKey("createdAt") as! NSDate
        super.init()
    }
    
    // MARK: - Queries
    static func all() -> [Task] {
        var tasks = [Task]()
        let path = Database.dataFilePath("theList")
        if NSFileManager.defaultManager().fileExistsAtPath(path) {
            if let data = NSData(contentsOfFile: path) {
                let unarchiver = NSKeyedUnarchiver(forReadingWithData: data)
                tasks = unarchiver.decodeObjectForKey(Task.key) as! [Task]
                unarchiver.finishDecoding()
            }
        }
        return tasks
    }
    
    func destroy() {
        var tasksFromStorage = Task.all()
        for var i = 0; i < tasksFromStorage.count; ++i {
            if tasksFromStorage[i].createdAt == self.createdAt {
                tasksFromStorage.removeAtIndex(i)
            }
        }
        Database.save(tasksFromStorage, toSchema: Task.schema, forKey: Task.key)
    }
    
    func save() {
        var tasksFromStorage = Task.all()
        var exists = false
        for var i = 0; i < tasksFromStorage.count; ++i {
            if tasksFromStorage[i].createdAt == self.createdAt {
                tasksFromStorage[i] = self
                exists = true
            }
        }
        if !exists {
            tasksFromStorage.append(self)
        }
        Database.save(tasksFromStorage, toSchema: Task.schema, forKey: Task.key)
    }
}