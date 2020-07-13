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


class HomeVC: UICollectionViewController {
    
    var store = TaskeeStore()
    
    var projects: [Project] = []
    
    let bottomAppBar = MDCBottomAppBarView()
    
    
    lazy var fetchedResultsController: NSFetchedResultsController<Project> = {
        let fetchRequest: NSFetchRequest<Project> = Project.fetchRequest()
//      fetchRequest.sortDescriptors = [NSSortDescriptor(key: "qualifyingZone", ascending: true), NSSortDescriptor(key: "wins", ascending: false), NSSortDescriptor(key: "teamName", ascending: true)]

      let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                managedObjectContext: store.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
      return fetchedResultsController
    }()

    
    
    
    init() {
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.collectionView.backgroundColor = .white
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(UINib(nibName: "ProjectCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: ProjectCollectionViewCell.identifier)
        setupBottomAppBar()
        self.title = "Projects"
        self.collectionView.reloadData()
        updateDataSource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        store.saveContext()
        updateDataSource()
    }
    
    private func updateDataSource() {
        self.store.fetchPersistedData {
            (fetchItemsResult) in
            
            switch fetchItemsResult {
            case let .success(projects):
                self.projects = projects
            case .failure(_):
                self.projects.removeAll()
                
            }
            self.collectionView.reloadSections(IndexSet(integer: 0))
        }
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
        bottomAppBar.floatingButton.backgroundColor = .systemTeal
        bottomAppBar.barTintColor = .systemTeal
        
        bottomAppBar.floatingButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        
    }
    
    
    
    
    
    
    @objc func addButtonTapped() {
        let newProjectVC = NewProjectVC()
        newProjectVC.store = store
        navigationController?.pushViewController(newProjectVC, animated: true)
    }
    

    func createNewItem() -> Project {
        let newItem = NSEntityDescription.insertNewObject(forEntityName: "Project", into: store.persistentContainer.viewContext) as! Project
        return newItem
    }
    
    
     func deleteItem(at index: Int) {
            let viewContext = store.persistentContainer.viewContext
            viewContext.delete(projects[index])
            
            projects.remove(at: index)
            collectionView.deleteItems(at: [IndexPath(row: index, section: 0)])
            
            store.saveContext()
        }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return projects.count
    }
    
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProjectCollectionViewCell.identifier, for: indexPath) as! ProjectCollectionViewCell
        let currentProject = projects[indexPath.row]
        cell.setupCell(title: currentProject.title!)
        
        
        return cell
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let currentProject = projects[indexPath.row]
        let projectDetailVC = ProjectDetailVC()
        projectDetailVC.store = store
        projectDetailVC.currentProject = currentProject
        navigationController?.pushViewController(projectDetailVC, animated: true)
    }
    
    
    
}


extension HomeVC: UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width * 0.90, height: view.frame.height * 0.15)
    }
    
    
}


