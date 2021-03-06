//
//  UserCoreDataService.swift
//  TinkoffChat
//
//  Created by Valeriia Korenevich on 26/03/2019.
//  Copyright © 2019 Valeriia Korenevich. All rights reserved.
//

import Foundation
import CoreData
import UIKit

protocol IUserCoreDataManager {
    func saveProfileData(profile: Profile, completion: @escaping (Error?) -> Void)
    func readProfileData(completion: @escaping (Profile) -> Void)
}

class UserCoreDataService: NSObject, IUserCoreDataManager {

    private let coreDataStack = CoreDataStack.shared

//    private let coreDataStack: CoreDataStack
//
//    init(coreDataStack: CoreDataStack) {
//        self.coreDataStack = coreDataStack
//    }

    func saveProfileData(profile: Profile, completion: @escaping (Error?) -> Void) {
        let saveContext = coreDataStack.saveContext
        saveContext.perform {
            let appUser = AppUser.findOrInsertAppUser(in: saveContext)

            appUser?.name = profile.name
            appUser?.info = profile.info
            appUser?.image = profile.image?.pngData()

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
