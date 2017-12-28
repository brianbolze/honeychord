//
//  KeyChangeViewController.swift
//  Honeychord
//
//  Created by BrianBolze on 12/28/17.
//  Copyright © 2017 Bolze, LLC. All rights reserved.
//

import UIKit

class KeyChangeViewController: UIViewController {
    
    var initialKey  = 0
    var changeHandler : SettingsChangeHandler?
    
    @IBOutlet weak var Segment1: UISegmentedControl! {
        didSet {
            if initialKey < 6 {
                Segment1.selectedSegmentIndex = initialKey
            } else {
                Segment1.selectedSegmentIndex = UISegmentedControlNoSegment
            }
        }
    }
    @IBOutlet weak var Segment2: UISegmentedControl! {
        didSet {
            if initialKey >= 6 {
                let segment = initialKey-6
                Segment2.selectedSegmentIndex = segment
            } else {
                Segment2.selectedSegmentIndex = UISegmentedControlNoSegment
            }
        }
    }
    
    @IBAction func keyChanged(sender: UISegmentedControl) {
        var otherSelector : UISegmentedControl? = nil
        var key=0
        if sender == Segment1 {
            otherSelector = Segment2
        } else {
            key+=6
            otherSelector = Segment1
        }
        otherSelector?.selectedSegmentIndex = UISegmentedControlNoSegment
        key += sender.selectedSegmentIndex
        if let h = changeHandler {
            h.changeKey(toKey: key)
        }
    }
    
    
}

