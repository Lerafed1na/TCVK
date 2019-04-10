//
//  FRManager.swift
//  TinkoffChat
//
//  Created by Valeriia Korenevich on 10/04/2019.
//  Copyright © 2019 Valeriia Korenevich. All rights reserved.
//

import Foundation
import CoreData

class FRManager {
    
    static let shared = FRManager()
    
    func fetchConversations() -> NSFetchRequest<Conversation> {
        let request: NSFetchRequest<Conversation> = Conversation.fetchRequest()
        let dateSortDescriptor = NSSortDescriptor(key: "date",
                                                  ascending: false)
        let onlineSortDescriptor = NSSortDescriptor(key: "isOnline",
                                                    ascending: false)
        request.sortDescriptors = [onlineSortDescriptor,
                                   dateSortDescriptor]
        return request
    }
    
    func fetchConversationsOnline() -> NSFetchRequest<Conversation> {
        let request: NSFetchRequest<Conversation> = Conversation.fetchRequest()
        request.predicate = NSPredicate(format: "isOnline == YES")
        return request
    }
    
    func fetchConversationBy(id: String) -> NSFetchRequest<Conversation> {
        let request: NSFetchRequest<Conversation> = Conversation.fetchRequest()
        request.predicate = NSPredicate(format: "conversationId == %@",
                                        id)
        return request
    }
    
    func fetchUsersOnline() -> NSFetchRequest<User> {
        let request: NSFetchRequest<User> = User.fetchRequest()
        request.predicate = NSPredicate(format: "isOnline == YES")
        return request
    }
    
    func fetchUserByID(id: String) -> NSFetchRequest<User> {
        let request: NSFetchRequest<User> = User.fetchRequest()
        request.predicate = NSPredicate(format: "userId == %@",
                                        id)
        return request
    }
    
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
