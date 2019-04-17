//
//  ImageStorage.swift
//  TinkoffChat
//
//  Created by Valeriia Korenevich on 16/04/2019.
//  Copyright © 2019 Valeriia Korenevich. All rights reserved.
//

import Foundation

struct ImageJson: Codable {
    let totalHits: Int
    let hits: [ImageInfo]
}

struct ImageInfo: Codable {
    let webformatURL:String
    let previewURL: String
}
