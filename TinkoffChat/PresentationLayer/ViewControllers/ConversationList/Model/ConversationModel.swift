//
//  ConversationModel.swift
//  TinkoffChat
//
//  Created by Valeriia Korenevich on 22/02/2019.
//  Copyright © 2019 Valeriia Korenevich. All rights reserved.
//

import Foundation
import UIKit

class ConversationModel: ConversationsCellConfiguration {

    var userId: String
    var name: String?
    var message: String?
    var messages: [MessageModel]
    var date: Date?
    var online: Bool = false
    var hasUnreadMessages: Bool = false
    var userImage: String?

    init(userId: String, online: Bool, hasUnreadMessages: Bool, name: String? = nil, message: String? = nil, messages: [MessageModel], date: Date? = nil, userImage: String?) {
        self.userId = userId
        self.online = online
        self.hasUnreadMessages = hasUnreadMessages
        self.name = name
        self.message = message
        self.messages = messages
        self.date = date
        self.userImage = userImage
    }

    class func sortConversationsByDate(first: ConversationModel, second: ConversationModel) -> Bool {

        if let first = first.date, let second = second.date {
            return first > second
        } else if first.date != second.date && (first.date == nil || second.date == nil) {
            return first.date ?? Date.distantPast > second.date ?? Date.distantPast
        } else if let firstName = first.name, let secondName = second.name {
            if first.date == nil || second.date == nil {
                return firstName < secondName
            }
        }
        return true
    }

}
