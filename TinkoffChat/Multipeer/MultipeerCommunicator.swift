//
//  MultipeerCommunicator.swift
//  TinkoffChat
//
//  Created by Valeriia Korenevich on 17/03/2019.
//  Copyright © 2019 Valeriia Korenevich. All rights reserved.
//

import Foundation
import MultipeerConnectivity


class MultipeerCommunicator: NSObject, Communicator {
    
    
    weak var delegate: CommunicatorDelegate?
    
    private let serviceBrowser: MCNearbyServiceBrowser!
    private let serviceAdvertiser: MCNearbyServiceAdvertiser!
    
    var online: Bool = false
    let serviceType = "tinkoff-chat"
    let myPeerID = MCPeerID(displayName: UIDevice.current.name)
    
    //Create a lazy initialized session property to create a MCSession on demand and implement the MCSessionDelegate protocol:
    lazy var session : MCSession = {
        let session = MCSession(peer: myPeerID,
                                securityIdentity: nil,
                                encryptionPreference: .none)
        session.delegate = self
        return session
    }()
    
    
    override init() {
        
        serviceAdvertiser = MCNearbyServiceAdvertiser(peer: myPeerID,
                                                      discoveryInfo: ["userName": UIDevice.current.name],
                                                      serviceType: serviceType)
        serviceBrowser = MCNearbyServiceBrowser(peer: myPeerID,
                                                serviceType: serviceType)
        super.init()
        
        serviceAdvertiser.delegate = self
        // make a visible for another peer
        serviceAdvertiser.startAdvertisingPeer()
        online = true
        
        serviceBrowser.delegate = self
        //started searching for peers
        serviceBrowser.startBrowsingForPeers()
    }
    
    deinit {
        serviceAdvertiser.stopAdvertisingPeer()
        serviceBrowser.stopBrowsingForPeers()
        online = false
    }
    
    func sendMessage(string: String, to userID: String, completionHandler: ((Bool, Error?) -> ())?) {
        if let indexTo = session.connectedPeers.index(where: {(user) -> Bool in
            user.displayName == userID // check if this is the user you are looking
        }) {
            do {
                var message = [String:String]()
                message["eventType"] = "TextMessage"
                message["text"] = string
                message["messageId"] = generateMessageId()
                
                let jsonMessage = try! JSONSerialization.data(withJSONObject: message, options: .prettyPrinted)
                try session.send(jsonMessage, toPeers: [session.connectedPeers[indexTo]], with: .reliable)
                completionHandler?(true, nil)
            } catch let error {
                completionHandler?(false, error)
            }
        }
    }
}

extension MultipeerCommunicator: MCSessionDelegate {
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        if (state == .connected) {
            print("\(peerID.displayName) State changed: connected")
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: []) as! Dictionary<String, String>
            
            if let text = json["text"] {
                delegate?.didRecieveMessage(text: text,
                                            fromUser: peerID.displayName,
                                            toUser: myPeerID.displayName)
            }
            
        } catch {
            print("problem with json")
        }
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
    }
    
}


extension MultipeerCommunicator: MCNearbyServiceAdvertiserDelegate {
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        
        if session.connectedPeers.contains(peerID) {
            invitationHandler(false, nil)
        } else {
            //When you receive an invitation, accept it by calling the invitionHandler block with true
            invitationHandler(true, session)
        }
    }
    
    private func advertiser(advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        delegate?.failedToStartAdvertising(error: error)
        print("did not start advertising \(error)")
    }
}


extension MultipeerCommunicator: MCNearbyServiceBrowserDelegate {
    
    //send invite to ID
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        if let info = info {
            delegate?.didFoundUser(userID: peerID.displayName, userName: info["userName"])
        }
        browser.invitePeer(peerID, to: session, withContext: nil, timeout: 60)
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        delegate?.didLostUser(userID: peerID.displayName)
        print(peerID.displayName)
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        delegate?.failedToStartBrowsingForUsers(error: error)
        print("didNotStartBrowsingForPeers: \(error)")
    }
    
}


protocol Communicator {
    func sendMessage(string: String, to userID: String, completionHandler: ((_ success: Bool, _ error: Error?) -> ())?)
    var delegate: CommunicatorDelegate? {get set}
    var online: Bool {get set}
}


protocol CommunicatorDelegate: class {
    //discovering
    func didFoundUser(userID: String, userName: String?)
    func didLostUser(userID: String)
    
    //errors
    func failedToStartBrowsingForUsers(error: Error)
    func failedToStartAdvertising(error: Error)
    
    //messages
    func didRecieveMessage(text: String, fromUser: String, toUser: String)
}

