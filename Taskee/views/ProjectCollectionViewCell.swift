//
//  ProjectCollectionViewCell.swift
//  Taskee
//
//  Created by Nicholas Kearns on 7/6/20.
//  Copyright © 2020 Nicholas Kearns. All rights reserved.
//

import UIKit
import MaterialComponents
class ProjectCollectionViewCell: MDCCardCollectionCell {
    
    static let identifier: String =  "ProjectCollectionViewCell"

    @IBOutlet weak var projectTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = .white

        //TODO: Configure the MDCCardCollectionCell specific properties
        self.cornerRadius = 4.0;
        self.setBorderWidth(1.0, for:.normal)
        self.setBorderColor(.lightGray, for: .normal)
    }
    
    func setupCell(title: String) {
        projectTitleLabel.text = title
    }

}
