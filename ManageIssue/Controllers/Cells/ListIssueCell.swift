//
//  ListIssueCell.swift
//  ManageIssue
//
//  Created by Taof on 10/21/19.
//  Copyright © 2019 Taof. All rights reserved.
//

import UIKit
import Stevia

class ListIssueCell: UITableViewCell {

    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Vỡ ống nước"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    let addressLabel: UILabel = {
        let label = UILabel()
        
        label.text = "CT07 - Hoa phượng 6 chung cư Bắc Hà"
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        
        label.text = "08:52"
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        
        label.text = "20/10/2019"
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    var issue: Issue? {
        didSet {
            if let issue = issue {
                titleLabel.text = issue.title
                addressLabel.text = issue.address
                dateLabel.text = issue.date
                timeLabel.text = issue.time
            }
        }
    }
    func setupLayout(){
        self.sv(
            titleLabel, addressLabel, timeLabel, dateLabel
        )
        
        self.layout(
            16,
            |-16-titleLabel-(>=5)-timeLabel-16-|,
            16,
            |-16-addressLabel.width(self.frame.size.width/2)-(>=5)-dateLabel-16-|,
            16
        )
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        setupLayout()
    }

}
