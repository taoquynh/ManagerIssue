//
//  ProfileController.swift
//  ManageIssue
//
//  Created by Taof on 10/25/19.
//  Copyright © 2019 Taof. All rights reserved.
//

import UIKit
import Stevia
import GrowingTextView
import Photos
import Kingfisher

class ProfileController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    let scrollView = TPKeyboardAvoidingScrollView()
    
    let contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "earth")
        imageView.frame = CGRect(x: 0, y: 0, width: 64, height: 64)
        imageView.contentMode = .scaleAspectFit
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.mainBrown().cgColor
        return imageView
    }()
    
    let changePhotoLabel: UILabel = {
        let label = UILabel()
        label.text = "Đổi ảnh đại diện"
        label.textColor = UIColor.main2Brown()
        label.textAlignment = .center
        return label
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Họ và tên"
        return label
    }()
    
    let nameTextField: UITextField = {
        let textField = UITextField()
        return textField
    }()
    
    let phoneLabel: UILabel = {
        let label = UILabel()
        label.text = "Số điện thoại"
        return label
    }()
    
    let phoneTextField: UITextField = {
        let textField = UITextField()
        
        return textField
    }()
    
    let addressLabel: UILabel = {
        let label = UILabel()
        label.text = "Địa chỉ"
        return label
    }()
    
    let addressTextView: GrowingTextView = {
        let textView = GrowingTextView()
        textView.trimWhiteSpaceWhenEndEditing = true
        textView.maxLength = 200
        textView.maxHeight = 100
        textView.minHeight = 80
        textView.font = UIFont.systemFont(ofSize: 16)
        return textView
    }()
    
    let saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("Cập nhật", for: .normal)
        button.layer.cornerRadius = 5
        button.layer.backgroundColor = UIColor.mainBrown().cgColor
        return button
    }()
    
    let cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("Huỷ", for: .normal)
        button.layer.cornerRadius = 5
        button.layer.borderColor = UIColor.mainBrown().cgColor
        button.layer.borderWidth = 1
        button.setTitleColor(UIColor.mainBrown(), for: .normal)
        return button
    }()
    
    var userProfile: Profile?
    var imagePicker: UIImagePickerController!
    var urlImage = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupLayout()
        
        ApiManager.shared.getProfile(success: { (response) in
            self.userProfile = response
            self.setupData()
        }) { (errorMessage) in
            AlertHelper.sorry(message: errorMessage, viewController: self)
        }
        
        changeAvatar()
        onAction()
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
    }
 
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        nameTextField.borderLine()
        nameTextField.viewMode()
        phoneTextField.borderLine()
        phoneTextField.viewMode()
        addressTextView.borderLine()
        
    }
    
    func setupData(){
        guard let userProfile = userProfile else {return}
        if userProfile.avatar.isEmpty {
            photoImageView.image = UIImage(named: "no_image")
        }else{
            print("avatar")
            photoImageView.setImage(urlString: userProfile.avatar)
        }
        nameTextField.text = userProfile.name
        phoneTextField.text = userProfile.phone
        addressTextView.text = userProfile.address
        
    }
    
    func setupNavigationBar(){
        navigationItem.title = "Hồ sơ cá nhân"
        navigationController?.navigationBar.barTintColor = UIColor.main2Brown()
        self.setupSlideMenuItem()
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
            photoImageView,
            changePhotoLabel,
            nameLabel,
            nameTextField,
            phoneLabel,
            phoneTextField,
            addressLabel,
            addressTextView,
            cancelButton,
            saveButton
        )
        
        contentView.layout(
            32,
            photoImageView.width(120).height(120),
            16,
            |-32-changePhotoLabel-32-|,
            48,
            |-32-nameLabel-32-|,
            16,
            |-32-nameTextField-32-| ~ 40,
            32,
            |-32-phoneLabel-32-|,
            16,
            |-32-phoneTextField-32-| ~ 40,
            32,
            |-32-addressLabel-32-|,
            16,
            |-32-addressTextView-32-| ~ 80,
            32,
            |-32-cancelButton-8-saveButton-32-| ~ 40,
            100
        )
        
        photoImageView.layer.cornerRadius = 60
        photoImageView.layer.masksToBounds = true
        photoImageView.contentMode = .scaleAspectFill
        photoImageView.centerHorizontally()
        
        cancelButton.Width == saveButton.Width
        
        scrollView.showsVerticalScrollIndicator = false
        scrollView.bounces = false
    }
    
    func onAction(){
        cancelButton.addTarget(self, action: #selector(onCancel), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(saveData), for: .touchUpInside)
    }
    
    @objc func onCancel(){
        self.slideMenuController()?.openLeft()
    }
    
    @objc func saveData(){
        guard let name = nameTextField.text, !name.isEmpty else {
            AlertHelper.sorry(message: "Tên không được để trống", viewController: self)
            return
        }
        
        guard let phone = phoneTextField.text, !phone.isEmpty else {
            AlertHelper.sorry(message: "Số điện thoại không được để trống", viewController: self)
            return
        }
        
        guard let address = addressTextView.text else { return }
        
        print(urlImage)
        userProfile?.name = name
        userProfile?.phone = phone
        userProfile?.address = address
        userProfile?.avatar = urlImage
        
        guard let userProfile = userProfile else { return }
        ApiManager.shared.updateProfile(userProfile: userProfile, success: {
            AlertHelper.sorry(message: "Cập nhật thành công", viewController: self)
        }) { (error) in
            AlertHelper.sorry(message: error, viewController: self)
        }
    }
    
    func changeAvatar(){
        changePhotoLabel.isUserInteractionEnabled = true
        
        let tapLabel = UITapGestureRecognizer(target: self, action: #selector(tapLabel(_:)))
        changePhotoLabel.addGestureRecognizer(tapLabel)
    }
    
    @objc func tapLabel(_ sender: UITapGestureRecognizer){
        let alert = UIAlertController(title: "NoiBai App", message: "Chọn ảnh từ", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Huỷ", style: .cancel, handler: nil)
        let camera = UIAlertAction(title: "Máy ảnh", style: .default, handler: { (_) in
            self.fromCamera()
        })
        let libray = UIAlertAction(title: "Thư viện", style: .default, handler: { (_) in
            self.fromGallery()
        })
        
        alert.addAction(camera)
        alert.addAction(libray)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    func setting(){
        // Noibai.vn would like to access Photo Library for profile photo upload. Your photos won’t be shared without your permission.
        let message = "NoiBai Taxi cần truy cập máy ảnh và thư viện của bạn. Ảnh của bạn sẽ không được chia sẻ khi chưa được phép của bạn."
        AlertHelper.confirmOrCancel(message: message, viewController: self) {
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            
            if UIApplication.shared.canOpenURL(settingsUrl) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.openURL(settingsUrl)
                } else {
                    UIApplication.shared.openURL(settingsUrl)
                }
            }
        }
    }
    
    private func fromCamera(){
        func takePhoto(){
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                self.imagePicker.allowsEditing = false
                self.imagePicker.sourceType = UIImagePickerController.SourceType.camera
                self.imagePicker.cameraCaptureMode = .photo
                self.imagePicker.cameraDevice = .front
                self.imagePicker.modalPresentationStyle = .fullScreen
                self.present(self.imagePicker, animated: true,completion: nil)
            }else{
                AlertHelper.sorry(message: "Không tìm thấy camera", viewController: self)
            }
        }
        
        //Camera
        AVCaptureDevice.requestAccess(for: AVMediaType.video) { response in
            if response {
                takePhoto()
            } else {
                print("camera denied")
                self.setting()
            }
        }
    }
    
    private func fromGallery(){
        func choosePhoto(){
            self.imagePicker.allowsEditing = false
            self.imagePicker.sourceType = .photoLibrary
            self.imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
            self.imagePicker.modalPresentationStyle = .popover
            self.present(self.imagePicker, animated: true, completion: nil)
        }
        
        // khai báo biến để lấy quyền truy cập
        let status = PHPhotoLibrary.authorizationStatus()
        
        if (status == PHAuthorizationStatus.authorized) {
            // quyền truy cập đã được cấp
            choosePhoto()
        }else if (status == PHAuthorizationStatus.denied) {
            // quyền truy cập bị từ chối
            print("photo denied")
            setting()
            
        }else if (status == PHAuthorizationStatus.notDetermined) {
            
            // quyền truy cập chưa được xác nhận
            PHPhotoLibrary.requestAuthorization({ (newStatus) in
                if (newStatus == PHAuthorizationStatus.authorized) {
                    choosePhoto()
                }else {
                    print("Không được cho phép truy cập vào thư viện ảnh")
                    self.setting()
                }
            })
        }else if (status == PHAuthorizationStatus.restricted) {
            // Truy cập bị hạn chế, thông thường sẽ không xảy ra
            print("Restricted access")
            setting()
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.originalImage] as? UIImage else {
            print("error: \(info)")
            return
        }
        
        ApiManager.shared.upload(image: selectedImage, success: { (url) in
            print(url)
            self.photoImageView.setImage(urlString: url)
            self.urlImage = url
        }) { (error) in
            AlertHelper.sorry(message: error, viewController: self)
        }
        
        dismiss(animated: true, completion: nil)
    }
}
