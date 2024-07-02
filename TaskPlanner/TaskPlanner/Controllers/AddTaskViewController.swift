//
//  AddTaskViewController.swift
//  TaskPlanner
//
//  Created by Matvei Khlestov on 02.07.2024.
//

import UIKit

final class AddTaskViewController: UIViewController {
    
    // MARK: - UI Elements
    private lazy var backBarButtonItem: UIBarButtonItem = {
        let button = UIBarButtonItem(
            image: UIImage(systemName: "arrow.backward"),
            primaryAction: backBarButtonItemTapped
        )
        return button
    }()
    
    private lazy var taskTextView: UITextView = {
        let textView = UITextView()
        textView.contentInset = UIEdgeInsets(
            top: 0,
            left: 15,
            bottom: 0,
            right: 15
        )
        textView.font = .systemFont(ofSize: 16, weight: .regular)
        textView.layer.cornerRadius = 10
        textView.layer.borderColor = UIColor.black.cgColor
        textView.layer.borderWidth = 0.8
        return textView
    }()
    
    private lazy var saveButton: UIButton = {
        createButton(
            withTitle: "Save Task",
            andColor: .systemBlue,
            action: taskButtonTapped,
            tag: 0
        )
    }()
    
    private lazy var cancelButton: UIButton = {
        createButton(
            withTitle: "Cancel",
            andColor: .systemRed,
            action: taskButtonTapped,
            tag: 1
        )
    }()
    
    private lazy var addTaskStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [taskTextView, saveButton, cancelButton])
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // MARK: -  Action
    private lazy var backBarButtonItemTapped = UIAction { [unowned self] _ in
        let tasksVC = TasksViewController()
        
        navigationController?.popToRootViewController(animated: true)
    }
    
    private lazy var taskButtonTapped = UIAction { [unowned self] action in
        guard let sender = action.sender as? UIButton else { return }
        
        switch sender.tag {
        case 0:
            navigationController?.popToRootViewController(animated: true)
        default:
            navigationController?.popToRootViewController(animated: true)
        }
    }
    
    // MARK: - Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        taskTextView.becomeFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
}

// MARK: - Private methods
private extension AddTaskViewController {
    func setupView() {
        view.backgroundColor = .white
        
        addSubviews()
        
        setupNavigationBar()
        
        setConstraints()
    }
    
    func addSubviews() {
        setupSubviews(addTaskStackView)
    }
    
    func setupSubviews(_ subviews: UIView... ) {
        for subview in subviews {
            view.addSubview(subview)
        }
    }
    
    func setupNavigationBar() {
        title = "Adding new task"
        
        navigationItem.leftBarButtonItem = backBarButtonItem
    }
    
    func createButton(withTitle title: String,
                      andColor color: UIColor,
                      action: UIAction,
                      tag: Int) -> UIButton {
        
        var attributes = AttributeContainer()
        attributes.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        
        var buttonConfiguration = UIButton.Configuration.filled()
        buttonConfiguration.baseBackgroundColor = color
        buttonConfiguration.buttonSize = .large
        buttonConfiguration.attributedTitle = AttributedString(title, attributes: attributes)
        let button = UIButton(configuration: buttonConfiguration, primaryAction: action)
        button.tag = tag
        return button
    }
}

// MARK: - Constraints
private extension AddTaskViewController {
    func setConstraints() {
        setConstraintsForAddStackView()
        setConstraintsForTaskTextView()
    }
    
    func setConstraintsForAddStackView() {
        NSLayoutConstraint.activate([
            addTaskStackView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: 30
            ),
            addTaskStackView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: 30
            ),
            addTaskStackView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -30
            )
        ])
    }
    
    func setConstraintsForTaskTextView() {
        NSLayoutConstraint.activate([
            taskTextView.widthAnchor.constraint(
                equalTo: addTaskStackView.widthAnchor
            ),
            taskTextView.heightAnchor.constraint(
                equalTo: view.heightAnchor,
                multiplier: 0.2
            )
        ])
    }
}
