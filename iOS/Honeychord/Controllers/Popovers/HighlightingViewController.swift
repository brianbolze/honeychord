//
//  HighlightingViewController.swift
//  Honeychord
//
//  Created by BrianBolze on 12/28/17.
//  Copyright © 2017 Bolze, LLC. All rights reserved.
//

import UIKit

class HighlightingViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    enum HighlightingSelectionMode {
        case Scales
        case ChordProgressions
        
        var numElements : Int {
            switch self {
            case .Scales:
                return Scale.knownScales.count
            case .ChordProgressions:
                return ChordProgression.knownProgressions.count
            }
        }
        
        func titleForRow(row : Int) -> String {
            switch self {
            case .Scales:
                return Scale.knownScales[row].name
            case .ChordProgressions:
                return ChordProgression.knownProgressions[row].name
            }
        }
    }
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var picker: UIPickerView! {
        didSet {
            picker.delegate = self
            picker.dataSource = self
            switch selectionMode {
            case .ChordProgressions:
                picker.selectRow(ChordProgression.knownProgressions.index(of: currentProgression)!, inComponent: 0, animated: false)
            case .Scales:
                picker.selectRow(Scale.knownScales.index(of: currentScale)!, inComponent: 0, animated: false)
            }
        }
    }
    
    // MARK: - Properties
    
    var selectionMode = HighlightingSelectionMode.ChordProgressions
    var changeHandler : SettingsChangeHandler?
    var currentProgression = ChordProgression.I_IV_V_I
    var currentScale = Scale.Major
    
    
    // MARK: - UIPickerViewDelegate
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch selectionMode {
        case .ChordProgressions:
            let new = ChordProgression.knownProgressions[row]
            currentProgression = new
            if let h = changeHandler {
                h.changeChordProgression(progression: new)
            }
        case .Scales:
            let new = Scale.knownScales[row]
            currentScale = new
            if let h = changeHandler {
                h.changeScale(toScale: currentScale)
            }
        }
    }
    
    
    // MARK: - UIPickerViewDataSource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return selectionMode.numElements
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let string = selectionMode.titleForRow(row: row)
        // return NSAttributedString(string: string, attributes: [NSForegroundColorAttributeName:UIColor.whiteColor()])
        return NSAttributedString(string: string, attributes: [NSAttributedStringKey.foregroundColor: UIColor.darkText])
    }
    
}

