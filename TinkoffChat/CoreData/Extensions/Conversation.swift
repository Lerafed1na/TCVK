//
//  Conversation.swift
//  TinkoffChat
//
//  Created by Valeriia Korenevich on 02/04/2019.
//  Copyright © 2019 Valeriia Korenevich. All rights reserved.
//

import Foundation
import CoreData

extension Conversation {

    static func insertConversationBy(id: String, in context: NSManagedObjectContext) -> Conversation {
        guard let conversation = NSEntityDescription.insertNewObject(forEntityName: "Conversation", into: context) as? Conversation else {
            fatalError("Can't insert Conversation")
        }
        conversation.conversationId = id
        return conversation
    }

    static func findConversationBy(id: String, in context: NSManagedObjectContext) -> Conversation? {
        let fetchConversationById = FRManager.shared.fetchConversationBy(id: id)
        do {
            let conversationsWithId = try context.fetch(fetchConversationById)
            assert(conversationsWithId.count < 2, "Conversations with id: \(id) more than one")
            if !conversationsWithId.isEmpty {
                let conversation = conversationsWithId.first!
                return conversation
            } else {
                return nil
            }
        } catch {
            assertionFailure("Can't fetch conversations")
            return nil
        }
    }

    static func findOnlineConversations(in context: NSManagedObjectContext) -> [Conversation]? {
        let fetchRequest = FRManager.shared.fetchConversationsOnline()
        do {
            let conversations = try context.fetch(fetchRequest)
            return conversations
        } catch {
            assertionFailure("Can't fetch conversations")
            return nil
        }
    }

    static func findOrInsertConversationBy(id: String, in context: NSManagedObjectContext) -> Conversation {
        guard let conversation = Conversation.findConversationBy(id: id,
                                                                 in: context) else {
            return Conversation.insertConversationBy(id: id,
                                                     in: context)
        }
        return conversation
    }

}
