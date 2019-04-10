//
//  StorageManager.swift
//  TinkoffChat
//
//  Created by Valeriia Korenevich on 07/04/2019.
//  Copyright © 2019 Valeriia Korenevich. All rights reserved.
//

import Foundation
import UIKit

protocol IStorageManager: class {
    func appendConversation(userID: String, userName: String?)
    func appendMessage(text: String, fromUser: String, toUser: String)
    func readProfileData(completion: @escaping (Profile) -> Void)
    func saveProfileData(profile: Profile, completion: @escaping (Error?) -> Void)
    func makeConversationOffline(userId: String)
}

class StorageManager: IStorageManager {
    
    private let coreDataStack = CoreDataStack.shared
    
    func appendConversation(userID: String, userName: String?) {
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
    }
    
    func appendMessage(text: String, fromUser: String, toUser: String) {
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
    
    func makeConversationOffline(userId: String) {
        let saveContext = CoreDataStack.shared.saveContext
        saveContext.perform {
            let conversation = Conversation.findOrInsertConversationBy(id: userId, in: saveContext)
            conversation.isOnline = false
            CoreDataStack.shared.performSave(context: saveContext, completion: nil)
        }
        
    }
    
    func saveProfileData(profile: Profile, completion: @escaping (Error?) -> Void) {
        let saveContext = coreDataStack.saveContext
        saveContext.perform {
            let appUser = AppUser.findOrInsertAppUser(in: saveContext)
            
            appUser?.name = profile.name
            appUser?.info = profile.info
            appUser?.image = profile.image.pngData()
            
            self.coreDataStack.performSave(context: saveContext) { (error) in
                DispatchQueue.main.async {
                    completion(error)
                }
            }
            
        }
    }
    
    func readProfileData(completion: @escaping (Profile) -> Void) {
        let mainContext = self.coreDataStack.mainContext
        mainContext.perform {
            let appUser = AppUser.findOrInsertAppUser(in: mainContext)
            
            let profile: Profile
            
            let name = appUser?.name ?? ""
            let info = appUser?.info ?? ""
            
            let image: UIImage
            if let imageData = appUser?.image {
                image = UIImage(data: imageData) ?? UIImage(named: "placeholder-user")!
            } else {
                image = UIImage(named: "placeholder-user")!
            }
            
            profile = Profile(name: name,
                              info: info,
                              image: image)
            
            DispatchQueue.main.async {
                completion(profile)
            }
        }
        
    }
    
}

