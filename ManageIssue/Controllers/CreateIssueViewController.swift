//
//  CreateIssueViewController.swift
//  ManageIssue
//
//  Created by Taof on 11/8/19.
//  Copyright © 2019 Taof. All rights reserved.
//

import UIKit
import GrowingTextView
import Stevia

class CreateIssueViewController: UIViewController {

        let scrollView = TPKeyboardAvoidingScrollView()
        
        let contentView: UIView = {
            let view = UIView()
            return view
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
        
    let collectionView: UICollectionView = {
           let layout = UICollectionViewFlowLayout()
           let collection = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
           collection.register(MediaCell.self, forCellWithReuseIdentifier: "MediaCell")
           collection.backgroundColor = .groupTableViewBackground
           
           layout.scrollDirection = .horizontal
           
           return collection
       }()
       
    var items: [Media] = []
    
        override func viewDidLoad() {
            super.viewDidLoad()
            
            setupNavigationBar()
            setupLayout()

            collectionView.delegate = self
            collectionView.dataSource = self
                        
            let image1 = UIImage(named: "ic_camera")
            items.insert(Media(image: image1, isDelete: false), at: 0)
            
            let image2 = UIImage(named: "ic_camera")
            items.insert(Media(image: image2, isDelete: true), at: 0)
            
        }
    
        override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            titleTextField.underView()
            addressTextField.underView()
        }
        
        func setupNavigationBar(){

            navigationItem.title = "Báo sự cố"
            navigationController?.navigationBar.barTintColor = UIColor.main2Brown()
            self.setupSlideMenuItem()
            self.view.backgroundColor = UIColor.white
            
            let sendBarButtonItem = UIBarButtonItem(title: "Gửi", style: .done, target: self, action: #selector(sendIssue))
            navigationItem.rightBarButtonItem = sendBarButtonItem
            sendBarButtonItem.tintColor = UIColor.white
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
                addressLabel,
                addressTextField,
                titleLabel,
                titleTextField,
                contentLabel,
                contentTextView,
                bottomView,
                collectionView
            )
            
            contentView.layout(
                48,
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
                |-32-bottomView-32-| ~ 1,
                48,
                |-32-collectionView-32-| ~ 200,
                16
            )
            
            scrollView.showsVerticalScrollIndicator = false
            scrollView.bounces = false
        }
        
        @objc func sendIssue(){
            guard let address = addressTextField.text, !address.isEmpty else {
                AlertHelper.sorry(message: "Vui lòng nhập địa chỉ", viewController: self)
                return
            }
            
            guard let title = titleTextField.text else {
                AlertHelper.sorry(message: "Vui lòng nhập tên sự cố", viewController: self)
                return
            }
            
            guard let content = contentTextView.text, !content.isEmpty else {
                AlertHelper.sorry(message: "Vui lòng mô tả chi tiết sự cố", viewController: self)
                return
            }
            
            let issue = Issue()
            issue.address = address
            issue.title = title
            issue.content = content
            
            ApiManager.shared.createIssue(issue: issue, success: {
                AlertHelper.sorry(message: "Gửi sự cố thành công", viewController: self)
            }) { (error) in
                AlertHelper.sorry(message: error, viewController: self)
            }
        }

}

extension CreateIssueViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MediaCell", for: indexPath) as! MediaCell
        cell.image = items[indexPath.row]
        cell.passAction = { [weak self] in
            guard let strongSelf = self else { return }
            print("tap delete")
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = collectionView.frame.size.height
        return CGSize(width: size, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == items.count - 1 {
            print("select image")
        }
    }
}
