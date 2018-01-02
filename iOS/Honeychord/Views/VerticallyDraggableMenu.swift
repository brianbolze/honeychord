//
//  VerticallyDraggableMenu.swift
//  Honeychord
//
//  Created by BrianBolze on 1/2/18.
//  Copyright © 2018 Bolze, LLC. All rights reserved.
//

import UIKit

protocol DraggableMenuDelegate {
    var panel : UIView? { get }
    var panelConstraint: NSLayoutConstraint? { get }
    var translateDistance : CGFloat { get }
    var translateTresholdDistance : CGFloat { get }
}

class VerticallyDraggableMenu : UIImageView {
    
    var startPosition : CGFloat?
    var dragStartPositionRelativeToCenter : CGFloat?
    var panelDelegate : DraggableMenuDelegate?
    var panelDragStartPositionRelativeToCenter : CGFloat?
    var translateDistance : CGFloat {
        if let d = panelDelegate {
            return d.translateDistance
        } else {
            return 100
        }
    }
    var translateTresholdDistance : CGFloat {
        if let d = panelDelegate {
            return d.translateTresholdDistance
        } else {
            return 50
        }
    }
    
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        sharedInit()
    }
    
    override init(image: UIImage!) {
        super.init(image: image)
        
        sharedInit()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        sharedInit()
    }
    
    private func sharedInit() {
        startPosition = center.y
        isUserInteractionEnabled = true
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
        addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePan)))
    }
    
    @objc func handleTap(recognizer: UITapGestureRecognizer) {
        if recognizer.state == .ended {
            let relativePosition = center.y - startPosition!
            let translate : CGFloat
            if relativePosition == 0 {
                translate = translateDistance
            } else {
                translate = -translateDistance
            }
            translateDistance(translate)
        }
    }
    
    @objc func handlePan(recognizer : UIPanGestureRecognizer) {
        let locationInView = recognizer.location(in: superview)
        switch recognizer.state {
        case .began:
            dragStartPositionRelativeToCenter = locationInView.y - center.y
            if let d = panelDelegate {
                if let p = d.panel {
                    panelDragStartPositionRelativeToCenter = locationInView.y - p.center.y
                }
            }
        case .ended:
            let relativePosition = center.y - startPosition!
            let touchPosition = locationInView.y - startPosition!
            var translate = CGFloat(0)
            if touchPosition > translateTresholdDistance {
                translate = translateDistance - relativePosition
            } else {
                translate = -relativePosition
            }
            translateDistance(translate)
            dragStartPositionRelativeToCenter = nil
        default:
            let newY = locationInView.y - self.dragStartPositionRelativeToCenter!
            if newY <= startPosition! + translateDistance && newY >= startPosition! {
                UIView.animate(withDuration: 0.1, animations: {
                    self.center.y = newY})
                if let d = panelDelegate {
                    if let p = d.panel {
                        UIView.animate(withDuration: 0.1, animations: {
                            p.center.y = locationInView.y - self.panelDragStartPositionRelativeToCenter!})
                    }
                }
            }
        }
    }
    
    private func translateDistance(_ distance: CGFloat) {
        UIView.animate(withDuration: 0.1, animations: {
            self.center.y += distance})
        if let d = panelDelegate {
            
            if let p = d.panel {
                UIView.animate(withDuration: 0.1, animations: {
                    // p.frame.origin.y += translateDistance
                    p.center.y += distance
                })
            }
        }
        
    }
}

