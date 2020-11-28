//
//  StatementViewController.swift
//  MPInterview
//
//  Created by Marcos Luiz on 28/11/20.
//  Copyright © 2020 ml2s. All rights reserved.
//

import Foundation
import UIKit

class StatementDetailViewController: BaseViewController {
    
    var statementDetailViewModel = StatementDetailViewModel()
    public var accountId : String?
    let pageTitle = "Extrato"
        
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = pageTitle
        statementDetailViewModel.accountId = accountId ?? ""
        
        tableView.register(StatementCell.self, forCellReuseIdentifier: "cell")
        
        self.view.addSubview(tableView)
        
        self.contraints()
        
        statementDetailViewModel.fetchStatementDetail{ [weak self] statement in
            DispatchQueue.main.async {
                self?.updateUI()
            }
        }
    }
    
    func updateUI() {
        tableView.reloadData()
    }
    
    private func contraints(){
        let safeArea = view.layoutMarginsGuide
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        self.tableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor).isActive = true
        self.tableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor).isActive = true
        self.tableView.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
        self.tableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor).isActive = true
    }
}

extension StatementDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (statementDetailViewModel.statement?.transactions.count ?? 0 ) + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! StatementCell
        if(indexPath.row == 0){
            cell.label.text = statementDetailViewModel.statement?.balance.label
            cell.value.text = statementDetailViewModel.statement?.balance.value
        }else{
            
            let cellData = statementDetailViewModel.statement?.transactions[indexPath.row-1]
            cell.label.text = cellData?.label
            cell.value.text = cellData?.value
            cell.descriptionLabel.text = cellData?.description
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
}

extension StatementDetailViewController: UITableViewDelegate { }
