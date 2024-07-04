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
    private var tasks: [Task] = []
    private var filteredTasks: [Task] = []
    private let reuseIdentifier = "CellId"
    private let storageManager = StorageManager.shared
    private let searchController = UISearchController(
        searchResultsController: nil
    )
    
    private var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }
    
    private var searchBarIsEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
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
        isFiltering ? filteredTasks.count : tasks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        let task = isFiltering ? filteredTasks[indexPath.row] : tasks[indexPath.row]
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
        let task = isFiltering ? filteredTasks[indexPath.row] : tasks[indexPath.row]
        let editTaskVC = EditTaskViewController()
        editTaskVC.delegate = self
        editTaskVC.task = task
        
        navigationController?.pushViewController(editTaskVC, animated: true)
    }
    
    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCell.EditingStyle,
                            forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            let task = getTask(at: indexPath)
            deleteTask(task, at: indexPath)
        }
    }
}

// MARK: - UISearchResultsUpdating
extension TasksViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text ?? "")
    }
}

// MARK: - TaskViewControllerDelegate
extension TasksViewController: TaskViewControllerDelegate {
    func reloadData() {
        fetchData()
        tableView.reloadData()
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
        
        setupSearchController()
    }
    
    func setupNavigationBar() {
        title = "Tasks"
        
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.backgroundColor = .appGreen
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        navigationController?.navigationBar.tintColor = .white
        
        navigationItem.rightBarButtonItem = addBarButtonItem
    }
    
    func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Tasks"
        navigationItem.searchController = searchController
        definesPresentationContext = true
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
    
    func filterContentForSearchText(_ searchText: String) {
        filteredTasks = tasks.filter { (task: Task) -> Bool in
            return task.title?.lowercased().contains(searchText.lowercased()) ?? false
        }
        
        tableView.reloadData()
    }
    
    func getTask(at indexPath: IndexPath) -> Task {
        isFiltering ? filteredTasks[indexPath.row] : tasks[indexPath.row]
    }
    
    func deleteTask(_ task: Task, at indexPath: IndexPath) {
        if isFiltering {
            filteredTasks = removeTask(task, from: filteredTasks)
            tasks = removeTask(task, from: tasks)
        } else {
            tasks = removeTask(task, from: tasks)
            filteredTasks = removeTask(task, from: filteredTasks)
        }
        
        tableView.deleteRows(at: [indexPath], with: .automatic)
        storageManager.delete(task)
    }
    
    func removeTask(_ task: Task, from list: [Task]) -> [Task] {
        var newList = list
        if let index = newList.firstIndex(of: task) {
            newList.remove(at: index)
        }
        return newList
    }
}
