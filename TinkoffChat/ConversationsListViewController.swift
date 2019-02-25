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
        
        self.conversetionListTableView.dataSource = self
        self.conversetionListTableView.delegate = self
        
        navigationItem.title = "Tinkoff Chat"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        userProfileButton.widthAnchor.constraint(equalToConstant: 35.0).isActive = true
        userProfileButton.heightAnchor.constraint(equalToConstant: 35.0).isActive = true
        
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
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "Show Chat") {
            let cell = sender as? ConversetionTableViewCell
            let conversationViewController = segue.destination as? ConversationViewController
            conversationViewController?.title = cell?.name
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let data = conversationsArray[section] {
            return data.count
        }
        return 0
    }
    
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
        return cell
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 76
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.0
    }

}
