//
//  UIButtonExtension.swift
//  TinkoffChat
//
//  Created by Fedor Korenevych on 20/04/2019.
//  Copyright © 2019 Lera Korenevich. All rights reserved.
//

import Foundation

extension UIButton {

    func changeColorButton(state: String) {
        UIView.animate(withDuration: 0.5) {
            if state == "OFF" {
                self.layer.backgroundColor =  #colorLiteral(red: 0.8636358976, green: 0, blue: 0.005087155849, alpha: 1)
            } else {
                self.layer.backgroundColor =  #colorLiteral(red: 0, green: 0.8028118014, blue: 0.1044786051, alpha: 1)
            }
        }
    }

    func buttonAnimationTransform() {
        UIView.animate(withDuration: 0.5, animations: { self.transform = CGAffineTransform(scaleX: 1.15, y: 1.15) }, completion: { _ in
            self.transform = CGAffineTransform.identity
        })
    }

    func shakeButton() {
        let animation = CABasicAnimation(keyPath: "pos")
        animation.duration = 0.5
        animation.repeatCount = 2
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint.init(x: self.center.x - 3, y: self.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint.init(x: self.center.x + 3, y: self.center.y))
        self.layer.add(animation, forKey: "pos")
    }

}
