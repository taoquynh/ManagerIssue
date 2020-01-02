 //
 //  SlideMenuViewController.swift
 //  ManageIssue
 //
 //  Created by Taof on 10/14/19.
 //  Copyright © 2019 Taof. All rights reserved.
 //
 
 import UIKit
 import Stevia

 @available(iOS 13.0, *)
 class SlideMenuViewController: UIViewController {
    
    let tableView = UITableView()
    var menus = [Menu]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        createData()
        setupTableView()
    }
    
    func setupTableView(){
        view.sv(tableView)
        view.layout(
            0,
            |-0-tableView-0-|,
            0
        )
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MenuCell.self, forCellReuseIdentifier: "MenuCell")
        tableView.tableFooterView = UIView()
        tableView.bounces = false
        tableView.rowHeight = 64
    }
    
    func createData(){
        let cell1 = Menu(icon: "ic_report", name: "Báo sự cố")
        let cell2 = Menu(icon: "ic_outden", name: "Danh sách sự cố")
        let cell3 = Menu(icon: "ic_user", name: "Hồ sơ")
        let cell4 = Menu(icon: "ic_settings", name: "Cài đặt")
        let cell5 = Menu(icon: "ic_logout", name: "Đăng xuất")
        
        menus = [cell1, cell2, cell3, cell4, cell5]
    }
 }

 @available(iOS 13.0, *)
 extension SlideMenuViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = HeaderView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 150))
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menus.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as! MenuCell
        cell.photoIcon.image = UIImage(named: menus[indexPath.row].icon)
        cell.titleLabel.text = menus[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let name = menus[indexPath.row].name
        
        switch name {
        case "Danh sách sự cố":
            let mainVC = HomeViewController()
            let navigation = UINavigationController(rootViewController: mainVC)
            navigation.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
            self.slideMenuController()?.changeMainViewController(navigation, close: true)
        case "Hồ sơ":
            let mainVC = ProfileController()
            let navigation = UINavigationController(rootViewController: mainVC)
            navigation.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
            self.slideMenuController()?.changeMainViewController(navigation, close: true)
        case "Cài đặt":
            let mainVC = SettingViewController()
            let navigation = UINavigationController(rootViewController: mainVC)
            navigation.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
            self.slideMenuController()?.changeMainViewController(navigation, close: true)
        case "Đăng xuất":
            print("Đăng xuất")
            AlertHelper.confirmOrCancel(message: "Bạn có chắc chắn muốn đăng xuất?", viewController: self) {
                UserDefaults.standard.removeObject(forKey: "token")
                
                if #available(iOS 13.0, *){
                    self.slideMenuController()?.closeLeft()
                    NotificationCenter.default.post(name: .notificationNameCancel, object: "Cancel")
                }else{
                    AppDelegate.sharedApp?.startLogIn()
                }
            }
        default:
            return
        }
    }
 }
