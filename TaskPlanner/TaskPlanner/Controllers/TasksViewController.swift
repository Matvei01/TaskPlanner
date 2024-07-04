//
//  TasksViewController.swift
//  TaskPlanner
//
//  Created by Matvei Khlestov on 01.07.2024.
//

import UIKit
import CoreData

protocol TaskViewControllerDelegate: AnyObject {
    func reloadData()
}

final class TasksViewController: UITableViewController {
    
    // MARK: - Private Properties
    private let reuseIdentifier = "CellId"
    private let storageManager = StorageManager.shared
    private var tasks: [Task] = []
    
    // MARK: - UI Elements
    private lazy var addBarButtonItem: UIBarButtonItem = {
        let button = UIBarButtonItem(
            systemItem: .add,
            primaryAction: addBarButtonItemTapped
        )
        return button
    }()
    
    // MARK: -  Action
    private lazy var addBarButtonItemTapped = UIAction { [unowned self] _ in
        let addTaskVC = AddTaskViewController()
        addTaskVC.delegate = self
        
        navigationController?.pushViewController(addTaskVC, animated: true)
    }
    
    // MARK: - Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
}

// MARK: - Table view data source
extension TasksViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tasks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        let task = tasks[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text = task.title
        if let date = task.date {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .short
            content.secondaryText = formatter.string(from: date)
        } else {
            content.secondaryText = "No date"
        }
        cell.contentConfiguration = content
        return cell
    }
}

// MARK: - Table view delegate
extension TasksViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let task = tasks[indexPath.row]
        let editTaskVC = EditTaskViewController()
        editTaskVC.delegate = self
        editTaskVC.task = task
        
        navigationController?.pushViewController(editTaskVC, animated: true)
    }
}

// MARK: - Private methods
private extension TasksViewController {
    func setupTableView() {
        tableView.register(
            UITableViewCell.self,
            forCellReuseIdentifier: reuseIdentifier
        )
        
        fetchData()
        
        setupNavigationBar()
    }
    
    func setupNavigationBar() {
        title = "Tasks"
        
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.backgroundColor = .systemGreen
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        navigationController?.navigationBar.tintColor = .white
        
        navigationItem.rightBarButtonItem = addBarButtonItem
    }
    
    func fetchData() {
        storageManager.fetchData { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let tasks):
                self.tasks = tasks
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

// MARK: - TaskViewControllerDelegate
extension TasksViewController: TaskViewControllerDelegate {
    func reloadData() {
        fetchData()
        tableView.reloadData()
    }
}
