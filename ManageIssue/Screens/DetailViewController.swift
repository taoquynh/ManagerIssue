//
//  DetailViewController.swift
//  ManageIssue
//
//  Created by Taof on 10/14/19.
//  Copyright © 2019 Taof. All rights reserved.
//

import UIKit
import GrowingTextView
import Stevia

class DetailViewController: UIViewController {
    
    let scrollView = TPKeyboardAvoidingScrollView()
    
    let contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    let stateLabel: UILabel = {
        let label = UILabel()
        label.text = "Trạng thái: "
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    let addressLabel: UILabel = {
        let label = UILabel()
        label.text = "Địa chỉ xảy ra vấn đề"
        return label
    }()
    
    let addressTextField: UITextField = {
        let textField = UITextField()
        return textField
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Tiêu đề"
        return label
    }()
    
    let titleTextField: UITextField = {
        let textField = UITextField()
        return textField
    }()
    
    let contentLabel: UILabel = {
        let label = UILabel()
        label.text = "Nội dung"
        return label
    }()
    
    let contentTextView: GrowingTextView = {
        let textView = GrowingTextView()
        textView.trimWhiteSpaceWhenEndEditing = false
        textView.maxLength = 200
        textView.maxHeight = 100
        textView.minHeight = 40
        textView.font = UIFont.systemFont(ofSize: 16)
        return textView
    }()
    
    let bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.mainBrown()
        return view
    }()
    
   
    var id: String = ""
    var issue = Issue()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupLayout()
        
        addressTextField.text = issue.address
        titleTextField.text = issue.title
        contentTextView.text = issue.content
        stateLabel.text = issue.status
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        titleTextField.underView()
        addressTextField.underView()
    }
    
    func setupNavigationBar(){
        
        navigationItem.title = "Chi tiết sự cố"
        addressTextField.isEnabled = false
        titleTextField.isEnabled = false
        contentTextView.isUserInteractionEnabled = false
        navigationController?.navigationBar.barTintColor = UIColor.main2Brown()
        self.view.backgroundColor = UIColor.white
    }
    
    func setupLayout(){
        view.sv(scrollView)
        view.layout(
            0,
            |-0-scrollView-0-|,
            0
        )
        
        scrollView.sv(contentView)
        
        scrollView.layout(
            0,
            |-0-contentView.width(self.view.frame.size.width)-0-|,
            0
        )
        
        contentView.sv(
            stateLabel,
            addressLabel,
            addressTextField,
            titleLabel,
            titleTextField,
            contentLabel,
            contentTextView,
            bottomView
        )
        
        contentView.layout(
            16,
            |-32-stateLabel-32-|,
            32,
            |-32-addressLabel-32-|,
            16,
            |-32-addressTextField-32-| ~ 40,
            32,
            |-32-titleLabel-32-|,
            16,
            |-32-titleTextField-32-| ~ 40,
            32,
            |-32-contentLabel-32-|,
            16,
            |-32-contentTextView-32-| ~ 80,
            |-32-bottomView-32-| ~ 1.5,
            16
        )
        
        scrollView.showsVerticalScrollIndicator = false
        scrollView.bounces = false
    }
}

