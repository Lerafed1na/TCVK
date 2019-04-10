//
//  UserFetchRequester.swift
//  TinkoffChat
//
//  Created by Valeriia Korenevich on 09/04/2019.
//  Copyright © 2019 Valeriia Korenevich. All rights reserved.
//

import Foundation
import CoreData

protocol IUserFetchRequester: class {
    func fetchUsersOnline() -> NSFetchRequest<User>
    func fetchUserByID(id: String) -> NSFetchRequest<User>
}

class UserFetchRequester: IUserFetchRequester {
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
