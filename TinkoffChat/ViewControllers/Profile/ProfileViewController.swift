//
//  ProfileViewController.swift
//  TinkoffChat
//
//  Created by Valeriia Korenevich on 15/02/2019.
//  Copyright © 2019 Valeriia Korenevich. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    @IBOutlet weak var placeholderProfilePhoto: UIImageView!
    @IBOutlet weak var setProfilePhotoButton: UIButton!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var infoTextField: UITextView!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var iconOfSetProfilePhotoButton: UIImageView!
    @IBOutlet var gcdButton: UIButton!
    @IBOutlet var operationsButton: UIButton!
    @IBOutlet var buttonsStack: UIStackView!
    
    let profile = Profile()
    let dataManagerGCD = GCDDataManager(fileName: "image.png")
    let dataManagerOperation = OperationDataManager(fileName: "image.png")
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
		dataManagerGCD.read(profile: profile, handler: updateInfo)
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
    
    private func setupUI() {
		// set initial state of activityIndicator
		activityIndicator.isHidden = true
		userNameTextField.autocorrectionType = .no
		infoTextField.autocorrectionType = .no
        setupPhotoButton()
		setupPhotoPlacholder()
        setupEditButton()
		setupGCDButton()
		setupOperationsButton()
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

	private func setupGCDButton() {
		gcdButton.layer.cornerRadius = 20.0
		gcdButton.layer.borderWidth = 0.5
		gcdButton.layer.borderColor = UIColor.black.cgColor
	}

	private func setupOperationsButton() {
		operationsButton.layer.cornerRadius = 20.0
		operationsButton.layer.borderWidth = 0.5
		operationsButton.layer.borderColor = UIColor.black.cgColor
	}

	private func disableSaveButtons() {
		gcdButton.isEnabled = false
		operationsButton.isEnabled = false
	}

	private func enableSaveButtons() {
		gcdButton.isEnabled = true
		operationsButton.isEnabled = true
	}
    
    private func showAlert(success: Bool) {
        if success {
			showSavedAlert()
        } else {
			showRetryAlert()
        }
    }

	private func showSavedAlert() {
		let alertController = UIAlertController(title: "Saved", message: "Your data has been saved",
        preferredStyle: .alert)

		let okAction = UIAlertAction(title: "OK", style: .cancel,
									 handler: { [weak self] _ in
										guard let strongSelf = self else { return }
										strongSelf.dataManagerGCD.read(profile: strongSelf.profile,
																	   handler: strongSelf.updateInfo)
										strongSelf.disabledInteraction()
		})

		alertController.addAction(okAction)

		self.present(alertController, animated: true, completion: nil)
	}

	private func showRetryAlert() {
		let alertController = UIAlertController(title: "Error", message: "could not save data", preferredStyle: .alert)

		let okAction = UIAlertAction(title: "OK", style: .default,
									 handler: { [weak self] _ in
										guard let strongSelf = self else { return }
										strongSelf.dataManagerGCD.read(profile:
                                            strongSelf.profile,
                                            handler: strongSelf.updateInfo)
										    strongSelf.disabledInteraction()
		})
		let retryAction = UIAlertAction(title: "Retry", style: .default,
										handler: { [weak self] _ in
											guard let strongSelf = self else { return }
											strongSelf.gcdSaveButtonWasPressed(strongSelf)})

		alertController.addAction(okAction)
		alertController.addAction(retryAction)

		self.present(alertController, animated: true, completion: nil)
	}
    
    private func enableInteraction() {
		enableSaveButtons()
		
        buttonsStack.isHidden = false
        gcdButton.isEnabled = false
        operationsButton.isEnabled = false
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

        buttonsStack.isHidden = true
        gcdButton.setTitleColor(UIColor.gray, for: .normal)
        operationsButton.setTitleColor(UIColor.gray, for: .normal)
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

			present(imagePicker, animated: true, completion: nil)
		}
	}

	private func showPhotoLibraryImagePickerController() {
		if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
			imagePicker.allowsEditing = false
			imagePicker.sourceType = .photoLibrary
			present(imagePicker, animated: true, completion: nil)
		}
	}
    
    func saveButtons() {
        if (profile.name != userNameTextField.text || profile.info != infoTextField.text || profile.image != placeholderProfilePhoto.image) {
            gcdButton.isEnabled = true
            operationsButton.isEnabled = true
            gcdButton.setTitleColor(UIColor.blue, for: .normal)
            operationsButton.setTitleColor(UIColor.blue, for: .normal)
        } else {
            gcdButton.isEnabled = false
            operationsButton.isEnabled = false
            gcdButton.setTitleColor(UIColor.gray, for: .normal)
            operationsButton.setTitleColor(UIColor.gray, for: .normal)
        }
    }
    
    

	// MARK: - IBActions
	@IBAction func backBtnWasPressed(_ sender: Any) {
		dismiss(animated: true, completion: nil)
	}

	@IBAction func editButtonWasPressed(_ sender: UIButton) {
        
		enableInteraction()
	}
    
    
    @IBAction func nameFieldDidChange(_ sender: Any) {
        saveButtons()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        saveButtons()
    }

	// Photo uploading from Camera or Gallery
	@IBAction func setButtonAction(_ sender: Any) {
		let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

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

		present(actionSheet, animated: true, completion: nil)
	}
    
    @IBAction func gcdSaveButtonWasPressed(_ sender: Any) {
        activityIndicator.isHidden = false
		view.endEditing(true)

		disableSaveButtons()

		if let text = userNameTextField.text {
			profile.name = text
		}
		if let text = infoTextField.text {
			profile.info = text
		}

        dataManagerGCD.write(profile: profile, handler: showAlert)
    }
    
    @IBAction func operationsSaveButtonWasPressed(_ sender: Any) {
		activityIndicator.isHidden = false
		view.endEditing(true)

		disableSaveButtons()

        let tempProfile = Profile()
        if let text = userNameTextField.text {
            tempProfile.name = text
        }
        if let text = infoTextField.text {
            tempProfile.info = text
        }

        dataManagerOperation.write(profile: profile, newProfile: tempProfile, handler: { (success) in
            if (success) {
                let alertController = UIAlertController(title: "Saved", message: "Your data has been saved", preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "OK", style: .cancel, handler: { [weak self] _ in
                    guard let strongSelf = self else { return }
                    
                    strongSelf.dataManagerOperation.read(profile: strongSelf.profile, handler: strongSelf.updateInfo)
                    strongSelf.disabledInteraction()})
                
                alertController.addAction(okAction)
                
                self.present(alertController, animated: true, completion: nil)
                
            } else {
                let alertController = UIAlertController(title: "Error", message: "could not save data", preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "OK", style: .default,handler: { [weak self] _ in
                                                guard let strongSelf = self else { return }
                                                strongSelf.dataManagerOperation.read(profile:
                                                    strongSelf.profile,
                                                    handler: strongSelf.updateInfo)
                                                strongSelf.disabledInteraction()
                })
                let retryAction = UIAlertAction(title: "Retry", style: .default,
                                                handler: { [weak self] _ in
                                                    guard let strongSelf = self else { return }
                                                
                                                    strongSelf.operationsSaveButtonWasPressed(strongSelf)})
                
                alertController.addAction(okAction)
                alertController.addAction(retryAction)
                
                self.present(alertController, animated: true, completion: nil)
            }
        })
    }
}


// MARK: - UIImagePickerControllerDelegate
extension ProfileViewController:  UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController,
							   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {

            profile.image = pickedImage
            saveButtons()
            
            if let text = userNameTextField.text {
                profile.name = text
            }
            if let text = infoTextField.text {
                profile.info = text
            }
        }
        
        updateInfo()
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}

protocol DataManagerProtocol {
    var fileName: String {get}
    init(fileName: String)
    func read(profile: Profile, handler: @escaping () -> Void)
	func write(profile: Profile, handler: @escaping (_ : Bool) -> Void)
}




