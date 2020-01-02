//
//  HeaderView.swift
//  ManageIssue
//
//  Created by Taof on 10/15/19.
//  Copyright © 2019 Taof. All rights reserved.
//

import UIKit
import Stevia

class HeaderView: UIView {
    
    let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.groupTableViewBackground
        return view
    }()
    
    let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "earth")
        imageView.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Hàn Mặc Tử"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    let phoneLabel: UILabel = {
        let label = UILabel()
        label.text = "0968326697"
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    
    let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        return view
    }()
    
    let rightView: UIView = {
        let view = UIView()
        return view
    }()
    
    func setupLayout(){
        self.sv(
            contentView.sv(
                photoImageView,
                rightView.sv(nameLabel, phoneLabel)
            ),
            lineView)
        
        self.layout(
            0,
            |-0-contentView-0-| ~ self.frame.height - 2,
            |-0-lineView.height(2)-0-|
        )
        
        contentView.layout(
            |-16-photoImageView.width(90).height(90)-16-rightView-0-|
        )
        
        photoImageView.centerVertically()
        
        photoImageView.layer.cornerRadius = 45
        photoImageView.layer.masksToBounds = true
        
        rightView.layout(
            5,
            |-0-nameLabel-0-|,
            8,
            |-0-phoneLabel-0-|
        )
        
        nameLabel.centerVertically(-16)
        phoneLabel.centerVertically(16)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        print("init")
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
