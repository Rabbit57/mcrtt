//
//  MPCHandler.swift
//  McRTT
//
//  Created by Egor Orlov on 03/04/2019.
//  Copyright © 2019 XorMagic. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class MPCHandler: NSObject, MCSessionDelegate {
    
    var peerID: MCPeerID!
    var session: MCSession!
    var browser: MCBrowserViewController!
    var advertiser: MCAdvertiserAssistant? = nil
    var names: [String] = []
    var dict: [String : Int] = [:]
    var dictRTT: [Int : Double] = [:]
    var points: [NSMutableArray] = [[]]
    let tableView: UITableView
    
    init(tableView: UITableView) {
        self.tableView = tableView
        super.init()
    }
    
    func setupPeerWithDisplayName(displayName: String) {
        peerID = MCPeerID(displayName: displayName)
    }
    
    func setupSession() {
        session = MCSession(peer: peerID)
        session.delegate = self
    }
    
    func setupBrowser() {
        browser = MCBrowserViewController(serviceType: "my-game", session: session)
    }
    
    func advertiseSelf(advertise: Bool) {
        if advertise {
            advertiser = MCAdvertiserAssistant(serviceType: "my-game", discoveryInfo: nil, session: session)
            advertiser!.start()
        } else {
            advertiser!.stop()
            advertiser = nil
        }
    }
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        if state == MCSessionState.connected {
            names.append(peerID.displayName)
            dict[peerID.displayName] = names.count - 1
            points.append([])
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        let lenName = Int(data[data.startIndex])
        let nameData = data[(data.startIndex + 1)...(data.startIndex + lenName)]
        let recvName = String(decoding: nameData, as: UTF8.self)
        let timeData = data.suffix(from: data.startIndex + lenName + 1)
        let recvTime = Double(String(decoding: timeData, as: UTF8.self))
        if recvName != names[0] {
            try! session.send(data, toPeers: [peerID], with: MCSessionSendDataMode.reliable)
        } else {
            let rtt = CACurrentMediaTime() - recvTime!
            dictRTT[dict[peerID.displayName]!] = rtt
            points[dict[peerID.displayName]!].add(rtt)
        }
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        
    }

}
