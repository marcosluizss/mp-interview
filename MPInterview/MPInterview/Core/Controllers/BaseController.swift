//
//  BaseController.swift
//  MPInterview
//
//  Created by Marcos Luiz on 25/11/20.
//  Copyright © 2020 ml2s. All rights reserved.
//

import UIKit

//classe base, ajuda na montagem da view
open class BaseViewController: UIViewController {
    
    override open func loadView() {
        let view = UIView()
        view.backgroundColor = UIColor.white
        self.view = view
    }
}
