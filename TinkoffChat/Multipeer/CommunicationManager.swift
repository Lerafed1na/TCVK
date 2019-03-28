//
//  CommunicationManager.swift
//  TinkoffChat
//
//  Created by Valeriia Korenevich on 17/03/2019.
//  Copyright © 2019 Valeriia Korenevich. All rights reserved.
//


import UIKit

class CommunicationManager: CommunicatorDelegate {
    
    
    var conversationsListDelegate: ConversationsListDelegate?
    var conversationDelegate: ConversationDelegate?

    var conversations: [String: [ConversationModel]] = [:]
    
    init() {
        conversations["online"] = [ConversationModel]()
    }
    
    func didFoundUser(userID: String, userName: String?) {
        guard conversations["online"]?.index(where: {(item) -> Bool in item.userId == userID}) == nil else {
            return
        }
        
        conversations["online"]?.append(ConversationModel(userId: userID,
                                                          online: true,
                                                          hasUnreadMessages: false,
                                                          name: userName,
                                                          messages: [MessageModel](),
                                                          userImage: "placeholder-user"))
        conversations["online"]?.sort(by: ConversationModel.sortConversationsByDate)
        conversationsListDelegate?.reloadData()
    }
    
    func didLostUser(userID: String) {
        if let index = conversations["online"]?.index(where: {(item) -> Bool in item.userId == userID}) {
            conversations["online"]?.remove(at: index)
            
            conversationsListDelegate?.reloadData()
            conversationDelegate?.lockTheSendButton()
        }
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
    
    func didRecieveMessage(text: String, fromUser: String, toUser: String) {
        guard var conversationsOnline = conversations["online"] else {
            return
        }
        if let index = conversationsOnline.index(where: {(item) -> Bool in item.userId == fromUser}) {
          conversationsOnline[index].messages.append(MessageModel(textMessage: text, isIncoming: true))
            conversationsOnline[index].date = Date()
            conversationsOnline[index].hasUnreadMessages = true
            conversationsOnline[index].message = conversationsOnline[index].messages.first?.textMessage
            
            conversations["online"]?.sort(by: ConversationModel.sortConversationsByDate)
            conversationDelegate?.reloadData()
            conversationsListDelegate?.reloadData()
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
}
