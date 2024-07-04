//
//  BaseViewController.swift
//  TaskPlanner
//
//  Created by Matvei Khlestov on 04.07.2024.
//

import UIKit

class BaseViewController: UIViewController {
    
    weak var delegate: TaskViewControllerDelegate?
    
    let storageManager = StorageManager.shared
    
    // MARK: - UI Elements
    private lazy var backBarButtonItem: UIBarButtonItem = {
        let button = UIBarButtonItem(
            image: UIImage(systemName: "arrow.backward"),
            primaryAction: backBarButtonItemTapped
        )
        return button
    }()
    
    lazy var taskTextView: UITextView = {
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
    
    lazy var saveButton: UIButton = {
        createButton(
            withTitle: "Save Task",
            andColor: .systemBlue,
            action: taskButtonTapped,
            tag: 0
        )
    }()
    
    lazy var cancelButton: UIButton = {
        createButton(
            withTitle: "Cancel",
            andColor: .systemRed,
            action: taskButtonTapped,
            tag: 1
        )
    }()
    
    lazy var addTaskStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            taskTextView, saveButton, cancelButton
        ])
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 25
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // MARK: -  Action
    private lazy var backBarButtonItemTapped = UIAction { [unowned self] _ in
        navigationController?.popToRootViewController(animated: true)
    }
    
    lazy var taskButtonTapped = UIAction { [unowned self] action in
        guard let sender = action.sender as? UIButton else { return }
        
        switch sender.tag {
        case 0:
            save()
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
    
    // MARK: - Private methods
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
        title = "Task"
        
        navigationItem.leftBarButtonItem = backBarButtonItem
    }
    
    func save() {}
    
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

// MARK: - Alert Controller
extension BaseViewController {
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) { [unowned self] _ in
            self.taskTextView.becomeFirstResponder()
        }
        alert.addAction(okAction)
        present(alert, animated: true)
    }
}

// MARK: - Constraints
extension BaseViewController {
    func setConstraints() {
        setConstraintsForAddStackView()
        setConstraintsForTaskTextView()
    }
    
    func setConstraintsForAddStackView() {
        NSLayoutConstraint.activate([
            addTaskStackView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: 50
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
