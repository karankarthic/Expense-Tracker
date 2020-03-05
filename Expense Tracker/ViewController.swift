//
//  ViewController.swift
//  Expense Tracker
//
//  Created by Karan Karthic on 03/03/20.
//  Copyright © 2020 Karan Karthic. All rights reserved.
//

import UIKit

struct Expense {
    
    let Id:Int
    let amount:Int
    let date:String
    let reason:String
}

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        self.navigationItem.title = "Expenses Tracker"
        
//        let fileManager = FileManager.default
//        var path = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
//
//        path.appendPathComponent("Expenses.sqlite")
//
//        fileManager.createFile(atPath:path.path , contents: nil, attributes: .none)
        
        let vc = Router.createModule()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            self.navigationController?.pushViewController(vc, animated: true)
        }
        

    }
    
}
