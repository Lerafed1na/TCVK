//
//  CollectionViewCell.swift
//  TinkoffChat
//
//  Created by Fedor Valeriia Korenevich on 16/04/2019.
//  Copyright © 2019 Valeriia Korenevich. All rights reserved.
//

import Foundation

class CollectionViewCell: UICollectionViewCell {
    @IBOutlet var photo: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let image = UIImage(named: "placeholder-user.png")
        photo.image = image
        photo.clipsToBounds = true
        photo.layer.cornerRadius = 3
    }
}
