//
//  ViewController.swift
//  TinkoffChat
//
//  Created by Valeriia Korenevich on 07/02/2019.
//  Copyright © 2019 Valeriia Korenevich. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        printStateName()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        printStateName()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
         printStateName()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
         printStateName()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
         printStateName()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
         printStateName()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        printStateName()
    }
    
    func printStateName(string: String = #function) {
        ChatLog.printLog("\(string)")
    }

}

