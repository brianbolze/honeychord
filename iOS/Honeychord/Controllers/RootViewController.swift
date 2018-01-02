//
//  RootViewController.swift
//  Honeychord
//
//  Created by BrianBolze on 12/28/17.
//  Copyright © 2017 Bolze, LLC. All rights reserved.
//

import UIKit

protocol MidiHandler {
    func noteOn(note : Note)
    func noteOn(note : Note, velocity : Int)
    func noteOff(note : Note)
    func aftertouch(note : Note, value : Int)
    func pitchBend(value : Int, channel : Int)
    func ctrlChange(value : Int, ctrl : Int, channel : Int)
    func volumeChange(value : Int)
    func isChordTone(note : Note) -> Bool
    func motionToggle(on : Bool)
    func zeroX()
    func zeroY()
    func zeroZ()
}


class RootViewController: UIViewController {
    
    var services: AppServices!
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // titleLabel.text = services.appName
    }

}
