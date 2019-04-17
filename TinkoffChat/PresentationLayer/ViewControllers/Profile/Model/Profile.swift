//
//  Profile.swift
//  TinkoffChat
//
//  Created by Valeriia Korenevich on 11/03/2019.
//  Copyright © 2019 Valeriia Korenevich. All rights reserved.
//

import UIKit

protocol ProfileProtocol {
    var name: String? {get set}
    var info: String? {get set}
    var image: UIImage? {get set}
}

class Profile: NSObject, ProfileProtocol {
    var name: String?
    var info: String?
    var image: UIImage?
    
//    var isNameChanged: Bool = false
//    var isInfoChanged: Bool = false
//    var isImageChanged: Bool = false
    
    init(name: String?, info: String?, image: UIImage?) {
        self.name = name
        self.info = info
        self.image = image
    }
    
    override init() {
    }
}

//struct Profile {
//
//    var name: String
//    var info: String
//    var image: UIImage
//}
