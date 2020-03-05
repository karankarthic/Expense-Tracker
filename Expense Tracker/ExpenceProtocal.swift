//
//  ExpenceProtocal.swift
//  Expense Tracker
//
//  Created by Karan Karthic on 03/03/20.
//  Copyright © 2020 Karan Karthic. All rights reserved.
//

import Foundation

protocol ExpenceViewToPresenterProtocol: class {
    var view:ExpencePresenterToViewProtocol? { get set }
    var intractor:ExpencePresenterToIntractorProtocol? { get set }
    var router:ExpencePresenterToRouterProtocol? { get set }
    
    func viewDidLoad()
    func insert(expense:Expense) -> Bool?
    func delete(expense:Expense) -> Bool?
    func update(expense:Expense) -> Bool?
}

protocol ExpencePresenterToViewProtocol: class {
    func reloadView(expenses:[Expense])
}

protocol ExpencePresenterToIntractorProtocol: class {
    var presenter : ExpenceIntractorToPresenterProtocol? { get set }
    func getExpenses()
    func insert(expence:Expense) ->Bool
    func delete(expense: Expense)->Bool
    func update(expense: Expense) -> Bool
    
}

protocol ExpenceIntractorToPresenterProtocol: class {
    func reloadView(expenses:[Expense])
}

protocol ExpencePresenterToRouterProtocol: class {
    static func createModule() -> ExpenseViewController
}
