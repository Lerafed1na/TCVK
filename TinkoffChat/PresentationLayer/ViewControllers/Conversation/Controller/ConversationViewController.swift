//
//  ConversationViewController.swift
//  TinkoffChat
//
//  Created by Valeriia Korenevich on 24/02/2019.
//  Copyright © 2019 Valeriia Korenevich. All rights reserved.
//

import UIKit
import CoreData

protocol ConversationDelegate: class {
    func reloadData()
    func lockTheSendButton()
}


class ConversationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
  

  var fetchResultsController: NSFetchedResultsController<Message>!
  
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var sendButton: UIButton!

    var communicator: Communicator!
    var conversation: Conversation!
    weak var converstionsListDelegate: ConversationsListDelegate?
  

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
      
      initialMessagesFetching()
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
      let messageToSend = textField.text
      let conversationId = conversation.conversationId
      
      CommunicationService.shared.multipeerCommunicator.sendMessage(string: messageToSend!, to: conversationId!) { success, error in
        if success {
          self.textField.text = ""
          self.sendButton.isEnabled = true
        }
        if let error = error {
          self.view.endEditing(true)
          let alert = UIAlertController(title: "Ошибка при отправке сообщения: \(error.localizedDescription)", message: nil, preferredStyle: .alert)
          let action = UIAlertAction(title: "Ок", style: .default, handler: nil)
          alert.addAction(action)
          self.present(alert, animated: true, completion: nil)
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
