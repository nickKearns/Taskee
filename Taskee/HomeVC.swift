//
//  HomeVC.swift
//  Taskee
//
//  Created by Nicholas Kearns on 7/6/20.
//  Copyright © 2020 Nicholas Kearns. All rights reserved.
//

import UIKit
import MaterialComponents


class HomeVC: UICollectionViewController {
    
    
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
    
    
    
    
    
    func setupBottomAppBar() {
        bottomAppBar.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(bottomAppBar)
        bottomAppBar.tintColor = .systemGray2
        
        NSLayoutConstraint.activate([
            bottomAppBar.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            bottomAppBar.widthAnchor.constraint(equalTo: self.view.widthAnchor),
            bottomAppBar.heightAnchor.constraint(equalToConstant: 80)
        ])
        
        bottomAppBar.floatingButton.setTitle("Add", for: .normal)
        bottomAppBar.floatingButton.backgroundColor = .systemGray2
        bottomAppBar.barTintColor = .systemGray2
        
        bottomAppBar.floatingButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        
    }
    
    
    @objc func addButtonTapped() {
        
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
        return CGSize(width: view.frame.width * 0.90, height: view.frame.height * 0.50)
    }
    
    
}


