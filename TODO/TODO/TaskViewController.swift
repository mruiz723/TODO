//
//  TaskViewController.swift
//  TODO
//
//  Created by Luis F Ruiz Arroyave on 10/23/16.
//  Copyright © 2016 UdeM. All rights reserved.
//

import UIKit

class TaskViewController: UIViewController {

    //MARK: - IBOutlets
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var priorityTextField: UITextField!
    @IBOutlet weak var descriptionTaskTextView: UITextView!
    
    //MARK: - Properties
    
    //MARK: - IBActions
    @IBAction func save(sender: AnyObject) {
        
    }
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
