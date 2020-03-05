//
//  ExpenceAddingVC.swift
//  Expense Tracker
//
//  Created by Karan Karthic on 03/03/20.
//  Copyright © 2020 Karan Karthic. All rights reserved.
//

import Foundation
import UIKit

protocol ExpenseVCToMainVC: class {
    func addExpense(expense:Expense)
    func update(expense:Expense)
    func refreshUpdatedThings()
}

class ExpenseAddingViewController:UIViewController
{
    weak var delegate:ExpenseVCToMainVC?
    var expense:Expense? = nil
    var isUpdatebuttonHidden = true
    lazy var amountTextField: UITextField = {
        
        let amountTextField = UITextField()
        amountTextField.translatesAutoresizingMaskIntoConstraints = false
        amountTextField.font = .systemFont(ofSize: 16, weight: .regular)
        amountTextField.borderStyle = .roundedRect
        amountTextField.keyboardType = .decimalPad
        amountTextField.backgroundColor = .clear
        amountTextField.placeholder = "Enter The Amount Of Expense..."
        return amountTextField
    }()
    lazy var reasonTextField: UITextField = {
        
        let reasonTextField = UITextField()
        reasonTextField.translatesAutoresizingMaskIntoConstraints = false
        reasonTextField.font = .systemFont(ofSize: 16, weight: .regular)
        reasonTextField.borderStyle = .roundedRect
        reasonTextField.backgroundColor = .clear
        reasonTextField.placeholder = "Enter The Reason For Expense..."
        return reasonTextField
    }()

    lazy var dateTextField: UITextField = {
        
        let dateTextField = UITextField()
        dateTextField.translatesAutoresizingMaskIntoConstraints = false
        dateTextField.font = .systemFont(ofSize: 16, weight: .regular)
        dateTextField.backgroundColor = .clear
        dateTextField.borderStyle = .roundedRect
        dateTextField.placeholder = "Enter The Date..."
        dateTextField.addInputViewDatePicker(target: self, selector: #selector(doneButtonAction))
        return dateTextField
    }()
    
    lazy var submitButton:UIButton = {
        let submitButton = UIButton()
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        submitButton.setTitle("Submit", for: .normal)
        submitButton.addTarget(self, action: #selector(submit), for: .touchUpInside)
        submitButton.titleLabel?.textColor = .white
        submitButton.backgroundColor = .lightGray
        submitButton.isHidden = true
        return submitButton
    }()
    
    lazy var updateButton:UIButton = {
        let updateButton = UIButton()
        updateButton.translatesAutoresizingMaskIntoConstraints = false
        updateButton.setTitle("Update", for: .normal)
        updateButton.addTarget(self, action: #selector(update), for: .touchUpInside)
        updateButton.titleLabel?.textColor = .white
        updateButton.backgroundColor = .lightGray
        updateButton.isHidden = true
        return updateButton
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Add Expense"
        self.setUpView()
        if let expense = expense{
            amountTextField.text = String(expense.amount)
            reasonTextField.text = expense.reason
            dateTextField.text = expense.date
        }
    }
    
    func setUpView()
    {
        self.view.addViews(views: [amountTextField,reasonTextField,dateTextField,submitButton,updateButton])
        self.view.backgroundColor = .white
        self.navigationItem.leftBarButtonItem = .init(title: "Back", style: .plain, target: self, action: #selector(close))
        NSLayoutConstraint.activate([amountTextField.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 100),
                                     amountTextField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 15),
                                     amountTextField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -15),
                                     
                                     reasonTextField.topAnchor.constraint(equalTo: self.amountTextField.bottomAnchor, constant: 15),
                                     reasonTextField.leadingAnchor.constraint(equalTo: self.amountTextField.leadingAnchor, constant: 0),
                                     reasonTextField.trailingAnchor.constraint(equalTo: self.amountTextField.trailingAnchor, constant: 0),
                                    
                                     dateTextField.topAnchor.constraint(equalTo: self.reasonTextField.bottomAnchor, constant: 15),
                                     dateTextField.leadingAnchor.constraint(equalTo: self.amountTextField.leadingAnchor, constant: 0),
                                     dateTextField.trailingAnchor.constraint(equalTo: self.amountTextField.trailingAnchor, constant: 0),
                                
        ])
        
        if isUpdatebuttonHidden {
            
            NSLayoutConstraint.activate([submitButton.topAnchor.constraint(equalTo: self.dateTextField.bottomAnchor, constant: 15),
                                                    submitButton.leadingAnchor.constraint(equalTo: self.amountTextField.leadingAnchor, constant: 0),
                                                    submitButton.trailingAnchor.constraint(equalTo: self.amountTextField.trailingAnchor, constant: 0),
                                                    submitButton.bottomAnchor.constraint(lessThanOrEqualTo: self.view.bottomAnchor)])
                       submitButton.isHidden = false
            
        }else{
           NSLayoutConstraint.activate([updateButton.topAnchor.constraint(equalTo: self.dateTextField.bottomAnchor, constant: 15),
                                        updateButton.leadingAnchor.constraint(equalTo: self.amountTextField.leadingAnchor, constant: 0),
                                        updateButton.trailingAnchor.constraint(equalTo: self.amountTextField.trailingAnchor, constant: 0),
                                        updateButton.bottomAnchor.constraint(lessThanOrEqualTo: self.view.bottomAnchor)])
           
        updateButton.isHidden = false
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        delegate?.refreshUpdatedThings()
    }
    
    @objc func close(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func doneButtonAction() {
       if let  datePicker = self.dateTextField.inputView as? UIDatePicker {
        let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "YYYY-MM-dd"
           self.dateTextField.text = dateFormatter.string(from: datePicker.date)
       }
       self.dateTextField.resignFirstResponder()
    }
    
    @objc func submit(){
        
        if let reason = reasonTextField.text , let amount = amountTextField.text, let date = dateTextField.text, reason != "" , amount != "" , date != "" ,let amountToAdd = Int(amount) {
            let expense = Expense(Id: 0, amount:amountToAdd , date: date, reason: reason)
            close()
            delegate?.addExpense(expense: expense)
            
        }
        
    }
    
    @objc func update(){
        
        if let reason = reasonTextField.text , let amount = amountTextField.text, let date = dateTextField.text, reason != "" , amount != "" , date != "" ,let amountToAdd = Int(amount) {
            let expense = Expense(Id: (self.expense?.Id ?? 0), amount:amountToAdd , date: date, reason: reason)
            close()
            delegate?.update(expense: expense)
        }
        
    }
}


extension UIView {
    
    func addViews(views:[UIView]){
        for view in views{
            self.addSubview(view)
        }
    }
    
}


extension UITextField {

   func addInputViewDatePicker(target: Any, selector: Selector?) {

    let screenWidth = UIScreen.main.bounds.width
    
    let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 216))
    datePicker.datePickerMode = .date
    self.inputView = datePicker

    let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 44))
    let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    let cancelBarButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelPressed))
    let doneBarButton = UIBarButtonItem(title: "Done", style: .plain, target: target, action: selector)
    toolBar.setItems([cancelBarButton, flexibleSpace, doneBarButton], animated: false)

    self.inputAccessoryView = toolBar
 }

   @objc func cancelPressed() {
     self.resignFirstResponder()
   }
}
