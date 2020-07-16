//
//  ProjectTableViewCell.swift
//  Taskee
//
//  Created by Nicholas Kearns on 7/13/20.
//  Copyright © 2020 Nicholas Kearns. All rights reserved.
//

import UIKit

class ProjectTableViewCell: UITableViewCell {

    static let identifier: String = "ProjectTableViewCell"
    
    @IBOutlet weak var projectTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 4
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
