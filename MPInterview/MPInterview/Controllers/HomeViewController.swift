//
//  ViewController.swift
//  MPInterview
//
//  Created by Marcos Luiz on 25/11/20.
//  Copyright © 2020 ml2s. All rights reserved.
//

import UIKit

class HomeViewController: BaseViewController {
    
    private let homeViewModel = HomeViewModel()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.distribution = .fill
        stack.alignment = .fill
        stack.axis = .vertical
        stack.spacing = 30
        return stack
    }()
    
    private lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var homeCardWidgetView : HomeCardWidgetView?
    private var homeStatementWidgetView : HomeStatementWidgetView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(stackView)
            
        homeViewModel.fetchWidgets { [weak self] widgets in
            DispatchQueue.main.async {
                self?.addWidget()
            }
        }
        
        createContraints()
    }
    
    private func addWidget(){
        for widget in homeViewModel.widgets {
            switch widget.identifier {
            case .header:
                titleLabel.text = widget.content.title
                self.stackView.addArrangedSubview(titleLabel)
            case .card:
                self.homeCardWidgetView = HomeCardWidgetView.init(cardData: getHomeCardWidgetData(data: widget)!)
                self.stackView.addArrangedSubview(self.homeCardWidgetView!)
                homeCardWidgetView?.prepare()
            case .statement:
                self.homeStatementWidgetView = HomeStatementWidgetView.init(statementData: getHomeStatementdWidgetData(data: widget)!)
                self.stackView.addArrangedSubview(self.homeStatementWidgetView!)
                homeStatementWidgetView?.prepare()
            default:
                print("notMapped")
            }
        }
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
        let safeArea = view.layoutMarginsGuide
        self.stackView.translatesAutoresizingMaskIntoConstraints = false
        self.stackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 10).isActive = true
        self.stackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -10).isActive = true
        self.stackView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 10).isActive = true
        self.stackView.heightAnchor.constraint(greaterThanOrEqualToConstant: 50).isActive = true
                
        self.homeCardWidgetView?.translatesAutoresizingMaskIntoConstraints = false
        
    }
    
}

extension HomeViewController : HomeCardButtonDelegate {
    func didPressButton(button: UIButton, value: String, action: ButtonActionIdentifier) {
        switch action {
        case .cardScreen:
            let cardScreen = CardDetailViewController()
            cardScreen.cardId = value
            navigationController?.pushViewController(cardScreen, animated: true)
        case .statementScreen:
            let statementScreen = StatementDetailViewController()
            statementScreen.accountId = value
            navigationController?.pushViewController(statementScreen, animated: true)
        }
    }
    
}

extension HomeViewController  {
    func getHomeCardWidgetData(data : HomeWidget) -> HomeCardWidgetUIModel? {
        if let cardId = data.content.button?.action.content.cardId
         , let buttonText = data.content.button?.text
         , let buttonAction = data.content.button?.action.identifier
         , let cardNumber = data.content.cardNumber{
            return HomeCardWidgetUIModel(cardNumber: cardNumber, buttonText: buttonText, buttonActionDelegate: self, buttonAction: buttonAction, cardId: cardId, title: data.content.title)
        }
        return nil
    }
    
    func getHomeStatementdWidgetData(data : HomeWidget) -> HomeStatementWidgetUIModel? {
        if let accountId = data.content.button?.action.content.accountId
         , let buttonText = data.content.button?.text
         , let buttonAction = data.content.button?.action.identifier
           , let balanceValue = data.content.balance?.value
            , let balanceLabel = data.content.balance?.label{
                return HomeStatementWidgetUIModel(balanceLabel: balanceLabel, balanceValue: balanceValue, buttonText: buttonText, buttonActionDelegate: self, buttonAction: buttonAction, accountId: accountId, title: data.content.title  )
                
                
            }
        return nil
    }
}



