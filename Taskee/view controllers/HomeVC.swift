//
//  HomeVC.swift
//  Taskee
//
//  Created by Nicholas Kearns on 7/6/20.
//  Copyright © 2020 Nicholas Kearns. All rights reserved.
//

import UIKit
import MaterialComponents
import CoreData


class HomeVC: UIViewController {
    
    var store = TaskeeStore()
    
    var projects: [Project] = []
    
    let bottomAppBar = MDCBottomAppBarView()
    
    
    lazy var fetchedResultsController: NSFetchedResultsController<Project> = {
        let fetchRequest: NSFetchRequest<Project> = Project.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                  managedObjectContext: store.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()
    
    
    
    
    let projectTableView: UITableView = {
        let t = UITableView()
        t.translatesAutoresizingMaskIntoConstraints = false
        t.rowHeight = 100
        return t
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        setupBottomAppBar()
        setupTableView()
        
        self.title = "Projects"
        getProjects()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        store.saveContext()
        getProjects()
    }
    
    
    func getProjects() {
        do {
            try fetchedResultsController.performFetch()
        } catch let nserror as NSError {
            print(nserror)
        }
        
    }
    
    
    
    
    
    func configure(cell: UITableViewCell, for indexPath: IndexPath) {
        
        
        
        guard let cell = cell as? ProjectTableViewCell else {
            return
        }
        
        
        
        let project = fetchedResultsController.object(at: indexPath)
        
        cell.projectTitleLabel.text = project.title
        
        
    }
    
    
    func setupTableView() {
        self.view.addSubview(projectTableView)
        projectTableView.register(UINib(nibName: "ProjectTableViewCell", bundle: .main), forCellReuseIdentifier: ProjectTableViewCell.identifier)
        
        
        projectTableView.delegate = self
        projectTableView.dataSource = self
        
        
        NSLayoutConstraint.activate([
            
            projectTableView.topAnchor.constraint(equalToSystemSpacingBelow: self.view.safeAreaLayoutGuide.topAnchor, multiplier: 0),
            projectTableView.bottomAnchor.constraint(equalTo: bottomAppBar.topAnchor),
            projectTableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            projectTableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
            
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
        
        bottomAppBar.floatingButton.setTitle("Add", for: .normal)
        bottomAppBar.floatingButton.backgroundColor = .systemGray3
        bottomAppBar.barTintColor = .systemGray3
        
        bottomAppBar.floatingButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        
    }
    
    
    
    
    
    
    @objc func addButtonTapped() {
        let newProjectVC = NewProjectVC()
        newProjectVC.store = store
        navigationController?.pushViewController(newProjectVC, animated: true)
    }
    
    
    
    
    
    
}


extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.fetchedObjects!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProjectTableViewCell.identifier) as! ProjectTableViewCell
        configure(cell: cell, for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let projectDetailVC = ProjectDetailVC()
        projectDetailVC.store = self.store
        let currentProject = fetchedResultsController.fetchedObjects![indexPath.row]
        projectDetailVC.currentProject = currentProject
        navigationController?.pushViewController(projectDetailVC, animated: true)
    }
    
    
    
    
    
    
    
}


extension HomeVC: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        projectTableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            projectTableView.insertRows(at: [newIndexPath!], with: .automatic)
        case .delete:
            projectTableView.deleteRows(at: [indexPath!], with: .automatic)
        case .update:
            let cell = projectTableView.cellForRow(at: indexPath!) as! ProjectTableViewCell
            configure(cell: cell, for: indexPath!)
        case .move:
            projectTableView.deleteRows(at: [indexPath!], with: .automatic)
            projectTableView.insertRows(at: [newIndexPath!], with: .automatic)
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        projectTableView.endUpdates()
    }
}


