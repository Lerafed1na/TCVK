//
//  CommunicationManager.swift
//  TinkoffChat
//
//  Created by Valeriia Korenevich on 17/03/2019.
//  Copyright © 2019 Valeriia Korenevich. All rights reserved.
//

import UIKit
import MultipeerConnectivity

protocol ManagerDelegate: class {
    // Manager delegation functions:
    //func globalUpdate()
    func updateConversationInfo()
}

protocol CommunicatorDelegate: class {
    //discovering
    func didFoundUser(userID: String, userName: String?)
    func didLostUser(userID: String)

    //errors
    func failedToStartBrowsingForUsers(error: Error)
    func failedToStartAdvertising(error: Error)

    //messages
    func didRecieveMessage(text: String, fromUser: String, toUser: String)
}

class CommunicationService: CommunicatorDelegate {

    static let shared = CommunicationService()
    var multipeerCommunicator: MultipeerCommunicator!
    weak var delegate: ManagerDelegate!
    //var conversations: [String: [ConversationModel]] = [:]

    private init() {
        self.multipeerCommunicator = MultipeerCommunicator()
        self.multipeerCommunicator.delegate = self
    }

    func didFoundUser(userID: String, userName: String?) {

        print("User found")
        let saveContext = CoreDataStack.shared.saveContext
        saveContext.perform {
            guard let user = User.findOrInsertUser(id: userID,
                                                   in: saveContext) else { return }
            let conversation = Conversation.findOrInsertConversationBy(id: userID,
                                                                       in: saveContext)
            conversation.user = user
            user.name = userName
            conversation.isOnline = true
            CoreDataStack.shared.performSave(context: saveContext,
                                             completion: nil)
        }
        DispatchQueue.main.async {
            self.delegate.updateConversationInfo()
        }
    }

    func didLostUser(userID: String) {
        let saveContext = CoreDataStack.shared.saveContext
        saveContext.perform {
            let conversation = Conversation.findOrInsertConversationBy(id: userID, in: saveContext)
            conversation.isOnline = false
            CoreDataStack.shared.performSave(context: saveContext, completion: nil)
        }
        DispatchQueue.main.async {
            self.delegate.updateConversationInfo()
        }
    }

    func didRecieveMessage(text: String, fromUser: String, toUser: String) {
        let saveContext = CoreDataStack.shared.saveContext
        saveContext.perform {
            let message: Message
            if let conversation = Conversation.findConversationBy(id: fromUser, in: saveContext) {
                message = Message.insertNewMessage(in: saveContext)
                message.isIncoming = true
                message.conversationId = conversation.conversationId
                message.text = text
                conversation.date = Date()
                message.date = Date()
                conversation.hasUnreadMessage = true
                conversation.addToMessages(message)
                conversation.lastMessage = message
            } else if let conversation = Conversation.findConversationBy(id: toUser, in: saveContext) {
                message = Message.insertNewMessage(in: saveContext)
                message.isIncoming = false
                message.conversationId = conversation.conversationId
                message.text = text
                conversation.date = Date()
                message.date = Date()
                conversation.hasUnreadMessage = false
                conversation.addToMessages(message)
                conversation.lastMessage = message
            }
            CoreDataStack.shared.performSave(context: saveContext, completion: nil)
        }
    }

    func failedToStartBrowsingForUsers(error: Error) {
        let alertController = UIAlertController(title: "Error",
                                                message: error.localizedDescription,
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Done",
                                                style: .cancel))
        alertController.present(alertController,
                                animated: true,
                                completion: nil)
    }

    func failedToStartAdvertising(error: Error) {
        let alertController = UIAlertController(title: "Error",
                                                message: error.localizedDescription,
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Done",
                                                style: .cancel))
        alertController.present(alertController,
                                animated: true,
                                completion: nil)
    }
}
