//
//  TasksViewController.swift
//  TaskPlanner
//
//  Created by Matvei Khlestov on 01.07.2024.
//

import UIKit

final class TasksViewController: UITableViewController {
    
    // MARK: - Private Properties
    private let reuseIdentifier = "CellId"
    
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
        
        navigationController?.pushViewController(addTaskVC, animated: true)
    }
    
    // MARK: - Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        
        return cell
    }
}

// MARK: - Private methods
private extension TasksViewController {
    func setupTableView() {
        tableView.register(
            UITableViewCell.self,
            forCellReuseIdentifier: reuseIdentifier
        )
        
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
}
