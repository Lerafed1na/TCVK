//
//  CoreDataStack.swift
//  TinkoffChat
//
//  Created by Valeriia Korenevich on 26/03/2019.
//  Copyright © 2019 Valeriia Korenevich. All rights reserved.
//

import Foundation
import CoreData


class CoreDataStack: NSObject {
    static let shared = CoreDataStack()
    
    
    // URL:
    var storeURL: URL {
        let documentUrl = FileManager.default.urls(for: .documentDirectory,
                                                   in: .userDomainMask).first!
        return documentUrl.appendingPathComponent("TinkoffChatStore")
    }
    
    // MARK: - NSManagedObjectModel
    let dataModelName = "TinkoffChat"
    let dataModelExtension = "momd"
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        let  modelURL = Bundle.main.url(forResource: self.dataModelName,
                                        withExtension: self.dataModelExtension)!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    // MARK: - NSPersistentStoreCoordinator
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType,
                                               configurationName: nil,
                                               at: self.storeURL,
                                               options: nil)
        } catch {
            assert(false, "Error adding store \(error)")
        }
        return coordinator
    }()
    
    // MARK: - NSManagedObjectContext
    // (masterContext)
    lazy var masterContext: NSManagedObjectContext = {
        var masterContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        masterContext.persistentStoreCoordinator = self.persistentStoreCoordinator
        masterContext.mergePolicy = NSOverwriteMergePolicy
        return masterContext
    }()
    
    // (mainContext)
    lazy var mainContext: NSManagedObjectContext = {
        var mainContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        mainContext.parent = self.masterContext
        mainContext.mergePolicy = NSOverwriteMergePolicy
        return mainContext
    }()
    
    // (saveContext)
    lazy var saveContext:NSManagedObjectContext = {
        var saveContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        saveContext.parent = self.mainContext
        saveContext.mergePolicy = NSOverwriteMergePolicy
        return saveContext
    }()
    
    // Saving function:
    public func performSave(context: NSManagedObjectContext, completion: ((Error?)->())?) {
        if context.hasChanges {
            context.perform { [weak self] in
                do {
                    try context.save()
                } catch {
                    print("Context save error: \(error)")
                }
                
                if let parent = context.parent {
                    self?.performSave(context: parent,
                                      completion: completion)
                } else {
                    completion?(nil)
                }
            }
        } else {
            completion?(nil)
        }
    }
}


extension AppUser {
    
    static func findOrInsertAppUser(in context: NSManagedObjectContext) -> AppUser? {
        guard let model = context.persistentStoreCoordinator?.managedObjectModel else {
            print("Model is not available in context!")
            assert(false)
            return nil
        }
        
        var appUser: AppUser?
        guard let fetchRequest = AppUser.fetchRequestAppUser(model: model) else {
            return nil
        }
        
        do {
            let results = try context.fetch(fetchRequest)
            assert(results.count < 2, "Multiple AppUsers found!")
            if let foundUser = results.first {
                appUser = foundUser
            }
        } catch {
            print("Failed to fetch AppUser: \(error)")
        }
        
        if appUser == nil {
            appUser = AppUser.insertAppUser(in: context)
        }
        
        return appUser
    }
    
    static func insertAppUser(in context: NSManagedObjectContext) -> AppUser? {
        if let appUser = NSEntityDescription.insertNewObject(forEntityName: "AppUser",
                                                             into: context) as? AppUser {
            return appUser
        }
        return nil
    }
    
    static func fetchRequestAppUser(model: NSManagedObjectModel) -> NSFetchRequest<AppUser>? {
        let templateName = "AppUser"
        guard let fetchRequest = model.fetchRequestTemplate(forName: templateName) as? NSFetchRequest<AppUser> else {
            assert(false, "No template with name \(templateName)!")
            return nil
        }
        return fetchRequest
    }
    
}
