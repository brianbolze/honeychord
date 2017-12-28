//
//  Bundle+Extension.swift
//  Honeychord
//
//  Created by BrianBolze on 12/28/17.
//  Copyright © 2017 Bolze, LLC. All rights reserved.
//

import Foundation

public extension Bundle {
    public var releaseVersionNumber: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    public var buildVersionNumber: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
    public var fullVersionString: String {
        let version = releaseVersionNumber ?? "0.0"
        let build = buildVersionNumber ?? "0"
        return version + "." + build
    }
}
