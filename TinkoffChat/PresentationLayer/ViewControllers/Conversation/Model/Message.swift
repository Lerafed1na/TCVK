//
//  Message.swift
//  TinkoffChat
//
//  Created by Valeriia Korenevich on 02/04/2019.
//  Copyright © 2019 Valeriia Korenevich. All rights reserved.
//

import Foundation
import CoreData

extension Message {
    
    static func insertNewMessage(in context: NSManagedObjectContext) -> Message {
        guard let message = NSEntityDescription.insertNewObject(forEntityName: "Message",
                                                                into: context) as? Message else {
            fatalError("Can't create Message entry")
        }
        return message
    }
    
    static func findMessagesBy(conversationId: String, in context: NSManagedObjectContext) -> [Message]? {
        let request = FRMessageManager.shared.fetchMessagesBy(conversationID: conversationId)
        do {
            let messages = try context.fetch(request)
            return messages
        } catch {
            assertionFailure("Can't fetch messages")
            return nil
        }
    }
}
