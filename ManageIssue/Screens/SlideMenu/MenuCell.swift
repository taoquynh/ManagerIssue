//
//  MenuCell.swift
//  ManageIssue
//
//  Created by Taof on 10/15/19.
//  Copyright © 2019 Taof. All rights reserved.
//

import UIKit
import Stevia

class MenuCell: UITableViewCell {
    
    let photoIcon: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        
        return label
    }()
    
    func setupLayout(){
        self.sv(photoIcon, titleLabel)
        self.layout(
            |-16-photoIcon.width(24).height(24)-16-titleLabel-8-|
        )
        
        photoIcon.centerVertically()
        titleLabel.centerVertically()
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
