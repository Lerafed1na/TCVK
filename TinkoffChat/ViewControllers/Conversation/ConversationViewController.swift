//
//  ConversationViewController.swift
//  TinkoffChat
//
//  Created by Valeriia Korenevich on 24/02/2019.
//  Copyright © 2019 Valeriia Korenevich. All rights reserved.
//

import UIKit

class ConversationViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    
    
    var communicator: Communicator!
    var conversation: ConversationModel!
    var converstionsListDelegate: ConversationsListDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.textField.delegate = self
        
        //setupUI
        setupSendButton()
        setupTextField()
        
        // Remove separator:
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        

    }
    
    private func setupSendButton() {
        sendButton.layer.cornerRadius = sendButton.bounds.height / 5
        sendButton.layer.borderWidth = 0.3
        sendButton.layer.borderColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
        sendButton.backgroundColor = .white
        sendButton.clipsToBounds = true
    }
    
    private func setupTextField() {
        
        textField.borderStyle = .roundedRect
        textField.layer.borderWidth = 0.3
        textField.layer.cornerRadius = 10
        textField.layer.borderColor = UIColor.black.cgColor
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
    
    
    @IBAction func sendButtonWasPressed(_ sender: Any) {
        
        if let text = textField.text {
            communicator.sendMessage(string: text, to: conversation.userId) {[weak self] (success, error) in
                if success {
                    self?.textField.text = ""
                    
                    self?.conversation.date = Date()
                    self?.conversation.message = text
                    self?.conversation.messages.append(MessageModel(textMessage: text,
                                                                    isIncoming: false))
                    
                    self?.tableView.reloadData()
                    self?.converstionsListDelegate?.sortConverstionData()
                } else {
                    let alertController = UIAlertController(title: "Error",
                                                            message: "message not send",
                                                            preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "Done",
                                                            style: .destructive))
                    self?.present(alertController,
                                  animated: true,
                                  completion: nil)
                }
            }
        }
    }
    
}


extension ConversationViewController: UITextFieldDelegate {
    
}


extension ConversationViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversation.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = conversation.messages[indexPath.row]
        var identifier = ""
        if message.isIncoming {
            identifier = "IncomingCell"
        } else {
            identifier = "OutcomingCell"
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! ChatTableViewCell
        cell.textMessage = message.textMessage

        return cell
    }
    
}

extension ConversationViewController: UITableViewDelegate {
    
}

extension ConversationViewController: ConversationDelegate {
    
    func reloadData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func lockTheSendButton() {
        DispatchQueue.main.async {
            self.sendButton.isEnabled = false
        }
    }
    
    
}
