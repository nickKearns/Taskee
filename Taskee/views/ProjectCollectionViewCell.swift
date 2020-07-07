//
//  ProjectCollectionViewCell.swift
//  Taskee
//
//  Created by Nicholas Kearns on 7/6/20.
//  Copyright © 2020 Nicholas Kearns. All rights reserved.
//

import UIKit
import MaterialComponents
class ProjectCollectionViewCell: MDCCollectionViewCell {
    
    static let identifier: String =  "ProjectCollectionViewCell"

    @IBOutlet weak var projectTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setupCell(title: String) {
        projectTitleLabel.text = title
    }

}
