//
//  GCDDataManager.swift
//  TinkoffChat
//
//  Created by Valeriia Korenevich on 11/03/2019.
//  Copyright © 2019 Valeriia Korenevich. All rights reserved.
//

import Foundation

class GCDDataManager: DataManagerProtocol {
	static let userNameKey = "userName"
	static let userInfoKey = "userInfo"
    internal let fileName: String
    
    required init (fileName: String) {
        self.fileName = fileName
    }
    
    private let userInteractiveQueue = DispatchQueue.global(qos: .userInteractive)

	func write(profile: Profile, newProfile: Profile, handler: @escaping (_ : Bool) -> Void) { }
    
    func write(profile: Profile, handler: @escaping (_ : Bool) -> Void) {
        userInteractiveQueue.async { [weak self] in
			guard let strongSelf = self else { return }

			UserDefaults.standard.set(profile.name, forKey: GCDDataManager.userNameKey)
			UserDefaults.standard.set(profile.info, forKey: GCDDataManager.userInfoKey)

            do {
				// Build path url to Documents folder on hdd of user mobile device
				let documentsPathURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
				// add file name and file extension to Documents path url we retrived above
				let filePathURL = documentsPathURL.appendingPathComponent(strongSelf.fileName)
				// load previousely saved image
				if let storedImage = UIImage(contentsOfFile: filePathURL.path) {
					// compare new image from newProfile with saved image and save new image if it's different
					if profile.image != storedImage, let imgData = profile.image.pngData()  {
						do {
							try imgData.write(to: filePathURL)
							DispatchQueue.main.async {
								handler(true)
							}
						} catch {
							print("Save Image faild!")
							DispatchQueue.main.async {
								handler(false)
							}
						}
					}
				} else {
					// just save image because saved image was not loaded
					if let imgData = profile.image.pngData() {
						do {
							try imgData.write(to: filePathURL)
							DispatchQueue.main.async {
								handler(true)
							}
						} catch {
							print("Save Image faild!")
							DispatchQueue.main.async {
								handler(false)
							}
						}
					}
				}
				
            } catch {
                DispatchQueue.main.async {
                    handler(false)
                }
            }
        }
        
    }
    
    func read(profile: Profile, handler: @escaping () -> Void) {
        userInteractiveQueue.async { [weak self] in
			guard let strongSelf = self else { return }

			if let name = UserDefaults.standard.string(forKey: GCDDataManager.userNameKey) {
				profile.name = name
			}

			if let info = UserDefaults.standard.string(forKey: GCDDataManager.userInfoKey) {
				profile.info = info
			}

			if let documentsPathURL = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
			{
				let filePathURL = documentsPathURL.appendingPathComponent(strongSelf.fileName)

				if let userImage = UIImage(contentsOfFile: filePathURL.path) {
					profile.image = userImage
				} else {
					if let paceholderImage = UIImage(named: "placeholder-user") {
						profile.image = paceholderImage
					}
				}

			} else {
				print("FileManager faild to create file path")
			}
            DispatchQueue.main.async {
                handler()
            }
        }
    }
    
}
