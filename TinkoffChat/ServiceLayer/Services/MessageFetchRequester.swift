//
//  MessageFetchRequester.swift
//  TinkoffChat
//
//  Created by Valeriia Korenevich on 09/04/2019.
//  Copyright © 2019 Valeriia Korenevich. All rights reserved.
//

import Foundation
import CoreData

protocol IMessageFetchRequester: class {
    func fetchMessagesBy(conversationID: String) -> NSFetchRequest<Message>
}

class MessageFetchRequester: IMessageFetchRequester {
    func fetchMessagesBy(conversationID: String) -> NSFetchRequest<Message> {
        let request: NSFetchRequest<Message> = Message.fetchRequest()
        request.predicate = NSPredicate(format: "conversationId == %@",
                                        conversationID)
        let sort = NSSortDescriptor(key: "date",
                                    ascending: true)
        request.sortDescriptors = [sort]
        return request
    }
}
