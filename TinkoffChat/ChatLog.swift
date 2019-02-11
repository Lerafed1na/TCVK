//
//  ChatLog.swift
//  TinkoffChat
//
//  Created by Valeriia Korenevich on 11/02/2019.
//  Copyright © 2019 Valeriia Korenevich. All rights reserved.
//

import Foundation

class ChatLog {
    
    public class func printLog(_ log: String) {
        // If equal "1" - print(log), if everything else - doesn't.
        if ProcessInfo.processInfo.environment["MyApp_log_level"] == "1" {
            print(log)
        }
    }
}
