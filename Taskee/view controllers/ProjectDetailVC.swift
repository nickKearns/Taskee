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



class ProjectDetailVC: UIViewController, NSFetchedResultsControllerDelegate {
    
    
    var store: TaskeeStore!
    var currentProject: Project!
    var tasks: [Task] = []
    
    //MARK: THE ELEMENTS OF THE VIEW
    var tasksTableView: UITableView = {
        let t = UITableView()
        t.translatesAutoresizingMaskIntoConstraints = false
        t.rowHeight = 100
        
        return t
    }()
    
    
    let bottomAppBar: MDCBottomAppBarView = {
        let bottomAppBar = MDCBottomAppBarView()
        bottomAppBar.translatesAutoresizingMaskIntoConstraints = false
        bottomAppBar.floatingButton.setTitle("Add Task", for: .normal)
        bottomAppBar.floatingButton.titleLabel?.adjustsFontSizeToFitWidth = true
        bottomAppBar.barTintColor = .systemGray3
        bottomAppBar.floatingButton.backgroundColor = .systemGray3

        return bottomAppBar
    }()
    
    
    lazy var fetchedResultsController: NSFetchedResultsController<Task> = {
        
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        let projectPredicate = NSPredicate(format: "project.title = %@", self.currentProject.title!)
        fetchRequest.predicate = projectPredicate
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "dueDate", ascending: false)]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                  managedObjectContext: store.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()
    
    
   
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.title = currentProject.title
        setupBottomAppBar()
        setupTaskTableView()

        getTasks()
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteButtonTapped))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        getTasks()
    }
    
    
    
    func getTasks() {
        do {
            try fetchedResultsController.performFetch()
        } catch let nserror as NSError {
            print(nserror)
        }
    }
    
    //MARK: SETTING UP THE TABLE VIEW CELLS
    func configureCell(cell: UITableViewCell, for indexPath: IndexPath) {
        
    
        guard let cell = cell as? TaskTableViewCell else {
            return
        }
        
        let currentTask = fetchedResultsController.object(at: indexPath)
        
        cell.taskTitleLabel.text = currentTask.title
    
    
    }
    
    
    //MARK: SETTING UP VIEWS
    
    func setupTaskTableView() {
        self.view.addSubview(tasksTableView)
        tasksTableView.delegate = self
        tasksTableView.dataSource = self
        
        tasksTableView.register(UINib(nibName: "TaskTableViewCell", bundle: .main), forCellReuseIdentifier: TaskTableViewCell.identifier)
        
        NSLayoutConstraint.activate([
            
            tasksTableView.topAnchor.constraint(equalToSystemSpacingBelow: self.view.safeAreaLayoutGuide.topAnchor, multiplier: 0),
            tasksTableView.bottomAnchor.constraint(equalTo: bottomAppBar.topAnchor),
            tasksTableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            tasksTableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
            
        ])
        
    }
    
    
    
    
    func setupBottomAppBar() {
        self.view.addSubview(bottomAppBar)
        
        NSLayoutConstraint.activate([
            bottomAppBar.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            bottomAppBar.widthAnchor.constraint(equalTo: self.view.widthAnchor),
            bottomAppBar.heightAnchor.constraint(equalToConstant: 80)
        ])
        
        bottomAppBar.floatingButton.addTarget(self, action: #selector(addTaskButtonTapped), for: .touchUpInside)
    }
    
    
    //MARK: THE TARGET FUNCTIONS FOR BUTTONS
    
    @objc
    func addTaskButtonTapped() {
        let newTaskVC = NewTaskVC()
        newTaskVC.store = self.store
        newTaskVC.project = currentProject
        navigationController?.pushViewController(newTaskVC, animated: true)
        
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
    
    
    
}


//MARK: TABLE VIEW FUNCTIONS

extension ProjectDetailVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.fetchedObjects!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TaskTableViewCell.identifier)
        configureCell(cell: cell!, for: indexPath)
        
        return cell!
    }
    
    
    
    
    
    
    
    
}
