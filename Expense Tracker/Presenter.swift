//
//  Presenter.swift
//  Expense Tracker
//
//  Created by Karan Karthic on 03/03/20.
//  Copyright © 2020 Karan Karthic. All rights reserved.
//

import Foundation

class Presenter:ExpenceViewToPresenterProtocol {

    var view: ExpencePresenterToViewProtocol?
    
    var intractor: ExpencePresenterToIntractorProtocol?
    
    var router: ExpencePresenterToRouterProtocol?
    
    func viewDidLoad() {
        intractor?.getExpenses()
    }
    
    func insert(expense:Expense) -> Bool?{
        return intractor?.insert(expence: expense)
    }
   
    func delete(expense: Expense) -> Bool? {
        return intractor?.delete(expense: expense)
    }
    
    func update(expense: Expense) -> Bool? {
        return intractor?.update(expense: expense)
    }
   
}

extension Presenter: ExpenceIntractorToPresenterProtocol {
    
    func reloadView(expenses: [Expense]) {
        view?.reloadView(expenses: expenses)
    }
    
    
}

