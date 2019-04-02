//
//  ConversationsListDelegate.swift
//  TinkoffChat
//
//  Created by Valeriia Korenevich on 02/04/2019.
//  Copyright © 2019 Valeriia Korenevich. All rights reserved.
//

import Foundation

protocol ConversationsListDelegate: class {
    
    func reloadData()
    func sortConverstionData()
}
