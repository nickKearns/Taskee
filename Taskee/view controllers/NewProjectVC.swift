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
    
    


    let saveButton: MDCButton = {
        let b = MDCButton()
        b.setTitle("Save", for: .normal)
        b.translatesAutoresizingMaskIntoConstraints = false
        
        return b
    }()
    
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
    
    
    
    
    
}

extension NewProjectVC: UITextFieldDelegate {
    
    
    
    
}


