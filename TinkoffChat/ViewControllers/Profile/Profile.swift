//
//  Profile.swift
//  TinkoffChat
//
//  Created by Valeriia Korenevich on 11/03/2019.
//  Copyright © 2019 Valeriia Korenevich. All rights reserved.
//

import UIKit

protocol IProfile {
    var name: String { get set }
    var info: String { get set }
    var image: UIImage { get set }
}

struct Profile: IProfile {
    var name: String
    var info: String
    var image: UIImage
}


