//
//  Intractor.swift
//  Expense Tracker
//
//  Created by Karan Karthic on 03/03/20.
//  Copyright © 2020 Karan Karthic. All rights reserved.
//

import Foundation

class Intractor:ExpencePresenterToIntractorProtocol {
    
  
    var presenter: ExpenceIntractorToPresenterProtocol?
    var datbase:SQLiteDatabase? = nil
    
    init() {
         do {
                datbase = try SQLiteDatabase.init(dbPath: getFilePath().path)
               //print("hi database")
               }catch
               {
                   print(error)
               }
         createtable()
//         dropTable()
//        dropTable()
        //insert(expence:Expense(amount: 1, date: "01-02-2020", reason: "test"))
    }
    
    func getFilePath() -> URL{
        
        
        var documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        documentsUrl.appendPathComponent("Expenses.sqlite")
        return documentsUrl
    }
    
    func createtable() {
        let query = "create table if not exists ExpensesTable(Id Int ,Amount Int ,Reason CHAR(255),AddedDate DATE)"
        do
        {
            try datbase?.createTabel(tabelQuery: query)
            
        }catch
        {
            print(error)
        }
    }
    
    
    func getExpenses() {
        let query = "SELECT * FROM ExpensesTable"
        do {
            guard let expenses = try datbase?.select(query: query) else{
                return
            }
            presenter?.reloadView(expenses: expenses)
        } catch
        {
            print(error)
        }
        
    }
    
    func insert(expence:Expense) ->Bool {
        let query = "INSERT into ExpensesTable values(\(expence.Id),\(expence.amount),'\(expence.reason)','\(expence.date)')"
        let isAdded:Bool
        do
        {
            guard let isInserted = try datbase?.insert(insertQuery: query) else{return false}
            isAdded = isInserted
        }catch{
            print(error)
            isAdded = false
        }
        return isAdded
    }
    
    func delete(expense: Expense) -> Bool {
        let query = "DELETE FROM ExpensesTable where Id = \(expense.Id)"
         let isDeleted:Bool
        do
        {
            guard let isInserted = try datbase?.delete(qurey: query) else{return false}
            isDeleted = isInserted
        }catch{
            print(error)
            isDeleted = false
        }
        return isDeleted
        
    }
    
    func update(expense: Expense) -> Bool{
        let query = "UPDATE ExpensesTable SET Amount = \(expense.amount),Reason = '\(expense.reason)',AddedDate = '\(expense.date)' WHERE ID = \(expense.Id) "
         let isUpdate:Bool
        do
        {
            guard let isInserted = try datbase?.delete(qurey: query) else{return false}
            isUpdate = isInserted
        }catch{
            print(error)
            isUpdate = false
        }
        return isUpdate
        
    }

    
    func search(query:String) {
        
        do {
            guard let expenses = try datbase?.select(query: query) else{
                return
            }
            
            presenter?.reloadView(expenses: expenses)
        } catch
        {
            print(error)
        }
    }
    
    func dropTable(){
        
        let query = "DROP TABLE ExpensesTable "
        do {
            guard let expenses = try datbase?.drop(qurey: query) else{
                return
            }
         
         print(expenses)
           // presenter?.reloadView(expenses: expenses)
        } catch
        {
            print(error)
        }
        
    }

}

//MARK: - Singleline querys
// let query = "SELECT * FROM ExpensesTable WHERE Amount is NULL"  - isEmpty
// let query = "SELECT * FROM ExpensesTable WHERE Amount Not NULL" - Not Empty
// let query = "SELECT * FROM ExpensesTable WHERE <columnName> Like <value>" - like
// let query  = "SELECT * FROM ExpensesTable WHERE <columnName> is <value>" - is
// let query  = "SELECT * FROM ExpensesTable WHERE <columnName> is not <value>" - isNot
// let query = "SELECT * FROM ExpensesTable WHERE <columnName> like '%<value>'" - endWith
// let query = "SELECT * FROM ExpensesTable WHERE <columnName> like '<value>%'" - startwith
// let query = "SELECT * FROM ExpensesTable WHERE <columnName> like '%<value>%'" - contain
// let query = "SELECT * FROM ExpensesTable WHERE <columnName> not like '%<value>%'" - Notcontain


//MARK: - Date Query


// let query = "SELECT * FROM ExpensesTable WHERE AddedDate < 'value'" - before
// let query = "SELECT * FROM ExpensesTable WHERE AddedDate > 'value'" - after
// let query = ""SELECT * FROM ExpensesTable WHERE AddedDate = 'value'" - yesturday,toomarrow,current date
// let query = "SELECT * FROM ExpensesTable WHERE AddedDate like '%<value>%'" - last,current ,next month or year
// let query = "SELECT * FROM ExpensesTable WHERE AddedDate BETWEEN <'startDate'> AND <'endDate'>" - for other date quries
// let query = "SELECT * FROM ExpensesTable WHERE AddedDate BETWEEN <'startDateLastWeek'> AND <'endDateCurrentWeek'>" - for last and current week or month or year
