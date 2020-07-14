//
//  NewProjectVC.swift
//  Taskee
//
//  Created by Nicholas Kearns on 7/8/20.
//  Copyright © 2020 Nicholas Kearns. All rights reserved.
//

import UIKit
import MaterialComponents



class NewProjectVC: UIViewController {
    
    var store: TaskeeStore?
    
    let bottomAppBar = MDCBottomAppBarView()



    let titleTextField: MDCTextField = {
        let t = MDCTextField()
        t.translatesAutoresizingMaskIntoConstraints = false
        t.placeholder = "Enter Project Title"
        return t
    }()
    
    
    let titleTextFieldController: MDCTextInputControllerOutlined
    
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        //TODO: Setup text field controllers
        titleTextFieldController = MDCTextInputControllerOutlined(textInput: titleTextField)
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.view.backgroundColor = .white
        setupTextField()
        setupBottomAppBar()
        


    }
    
    
    
    func setupTextField() {
        self.view.addSubview(titleTextField)
        titleTextField.delegate = self
        
        NSLayoutConstraint.activate([
            titleTextField.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.75),
            titleTextField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            titleTextField.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -175)
            
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
    
    
    
    @objc
    func saveButtonTapped() {
        let newProject = Project(context: (store?.persistentContainer.viewContext)!)
        newProject.title = titleTextField.text
        store?.saveContext()
        navigationController?.popViewController(animated: true)
        
        
        
    
    }
    
    
    
    
    
}

extension NewProjectVC: UITextFieldDelegate {
    
    
    
    
}


