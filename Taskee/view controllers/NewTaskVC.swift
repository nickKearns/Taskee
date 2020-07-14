//
//  NewTaskVC.swift
//  Taskee
//
//  Created by Nicholas Kearns on 7/13/20.
//  Copyright © 2020 Nicholas Kearns. All rights reserved.
//

import UIKit
import MaterialComponents


class NewTaskVC: UIViewController {
    
    var store: TaskeeStore!
    var project: Project!
    
    let bottomAppBar = MDCBottomAppBarView()

    
    let taskTitleTextField: MDCTextField = {
        let tf = MDCTextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "Enter Title"
        
        return tf
    }()
    
    
    let datePicker: UIDatePicker = {
        let d = UIDatePicker()
        d.datePickerMode = .date
        
        
        return d
    }()
    
    let dateTextField: MDCTextField = {
        let tf = MDCTextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "Enter Due Date"
        
        return tf
    }()
    
    
    
    let taskTitleTextFieldController: MDCTextInputControllerOutlined
    
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        //TODO: Setup text field controllers
        taskTitleTextFieldController = MDCTextInputControllerOutlined(textInput: taskTitleTextField)
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupTextFields()
        setupDatePicker()
        setupBottomAppBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    func setupTextFields() {
        
        self.view.addSubview(taskTitleTextField)
        
        NSLayoutConstraint.activate([
            taskTitleTextField.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 50),
            taskTitleTextField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            taskTitleTextField.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.50)
        ])
        
        self.view.addSubview(dateTextField)
        dateTextField.inputView = datePicker
        
        NSLayoutConstraint.activate([
            dateTextField.topAnchor.constraint(equalTo: taskTitleTextField.bottomAnchor, constant: 50),
            dateTextField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            dateTextField.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.50)
        
        ])
        
        
        
    }
    
    func setupBottomAppBar() {
        bottomAppBar.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(bottomAppBar)
        
        NSLayoutConstraint.activate([
            bottomAppBar.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            bottomAppBar.widthAnchor.constraint(equalTo: self.view.widthAnchor),
            bottomAppBar.heightAnchor.constraint(equalToConstant: 80)
        ])
        
        bottomAppBar.floatingButton.setTitle("Save", for: .normal)
        bottomAppBar.floatingButton.backgroundColor = .systemGray3
        bottomAppBar.barTintColor = .systemGray3

        
        bottomAppBar.floatingButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        
    }
    
    
    //snippets of code from https://stackoverflow.com/questions/27050988/uidatepicker-with-done-button
    
    func setupDatePicker() {
        
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
        toolBar.setItems([doneButton], animated: false)
        toolBar.sizeToFit()
        dateTextField.inputAccessoryView = toolBar
        
        
        
    }
    
    @objc
    func saveButtonTapped() {
        let newTask = Task(context: store.managedContext)
        newTask.title = taskTitleTextField.text
        newTask.dueDate = datePicker.date
        newTask.status = false
        newTask.project = project
        store?.saveContext()
        navigationController?.popViewController(animated: true)
    }
    


    @objc
    func doneButtonTapped() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "mm-dd-yyyy"
        let strDate = dateFormatter.string(from: datePicker.date)
        dateTextField.text = strDate
        dateTextField.resignFirstResponder()
    }
    
    
    
    
    
}
