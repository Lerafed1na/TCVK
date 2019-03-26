//
//  CoreDataManager.swift
//  TinkoffChat
//
//  Created by Valeriia Korenevich on 26/03/2019.
//  Copyright © 2019 Valeriia Korenevich. All rights reserved.
//

import Foundation
import CoreData
import UIKit


class CoreDataManager: NSObject {
    
    private let coreDataStack = CoreDataStack.shared
    
    
    func saveProfileData(profile: Profile, completion: @escaping (Error?) -> Void) {
        let appUser = AppUser.findOrInsertAppUser(in: coreDataStack.saveContext)
        
        appUser?.name = profile.name
        appUser?.info = profile.info
        appUser?.image = profile.image.pngData()
        
        self.coreDataStack.performSave(context: self.coreDataStack.saveContext) { (error) in
            DispatchQueue.main.async {
                completion(error)
            }
        }
    }
    
    func readProfileData(completion: @escaping (Profile) -> ()) {
        let appUser = AppUser.findOrInsertAppUser(in: coreDataStack.mainContext)
        
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
