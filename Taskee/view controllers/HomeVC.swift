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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        store.saveContext()
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
        return 30
    }
    
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProjectCollectionViewCell.identifier, for: indexPath) as! ProjectCollectionViewCell
        
        cell.setupCell(title: "testing label")
        
        
        return cell
    }
    
    
    
    
}


extension HomeVC: UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width * 0.90, height: view.frame.height * 0.15)
    }
    
    
}


