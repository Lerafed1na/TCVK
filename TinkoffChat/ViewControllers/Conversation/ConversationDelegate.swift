//
//  ConversationDelegate.swift
//  TinkoffChat
//
//  Created by Valeriia Korenevich on 28/03/2019.
//  Copyright © 2019 Valeriia Korenevich. All rights reserved.
//

import Foundation

protocol ConversationDelegate: class {
    func reloadData()
    func lockTheSendButton()
}
