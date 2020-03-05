//
//  ChoiceVC.swift
//  Expense Tracker
//
//  Created by Karan Karthic on 04/03/20.
//  Copyright © 2020 Karan Karthic. All rights reserved.
//

import UIKit

protocol ChoiceVCToMainVcdelgate:class{
    
    func excuteSearch(query:String)
}

class ChoiceVC:UIViewController , UITableViewDelegate, UITableViewDataSource {
    
    weak var delegate:ChoiceVCToMainVcdelgate?
    lazy var tableView = UITableView()
    
    lazy var date = Date()
    let choices = ["Today","This Month","Last Month"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = .init(title: "Back", style: .plain, target: self, action: #selector(close))
        self.view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        NSLayoutConstraint.activate([tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                                     tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
                                     tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
                                     tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)])
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return choices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = choices[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            delegate?.excuteSearch(query: today())
        }
        if indexPath.row == 1 {
            delegate?.excuteSearch(query: thisMonth())
        }
        
        if indexPath.row == 2 {
            delegate?.excuteSearch(query: lastmonth())
        }
        
        
        close()
       
    }
    
    @objc func close(){
           self.dismiss(animated: true, completion: nil)
    }
    
    func today() -> String{
        
        let dateformater = DateFormatter()
        dateformater.dateFormat = "YYYY-MM-dd"
        let currentdate = dateformater.string(from: Date())
        let query = "SELECT * FROM ExpensesTable WHERE AddedDate = Date('\(currentdate)')"
        return query
    }
    
    func thisMonth() -> String{
        let query = "SELECT * FROM ExpensesTable where AddedDate = DATE('now')"
        return query
    }
    
    func lastmonth() -> String{
        var comp: DateComponents = Calendar.current.dateComponents([.year, .month], from: Date())
        comp.month = ((comp.month ?? 1) - 1)
        let startOfMonth = Calendar.current.date(from: comp)!
        let dateformater = DateFormatter()
        dateformater.dateFormat = "YYYY-MM-dd"
        let startdate = dateformater.string(from: startOfMonth)
        var comps2 = DateComponents()
        comps2.month = 1
        comps2.day = -1
        let endOfMonth = Calendar.current.date(byAdding: comps2, to: startOfMonth)
        let enddate = dateformater.string(from: endOfMonth!)
        
        let query = "SELECT * FROM ExpensesTable WHERE AddedDate BETWEEN date('\(startdate)') AND date('\(enddate)')"
        return query
    }
    
}
