//
//  ConversationsListViewController.swift
//  TinkoffChat
//
//  Created by Valeriia Korenevich on 22/02/2019.
//  Copyright © 2019 Valeriia Korenevich. All rights reserved.
//

import UIKit
import MultipeerConnectivity
import CoreData

class ConversationsListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  

    @IBOutlet var tableView: UITableView!
    @IBOutlet var userProfileButton: UIButton!

    var fetchResultsController: NSFetchedResultsController<Conversation>!

    override func viewDidLoad() {
        super.viewDidLoad()
      self.tableView.dataSource = self

        //update function for current theme with User Defaults:
        if let selectedColor = UserDefaults.standard.colorForKey(key: "selectedColor") {
            UINavigationBar.appearance().barTintColor = selectedColor
        } else {
            UINavigationBar.appearance().barTintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        }

        updateWindows()

        self.tableView.dataSource = self
        self.tableView.delegate = self

        // Large navbar title and Remove separator:
        navigationItem.title = "Tinkoff Chat"
        navigationController?.navigationBar.prefersLargeTitles = true
        self.tableView.separatorStyle = .none

        // Add to userProfileButton an Anchor constraint
        userProfileButton.widthAnchor.constraint(equalToConstant: 35.0).isActive = true
        userProfileButton.heightAnchor.constraint(equalToConstant: 35.0).isActive = true
      
      
      initialConversationFetching()
      
    }
  
    func initialConversationFetching() {
        let request = FRManager.shared.fetchConversations()
        request.fetchBatchSize = 20
        fetchResultsController = NSFetchedResultsController(fetchRequest: request,
                                                            managedObjectContext: CoreDataStack.shared.mainContext,
                                                            sectionNameKeyPath: nil,
                                                            cacheName: nil)
        fetchResultsController.delegate = self
        do {
          try fetchResultsController.performFetch()
        } catch let error {
          print("fetchConversations() method:   \(error)")
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
    }

	// MARK: Private methods
    // print chosen color for ThemesView delegate and closure:
	func logThemeChanging(selectedTheme: UIColor) {
		ChatLog.printLog("Selected Theme color:\(selectedTheme)")

	}

    // MARK: - Navigation
    // Segue to chat:
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Show Chat" {
          if let indexPath = tableView.indexPathForSelectedRow {
            let destinationController = segue.destination as!
            ConversationViewController
            
            let conversation = fetchResultsController.object(at: indexPath)
            print(conversation)
            print(destinationController)
            destinationController.conversation = conversation
          
          }
            // MARK: - Themes: segue to ThemesViewController:
        } else if segue.identifier == "Show Themes" {
            guard let themesNavigationController = segue.destination as? UINavigationController else { return }
            guard let themesViewController = themesNavigationController.topViewController as? ThemesViewController else { return }

            themesViewController.closure = { logThemeChanging }()

            //themesViewController.delegate = self as  ThemesViewControllerDelegate

        }
    }
  
  
  func numberOfSections(in tableView: UITableView) -> Int {
    if let sections = fetchResultsController?.sections {
        return sections.count
    }
    return 0
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return fetchResultsController.fetchedObjects?.count ?? 0
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    guard let sections = fetchResultsController?.sections else {
        return nil
    }
    return sections[section].indexTitle == "1" ? "Online" : "History"
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath as IndexPath, animated: true)
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChannelCell",
                                                   for: indexPath) as? ConversetionTableViewCell else { return UITableViewCell() }
    
    let conversation = fetchResultsController.object(at: indexPath)
    cell.name = conversation.user?.name
    cell.date = conversation.date
    if let lastMessage = conversation.lastMessage, (conversation.messages?.count)! > 0 {
        if conversation.hasUnreadMessage {
                        cell.lastMessageLabel.font = UIFont(name: "HelveticaNeue-Bold",
                                                size: 16)
        } else {
            cell.lastMessageLabel.font = UIFont(name: "Futura-Medium",
                                                size: 14.0)
        }
        cell.lastMessageLabel.text = lastMessage.text
    } else {
        cell.lastMessageLabel.text = "No messages yet"
        cell.lastMessageLabel.font = UIFont(name: "Futura-Medium",
                                            size: 14.0)
    }
    cell.hasUnreadMessages = conversation.hasUnreadMessage
    if cell.online == conversation.isOnline {
        cell.backgroundColor = #colorLiteral(red: 0.7980608344, green: 0.943246901, blue: 0, alpha: 1)
    } else {
        cell.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
    }
    

    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 76
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 50.0
  }
}


extension ConversationsListViewController: NSFetchedResultsControllerDelegate {
  func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
    switch type {
    case .update:
      tableView.reloadRows(at: [newIndexPath!], with: .none)
    case .insert:
      tableView.insertRows(at: [newIndexPath!], with: .none)
    case .delete:
      tableView.deleteRows(at: [indexPath!], with: .none)
    case.move:
      tableView.deleteRows(at: [indexPath!], with: .none)
      tableView.insertRows(at: [newIndexPath!], with: .none)
    }
  }
  func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    tableView.beginUpdates()
  }
  func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    tableView.endUpdates()
  }
}
