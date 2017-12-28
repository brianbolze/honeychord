//
//  ChordProgression.swift
//  Honeychord
//
//  Created by BrianBolze on 12/28/17.
//  Copyright © 2017 Bolze, LLC. All rights reserved.
//

import Foundation

public enum ChordProgression {
    
    case ii_V_I
    case V_IV_I
    case I_IV_V_I
    case I_vi_ii_V
    case Fiftys_Progression
    case Pop_Punk_Progression
    case Circle_Progression
    case Twelve_Bar_Blues
    case Pachelbels_Canon
    case Ragtime_Progression
    
    public static var knownProgressions : [ChordProgression] {
        return [.ii_V_I, .V_IV_I, .I_IV_V_I, .I_vi_ii_V, .Fiftys_Progression,
                .Pop_Punk_Progression, .Circle_Progression, .Twelve_Bar_Blues,
                .Pachelbels_Canon, .Ragtime_Progression]
    }
    
    public var name : String {
        switch self {
        case .ii_V_I:
            return "ii-V-I"
        case .V_IV_I:
            return "V-IV-I"
        case .I_IV_V_I:
            return "I-IV-V-I"
        case .I_vi_ii_V:
            return "I-vi-ii-V"
        case .Fiftys_Progression:
            return "Fifty's Progression"
        case .Pop_Punk_Progression:
            return "Pop-Punk Progression"
        case .Circle_Progression:
            return "Circle Progression"
        case .Twelve_Bar_Blues:
            return "12-Bar Blues"
        case .Pachelbels_Canon:
            return "Pachelbels Canon"
        case .Ragtime_Progression:
            return "Ragtime Progression"
        }
    }
    
    public var intervals : [Int] {
        switch self {
        case .ii_V_I:
            return [2,7,0]
        case .V_IV_I:
            return [7,5,0]
        case .I_IV_V_I:
            return [0,5,7,0]
        case .I_vi_ii_V:
            return [0,9,2,7]
        case .Fiftys_Progression:
            return [0,9,5,7]
        case .Pop_Punk_Progression:
            return [0,7,9,5]
        case .Circle_Progression:
            return [0,9,5,4,9,6,2,7]
        case .Twelve_Bar_Blues:
            return [0,0,0,0,5,5,0,0,7,5,0]
        case .Pachelbels_Canon:
            return [12,7,9,4,5,0,5,7]
        case .Ragtime_Progression:
            return [9,2,7,0]
        }
    }
    
    public var chords : [Chord] {
        switch self {
        case .ii_V_I:
            return [.Minor7, .Dominant7, .Major7]
        case .V_IV_I:
            return [.Major, .Major, .Major]
        case .I_IV_V_I:
            return [.Major, .Major, .Major, .Major]
        case .I_vi_ii_V:
            return [.Major, .Minor, .Minor, .Major]
        case .Fiftys_Progression:
            return [.Major, .Minor, .Major, .Major]
        case .Pop_Punk_Progression:
            return [.Major, .Major, .Minor, .Major]
        case .Circle_Progression:
            return [.Major7, .Minor7, .Major7, .Dominant7,.Minor7,.Minor7flat5,.Minor7,.Dominant7]
        case .Twelve_Bar_Blues:
            return [.Major, .Major, .Major, .Major, .Major, .Major, .Major, .Major, .Major, .Major, .Major, .Major]
        case .Pachelbels_Canon:
            return [.Major, .Major, .Minor, .Minor, .Major, .Major, .Major, .Major]
        case .Ragtime_Progression:
            return [.Major7, .Major7, .Major7, .Major]
        }
    }
    
}

extension ChordProgression: CustomStringConvertible {
    
    public var description : String {
        switch self {
        case .ii_V_I:
            return "ii-V-I"
        case .V_IV_I:
            return "V-IV-I"
        case .I_IV_V_I:
            return "I-IV-V-I"
        case .I_vi_ii_V:
            return "I-vi-ii-V"
        case .Fiftys_Progression:
            return "I-vi-IV-V"
        case .Pop_Punk_Progression:
            return "I-V-vi-IV"
        case .Circle_Progression:
            return "I▵⁷-vi⁷-IV-III⁷-vi⁷-ᵇv⁷-ii⁷-V⁷"
        case .Twelve_Bar_Blues:
            // return "Twelve_Bar_Blues"
            return "I-I-I-I-IV-IV-I-I-V-IV-I-I"
        case .Pachelbels_Canon:
            return "I-V-vi-iii-IV-I-IV-V"
        case .Ragtime_Progression:
            return "VI⁷-II⁷-V⁷-I"
        }
    }
    
}
