//
//  GraphViewController.swift
//  McRTT
//
//  Created by Egor Orlov on 03/04/2019.
//  Copyright © 2019 XorMagic. All rights reserved.
//

import UIKit

class GraphViewController: UIViewController {
    
    var points: NSMutableArray = []

    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        
    }
    
    func updateGraph() {
        if points.count >= Int(view.frame.width) {
            points.removeAllObjects()
        }
        
        view.setNeedsDisplay()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            self.updateGraph()
        }
        
        (view as! GraphView).points = points

    }

}
