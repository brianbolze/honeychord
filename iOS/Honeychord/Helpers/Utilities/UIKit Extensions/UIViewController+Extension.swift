//
//  UIViewController+Extension.swift
//  Honeychord
//
//  Created by BrianBolze on 12/28/17.
//  Copyright © 2017 Bolze, LLC. All rights reserved.
//

import UIKit

// Fix for IOS 9 pop-over arrow anchor bug
// ---------------------------------------
// - IOS9 points pop-over arrows on the top left corner of the anchor view
// - It seems that the popover controller's sourceRect is not being set
//   so, if it is empty  CGRect(0,0,0,0), we simply set it to the source view's bounds
//   which produces the same result as the IOS8 behaviour.
// - This method is to be called in the prepareForSegue method override of all
//   view controllers that use a PopOver segue
//
//   example use:
//
//          override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
//          {
//             fixIOS9PopOverAnchor(segue)
//          }
//
extension UIViewController
{
    func fixIOS9PopOverAnchor(segue: UIStoryboardSegue?)
    {
//        guard #available(iOS 9.0, *) else { return }
        if let popOver = segue?.destination.popoverPresentationController, let anchor = popOver.sourceView, popOver.sourceRect == CGRect() && segue!.source === self
        { popOver.sourceRect = anchor.bounds }
    }
}
