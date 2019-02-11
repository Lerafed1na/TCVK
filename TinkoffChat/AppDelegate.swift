//
//  AppDelegate.swift
//  TinkoffChat
//
//  Created by Valeriia Korenevich on 07/02/2019.
//  Copyright © 2019 Valeriia Korenevich. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var prevState = "NOT RUNNING"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Called if everything is fine with initialization
       lerasFunctionForAplicationState(UIApplication.shared.applicationState)
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Switching to another application or pressing the "HOME" button
        lerasFunctionForAplicationState(UIApplication.shared.applicationState)
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Transition to the background task execution state.
        lerasFunctionForAplicationState(UIApplication.shared.applicationState)
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // The application has switched to the Foreground Inactive state. It was called from a minimized state and was in the background state.
        lerasFunctionForAplicationState(UIApplication.shared.applicationState)
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // The application is in the Active state.
        lerasFunctionForAplicationState(UIApplication.shared.applicationState)
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // When you close the application. Called only when the application is running. It is not called from the Suspended state.
        lerasFunctionForAplicationState(UIApplication.shared.applicationState)
        self.saveContext()
    }
    
    func convertState(_ state: UIApplication.State) -> String {
        switch state {
        case .active:
            return "ACTIVE"
        case .inactive:
            return "INACTIVE"
        case .background:
            return "BACKGROUND"
        }
    }
    
    func lerasFunctionForAplicationState(_ applistaionState: UIApplication.State, inFunction name: String = #function) {
        let state = convertState(applistaionState)
        if state != prevState {
            ChatLog.printLog("Application moved from \(prevState) to \(state): \(name)")
        } else {
            ChatLog.printLog("Application is still in \(state): \(name)")
        }
        prevState = state
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "TinkoffChat")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

