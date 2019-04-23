//
//  FRMessageManager.swift
//  TinkoffChat
//
//  Created by Valeriia Korenevich on 11/04/2019.
//  Copyright © 2019 Valeriia Korenevich. All rights reserved.
//

import Foundation
import CoreData

protocol IFRMessageManager {
    func fetchMessagesBy(conversationID: String) -> NSFetchRequest<Message>
}

class FRMessageManager: IFRMessageManager {
    static let shared = FRMessageManager()

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
