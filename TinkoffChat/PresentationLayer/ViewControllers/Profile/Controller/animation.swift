//
//  animation.swift
//  TinkoffChat
//
//  Created by Valeriia Korenevich on 17/04/2019.
//  Copyright © 2019 Valeriia Korenevich. All rights reserved.
//

import Foundation
import UIKit

class EditButton: UIButton {

    func changeColor(state: String) {
        UIView.animate(withDuration: 0.5) {
            if state == "OFF" {
                self.layer.backgroundColor =  #colorLiteral(red: 0, green: 1, blue: 0, alpha: 1)
            } else {
                self.layer.backgroundColor =  #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            }
        }
    }

    func buttonAnimationOne () {
        UIView.animate(withDuration: 0.5, animations: { self.transform = CGAffineTransform(scaleX: 1.15, y: 1.15) }, completion: { _ in
            self.transform = CGAffineTransform.identity
        })
    }

}
