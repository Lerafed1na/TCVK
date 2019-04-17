//
//  CoreAssembly.swift
//  TinkoffChat
//
//  Created by Valeriia Korenevich on 12/04/2019.
//  Copyright © 2019 Valeriia Korenevich. All rights reserved.
//

import Foundation

protocol ICoreAssembly {
    var coreDataStack: CoreDataStack { get }
    var communicator: Communicator { get }
    var conversationRequester: IFRConversationManager { get }
    var userRequester: IFRUserManager { get }
    var messageRequester: IFRMessageManager { get }
}

class CoreAssembly: ICoreAssembly {
    lazy var coreDataStack: CoreDataStack = CoreDataStack.shared
    lazy var communicator: Communicator = MultipeerCommunicator()
    lazy var conversationRequester: IFRConversationManager = FRConversationManager.shared
    lazy var userRequester: IFRUserManager = FRUserManager.shared
    lazy var messageRequester: IFRMessageManager = FRMessageManager.shared
}
