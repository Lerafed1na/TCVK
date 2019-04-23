//
//  ConversationViewController.swift
//  TinkoffChat
//
//  Created by Valeriia Korenevich on 24/02/2019.
//  Copyright © 2019 Valeriia Korenevich. All rights reserved.
//

import UIKit
import CoreData

class ConversationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, ManagerDelegate {

  var fetchResultsController: NSFetchedResultsController<Message>!

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var sendButton: UIButton!

    var communicator: Communicator!
    var conversation: Conversation!
    weak var converstionsListDelegate: ConversationsListDelegate?
    var sendButtonLocked: Bool!

    let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 40))

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLabel()
        // label animation
        setupLabelAnimation()

        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.textField.delegate = self

        CommunicationService.shared.delegate = self

        //setupUI
        setupSendButton()
        setupTextField()

        sendButtonLocked = true

        // Remove separator:
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none

        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)

        initialMessagesFetching()
    }

    private func setupLabelAnimation() {
        if conversation.isOnline {
            setLabelPerformAnimation(label, enabled: true)
        } else {
            setLabelPerformAnimation(label, enabled: false)
        }
    }

    private func setupLabel() {
        navigationItem.titleView = label
        label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.text = conversation.user?.name
    }

    func updateConversationInfo() {

        conversation.isOnline = !conversation.isOnline
        if conversation.isOnline {
            setLabelPerformAnimation(label, enabled: true)
        } else {
            setLabelPerformAnimation(label, enabled: false)
        }
    }

    private func setButtonPerformAnimation(_ button: UIButton, enabled: Bool) {
        if enabled {
            // button is "enabled"
            UIView.animate(withDuration: 0.5, animations: {
                button.transform = CGAffineTransform(scaleX: 1.15, y: 1.15)
                button.backgroundColor = UIColor.green
            }, completion: { _ in
                button.transform = CGAffineTransform.identity
            })
        } else {
            // button is "off"
            UIView.animate(withDuration: 0.5, animations: {
                button.transform = CGAffineTransform(scaleX: 1.15, y: 1.15)
                button.backgroundColor = UIColor.red
            }, completion: { _ in
                button.transform = CGAffineTransform.identity
            })
        }
    }

    private func setLabelPerformAnimation(_ label: UILabel, enabled: Bool) {
        if enabled {
            // user is online
            UIView.animate(withDuration: 1, animations: { () -> Void in
                label.textColor = UIColor.green
                label.transform = CGAffineTransform(scaleX: 1.10,
                                                    y: 1.10)
            })
        } else {
            //user is offline
            UIView.animate(withDuration: 1, animations: { () -> Void in
                label.textColor = UIColor.black
                label.transform = CGAffineTransform(scaleX: 1.0,
                                                    y: 1.0)
            })
        }
    }

  private func initialMessagesFetching() {
    guard let conversationId = conversation.conversationId else { return }
    fetchResultsController = NSFetchedResultsController(fetchRequest: FRMessageManager.shared.fetchMessagesBy(conversationID: conversationId),
                                                        managedObjectContext: CoreDataStack.shared.mainContext,
                                                        sectionNameKeyPath: nil,
                                                        cacheName: nil)
    fetchResultsController.delegate = self
    do {
      try fetchResultsController.performFetch()
    } catch {
    }
  }

    private func setupSendButton() {
        sendButton.layer.cornerRadius = sendButton.bounds.height / 5
        sendButton.layer.borderWidth = 0.3
        sendButton.layer.borderColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
        sendButton.backgroundColor = #colorLiteral(red: 0.8633465171, green: 0, blue: 0.04152081162, alpha: 1)
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
      guard let messageToSend = textField.text,
        let conversationId = conversation.conversationId, !messageToSend.isEmpty else { return }

    CommunicationService.shared.multipeerCommunicator.sendMessage(string: messageToSend, to: conversationId) { [weak self] success, error in
        if success {
          self?.textField.text = nil
            if self?.sendButtonLocked == false {
                self?.sendButtonLocked = true
                self?.setButtonPerformAnimation((self?.sendButton)!,
                                          enabled: false)
            }
        }
        if let error = error {
            self?.view.endEditing(true)
          let alert = UIAlertController(title: "Ошибка при отправке сообщения: \(error.localizedDescription)", message: nil, preferredStyle: .alert)
          let action = UIAlertAction(title: "Ок", style: .default, handler: nil)
          alert.addAction(action)
            self?.present(alert, animated: true, completion: nil)
        }
      }
    }

    // MARK: - sendButtonLock
    @objc private func textFieldDidChange(_ textField: UITextField) {
        if textField == textField {
            if let text = textField.text, !text.trimmingCharacters(in: .whitespaces).isEmpty && conversation.isOnline {
                if sendButtonLocked == true {
                    sendButtonLocked = false
                    setButtonPerformAnimation(sendButton, enabled: true)
                }
                sendButton.isEnabled = true
            } else {
                if sendButtonLocked == false {
                    sendButtonLocked = true

                    setButtonPerformAnimation(sendButton, enabled: false)

                }
                sendButton.isEnabled = false
            }
        }
    }

  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return fetchResultsController.fetchedObjects?.count ?? 0
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let message = fetchResultsController.object(at: indexPath)
            var identifier = ""
            if message.isIncoming {
                identifier = "IncomingCell"
            } else {
                identifier = "OutcomingCell"
            }
            guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier,
                                                           for: indexPath) as? ChatTableViewCell else {
                return ChatTableViewCell()
            }
            cell.textMessage = message.text
            return cell
  }
}

protocol ConversationDelegate: class {
    func reloadData()
    func lockTheSendButton()
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

extension ConversationViewController: NSFetchedResultsControllerDelegate {
  func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    tableView.beginUpdates()
  }
  func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    tableView.endUpdates()
  }
  func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                  didChange anObject: Any, at indexPath: IndexPath?,
                  for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
    switch type {
    case .delete:
      tableView.deleteRows(at: [indexPath!],
                           with: .none)
    case .update:
      tableView.reloadRows(at: [indexPath!],
                           with: .none)
    case .insert:
      tableView.insertRows(at: [newIndexPath!],
                           with: .none)
    case .move:
      tableView.deleteRows(at: [indexPath!],
                           with: .none)
      tableView.insertRows(at: [newIndexPath!],
                           with: .none)
    }
  }
}
