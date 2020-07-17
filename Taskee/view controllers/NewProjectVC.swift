//
//  NewProjectVC.swift
//  Taskee
//
//  Created by Nicholas Kearns on 7/8/20.
//  Copyright © 2020 Nicholas Kearns. All rights reserved.
//

import UIKit
import MaterialComponents



class NewProjectVC: UIViewController, UICollectionViewDataSource {
    
    var store: TaskeeStore?
    
    let bottomAppBar = MDCBottomAppBarView()

    let colorPickCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout.init())
    
    var pickedColor = UIColor.white
    
    let colorsArray = [UIColor.green, UIColor.blue, UIColor.brown, UIColor.red, UIColor.yellow, UIColor.cyan]

    let titleTextField: MDCTextField = {
        let t = MDCTextField()
        t.translatesAutoresizingMaskIntoConstraints = false
        t.placeholder = "Enter Project Title"
        t.returnKeyType = .done
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
        self.title = "New Project"
        setupTextField()
        setupBottomAppBar()
        setupCollectionView()
    }
    
    func setupCollectionView() {
        colorPickCollectionView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(colorPickCollectionView)
        colorPickCollectionView.backgroundColor = .white
        colorPickCollectionView.delegate = self
        colorPickCollectionView.dataSource = self
        colorPickCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        NSLayoutConstraint.activate([
            colorPickCollectionView.topAnchor.constraint(equalTo: titleTextField.bottomAnchor),
            colorPickCollectionView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.75),
            colorPickCollectionView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            colorPickCollectionView.bottomAnchor.constraint(equalTo: bottomAppBar.topAnchor, constant: 10)
        ])
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    
    func setupBottomAppBar() {
        bottomAppBar.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(bottomAppBar)
        
        NSLayoutConstraint.activate([
            bottomAppBar.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            bottomAppBar.widthAnchor.constraint(equalTo: self.view.widthAnchor),
            bottomAppBar.heightAnchor.constraint(equalToConstant: 80)
        ])
        
        bottomAppBar.floatingButton.setTitle("Save", for: .normal)
        bottomAppBar.floatingButton.backgroundColor = .systemTeal
        bottomAppBar.barTintColor = .systemTeal
        
        bottomAppBar.floatingButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        
    }
    
    
    
    @objc
    func saveButtonTapped() {
        let newProject = Project(context: (store?.persistentContainer.viewContext)!)
        newProject.title = titleTextField.text
        newProject.color = pickedColor
        store?.saveContext()
        navigationController?.popViewController(animated: true)
        
        
        
    
    }
    
    
    
    
    
}


extension NewProjectVC: UICollectionViewDelegate {
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        colorsArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.backgroundColor = colorsArray[indexPath.row]
        cell.layer.cornerRadius = cell.frame.size.width/2
        cell.clipsToBounds = true
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.pickedColor = colorsArray[indexPath.row]
        
        
    }
    
    
}


extension NewProjectVC: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 60  , height: 60)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return  UIEdgeInsets(top: 20 , left: 20  ,  bottom: 20, right: 20)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20.0
    }
}

extension NewProjectVC: UITextFieldDelegate {
    
    
    
    
}


