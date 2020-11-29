//
//  StatementViewController.swift
//  MPInterview
//
//  Created by Marcos Luiz on 28/11/20.
//  Copyright © 2020 ml2s. All rights reserved.
//

import Foundation
import UIKit

class StatementViewController: BaseViewController {
    
    var statementViewModel = StatementViewModel()
    let pageTitle = "Extrato"
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        tableView.register(StatementCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = pageTitle
        
        self.view.addSubview(tableView)
        
        self.contraints()
        
        statementViewModel.fetchStatementDetail{ [weak self] result in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    self?.updateUI()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    guard let error = error as? APIResponseError else {
                        return
                    }
                    switch error {
                    case .messageError(let msgError):
                        self?.loadErrorAlert(message: msgError)
                    default:
                        print("erro não mapeado")
                        self?.loadErrorAlert(message: "Tente novamente mais tarde")
                    }
                }
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

extension StatementViewController {
    private func loadErrorAlert(message : String){
        let dialogMessage = UIAlertController(title: "Não foi possivel recuperar o extrato", message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: { ( action ) -> Void in
            _ = self.navigationController?.popViewController(animated: true)
        })
        dialogMessage.addAction(ok)
        self.present(dialogMessage, animated: true, completion: nil)
    }
}

extension StatementViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (statementViewModel.statement?.transactions.count ?? 0 ) + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! StatementCell
        if(indexPath.row == 0){
            cell.label.text = statementViewModel.statement?.balance.label
            cell.value.text = statementViewModel.statement?.balance.value
        }else{
            
            let cellData = statementViewModel.statement?.transactions[indexPath.row-1]
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

extension StatementViewController: UITableViewDelegate { }
