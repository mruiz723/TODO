//
//  NewTaskViewController.swift
//  TODO
//
//  Created by Luis F Ruiz Arroyave on 10/23/16.
//  Copyright © 2016 UdeM. All rights reserved.
//

import UIKit
import SVProgressHUD

protocol NewTaskViewControllerDelegate {
    
    func didCreate(task:Task)
}

class NewTaskViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    //MARK: - IBOutlets
    
    @IBOutlet weak var titleTextField: UITextField!
   
    @IBOutlet weak var priorityTextField: UITextField!
    @IBOutlet weak var descriptionTaskTextView: UITextView!
    @IBOutlet weak var toolbar: UIToolbar!
    
    //MARK: - Properties
    var delegate : NewTaskViewControllerDelegate?
    var priorities = Task.priorities()
    
    //MARK: - IBActions
    @IBAction func cancel(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func create(sender: AnyObject) {
        if titleTextField.text?.characters.count > 0 {
            
            let title = titleTextField.text!
            
            if priorityTextField.text?.characters.count > 0 {
                
                let priority = Task.priorities().indexOf(priorityTextField.text!)
                let descriptionTask = descriptionTaskTextView.text.characters.count > 0 ? descriptionTaskTextView.text : ""
                
                SVProgressHUD.show()
                Task.save(["title": title, "priority": priority!, "descriptionTask": descriptionTask], completionHandler: { (success, response) in
                    SVProgressHUD.dismiss()
                    if success {
                        let task = response["task"] as! Task
                        self.delegate?.didCreate(task)
                    }else {
                        print("Error \(response["error"] as! String)")
                    }
                    self.dismissViewControllerAnimated(true, completion: nil)
                })
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
