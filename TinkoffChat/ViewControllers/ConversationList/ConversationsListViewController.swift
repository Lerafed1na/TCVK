//
//  ConversationsListViewController.swift
//  TinkoffChat
//
//  Created by Valeriia Korenevich on 22/02/2019.
//  Copyright © 2019 Valeriia Korenevich. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class ConversationsListViewController: UIViewController {

    @IBOutlet var conversetionListTableView: UITableView!
    @IBOutlet var userProfileButton: UIButton!

    private var communicator: Communicator = MultipeerCommunicator()
    private var communicationManager = CommunicationManager()

    let status = [0: "online", 1: "offline"]

    override func viewDidLoad() {
        super.viewDidLoad()

        communicator.delegate = communicationManager
        communicationManager.conversationsListDelegate = self

        //update function for current theme with User Defaults:
        if let selectedColor = UserDefaults.standard.colorForKey(key: "selectedColor") {
            UINavigationBar.appearance().barTintColor = selectedColor
        } else {
            UINavigationBar.appearance().barTintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        }

        updateWindows()

        self.conversetionListTableView.dataSource = self
        self.conversetionListTableView.delegate = self

        // Large navbar title and Remove separator:
        navigationItem.title = "Tinkoff Chat"
        navigationController?.navigationBar.prefersLargeTitles = true
        self.conversetionListTableView.separatorStyle = .none

        // Add to userProfileButton an Anchor constraint
        userProfileButton.widthAnchor.constraint(equalToConstant: 35.0).isActive = true
        userProfileButton.heightAnchor.constraint(equalToConstant: 35.0).isActive = true
    }

    override func viewWillAppear(_ animated: Bool) {
        conversetionListTableView.reloadData()
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
            if let cell = sender as? ConversetionTableViewCell,
                let conversationViewController = segue.destination as? ConversationViewController {
                if let indexPath = conversetionListTableView.indexPathForSelectedRow {

                    conversationViewController.communicator = communicator
                    conversationViewController.conversation = communicationManager.conversations[status[indexPath.section]!]?[indexPath.row]
                    conversationViewController.converstionsListDelegate = self
                    communicationManager.conversationDelegate = conversationViewController
                    conversationViewController.title = cell.name //// Transfer name into navbar
                }

            }
            // MARK: - Themes: segue to ThemesViewController:
        } else if segue.identifier == "Show Themes" {
            guard let themesNavigationController = segue.destination as? UINavigationController else { return }
            guard let themesViewController = themesNavigationController.topViewController as? ThemesViewController else { return }

            themesViewController.closure = { logThemeChanging }()

            //themesViewController.delegate = self as  ThemesViewControllerDelegate

        }
    }
}

extension ConversationsListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChannelCell",
                                                       for: indexPath) as? ConversetionTableViewCell else { return UITableViewCell() }
        if let conversation = communicationManager.conversations[status[indexPath.section]!]?[indexPath.row] {

            cell.name = conversation.name
            cell.message = conversation.messages.last?.textMessage
            cell.date = conversation.date
            cell.online = conversation.online
            cell.hasUnreadMessages = conversation.hasUnreadMessages

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

extension ConversationsListViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return communicationManager.conversations[status[section]!]?.count ?? 0
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Online"

        default:
            break
        }
        return nil
    }
}

extension ConversationsListViewController: ConversationsListDelegate {

    func reloadData() {
        DispatchQueue.main.async {
            self.conversetionListTableView.reloadData()
        }
    }

    func sortConverstionData() {
        communicationManager.conversations["online"]?.sort(by: ConversationModel.sortConversationsByDate)
    }

}
/*extension ConversationsListViewController: ThemesViewControllerDelegate {
	func themesViewController(_ controller: ThemesViewController!, didSelectTheme selectedTheme: UIColor!) {
		logThemeChanging(selectedTheme: selectedTheme)
 
	}
}*/
