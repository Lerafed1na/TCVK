//
//  User.swift
//  TinkoffChat
//
//  Created by Valeriia Korenevich on 02/04/2019.
//  Copyright © 2019 Valeriia Korenevich. All rights reserved.
//

import Foundation
import CoreData

extension User {
    static func insertUserWith(id: String, in context: NSManagedObjectContext) -> User {
        guard let user = NSEntityDescription.insertNewObject(forEntityName: "User",
                                                             into: context) as? User else {
            fatalError("Can't insert User")
        }
        user.userId = id
        return user
    }
    static func findOrInsertUser(id: String, in context: NSManagedObjectContext) -> User? {
        let request = FRUserManager.shared.fetchUserByID(id: id)
        do {
            let users = try context.fetch(request)
            assert(users.count < 2, "Users with id \(id) more than 1")
            if !users.isEmpty {
                return users.first!
            } else {
                return User.insertUserWith(id:id,
                                           in: context)
            }
        } catch {
            assertionFailure("Can't fetch users")
            return nil
        }
    }
}
