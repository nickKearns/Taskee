//
//  ProjectDetailVC.swift
//  Taskee
//
//  Created by Nicholas Kearns on 7/10/20.
//  Copyright © 2020 Nicholas Kearns. All rights reserved.
//

import UIKit
import CoreData
import MaterialComponents



class ProjectDetailVC: UIViewController {
    
    
    var store: TaskeeStore?
    var currentProject: Project!
    
    
    var titleLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.numberOfLines = 0
        l.font = l.font.withSize(40)
        l.textAlignment = .center
        return l
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupLabels()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteButtonTapped))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    
    
    @objc
    func deleteButtonTapped() {
        let alertTrash = UIAlertController(
            title: nil,
            message: "Are you sure you want to delete this project?",
            preferredStyle: .actionSheet
        )
        
        guard let currentTitle = currentProject.title else {
            return
        }
        
        let actionDelete = UIAlertAction(title: "Delete \(currentTitle)", style: .destructive) { (_) in
            self.store?.persistentContainer.viewContext.delete(self.currentProject)
            self.navigationController?.popViewController(animated: true)
        }
        alertTrash.addAction(actionDelete)
        
        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel)
        alertTrash.addAction(actionCancel)
        
        present(alertTrash, animated: true)
    }
    
    
    func setupLabels() {
        self.view.addSubview(titleLabel)
        titleLabel.text = currentProject.title
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 150),
            titleLabel.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.75),
            titleLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        
        
        
        ])
        
    }
    
    
}
