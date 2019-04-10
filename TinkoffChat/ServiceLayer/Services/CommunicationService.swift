//
//  CommunicationManager.swift
//  TinkoffChat
//
//  Created by Valeriia Korenevich on 17/03/2019.
//  Copyright © 2019 Valeriia Korenevich. All rights reserved.
//

import UIKit
import MultipeerConnectivity

protocol ICommunicatorDelegate: class {
    //discovering
    func didFoundUser(userID: String, userName: String?)
    func didLostUser(userID: String)
    
    //errors
    func failedToStartBrowsingForUsers(error: Error)
    func failedToStartAdvertising(error: Error)
    
    //messages
    func didRecieveMessage(text: String, fromUser: String, toUser: String)
}

class CommunicationService: ICommunicatorDelegate {
    
    static let shared = CommunicationService.self
    
    private let storageManager: IStorageManager
    var communicator: ICommunicator!
    
    init(storageManager: IStorageManager, communicator: ICommunicator) {
        self.storageManager = storageManager
        self.communicator = communicator
        self.communicator.delegate = self
    }
    
    func didFoundUser(userID: String, userName: String?) {
        storageManager.appendConversation(userID: userID,
                                          userName: userName)
    }
    
    func didLostUser(userID: String) {
        storageManager.makeConversationOffline(userId: userID)
    }
    
    func didRecieveMessage(text: String, fromUser: String, toUser: String) {
       storageManager.appendMessage(text: text,
                                    fromUser: fromUser,
                                    toUser: toUser)
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
