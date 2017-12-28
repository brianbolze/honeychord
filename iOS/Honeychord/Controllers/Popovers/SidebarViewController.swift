//
//  SidebarViewController.swift
//  Honeychord
//
//  Created by BrianBolze on 12/28/17.
//  Copyright © 2017 Bolze, LLC. All rights reserved.
//

import UIKit

class SideBarViewController: UIViewController {
    
    var changeHandler : SettingsChangeHandler?
    
    @IBAction func zoomIn() {
        changeHandler?.zoomIn()
    }
    
    @IBAction func zoomOut() {
        changeHandler?.zoomOut()
    }
    
    @IBAction func panUp() {
        changeHandler?.panUp()
    }
    
    @IBAction func panDown() {
        changeHandler?.panDown()
    }
    
    @IBAction func panLeft() {
        changeHandler?.panLeft()
    }
    
    @IBAction func panRight() {
        changeHandler?.panRight()
    }
    
}

