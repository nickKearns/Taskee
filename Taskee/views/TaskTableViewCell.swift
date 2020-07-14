//
//  TaskTableViewCell.swift
//  Taskee
//
//  Created by Nicholas Kearns on 7/13/20.
//  Copyright © 2020 Nicholas Kearns. All rights reserved.
//

import UIKit

class TaskTableViewCell: UITableViewCell {
    
    static let identifier: String = "TaskTableViewCell"

    @IBOutlet weak var taskTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
