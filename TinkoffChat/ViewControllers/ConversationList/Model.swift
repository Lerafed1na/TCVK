//
//  Model.swift
//  TinkoffChat
//
//  Created by Valeriia Korenevich on 22/02/2019.
//  Copyright © 2019 Valeriia Korenevich. All rights reserved.
//

import Foundation
import UIKit

class ConversationModel: ConversationsCellConfiguration {
    var name: String?
    var message: String?
    var date: Date?
    var online: Bool = false
    var hasUnreadMessages: Bool = false
    var userImage: String?
    
    init(online: Bool, hasUnreadMessages: Bool, name: String? = nil, message: String? = nil, date: Date? = nil, userImage: String?) {
        self.online = online
        self.hasUnreadMessages = hasUnreadMessages
        self.name = name
        self.message = message
        self.date = date
        self.userImage = userImage
    }
}

class DataSource {
    
    static let conversetions: [ConversationModel] = [
    ConversationModel(
        online: true,
        hasUnreadMessages: true,
        name: "Jack",
        message: "How are you?",
        date: Calendar.current.date(byAdding: .day, value: -1, to: Date()),
        userImage: "Lera"),
    ConversationModel(
        online: false,
        hasUnreadMessages: true,
        name: "Lara",
        message: "What are you doing?What are you doing?What are you doing?What are you doing?What are you doing?What are you doing?What are you doing?What are you doing?What are you doing?What are you doing?What are you doing?What are you doing?What are you doing?What are you doing?What are you doing?What are you doing?",
        date: Calendar.current.date(byAdding: .month, value: -2, to: Date()),
        userImage: "Opra"),
    ConversationModel(
        online: true,
        hasUnreadMessages: false,
        name: "Rayan",
        message: nil,
        date: Calendar.current.date(byAdding: .hour, value: -8, to: Date()),
        userImage: "Rayan"),
    ConversationModel(
        online: true,
        hasUnreadMessages: true,
        name: "Rassel",
        message: "Please, buy some food!",
        date: Calendar.current.date(byAdding: .hour, value: -4, to: Date()),
        userImage: "Rassel"),
    ConversationModel(
        online: true,
        hasUnreadMessages: false,
        name: "Kate",
        message: nil,
        date: nil,
        userImage: "Kate"),
    ConversationModel(
        online: false,
        hasUnreadMessages: false,
        name: "Farrel",
        message: "Because I am happy!",
        date: Date(),
        userImage: "Farrel"),
    ConversationModel(
        online: false,
        hasUnreadMessages: false,
        name: "Sofi",
        message: "Hey!",
        date: Calendar.current.date(byAdding: .minute, value: -40, to: Date()),
        userImage: "Sofi"),
    ConversationModel(
        online: false,
        hasUnreadMessages: false,
        name: "Mishel",
        message: nil,
        date: nil,
        userImage: nil),
    ConversationModel(
        online: true,
        hasUnreadMessages: false,
        name: "Piter",
        message: "Happy Birthday to you Piter!",
        date: Calendar.current.date(byAdding: .minute, value: -88, to: Date()),
        userImage: nil),
    ConversationModel(
        online: true,
        hasUnreadMessages: false,
        name: "Ashly",
        message: "Axaxaxaxaxxaxaxaxaxax",
        date: Calendar.current.date(byAdding: .day, value: -8, to: Date()),
        userImage: "Ashly"),
    ConversationModel(
        online: true,
        hasUnreadMessages: false,
        name: "Robert",
        message: "😆😆😆😆😆😆",
        date: Calendar.current.date(byAdding: .hour, value: -18, to: Date()),
        userImage: "Robert"),
    ConversationModel(
        online: true,
        hasUnreadMessages: true,
        name: "Tom",
        message: "22:00",
        date: Calendar.current.date(byAdding: .minute, value: -20, to: Date()),
        userImage: "Tom"),
    ConversationModel(
        online: true,
        hasUnreadMessages: false,
        name: "Bred",
        message: nil,
        date: nil,
        userImage: nil),
    ConversationModel(
        online: true,
        hasUnreadMessages: false,
        name: "Lilly",
        message: "I moved to New York city, baby!",
        date: Calendar.current.date(byAdding: .day, value: -1, to: Date()),
        userImage: "Lilly"),
    ConversationModel(
        online: false,
        hasUnreadMessages: false,
        name: "Michael",
        message: "Do you want it that?",
        date: Calendar.current.date(byAdding: .minute, value: -10, to: Date()),
        userImage: "Michael"),
    ConversationModel(
        online: false,
        hasUnreadMessages: true,
        name: "Polly",
        message: "❤️",
        date: Calendar.current.date(byAdding: .minute, value: -11, to: Date()),
        userImage: nil),
    ConversationModel(
            online: false,
            hasUnreadMessages: false,
            name: "Karen",
            message: nil,
            date: nil,
            userImage: "Karen"),
    ConversationModel(
        online: false,
        hasUnreadMessages: true,
        name: "Ben",
        message: "It's friday time!",
        date: Calendar.current.date(byAdding: .day, value: -17, to: Date()),
        userImage: nil),
    ConversationModel(
        online: false,
        hasUnreadMessages: true,
        name: "Alex",
        message: nil,
        date: Calendar.current.date(byAdding: .hour, value: -5, to: Date()),
        userImage: nil),
    ConversationModel(
        online: false,
        hasUnreadMessages: false,
        name: "Ann",
        message: "I like big apples!",
        date: Calendar.current.date(byAdding: .minute, value: -32, to: Date()),
        userImage: "Ann"),
    ConversationModel(
        online: false,
        hasUnreadMessages: true,
        name: "Johny",
        message: "Happy Birthday to you!",
        date: Calendar.current.date(byAdding: .month, value: -7, to: Date()),
        userImage: "Johny"),
    ]
}


