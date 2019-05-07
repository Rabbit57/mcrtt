//
//  TableViewController.swift
//  McRTT
//
//  Created by Egor Orlov on 02/04/2019.
//  Copyright © 2019 XorMagic. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class TableViewController: UITableViewController, MCBrowserViewControllerDelegate {
    
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        browserViewController.dismiss(animated: true, completion: nil)
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        browserViewController.dismiss(animated: true, completion: nil)
    }
    
    var mpcHandler: MPCHandler!
    let ourName = UIDevice.current.name
    
    func updateRTTLabel() {
        for i in 0...mpcHandler.names.count - 1 {
            let indexPath = IndexPath(row: i, section: 0)
            if (self.tableView.cellForRow(at: indexPath) != nil) {
               (self.tableView.cellForRow(at: indexPath) as! TableViewCell).roundTrip.text = "\(mpcHandler.dictRTT[i] ?? 0)"
            }
        }
        
    }
    
    func sendData() {
        if mpcHandler.session.connectedPeers.count == 0 {return}
        var data: Data = Data()
        let lenName = (ourName.data(using: .utf8))!.count
        if lenName >= 256 {return}
        data.append(contentsOf: [UInt8(lenName)])
        data.append(ourName.data(using: .utf8)!)
        data.append("\(CACurrentMediaTime())".data(using: .utf8)!)
        try! mpcHandler.session.send(data, toPeers: mpcHandler.session.connectedPeers, with: MCSessionSendDataMode.reliable)
        
    }
    
    @IBAction func connectWithPeers(_ sender: Any) {
        if mpcHandler.session != nil {
            mpcHandler.setupBrowser()
            mpcHandler.browser.delegate = self
            self.present(mpcHandler.browser, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mpcHandler = MPCHandler(tableView: tableView)
        mpcHandler.setupPeerWithDisplayName(displayName: ourName)
        mpcHandler.setupSession()
        mpcHandler.advertiseSelf(advertise: true)
        mpcHandler.names.append(ourName)
        mpcHandler.dict[ourName] = 0
        mpcHandler.dictRTT[0] = 0
        
        Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { timer in
            self.updateRTTLabel()
        }
        
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            self.sendData()
        }
    }
    

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mpcHandler.names.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableRow", for: indexPath) as? TableViewCell
        
        let n = indexPath.row
        
        cell!.name.text = "\(mpcHandler.names[n])"

        return cell!
    }
    
    var indX = 0
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        indX = indexPath.row
        performSegue(withIdentifier: "graphView", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let info = segue.destination as! GraphViewController
        info.points = mpcHandler.points[indX]
    }

}
