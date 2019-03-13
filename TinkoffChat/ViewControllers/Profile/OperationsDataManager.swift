//
//  OperationsDataManager.swift
//  TinkoffChat
//
//  Created by Valeriia Korenevich on 12/03/2019.
//  Copyright © 2019 Valeriia Korenevich. All rights reserved.
//

import Foundation

class OperationDataManager: DataManagerProtocol {
    static let userNameKey = "userName"
    static let userInfoKey = "userInfo"
    
    let fileName: String
    
    required init(fileName: String) {
        self.fileName = fileName
    }
    
    func read(profile: Profile, handler: @escaping () -> Void) {
        let read = ReadOperation(fileName: self.fileName, profile: profile, handler: handler)
        let operationQueue = OperationQueue.main
        operationQueue.addOperation(read)
    }
    
    func write(profile: Profile, newProfile: Profile, handler: @escaping (Bool) -> Void) {
        let write = WriteOperation(fileName: self.fileName, profile: profile, newProfile: newProfile, handler: handler)
        let operationQueue = OperationQueue.main
        operationQueue.addOperation(write)
    }

	func write(profile: Profile, handler: @escaping (Bool) -> Void) { }
}

class ReadOperation: Operation {
    var profile: Profile
    var fileName: String
    var handler: () -> Void
    
    init (fileName: String, profile: Profile, handler: @escaping () -> Void) {
        self.profile = profile
        self.fileName = fileName
        self.handler = handler
    }
    
    private var finish = false
    private var execute = false
    private let queue = DispatchQueue.global(qos: .userInitiated)
    
    override var isAsynchronous: Bool { return true }
    override var isFinished: Bool { return finish }
    override var isExecuting: Bool { return execute }
    
    override func start () {
        queue.async {
            self.main ()
        }
        execute = true
    }
    
    override func main () {
        let defaults = UserDefaults.standard
        if let userNameFromDefaults = defaults.string(forKey: OperationDataManager.userNameKey) {
            profile.name = userNameFromDefaults
        } else {
            profile.name = "No name yet"
        }
        if let userDescrFromDefaults = defaults.string(forKey: OperationDataManager.userInfoKey) {
            profile.info = userDescrFromDefaults
        } else {
            profile.info = "No description yet"
        }
        let documentsPathURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let filePathURL = documentsPathURL.appendingPathComponent(self.fileName)
        if let imageFromFile = UIImage(contentsOfFile: filePathURL.path) {
            profile.image = imageFromFile
        } else {
            profile.image = UIImage(named: "placeholder-user")!
        }
        DispatchQueue.main.async {
            self.handler()
        }
        finish = true
        execute = false
    }
}


class WriteOperation: Operation {
    var profile: Profile
    var newProfile: Profile
    var fileName: String
    var handler: (Bool) -> Void
    
    init (fileName: String, profile: Profile, newProfile: Profile, handler: @escaping (Bool) -> Void) {
        self.profile = profile
        self.newProfile = newProfile
        self.fileName = fileName
        self.handler = handler
    }
    
    private var finish = false
    private var execute = false
    private let queue = DispatchQueue.global(qos: .userInitiated)
    
    override var isAsynchronous: Bool { return true }
    override var isFinished: Bool { return finish }
    override var isExecuting: Bool { return execute }
    
    override func start () {
        queue.async {
            self.main ()
        }
        execute = true
    }
    
    override func main () {
        let defaults = UserDefaults.standard
        if (newProfile.name != profile.name) {
            defaults.set(newProfile.name, forKey: OperationDataManager.userNameKey)
        }
        if (newProfile.info != profile.info) {
            defaults.set(newProfile.info, forKey: OperationDataManager.userInfoKey)
        }
        do{
            let documentsPathURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let filePathURL = documentsPathURL.appendingPathComponent(self.fileName)
            if let imageFromFile = UIImage(contentsOfFile: filePathURL.path) {
                if (!profile.image.isEqual(imageFromFile)) {
                    let userPhotoData = profile.image.pngData()!
                    try userPhotoData.write(to: filePathURL)
                }
            } else {
                let userPhotoData = profile.image.pngData()!
                try userPhotoData.write(to: filePathURL)
            }
        } catch {
            DispatchQueue.main.async {
                self.handler(false)
            }
        }
        DispatchQueue.main.async {
            self.handler(true)
        }
        finish = true
        execute = false
    }
}
