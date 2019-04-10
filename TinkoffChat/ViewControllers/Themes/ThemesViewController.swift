//
//  ThemesViewController.swift
//  TinkoffChat
//
//  Created by Valeriia Korenevich on 05/03/2019.
//  Copyright © 2019 Valeriia Korenevich. All rights reserved.
//

import UIKit

class ThemesViewController: UIViewController {

    @IBOutlet weak var firstButton: UIButton!
    @IBOutlet weak var secondButton: UIButton!
    @IBOutlet weak var thirdButton: UIButton!
    @IBOutlet weak var randomButton: UIButton!

    var selectedColor: UIColor?
    var closure: ((UIColor) -> Void)!

    var themes = ThemesStructSwift(
        theme1: UIColor.init(red: 224.0 / 255, green: 130.0 / 255, blue: 131.0 / 255, alpha: 1.0),
        theme2: UIColor.init(red: 213.0 / 255, green: 184.0 / 255, blue: 255.0 / 255, alpha: 1.0),
        theme3: UIColor.init(red: 240.0 / 255, green: 255.0 / 255, blue: 0 / 255, alpha: 1.0), randomColor: UIColor.white)

    override func viewDidLoad() {
        super.viewDidLoad()
        //update function for current theme with User Defaults:

        DispatchQueue.global(qos: .userInteractive).async {
            if let selectedColor = UserDefaults.standard.colorForKey(key: "selectedColor") {
                DispatchQueue.main.async {
                    self.view.backgroundColor = selectedColor
                    UINavigationBar.appearance().barTintColor = selectedColor
                }
            } else {
                DispatchQueue.main.async {
                    UINavigationBar.appearance().barTintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                    self.view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                }
            }
        }
        updateWindows()

        firstButton.backgroundColor = self.themes.theme1
        firstButton.layer.cornerRadius = 15
        firstButton.layer.borderWidth = 1.5
        firstButton.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        firstButton.clipsToBounds = true

        secondButton.backgroundColor = self.themes.theme2
        secondButton.layer.cornerRadius = 15
        secondButton.layer.borderWidth = 1.5
        secondButton.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        secondButton.clipsToBounds = true

        thirdButton.backgroundColor = self.themes.theme3
        thirdButton.layer.cornerRadius = 15
        thirdButton.layer.borderWidth = 1.5
        thirdButton.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        thirdButton.clipsToBounds = true

        randomButton.backgroundColor = self.themes.randomColor
        randomButton.layer.cornerRadius = 15
        randomButton.layer.borderWidth = 1.5
        randomButton.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        randomButton.clipsToBounds = true
    }

    func getRandomColor() -> UIColor {
        //Generate between 0 to 1
        let red: CGFloat = CGFloat(drand48())
        let green: CGFloat = CGFloat(drand48())
        let blue: CGFloat = CGFloat(drand48())

        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }

    @IBAction func buttonPressed(_ sender: UIButton) {

        if sender == self.firstButton {
            selectedColor = self.themes.theme1
        } else if sender == self.secondButton {
            selectedColor = self.themes.theme2
        } else if sender == self.thirdButton {
            selectedColor = self.themes.theme3
        } else {
            selectedColor = getRandomColor()
            self.themes.randomColor = selectedColor!
        }

        self.view.backgroundColor = selectedColor
        closure?(selectedColor!)

        UINavigationBar.appearance().barTintColor = selectedColor

       // save color in UserDefaults
        updateWindows()
        UserDefaults.standard.setColor(color: selectedColor, forKey: "selectedColor")
    }

    @IBAction func doneButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

}
