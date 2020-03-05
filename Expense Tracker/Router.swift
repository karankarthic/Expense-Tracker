//
//  Router.swift
//  Expense Tracker
//
//  Created by Karan Karthic on 03/03/20.
//  Copyright © 2020 Karan Karthic. All rights reserved.
//

import Foundation

class Router:ExpencePresenterToRouterProtocol {
    
    static func createModule() -> ExpenseViewController {
        let view = ExpenseViewController()
        let presenter = Presenter()
        let intractor = Intractor()
        
        view.presenter = presenter
        presenter.view = view
        presenter.intractor = intractor
        presenter.router = Router()
        intractor.presenter = presenter
        
        return view
    }
    
    
}
