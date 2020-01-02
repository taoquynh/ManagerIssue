 //
 //  SettingViewController.swift
 //  ManageIssue
 //
 //  Created by Taof on 10/14/19.
 //  Copyright © 2019 Taof. All rights reserved.
 //
 
 import UIKit
 import Stevia
 
 class SettingViewController: UIViewController {
    
    let tableView = UITableView()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        setupNavigationBar()
        setupTableView()
    }
    
    func setupLayout(){
        view.sv(tableView)
        
        view.layout(
            0,
            |-0-tableView-0-|,
            0
        )
    }
    
    func setupTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TableViewCell")
        tableView.rowHeight = 60
        tableView.tableFooterView = UIView()
    }
    
    func setupNavigationBar(){
        navigationItem.title = "Cài đặt"
        navigationController?.navigationBar.barTintColor = UIColor.main2Brown()
        self.setupSlideMenuItem()
        self.view.backgroundColor = UIColor.white
    }
    
 }
 
 extension SettingViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath)
        cell.textLabel?.text = "Đổi mật khẩu"
        return cell
    }
 }
