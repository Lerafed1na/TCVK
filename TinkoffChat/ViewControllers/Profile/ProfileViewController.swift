//
//  ProfileViewController.swift
//  TinkoffChat
//
//  Created by Valeriia Korenevich on 15/02/2019.
//  Copyright © 2019 Valeriia Korenevich. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class ProfileViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    @IBOutlet weak var placeholderProfilePhoto: UIImageView!
    @IBOutlet weak var setProfilePhotoButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var infoTextField: UITextView!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var iconOfSetProfilePhotoButton: UIImageView!
    
    
    var profile: Profile!
    let dataManager = CoreDataManager()
    let imagePicker = UIImagePickerController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // setup controller UI
        userNameTextField.delegate = self
        infoTextField.delegate = self
        setupUI()
        // set controller UI state to non-edit
        disabledInteraction()
        // set ProfileViewController delegate of UIImagePickerController
        imagePicker.delegate = self
        // read and set stored profile data
        loadProfileData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // adding keyboard observers
        setUpObservers()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        // removing keyboard observers
        removeObservers()
    }
    
    private func loadProfileData() {
        activityIndicator.startAnimating()
        
        dataManager.readProfileData { (profile) in
            self.profile = profile
            self.updateInfo()
        }
    }
    
    private func showSavedAlert() {
        
        let alertController = UIAlertController(title: "Changes saved!",
                                                message: nil,
                                                preferredStyle: .alert)
        let action = UIAlertAction(title: "ОК", style: .default) { [weak self] _ in
            guard let `self` = self else { return }
            self.disabledInteraction()
            self.updateInfo()
        }
        alertController.addAction(action)
        self.present(alertController,
                     animated: true,
                     completion: nil)
    }
    
    private func showRetryAlert() {
        let alertController = UIAlertController(title: "Error",
                                                message: "could not save data",
                                                preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Done",
                                                style: .cancel,
                                                handler: nil))
        alertController.addAction(UIAlertAction(title: "Retry",
                                                style: .default) { [weak self] _ in
                                                    guard let `self` = self else { return }
                                                    self.saveButtonWasPressed(self)
        })
        self.present(alertController,
                     animated: true,
                     completion: nil)
    }
    
    private func showAlert(success: Bool) {
        if success {
            showSavedAlert()
        } else {
            showRetryAlert()
        }
    }
    
    private func setupUI() {
        // set initial state of activityIndicator
        activityIndicator.isHidden = true
        userNameTextField.autocorrectionType = .no
        infoTextField.autocorrectionType = .no
        setupPhotoButton()
        setupPhotoPlacholder()
        setupEditButton()
        setupSaveButton()
    }
    
    private func setupPhotoButton() {
        setProfilePhotoButton.layer.cornerRadius = setProfilePhotoButton.frame.size.height / 2
        setProfilePhotoButton.layer.backgroundColor = #colorLiteral(red: 0.2470588235, green: 0.4705882353, blue: 0.9411764706, alpha: 1)
    }
    
    private func setupPhotoPlacholder() {
        placeholderProfilePhoto.layer.cornerRadius = setProfilePhotoButton.frame.size.height / 2
        placeholderProfilePhoto.clipsToBounds = true
    }
    
    private func setupEditButton() {
        editButton.layer.cornerRadius = editButton.bounds.height / 5
        editButton.layer.borderWidth = 0.5
        editButton.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        editButton.backgroundColor = .white
        editButton.clipsToBounds = true
    }
    
    private func setupSaveButton() {
        saveButton.layer.cornerRadius = 20.0
        saveButton.layer.borderWidth = 0.5
        saveButton.layer.borderColor = UIColor.black.cgColor
    }
    
    private func disableSaveButton() {
        saveButton.isEnabled = false
    }
    
    private func enableSaveButton() {
        saveButton.isEnabled = true
    }
    
    private func enableInteraction() {
        enableSaveButton()
        
        saveButton.isHidden = false
        saveButton.isEnabled = false
        editButton.isHidden = true
        
        userNameTextField.isEnabled = true
        setProfilePhotoButton.isHidden = false
        iconOfSetProfilePhotoButton.isHidden = false
        
        infoTextField.isEditable = true
        infoTextField.layer.borderWidth = 0.5
        infoTextField.layer.cornerRadius = 20
        infoTextField.layer.borderColor = UIColor.black.cgColor
    }
    
    private func disabledInteraction() {
        activityIndicator.isHidden = true
        
        saveButton.isHidden = true
        saveButton.setTitleColor(UIColor.gray, for: .normal)
        
        editButton.isHidden = false
        
        userNameTextField.isEnabled = false
        setProfilePhotoButton.isHidden = true
        iconOfSetProfilePhotoButton.isHidden = true
        
        infoTextField.isEditable = false
        infoTextField.layer.borderWidth = 0.0
        infoTextField.layer.borderColor = UIColor.white.cgColor
    }
    
    private func updateInfo() {
        userNameTextField.text = profile.name
        infoTextField.text = profile.info
        placeholderProfilePhoto.image = profile.image
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            if let endFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                if view.frame.origin.y == 0 {
                    view.frame.origin.y -= endFrame.height
                }
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if view.frame.origin.y >= 0.0 {
            return
        }
        
        if let userInfo = notification.userInfo {
            if let endFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                if view.frame.origin.y != 0.0 {
                    view.frame.origin.y += endFrame.height
                }
            }
        }
    }
    
    private func setUpObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(notification:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(notification:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    private func removeObservers() {
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillShowNotification,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillHideNotification,
                                                  object: nil)
    }
    
    private func showCameraImagePickerController() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.allowsEditing = false
            imagePicker.sourceType = .camera
            imagePicker.cameraCaptureMode = .photo
            imagePicker.modalPresentationStyle = .fullScreen
            
            present(imagePicker,
                    animated: true,
                    completion: nil)
        }
    }
    
    private func showPhotoLibraryImagePickerController() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            imagePicker.allowsEditing = false
            imagePicker.sourceType = .photoLibrary
            present(imagePicker,
                    animated: true,
                    completion: nil)
        }
    }
    
    private func savesButton() {
        if (profile.name != userNameTextField.text || profile.info != infoTextField.text || profile.image != placeholderProfilePhoto.image) {
            saveButton.isEnabled = true
            saveButton.setTitleColor(UIColor.blue,
                                     for: .normal)
        } else {
            saveButton.setTitleColor(UIColor.gray,
                                     for: .normal)
        }
    }
    
    
    // MARK: - IBActions
    @IBAction func backBtnWasPressed(_ sender: Any) {
        dismiss(animated: true,
                completion: nil)
    }
    
    @IBAction func editButtonWasPressed(_ sender: UIButton) {
        
        enableInteraction()
    }
    
    
    @IBAction func nameFieldDidChange(_ sender: Any) {
        savesButton()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        savesButton()
    }
    
    // Photo uploading from Camera or Gallery
    @IBAction func setButtonAction(_ sender: Any) {
        let actionSheet = UIAlertController(title: nil,
                                            message: nil,
                                            preferredStyle: .actionSheet)
        
        let takePhotoAction = UIAlertAction(title: "Take Photo",
                                            style: .cancel) { [weak self] _ in
                                                self?.showCameraImagePickerController()
        }
        
        let libraryPhotoAction = UIAlertAction(title: "From Gallery",
                                               style: .default) { [weak self] _ in
                                                self?.showPhotoLibraryImagePickerController()
        }
        
        actionSheet.addAction(takePhotoAction)
        actionSheet.addAction(libraryPhotoAction)
        
        present(actionSheet,
                animated: true,
                completion: nil)
    }
    
    @IBAction func saveButtonWasPressed(_ sender: Any) {
        
        saveButton.isEnabled = false
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        
        self.profile.name = userNameTextField.text!
        self.profile.info = infoTextField.text!
        self.profile.image = placeholderProfilePhoto.image!
        
        dataManager.saveProfileData(profile: self.profile) { (error) in
            if error == nil {
                self.showAlert(success: true)
            } else {
                self.showAlert(success: false)
            }
            
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
            self.saveButton.isEnabled = true
            
        }
    }
    
}


// MARK: - UIImagePickerControllerDelegate
extension ProfileViewController:  UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            profile.image = pickedImage
            savesButton()
            
            if let text = userNameTextField.text {
                profile.name = text
            }
            if let text = infoTextField.text {
                profile.info = text
            }
        }
        
        updateInfo()
        dismiss(animated: true,
                completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true,
                completion: nil)
    }
    
}

protocol DataManagerProtocol {
    
    func fetchProfileData(handler: @escaping (Profile?) -> Void)
    func saveProfileData(profile: Profile, handler: @escaping (Bool) -> Void)
}
