//
//  DraggableImageView.swift
//  Honeychord
//
//  Created by BrianBolze on 1/2/18.
//  Copyright © 2018 Bolze, LLC. All rights reserved.
//

import UIKit

class DraggableImageView : UIImageView {
    
    var dragStartPositionRelativeToCenter : CGPoint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        isUserInteractionEnabled = true
        addGestureRecognizer(UIPanGestureRecognizer(target: self, action: "handlePan:"))
    }
    
    override init(image: UIImage!) {
        super.init(image: image)
        isUserInteractionEnabled = true
        addGestureRecognizer(UIPanGestureRecognizer(target: self, action: "handlePan:"))
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        isUserInteractionEnabled = true
        addGestureRecognizer(UIPanGestureRecognizer(target: self, action: "handlePan:"))
    }
    
    func handlePan(recognizer : UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            let locationInView = recognizer.location(in: superview)
            dragStartPositionRelativeToCenter = CGPoint(x: locationInView.x - center.x, y: locationInView.y - center.y)
        case .ended:
            dragStartPositionRelativeToCenter = nil
        default:
            let locationInView = recognizer.location(in: superview)
            UIView.animate(withDuration: 0.1, animations: {
                self.center = CGPoint(x: locationInView.x - self.dragStartPositionRelativeToCenter!.x,
                                      y: locationInView.y - self.dragStartPositionRelativeToCenter!.y) })
        }
    }
}
