//
//  ConversationsListViewController.swift
//  TinkoffChat
//
//  Created by Valeriia Korenevich on 22/02/2019.
//  Copyright © 2019 Valeriia Korenevich. All rights reserved.
//


/*
 Переключение между ThemesViewController.swift и ThemesViewController.m
 
 1. Сменить Target Membership
 2. Проверить/Обновить Custom Class в StoryBoard. Если запускаем ThemesViewController.swift, то ‘Inherit Module From Target' должна стоять галочка.
 3. В ConversationsListViewController:
    a. Change on ThemesViewController.swift 3.1., 3.2., 3.3.
    b. Change on ThemesViewController.m 3.4., 3.5., 3.6.
 
 
 */

import UIKit

class ConversationsListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

  
    @IBOutlet var conversetionListTableView: UITableView!
    @IBOutlet var userProfileButton: UIButton!
    
    var conversationsArray = [Int: [ConversationModel]]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UINavigationBar.appearance().barTintColor = UserDefaults.standard.colorForKey(key: "selectedColor")
        
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
        
        navigationItem.title = "Tinkoff Chat"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        userProfileButton.widthAnchor.constraint(equalToConstant: 35.0).isActive = true
        userProfileButton.heightAnchor.constraint(equalToConstant: 35.0).isActive = true
        
        // Do any additional setup after loading the view.
    }
    
    func sortConversationsArray() {
        
        conversationsArray[0] = DataSource.conversetions.filter({$0.online == true})
        conversationsArray[1] = DataSource.conversetions.filter({$0.online == false})
        
        conversationsArray[0]?.sort(by: { (first, second) -> Bool in
            if first.date == nil {
                return false
            }
            if let date1 = first.date, let date2 = second.date {
                return date1 > date2
            }
            return true
        })
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
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if (segue.identifier == "Show Chat") {
			let cell = sender as? ConversetionTableViewCell
			let conversationViewController = segue.destination as? ConversationViewController
			conversationViewController?.title = cell?.name

		} else if (segue.identifier == "Show Themes") {
			guard let themesNavigationController = segue.destination as? UINavigationController else { return }
			guard let themesViewController = themesNavigationController.topViewController as? ThemesViewController else { return }
            
            //3.1. If you want change target on ThemesViewController.swift you have to remove the "//" from the line below
            
            //themesViewController.closure = { logThemeChanging }()
            
            //3.4. If you want change target on ThemesViewController.m you have to add the "//" to the line above
            //3.5. If you want change target on ThemesViewController.m you have to remove the "//" from the line below
			themesViewController.delegate = self as  ThemesViewControllerDelegate
            //3.2. If you want change target on ThemesViewController.swift you have to add "//" to the line above
		}
	}
}

//3.3. If you want change target on ThemesViewController.swift you have to add the "//" to the block below
//3.6. If you want change target on ThemesViewController.m you have to remove the "//" from the block below
extension ConversationsListViewController: ThemesViewControllerDelegate {
	func themesViewController(_ controller: ThemesViewController!, didSelectTheme selectedTheme: UIColor!) {
		logThemeChanging(selectedTheme: selectedTheme)
        
//        controller.get
	}
}
