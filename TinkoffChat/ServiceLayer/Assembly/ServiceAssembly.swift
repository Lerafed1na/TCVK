//
//  ServiceAssembly.swift
//  TinkoffChat
//
//  Created by Valeriia Korenevich on 07/04/2019.
//  Copyright © 2019 Valeriia Korenevich. All rights reserved.
//

import Foundation

protocol IServiceAssembly {
    var frcMessageService: IMessageFetchRequester { get }
    var frcUserService: IUserFetchRequester { get }
    var frcConversationService: IConversationFetchRequester { get }
    var communicationService: ICommunicatorDelegate { get }
}

class ServiceAssembly: IServiceAssembly {
    
    private let coreAssembly: ICoreAssembly
    
    init(coreAssembly: ICoreAssembly) {
        self.coreAssembly = coreAssembly
    }
    
    lazy var frcMessageService: IMessageFetchRequester = MessageFetchRequester()
    lazy var frcUserService: IUserFetchRequester = UserFetchRequester()
    lazy var frcConversationService: IConversationFetchRequester = ConversationFetchRequester()
    lazy var communicationService: ICommunicatorDelegate = CommunicationService(storageManager: coreAssembly.storageManager,
                                                                                communicator: coreAssembly.multipeerCommunicator)
}
