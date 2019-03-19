//
//  CommunicationManager.swift
//  TinkoffChat
//
//  Created by Valeriia Korenevich on 17/03/2019.
//  Copyright © 2019 Valeriia Korenevich. All rights reserved.
//


import UIKit

class CommunicationManager: CommunicatorDelegate {
    
    
    var conversations: [String: [ConversationModel]] = [:]
    
    init() {
        conversations["online"] = [ConversationModel]()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(sortConversationDate),
                                               name: Notification.Name("ConversationListSortDate"),
                                               object: nil)
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self,
                                                  name: Notification.Name("ConversationListSortDate"),
                                                  object: nil)
    }
    
    @objc func sortConversationDate() {
        conversations["online"]?.sort(by: ConversationModel.sortConversationsByDate)
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
        
        NotificationCenter.default.post(name: Notification.Name("ConversationListSortDate"),
                                        object: nil)
        NotificationCenter.default.post(name: Notification.Name("ConversationsListReloadData"),
                                        object: nil)
    }
    
    func didLostUser(userID: String) {
        if let index = conversations["online"]?.index(where: {(item) -> Bool in item.userId == userID}) {
            conversations["online"]?.remove(at: index)
            
            NotificationCenter.default.post(name: Notification.Name("ConversationsListReloadData"),
                                            object: nil)
            
            NotificationCenter.default.post(name: Notification.Name("ConversationSendOff"),
                                            object: nil)
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
            
            NotificationCenter.default.post(name: Notification.Name("ConversationListSortDate"),
                                            object: nil)
            NotificationCenter.default.post(name: Notification.Name("ConversationsListReloadData"),
                                            object: nil)
            NotificationCenter.default.post(name: Notification.Name("ConversationReloadData"),
                                            object: nil)
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
