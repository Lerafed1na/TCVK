//
//  CoreAssembly.swift
//  TinkoffChat
//
//  Created by Valeriia Korenevich on 07/04/2019.
//  Copyright © 2019 Valeriia Korenevich. All rights reserved.
//

import Foundation

protocol ICoreAssembly {
    var coreDataStack: CoreDataStack { get }
    var multipeerCommunicator: ICommunicator { get }
    var storageManager: IStorageManager { get }
}

class CoreAssembly: ICoreAssembly {
    var storageManager: IStorageManager = StorageManager()
    lazy var coreDataStack: CoreDataStack = CoreDataStack()
    lazy var multipeerCommunicator: ICommunicator = MultipeerCommunicator()
    
}
