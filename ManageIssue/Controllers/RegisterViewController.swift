//
//  RegisterViewController.swift
//  ManageIssue
//
//  Created by Taof on 10/25/19.
//  Copyright © 2019 Taof. All rights reserved.
//

import UIKit
import Stevia
import GrowingTextView

@available(iOS 13.0, *)
class RegisterViewController: UIViewController {
    
    let scrollView = TPKeyboardAvoidingScrollView()
    
    let contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "harder")
        imageView.frame = CGRect(x: 0, y: 0, width: 64, height: 64)
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    let userNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Họ và tên"
        textField.textAlignment = .center
        return textField
    }()
    
    let phoneTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Số điện thoại"
        textField.textAlignment = .center
        return textField
    }()
    
    let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Mật khẩu"
        textField.textAlignment = .center
        return textField
    }()
    
    let confirmTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Nhập lại mật khẩu"
        textField.textAlignment = .center
        return textField
    }()
    
    let registerButton: UIButton = {
        let button = UIButton()
        button.setTitle("Đăng ký", for: .normal)
        button.layer.cornerRadius = 5
        button.layer.backgroundColor = UIColor.mainBrown().cgColor
        return button
    }()
    
    let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Đăng nhập", for: .normal)
        button.setTitleColor(UIColor.mainBrown(), for: .normal)
        return button
    }()
    
    let noteLabel: UILabel = {
        let label = UILabel()
        label.text = "Đã có tài khoản?"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .right
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupLayout()
        config()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        userNameTextField.underlined(UIColor.lightGray)
        passwordTextField.underlined(UIColor.lightGray)
        phoneTextField.underlined(UIColor.lightGray)
        confirmTextField.underlined(UIColor.lightGray)
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
            userNameTextField,
            phoneTextField,
            passwordTextField,
            confirmTextField,
            registerButton,
            loginButton,
            noteLabel
        )
        
        contentView.layout(
            80,
            photoImageView.height(150).width(self.view.frame.width/5*3),
            64,
            |-64-userNameTextField-64-| ~ 40,
            24,
            |-64-phoneTextField-64-| ~ 40,
            24,
            |-64-passwordTextField-64-| ~ 40,
            24,
            |-64-confirmTextField-64-| ~ 40,
            48,
            |-64-registerButton-64-| ~ 40,
            8,
            |-64-noteLabel-(<=4)-loginButton-64-| ~ 30,
            100
        )
        
        photoImageView.contentMode = .scaleAspectFit
        photoImageView.centerHorizontally()
        
        loginButton.Width == registerButton.Width / 3 + 20
        
        scrollView.showsVerticalScrollIndicator = false
        scrollView.bounces = false
        
        
        
    }
    
    func config(){
        
        let usernameIconImageView = UIImageView(image: UIImage(named: "ic_user"))
        usernameIconImageView.frame = CGRect(x: 0.0, y: 0.0, width: usernameIconImageView.image!.size.width + 10, height: usernameIconImageView.image!.size.height)
        usernameIconImageView.contentMode = .center
        
        userNameTextField.leftView = usernameIconImageView
        userNameTextField.leftViewMode = .always
        
        let phoneIconImageView = UIImageView(image: UIImage(named: "ic_iphone"))
        phoneIconImageView.frame = CGRect(x: 0.0, y: 0.0, width: phoneIconImageView.image!.size.width + 10, height: phoneIconImageView.image!.size.height)
        phoneIconImageView.contentMode = .center
        
        phoneTextField.leftView = phoneIconImageView
        phoneTextField.leftViewMode = .always
        
        let passwordIconImageView = UIImageView(image: UIImage(named: "ic-key"))
        passwordIconImageView.frame = CGRect(x: 0.0, y: 0.0, width: passwordIconImageView.image!.size.width + 10, height: passwordIconImageView.image!.size.height)
        passwordIconImageView.contentMode = .center
        
        passwordTextField.leftView = passwordIconImageView
        passwordTextField.leftViewMode = .always
        
        let confirmIconImageView = UIImageView(image: UIImage(named: "ic-key"))
        confirmIconImageView.frame = CGRect(x: 0.0, y: 0.0, width: confirmIconImageView.image!.size.width + 10, height: confirmIconImageView.image!.size.height)
        confirmIconImageView.contentMode = .center
        
        confirmTextField.leftView = confirmIconImageView
        confirmTextField.leftViewMode = .always
        
        
        registerButton.addTarget(self, action: #selector(onRegister), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(onLogin), for: .touchUpInside)
    }
    
    @objc func onLogin(){
        dismiss(animated: true, completion: nil)
    }
    
    @objc func onRegister(){
        self.view.endEditing(true)
        print("Đăng kí thành công")
        guard let name = userNameTextField.text, !name.isEmpty else {
            AlertHelper.sorry(message: "Vui lòng nhập họ tên", viewController: self)
            return
        }
        
        guard let phone = phoneTextField.text, !phone.isEmpty else {
            AlertHelper.sorry(message: "Vui lòng nhập số điện thoại", viewController: self)
            return
        }
        
        guard let pass = passwordTextField.text, !pass.isEmpty else {
            AlertHelper.sorry(message: "Vui lòng nhập mật khẩu", viewController: self)
            return
        }
        
        guard let confirmPassword = confirmTextField.text, !confirmPassword.isEmpty, confirmPassword == pass else {
            AlertHelper.sorry(message: "Vui lòng xác nhận mật khẩu", viewController: self)
            return
        }
        
        ApiManager.shared.register(name: name, phone: phone, password: confirmPassword, success: {
            if #available(iOS 13.0, *) {
                let homeVC = HomeViewController()
                let slideVC = SlideMenuViewController()
                let navigation = UINavigationController(rootViewController: homeVC)
                navigation.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
                let slideMenuController = SlideMenuController(mainViewController: navigation, leftMenuViewController: slideVC)
                SlideMenuOptions.contentViewScale = 1
                slideMenuController.modalPresentationStyle = .fullScreen
                self.present(slideMenuController, animated: true, completion: nil)
            }else{
                AppDelegate.sharedApp?.startMain()
            }
        }) { (errorMessage) in
            AlertHelper.sorry(message: errorMessage, viewController: self)
        }
    }
    
}
