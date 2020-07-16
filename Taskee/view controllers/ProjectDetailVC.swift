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
        bottomAppBar.barTintColor = .systemTeal
        bottomAppBar.floatingButton.backgroundColor = .systemTeal

        return bottomAppBar
    }()
    
    
    lazy var fetchedResultsController: NSFetchedResultsController<Task> = {
        
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        let projectPredicate = NSPredicate(format: "project.title = %@", self.currentProject.title!)
        fetchRequest.predicate = projectPredicate
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "status", ascending: true), NSSortDescriptor(key: "dueDate", ascending: false)]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                  managedObjectContext: store.persistentContainer.viewContext, sectionNameKeyPath: #keyPath(Task.status), cacheName: nil)
        
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()
    
    
   
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.title = currentProject.title
//        navigationController!.navigationBar.prefersLargeTitles = true
        setupBottomAppBar()
        setupTaskTableView()

        getTasks()
        
        
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        store.saveContext()
        
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
        
        
        if currentTask.status == false {
            cell.statusButton.setImage(UIImage(named: "unmarked"), for: .normal)
        } else {
            cell.statusButton.setImage(UIImage(named: "marked"), for: .normal)
        }
        
        cell.taskTitleLabel.text = currentTask.title
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        let dateAsString = dateFormatter.string(from: currentTask.dueDate!)
        cell.taskDueDateLabel.text = "Due Date " + dateAsString
        
        cell.tapCallback = {
            if currentTask.status {
                currentTask.status = false
                cell.statusButton.setImage(UIImage(named: "unmarked"), for: .normal)
            } else {
                currentTask.status = true
                cell.statusButton.setImage(UIImage(named: "marked"), for: .normal)
            }
        }
    
    
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
}


//MARK: TABLE VIEW FUNCTIONS

extension ProjectDetailVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections!.count
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionInfo =
          fetchedResultsController.sections?[section] else {
          return 0
        }
        return sectionInfo.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TaskTableViewCell.identifier)
        configureCell(cell: cell!, for: indexPath)
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
}



extension ProjectDetailVC: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tasksTableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            tasksTableView.insertRows(at: [newIndexPath!], with: .automatic)
        case .delete:
            tasksTableView.deleteRows(at: [indexPath!], with: .automatic)
        case .update:
            let cell = tasksTableView.cellForRow(at: indexPath!) as! TaskTableViewCell
            configureCell(cell: cell, for: indexPath!)
        case .move:
            tasksTableView.deleteRows(at: [indexPath!], with: .automatic)
            tasksTableView.insertRows(at: [newIndexPath!], with: .automatic)
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tasksTableView.endUpdates()
    }
}
