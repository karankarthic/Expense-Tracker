//
//  ExpenseViewController.swift
//  Expense Tracker
//
//  Created by Karan Karthic on 03/03/20.
//  Copyright © 2020 Karan Karthic. All rights reserved.
//

import UIKit

class ExpenseViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    lazy var tableView : UITableView = UITableView()
    lazy var filterButton : UIBarButtonItem = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(presentChoiceVC))
    lazy var addButton : UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(presentAddingVC))
    weak var presenter:ExpenceViewToPresenterProtocol?
    var updatingID:Int? = nil
    var expenses:[Expense] = []
    var updatingExpense:Expense? = nil
    var isUpdatebuttonHidden = true
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationItem.leftBarButtonItem = filterButton
        self.navigationItem.rightBarButtonItem = addButton
        self.navigationItem.title = "Expenses"
        
        self.view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        NSLayoutConstraint.activate([tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                                     tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
                                     tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
                                     tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)])
        
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 44.0
        tableView.tableFooterView = UIView()
        presenter?.viewDidLoad()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return expenses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "Reason:\(expenses[indexPath.row].reason), Amount:\(expenses[indexPath.row].amount), Date:\(expenses[indexPath.row].date)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let editAction = UITableViewRowAction(style: .normal, title: "Edit") { (rowAction, indexPath) in
            self.updatingExpense = self.expenses[indexPath.row]
            self.updatingID = indexPath.row
            self.isUpdatebuttonHidden = false
            self.presentAddingVC()
        }
        editAction.backgroundColor = .blue
        
        let deleteAction = UITableViewRowAction(style: .normal, title: "Delete") { (rowAction, indexPath) in
            let expense = self.expenses[indexPath.row]
            if let bool = self.presenter?.delete(expense: expense),bool {
                self.expenses.remove(at: indexPath.row)
                self.reloadtableView()
            }
        }
        deleteAction.backgroundColor = .red
        
        return [editAction,deleteAction]
    }
    
    func reloadtableView()
    {
        self.tableView.reloadData()
    }
    
    @objc func presentAddingVC()
    {
        let presentingVc = ExpenseAddingViewController()
        presentingVc.delegate = self
        presentingVc.expense = updatingExpense
        presentingVc.isUpdatebuttonHidden = isUpdatebuttonHidden
        let vc = UINavigationController.init(rootViewController: presentingVc)
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc func presentChoiceVC(){
    
       let presentingVc = ChoiceVC()
       presentingVc.delegate = self
       let vc = UINavigationController.init(rootViewController: presentingVc)
       self.present(vc, animated: true, completion: nil)
    }
 
}

extension ExpenseViewController: ExpenseVCToMainVC {
    
    func update(expense: Expense) {
        let alert : UIAlertController

        if let bool = presenter?.update(expense:expense), bool{
            
            alert = UIAlertController(title: "", message: "updated succesfully", preferredStyle: .alert)
            
        } else {
            
            alert = UIAlertController(title: "", message: "not updated", preferredStyle: .alert)
            
        }
        let action = UIAlertAction(title: "close", style: .cancel) { (_) in
            self.presenter?.viewDidLoad()
        }
        
        alert.addAction(action)
        self.present(alert, animated: false, completion: nil)
    }
    
    func refreshUpdatedThings(){
        updatingID = nil
        updatingExpense = nil
        isUpdatebuttonHidden = true
    }
    
    
    func addExpense(expense: Expense) {
        
        let alert : UIAlertController
        let addingExpense = Expense(Id: expenses.count, amount: expense.amount, date: expense.date, reason: expense.reason)
        if let bool = presenter?.insert(expense:addingExpense), bool{
            
            alert = UIAlertController(title: "", message: "added succesfully", preferredStyle: .alert)
            
        } else {
            
            alert = UIAlertController(title: "", message: "not added", preferredStyle: .alert)
            
        }
        let action = UIAlertAction(title: "close", style: .cancel) { (_) in
            self.presenter?.viewDidLoad()
        }
        
        alert.addAction(action)
        
        self.present(alert, animated: false, completion: nil)
    }
    
}

extension ExpenseViewController: ExpencePresenterToViewProtocol
{
    func reloadView(expenses:[Expense]) {
        print("in presenter")
        self.expenses = expenses
        reloadtableView()
    }
    
    
}

extension ExpenseViewController:ChoiceVCToMainVcdelgate{
    
    func excuteSearch(query: String) {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(clearSearch))
        presenter?.search(query: query)
    }
    
    @objc func clearSearch(){
        self.navigationItem.rightBarButtonItem = addButton
        presenter?.viewDidLoad()
    }
    
    
}
