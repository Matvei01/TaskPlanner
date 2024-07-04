//
//  EditTaskViewController.swift
//  TaskPlanner
//
//  Created by Matvei Khlestov on 04.07.2024.
//

import UIKit

final class EditTaskViewController: BaseViewController {
    
    var task: Task?
    
    override func setupNavigationBar() {
        title = "Editing task"
        super.setupNavigationBar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        taskTextView.text = task?.title
    }
    
    override func save() {
        guard let taskName = taskTextView.text, !taskName.isEmpty else {
            showAlert(title: "Error", message: "Fill in all the fields")
            return
        }
        
        guard let task = task else {
            showAlert(title: "Error", message: "Task not found")
            return
        }
        
        storageManager.update(task, newName: taskName)
        delegate?.reloadData()
        navigationController?.popToRootViewController(animated: true)
    }
}

