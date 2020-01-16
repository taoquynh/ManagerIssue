//
//  HomeViewController.swift
//  ManageIssue
//
//  Created by Taof on 10/14/19.
//  Copyright © 2019 Taof. All rights reserved.
//

import UIKit
import Stevia

enum State {
    case no_process
    case processing
    case processed
}
class HomeViewController: UIViewController {
    
    deinit {
        print("Đã huỷ HomeViewController")
    }
    
    let segmentControl: UISegmentedControl = {
        let segment = UISegmentedControl(items: ["Chưa xử lý", "Đang xử lý", "Đã xử lý"])
        // Make second segment selected
        segment.selectedSegmentIndex = 0
        //Change text color of UISegmentedControl
        segment.tintColor = UIColor.mainBrown()
        //        segment.layer.borderColor = UIColor.clear.cgColor
        return segment
    }()
    
    let tableView: UITableView = {
        let tableView = UITableView()
        
        return tableView
    }()
    
    let containerView: UIView = {
        let view = UIView()
        return view
    }()
    
    var listIssues: [Issue] = []
    var isState: State = .no_process
    var searchBar: UISearchBar!
    var isSearching: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        setupNavigationBar()
        setupLayout()
        setUpTableView()
        
        segmentControl.addTarget(self, action: #selector(segmentedValueChanged(_:)), for: .valueChanged)
        getData()
        NotificationCenter.default.addObserver(self, selector: #selector(notification(_:)), name: .notificationNameCancel, object: nil)
        
    }
    
    @objc func notification(_ notification: Notification){
        if let message = notification.object as? String{
            print("message: \(message)")
            self.dismiss(animated: true, completion: nil)
        }
    }
    func getData(){
        ApiManager.shared.getListIssue(success: { (response) in
            guard let response = response, let result = response.result else { return }
            self.listIssues = result
            print(result.count)
            for i in result {
                print(i.content)
                
            }
            self.tableView.reloadData()
        }) { (errorMessage) in
            AlertHelper.sorry(message: errorMessage, viewController: self)
        }
    }
    
    @objc func segmentedValueChanged(_ sender:UISegmentedControl!){
        print("Selected Segment Index is : \(sender.selectedSegmentIndex)")
        switch sender.selectedSegmentIndex {
        case 0:
            isState = .no_process
        case 1:
            isState = .processing
        case 2:
            isState = .processed
        default:
            return
        }
        
        tableView.reloadData()
    }
    
    func setupLayout(){
        view.sv(containerView)
        view.layout(
            100,
            |-0-containerView-0-|,
            0
        )
        
        containerView.sv(segmentControl, tableView)
        containerView.layout(
            0,
            |-16-segmentControl-16-| ~ 40,
            8,
            |-0-tableView-0-|,
            4
        )
    }
    
    func setUpTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ListIssueCell.self, forCellReuseIdentifier: "ListIssueCell")
        tableView.rowHeight = 80
        tableView.tableFooterView = UIView()
    }
    
    func setupNavigationBar(){
        navigationItem.title = "Danh sách sự cố"
        
        let addBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(goToCreateIssue))
        let searchBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(search))
        navigationItem.rightBarButtonItems = [addBarButtonItem, searchBarButtonItem]
        addBarButtonItem.tintColor = UIColor.white
        searchBarButtonItem.tintColor = UIColor.white
        navigationController?.navigationBar.barTintColor = UIColor.main2Brown()
        self.setupSlideMenuItem()
    }
    
    @objc func search(){
        isSearching = !isSearching
        if isSearching {
            makeSearchBar()
        }else{
            navigationItem.titleView = nil
        }
    }
    
    func makeSearchBar(){
        searchBar = UISearchBar()
        searchBar.sizeToFit()
        searchBar.delegate = self
        navigationItem.titleView = searchBar
    }
    
    @objc func goToCreateIssue(){
        let createVC = CreateIssueViewController()
        navigationController?.pushViewController(createVC, animated: true)
    }
}

extension HomeViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
        if searchText.isEmpty {
            getData()
        } else {
            searchByText(searchText, isState)
        }
    }
    
    func searchByText(_ keyword: String, _ isState: State){
        ApiManager.shared.searchIssue(status: getStatus(isState), keyword: keyword, success: { (response) in
            guard let response = response, let result = response.result else { return }
            self.listIssues = result
            self.tableView.reloadData()
        }) { (errorMessage) in
            AlertHelper.sorry(message: errorMessage, viewController: self)
        }
    }
    
    func getStatus(_ isState: State) -> Int {
        switch isState {
        case .no_process:
            return 0
        case .processing:
            return 1
        case .processed:
            return 2
        }
    }
}


extension HomeViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch isState {
        case .no_process:
            return listIssues.filter { $0.status == "Chưa xử lý"}.count
        case .processing:
            return listIssues.filter { $0.status == "Đang xử lý"}.count
        case .processed:
            return listIssues.filter { $0.status == "Đã xử lý"}.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListIssueCell", for: indexPath) as! ListIssueCell
        switch isState {
        case .no_process:
            cell.issue = listIssues.filter { $0.status == "Chưa xử lý"}[indexPath.row]
        case .processing:
            cell.issue = listIssues.filter { $0.status == "Đang xử lý"}[indexPath.row]
        case .processed:
            cell.issue = listIssues.filter { $0.status == "Đã xử lý"}[indexPath.row]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(listIssues[indexPath.row].id)
        let detailVC = DetailViewController()
        switch isState {
        case .no_process:
            detailVC.issue = listIssues.filter { $0.status == "Chưa xử lý"}[indexPath.row]
        case .processing:
            detailVC.issue = listIssues.filter { $0.status == "Đang xử lý"}[indexPath.row]
        case .processed:
            detailVC.issue = listIssues.filter { $0.status == "Đã xử lý"}[indexPath.row]
        }
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .done, target: self, action: nil)
        self.navigationItem.backBarButtonItem?.tintColor = UIColor.white
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
