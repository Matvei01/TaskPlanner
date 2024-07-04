//
//  AddTaskViewController.swift
//  TaskPlanner
//
//  Created by Matvei Khlestov on 02.07.2024.
//

import UIKit

final class AddTaskViewController: BaseViewController {
    
    override func setupNavigationBar() {
        title = "Adding new task"
        super.setupNavigationBar()
    }
    
    override func save() {
        guard let taskName = taskTextView.text, !taskName.isEmpty else {
            showAlert(title: "Error", message: "Fill in all the fields")
            return
        }
        storageManager.create(taskName)
        delegate?.reloadData()
        navigationController?.popToRootViewController(animated: true)
    }
}
