//
//  ViewController.swift
//  toDoListOSX
//
//  Created by Jae Hoon Lee on 8/8/15.
//  Copyright © 2015 Jae Hoon Lee. All rights reserved.
//

import Cocoa

class ViewController: NSViewController, NSTableViewDataSource {
    
    var tasks = Task.all()

    @IBOutlet weak var taskTableView: NSTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func textFieldEnterPressed(sender: NSTextField) {
        if sender.stringValue != "" {
            let newTask = Task(obj: sender.stringValue)
            newTask.save()
            tasks.append(newTask)
            taskTableView.reloadData()
        }
        sender.stringValue = ""
    }

    @IBAction func finishedButtonPressed(sender: NSButton) {
        print(taskTableView.selectedRow)
        if taskTableView.selectedRow > -1 {
            tasks[taskTableView.selectedRow].destroy()
            tasks.removeAtIndex(taskTableView.selectedRow)
            taskTableView.reloadData()
        }
    }
    
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return tasks.count
    }

    func tableView(tableView: NSTableView, objectValueForTableColumn tableColumn: NSTableColumn?, row: Int) -> AnyObject? {
        return tasks[row].objective
    }
}

