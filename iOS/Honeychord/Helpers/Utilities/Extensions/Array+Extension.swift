//
//  Array+Extension.swift
//  Honeychord
//
//  Created by BrianBolze on 1/2/18.
//  Copyright © 2018 Bolze, LLC. All rights reserved.
//

import Foundation

extension Array {
    subscript (safe index: Int) -> Element? {
        return indices ~= index ? self[index] : nil
    }
}
