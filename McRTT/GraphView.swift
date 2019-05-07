//
//  GraphView.swift
//  McRTT
//
//  Created by Egor Orlov on 03/04/2019.
//  Copyright © 2019 XorMagic. All rights reserved.
//

import UIKit

class GraphView: UIView {
    
    var points: NSMutableArray = []
    let scaleY = 100.0
    let originY: CGFloat = 2.0 / 3
    var labels: [UILabel] = []
    
    override func layoutSubviews() {
        for i in labels {
            i.removeFromSuperview()
        }
        
        labels.removeAll()
        for i in 0...4 {
            let rect = CGRect(x: 0, y: (Int(frame.height * originY) - 2) - i * 25, width: 100, height: 20)
            labels.append(UILabel(frame: rect))
            labels[i].text = "\(Double(i) * 0.25)"
            addSubview(labels[i])
        }
        
    }
    
    override func draw(_ rect: CGRect) {
        guard let cont = UIGraphicsGetCurrentContext() else {return}
        cont.translateBy(x: 0, y: frame.height * originY)
        cont.scaleBy(x: 1, y: -1)
        cont.strokeLineSegments(between: [CGPoint(x: 0.0, y: 0.0), CGPoint(x: Double(frame.width), y: 0.0)])
        cont.setFillColor(UIColor.red.cgColor)
        cont.setStrokeColor(UIColor.lightGray.cgColor)
        
        for i in 1...4 {
            cont.strokeLineSegments(between: [CGPoint(x: 0.0, y: Double(i) * scaleY / 4), CGPoint(x: Double(frame.width), y: Double(i) * scaleY / 4)])
        }
        
        for i in 0...Int(rect.width - 1) {
            if i >= points.count {return}
            cont.fillEllipse(in: CGRect(x: i, y: Int((points[i] as! Double) * scaleY), width: 2, height: 2))
        }
        
    }
}
