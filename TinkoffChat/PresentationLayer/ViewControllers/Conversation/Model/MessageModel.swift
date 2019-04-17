//
//  MessageModel.swift
//  TinkoffChat
//
//  Created by Valeriia Korenevich on 11/04/2019.
//  Copyright © 2019 Valeriia Korenevich. All rights reserved.
//

import Foundation

class MessageModel: MessageCellConfiguration {
    var textMessage: String?
    var isIncoming: Bool
    
    init(textMessage: String, isIncoming: Bool) {
        self.textMessage = textMessage
        self.isIncoming = isIncoming
    }
}
