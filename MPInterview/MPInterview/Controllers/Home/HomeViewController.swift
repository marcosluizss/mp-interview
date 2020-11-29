//
//  ViewController.swift
//  MPInterview
//
//  Created by Marcos Luiz on 25/11/20.
//  Copyright © 2020 ml2s. All rights reserved.
//

import UIKit

class HomeViewController: BaseViewController {
    
    var homeViewModel = HomeViewModel()
        
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.distribution = .fill
        stack.alignment = .fill
        stack.axis = .vertical
        stack.spacing = 30
        return stack
    }()
            
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
                let headerModel = HomeHeaderWidgetUIModel.fromHomeWidget(homeWidget: widget)
                let herderWidget = HomeHeaderWidgetView.init(headerModel: headerModel)
                self.stackView.addArrangedSubview(herderWidget)
                herderWidget.prepare()
            case .card:
                if let cardUIModel = HomeCardWidgetUIModel.fromHomeWidget(homeWidget: widget, buttonDelegate: self) {
                    let creditCardWidget = HomeCardWidgetView.init(cardModel: cardUIModel)
                    self.stackView.addArrangedSubview(creditCardWidget)
                    creditCardWidget.prepare()
                }
            case .statement:
                if let statementUIModel = HomeStatementWidgetUIModel.fromHomeWidget(homeWidget: widget, buttonDelegate: self){
                    let statementWidget = HomeStatementWidgetView.init(statementModel: statementUIModel)
                    self.stackView.addArrangedSubview(statementWidget)
                    statementWidget.prepare()
                }
            default:
                print("notMapped - Não deve chegar nenhum pois tratamos no ViewModel")
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
    }
    
}

extension HomeViewController : HomeCardButtonDelegate {
    func didPressButton(button: UIButton, value: String, action: ButtonActionIdentifier) {
        switch action {
        case .cardScreen:
            let cardScreen = CreditCardViewController()
            cardScreen.cardDetailViewModel.cardId = value
            navigationController?.pushViewController(cardScreen, animated: true)
        case .statementScreen:
            let statementScreen = StatementViewController()
            statementScreen.statementViewModel.accountId = value
            navigationController?.pushViewController(statementScreen, animated: true)
        }
    }
    
}



