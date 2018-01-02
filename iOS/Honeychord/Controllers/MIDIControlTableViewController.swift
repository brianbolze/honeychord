//
//  MIDIControlTableViewController.swift
//  Honeychord
//
//  Created by BrianBolze on 1/2/18.
//  Copyright © 2018 Bolze, LLC. All rights reserved.
//

import UIKit

class MIDIControlTableViewController: UITableViewController {
    
    var busHandler : MIDIBusSettingsHandler?
    var controlKnob : Int = 0
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 16
        case 2:
            return 128
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "MIDI Send"
        case 1:
            return "Channel"
        case 2:
            return "Control Number"
        default:
            return ""
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "midiCtrlCell", for: indexPath as IndexPath)
        switch indexPath.section {
        case 0:
            var text = "Off"
            if busHandler!.knobState(knobID: controlKnob) {
                text = "On"
            }
            cell.textLabel?.text = text
            cell.selectionStyle = .none
        case 1:
            cell.textLabel?.text = "\(indexPath.row)"
        case 2:
            cell.textLabel?.text = MIDIControl.knownControls[indexPath.row].description
        default:
            break
        }
        cell.backgroundColor = UIColor.gray
        cell.textLabel?.textColor = UIColor.white
        cell.textLabel?.font = UIFont(name: "Helvetica Neue", size: 12)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            let activated = busHandler?.toggleKnob(knobID: controlKnob)
            var text = "Off"
            if activated! {
                text = "On"
            }
            let cell = tableView.cellForRow(at: indexPath as IndexPath)
            cell!.textLabel!.text = text
            
        case 1:
            busHandler?.assignKnobChannel(knobID: controlKnob, channelNum: indexPath.row)
        case 2:
            busHandler?.assignKnobControl(knobID: controlKnob, control: MIDIControl.knownControls[indexPath.row])
        default:
            break
        }
    }
    
}

