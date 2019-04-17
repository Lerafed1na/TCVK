//
//  FRUserManager.swift
//  TinkoffChat
//
//  Created by Valeriia Korenevich on 11/04/2019.
//  Copyright © 2019 Valeriia Korenevich. All rights reserved.
//

import Foundation
import CoreData

protocol IFRUserManager {
    func fetchUsersOnline() -> NSFetchRequest<User>
    func fetchUserByID(id: String) -> NSFetchRequest<User>
}

class FRUserManager: IFRUserManager {
    static let shared = FRUserManager()
    func fetchUsersOnline() -> NSFetchRequest<User> {
        let request: NSFetchRequest<User> = User.fetchRequest()
        request.predicate = NSPredicate(format: "isOnline == YES")
        return request
    }
    
    func fetchUserByID(id: String) -> NSFetchRequest<User> {
        let request: NSFetchRequest<User> = User.fetchRequest()
        request.predicate = NSPredicate(format: "userId == %@",
                                        id)
        return request
    }
}
