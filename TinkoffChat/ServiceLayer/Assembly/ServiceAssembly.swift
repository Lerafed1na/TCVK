//
//  ServiceAssembly.swift
//  TinkoffChat
//
//  Created by Valeriia Korenevich on 12/04/2019.
//  Copyright © 2019 Valeriia Korenevich. All rights reserved.
//

import Foundation

protocol IServiceAssembly {
   // var profileDataManager: IUserCoreDataManager { get }
    var communicatorService: CommunicatorDelegate { get }
}

class ServiceAssembly: NSObject, IServiceAssembly {
    
    var coreAssembly: ICoreAssembly
    
    init(coreAssembly: ICoreAssembly) {
        self.coreAssembly = coreAssembly
    }
    //lazy var profileDataManager: IUserCoreDataManager = UserCoreDataService(coreDataStack: coreAssembly.coreDataStack)
    var communicatorService: CommunicatorDelegate = CommunicationService.shared
    
}
