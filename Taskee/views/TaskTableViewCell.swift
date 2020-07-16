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
    
    
    
    var tapCallback: (() -> Void)?
    
    
    @IBAction func buttonTapped(_ sender: Any) {
        tapCallback?()
    }
    
    @IBOutlet weak var taskTitleLabel: UILabel!
    @IBOutlet weak var statusButton: UIButton!
    @IBOutlet weak var taskDueDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
