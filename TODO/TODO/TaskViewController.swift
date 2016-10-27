//
//  TaskViewController.swift
//  TODO
//
//  Created by Luis F Ruiz Arroyave on 10/23/16.
//  Copyright © 2016 UdeM. All rights reserved.
//

import UIKit

protocol TaskViewControllerDelegate {
    func didUpdate(task: Task)
}

class TaskViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    //MARK: - IBOutlets
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var priorityTextField: UITextField!
    @IBOutlet weak var descriptionTaskTextView: UITextView!
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var saveButton: UIButton!
    
    //MARK: - Properties
    var priorities = Task.priorities()
    var task : Task?
    var type : String?
    var delegate : TaskViewControllerDelegate?
    
    //MARK: - IBActions
    @IBAction func save(sender: AnyObject) {
        if titleTextField.text?.characters.count > 0 {
            
            let title = titleTextField.text!
            
            if priorityTextField.text?.characters.count > 0 {
                
                let priority = Task.priorities().indexOf(priorityTextField.text!)
                let descriptionTask = descriptionTaskTextView.text.characters.count > 0 ? descriptionTaskTextView.text : ""
                let task = Task(title: title, priority:priority! , descriptionTask: descriptionTask)
                
                delegate?.didUpdate(task)
                self.navigationController?.popViewControllerAnimated(true)
            }
        }
        
    }
    
    @IBAction func done(sender: AnyObject) {
        priorityTextField.resignFirstResponder()
    }
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let pickerView = UIPickerView()
        priorityTextField.inputView = pickerView
        priorityTextField.inputAccessoryView = toolbar
        toolbar.removeFromSuperview()
        pickerView.delegate = self
        
        if let item = task {
            titleTextField.text = item.title
            priorityTextField.text = priorities[item.priority]
            descriptionTaskTextView.text = item.descriptionTask
        }
        
        if type == "detail" {
            saveButton.removeFromSuperview()
            titleTextField.enabled = false
            priorityTextField.enabled = false
            descriptionTaskTextView.editable = false
            title = "Detail Task"
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //MARK: -  UIPickerViewDataSource
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return priorities.count
    }
    
    //MARK: - UIPickerViewDelegate
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return priorities[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        priorityTextField.text = priorities[row]
    }


}
