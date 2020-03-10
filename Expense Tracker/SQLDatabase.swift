//
//  SQLDatabase.swift
//  Expense Tracker
//
//  Created by Karan Karthic on 03/03/20.
//  Copyright © 2020 Karan Karthic. All rights reserved.
//

import Foundation
import SQLite3


enum SQLiteError: Error {
  case OpenDatabase(message: String)
  case Prepare(message: String)
  case Step(message: String)
  case Bind(message: String)
}

class SQLiteDatabase {
    
    var dbPointer: OpaquePointer? = nil
    
    init(dbPath: String )throws {
    
    var dbPointer : OpaquePointer? = nil
    
        guard sqlite3_open(dbPath, &dbPointer) == SQLITE_OK , let _ = dbPointer else{
            defer {
                if dbPointer != nil {
                    sqlite3_close(dbPointer)
                    //print("hi")
                }
            }
            let errorMessage = String(cString: sqlite3_errmsg(dbPointer))
            print(errorMessage)
            return
        }
        guard let db = dbPointer else{
            throw SQLiteError.OpenDatabase(message: "db is nil")
        }
        
        self.dbPointer = db
        //print("opened")
  }
   
    deinit {
      sqlite3_close(dbPointer)
    }
    
    func prepareStatement(sql: String) throws -> OpaquePointer? {
     var statement: OpaquePointer?
     guard sqlite3_prepare_v2(dbPointer, sql, -1, &statement, nil) == SQLITE_OK else {
       throw SQLiteError.Prepare(message: "error while preaparing statement")
     }
     return statement
    }
    
    func createTabel(tabelQuery:String) throws{
        
        let createTableStatement = try prepareStatement(sql: tabelQuery)
        
        defer {
            sqlite3_finalize(createTableStatement)
        }
        
        guard sqlite3_step(createTableStatement) == SQLITE_DONE else {
          throw SQLiteError.Step(message: "error on creating table")
        }
        
//         print("table created.")
    }
    
    func insert(insertQuery:String) throws -> Bool
    {
        let insertStatement = try prepareStatement(sql: insertQuery)

        defer {
            sqlite3_finalize(insertStatement)
        }
        
        guard sqlite3_step(insertStatement) == SQLITE_DONE else {
          throw SQLiteError.Step(message: "error on insert ")
        }

//         print("inserted.")
        return true
    }
    
    func delete(qurey:String) throws -> Bool {
        let insertStatement = try prepareStatement(sql: qurey)

        defer {
            sqlite3_finalize(insertStatement)
        }
        
        guard sqlite3_step(insertStatement) == SQLITE_DONE else {
          throw SQLiteError.Step(message: "error on insert ")
        }

//         print("deleted.")
        return true
        
    }
    
    func drop(qurey:String) throws{
        let stmt = try prepareStatement(sql: qurey)

        defer {
            sqlite3_finalize(stmt)
        }
        
        guard sqlite3_step(stmt) == SQLITE_DONE else {
          throw SQLiteError.Step(message: "error on insert ")
        }

//         print("dropped.")
        
    }
    
    func select(query:String) throws -> [Expense]{
        
        let queryStatement = try prepareStatement(sql: query)
        
        defer {
            sqlite3_finalize(queryStatement)
        }
        
        var qureyResult = sqlite3_step(queryStatement)
        var expenses = [Expense]()
        while qureyResult == SQLITE_ROW {
            
            let columnCount = sqlite3_column_count(queryStatement)
            var rowValue = [String:Any]()
            for index in 0..<columnCount{
                var value:Any
                let columnType = sqlite3_column_type(queryStatement, index)
                let columName = String(cString: sqlite3_column_name(queryStatement, index)!)
                switch columnType {
                case SQLITE_INTEGER:
                    let amount = sqlite3_column_int64(queryStatement, index)
                    value = Int(amount)
                case SQLITE_TEXT:
                    let cString = sqlite3_column_text(queryStatement, index)
                    var text = ""
                    if cString != nil {
                        text = String(cString: sqlite3_column_text(queryStatement, index))
                    }
                    value = text
                    
                default:
                    return []
                }
                rowValue[columName] = value
            }
            expenses.append(getExpenseFromDict(rowValue))
            qureyResult = sqlite3_step(queryStatement)
        }
        //print(expenses)
        return expenses
    }
    
    func getExpenseFromDict(_ dict:[String:Any]) -> Expense
    {
       guard let id = dict["Id"] as? Int, let amount = dict["Amount"] as? Int , let reason = dict["Reason"] as? String , let date = dict["AddedDate"] as? String
        else{
            return Expense(Id: 0, amount: 0, date: "", reason: "")
        }
        
        return Expense(Id: id, amount:amount , date: date, reason: reason)
    }
    
}


