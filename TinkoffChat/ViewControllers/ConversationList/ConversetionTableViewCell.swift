//
//  ConversetionTableViewCell.swift
//  TinkoffChat
//
//  Created by Valeriia Korenevich on 22/02/2019.
//  Copyright © 2019 Valeriia Korenevich. All rights reserved.
//

import UIKit

protocol ConversationsCellConfiguration : class {
    var name :String? {get set}
    var message :String? {get set}
    var date : Date? {get set}
    var online : Bool {get set}
    var hasUnreadMessages: Bool {get set}
    var userImage: String? {get set}
}

class ConversetionTableViewCell: UITableViewCell, ConversationsCellConfiguration {
    
    @IBOutlet var userImageView: UIImageView!
    @IBOutlet var nameOfUserLabel: UILabel!
    @IBOutlet var timeOfLastMessageLabel: UILabel!
    @IBOutlet var lastMessageLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    // Conform to protocol. Setting name:
    var name: String? {
        didSet {
            if name != nil {
                nameOfUserLabel.text = name
            }
        }
    }
    
    // Conform to protocol. Setting message:
    var message: String? {
        didSet {
            if message == nil {
                lastMessageLabel.font = UIFont(name: "Helvetica-Bold", size: 14)
                lastMessageLabel.text = "No message yet"
            } else {
                lastMessageLabel.font = UIFont(name: "Futura-Medium", size: 14)
                lastMessageLabel.text = message
            }
        }
    }
    
    // Conform to protocol. Setting date:
    var date: Date? {
        didSet {
            // Decoding date from String source:
            if let newDate = date {
                let dateFormatter = DateFormatter()
                if Calendar.current.isDateInToday(newDate) {
                    dateFormatter.dateFormat = "HH:mm"
                } else {
                    dateFormatter.dateFormat = "dd MMM"
                }
                timeOfLastMessageLabel.text = dateFormatter.string(from: newDate)
            } else {
                timeOfLastMessageLabel.text = ""
            }
        }
    }
    
    // Conform to protocol. Setting online:
    var online: Bool = true {
        didSet {
            self.backgroundColor = online ? #colorLiteral(red: 0.9557935596, green: 0.9555761218, blue: 0, alpha: 1) : #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
    }
    
    // Conform to protocol. Setting hasUnreadMessages:
    var hasUnreadMessages: Bool = true {
        didSet {
            if hasUnreadMessages == true {
                lastMessageLabel.font = UIFont.init(name: "Futura-Bold", size: 14)
                lastMessageLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            } else {
                    lastMessageLabel.font = UIFont.init(name: "Futura-Medium", size: 14)
                lastMessageLabel.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            }
        }
    }
    
    // Conform to protocol. Setting userImage:
    var userImage: String? {
        didSet {
            userImageView.image = UIImage(named: "placeholder-user")
            userImageView.layer.cornerRadius = userImageView.frame.size.height / 2
            userImageView.clipsToBounds = true
        }
    }
}
