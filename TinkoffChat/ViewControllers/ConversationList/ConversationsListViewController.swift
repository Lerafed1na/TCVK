//
//  ConversationsListViewController.swift
//  TinkoffChat
//
//  Created by Valeriia Korenevich on 22/02/2019.
//  Copyright © 2019 Valeriia Korenevich. All rights reserved.
//

import UIKit

class ConversationsListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

  
    @IBOutlet var conversetionListTableView: UITableView!
    @IBOutlet var userProfileButton: UIButton!
    
    var conversationsArray = [Int: [ConversationModel]]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //update function for current theme with User Defaults:
        
        if let selectedColor = UserDefaults.standard.colorForKey(key: "selectedColor") {
            UINavigationBar.appearance().barTintColor = selectedColor
        } else {
            UINavigationBar.appearance().barTintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        }
        
        // Views updating:
        let windows = UIApplication.shared.windows
        for window in windows {
            for view in window.subviews {
                view.removeFromSuperview()
                window.addSubview(view)
            }
        }
        
        self.conversetionListTableView.dataSource = self
        self.conversetionListTableView.delegate = self
        
        
        sortConversationsArray()
        
        // Large navbar title and Remove separator:
        navigationItem.title = "Tinkoff Chat"
        navigationController?.navigationBar.prefersLargeTitles = true
        self.conversetionListTableView.separatorStyle = .none
        
        // Add to userProfileButton an Anchor constraint
//        userProfileButton.widthAnchor.constraint(equalToConstant: 35.0).isActive = true
//        userProfileButton.heightAnchor.constraint(equalToConstant: 35.0).isActive = true
        
        // Do any additional setup after loading the view.
    }
    
    func sortConversationsArray() {
        
        // Make a two arrays: online and offline
        conversationsArray[0] = DataSource.conversetions.filter({$0.online == true})
        conversationsArray[1] = DataSource.conversetions.filter({$0.online == false})
        
        // sort first array from last message to first
        conversationsArray[0]?.sort(by: { (first, second) -> Bool in
            if first.date == nil {
                return false
            }
            if let date1 = first.date, let date2 = second.date {
                return date1 > date2
            }
            return true
        })
        
        // sort second array from last message to first
        conversationsArray[1]?.sort(by: { (first, second) -> Bool in
            if first.date == nil {
                return false
            }
            if let date1 = first.date, let date2 = second.date {
                return date1 > date2
            }
            return true
        })
    }

	// MARK: Private methods
    // print chosen color for ThemesView delegate and closure:
	func logThemeChanging(selectedTheme: UIColor) {
		ChatLog.printLog("Selected Theme color:\(selectedTheme)")
	}

	// MARK: TableView DataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let data = conversationsArray[section] {
            return data.count
        }
        return 0
    }

	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		switch section {
		case 0:
			return "Online"
		case 1:
			return "History"
		default:
			break
		}
		return nil
	}

	// MARK: TableView Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChannelCell", for: indexPath) as? ConversetionTableViewCell else { return UITableViewCell() }
        let cellData = indexPath.section == 0 ? conversationsArray[0]?[indexPath.row] : conversationsArray[1]?[indexPath.row]
        
        cell.name = cellData?.name
        cell.message = cellData?.message
        cell.date = cellData?.date ?? Date()
        cell.hasUnreadMessages = (cellData?.hasUnreadMessages)!
        cell.online = (cellData?.online)!
        cell.userImage = cellData?.userImage
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 76
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.0
    }

	// MARK: - Navigation
    // Segue to chat:
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if (segue.identifier == "Show Chat") {
			let cell = sender as? ConversetionTableViewCell
			let conversationViewController = segue.destination as? ConversationViewController
			conversationViewController?.title = cell?.name //// Transfer name into navbar

        //MARK: - Themes: segue to ThemesViewController:
		} else if (segue.identifier == "Show Themes") {
			guard let themesNavigationController = segue.destination as? UINavigationController else { return }
			guard let themesViewController = themesNavigationController.topViewController as? ThemesViewController else { return }
            
            themesViewController.closure = { logThemeChanging }()
            
			//themesViewController.delegate = self as  ThemesViewControllerDelegate
            
		}
	}
}


/*extension ConversationsListViewController: ThemesViewControllerDelegate {
	func themesViewController(_ controller: ThemesViewController!, didSelectTheme selectedTheme: UIColor!) {
		logThemeChanging(selectedTheme: selectedTheme)
 
	}
}*/
