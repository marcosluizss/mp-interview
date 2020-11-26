//
//  ViewController.swift
//  MPInterview
//
//  Created by Marcos Luiz on 25/11/20.
//  Copyright © 2020 ml2s. All rights reserved.
//

import UIKit

class HomeViewController: BaseViewController {
    
    private lazy var tableView : UITableView = {
       let tableView = UITableView()
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "widget")
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsSelection = false
        
       return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(tableView)
            
        createContraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }

    private func createContraints(){
        
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        self.tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.tableView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
    }
}

extension HomeViewController: UITableViewDelegate { }

extension HomeViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "widget", for: indexPath);
        	cell.textLabel?.text = "Teste"
        
        return cell
    }
    
}

