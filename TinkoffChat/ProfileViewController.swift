//
//  ProfileViewController.swift
//  TinkoffChat
//
//  Created by Valeriia Korenevich on 15/02/2019.
//  Copyright © 2019 Valeriia Korenevich. All rights reserved.
//

import UIKit


class ProfileViewController: UIViewController {
    
    @IBOutlet weak var placeholderProfilePhoto: UIImageView!
    @IBOutlet weak var setProfilePhotoButton: UIButton!
    @IBOutlet weak var userNameTextField: UILabel!
    @IBOutlet weak var infoTextField: UILabel!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var iconOfSetProfilePhotoButton: UIImageView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        print(editButton?.frame ?? "nil") // инициализация аутлетов в данный момент еще не произошла, поэтому нужно развернуть optional, так как обращение к nil приведет к крашу.
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        print(editButton?.frame ?? "nil") // в ViewDidLoad отображаются размеры кнопки, рассчитанные для девайса, выбранного в .storyboard. В нашем случае iPhone SE
        printStateName()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        printStateName()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print(editButton?.frame ?? "nil") //в ViewDidAppear отображаются размеры кнопки, рассчитанные для девайса, на котором запущенно приложение. В нашем случае iPhone 8 Plus или iPhone X
        
        printStateName()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        printStateName()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        printStateName()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        printStateName()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        printStateName()
    }
    
    func printStateName(string: String = #function) {
        ChatLog.printLog("\(string)")
    }
    
    

    @IBAction func setButtonAction(_ sender: Any) {
        print("Выбери изображение профиля")
    }
    
    
    func configureView() {
     let cornerRadius = placeholderProfilePhoto.bounds.height / 5
     placeholderProfilePhoto.layer.cornerRadius = cornerRadius
     placeholderProfilePhoto.clipsToBounds = true
     setProfilePhotoButton.layer.cornerRadius = cornerRadius
     setProfilePhotoButton.backgroundColor = #colorLiteral(red: 0.2470588235, green: 0.4705882353, blue: 0.9411764706, alpha: 1)
     editButton.layer.cornerRadius = editButton.bounds.height / 5
     editButton.layer.borderWidth = 1.5
     editButton.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
     editButton.backgroundColor = .white
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
