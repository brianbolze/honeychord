//
//  MIDIControl.swift
//  Honeychord
//
//  Created by BrianBolze on 12/28/17.
//  Copyright © 2017 Bolze, LLC. All rights reserved.
//

import Foundation

public enum MIDIControl : Int, CustomStringConvertible {
    case ctrl_0 = 0
    case ctrl_1
    case ctrl_2
    case ctrl_3
    case ctrl_4
    case ctrl_5
    case ctrl_6
    case ctrl_7
    case ctrl_8
    case ctrl_9
    case ctrl_10
    case ctrl_11
    case ctrl_12
    case ctrl_13
    case ctrl_14
    case ctrl_15
    case ctrl_16
    case ctrl_17
    case ctrl_18
    case ctrl_19
    case ctrl_20
    case ctrl_21
    case ctrl_22
    case ctrl_23
    case ctrl_24
    case ctrl_25
    case ctrl_26
    case ctrl_27
    case ctrl_28
    case ctrl_29
    case ctrl_30
    case ctrl_31
    case ctrl_32
    case ctrl_33
    case ctrl_34
    case ctrl_35
    case ctrl_36
    case ctrl_37
    case ctrl_38
    case ctrl_39
    case ctrl_40
    case ctrl_41
    case ctrl_42
    case ctrl_43
    case ctrl_44
    case ctrl_45
    case ctrl_46
    case ctrl_47
    case ctrl_48
    case ctrl_49
    case ctrl_50
    case ctrl_51
    case ctrl_52
    case ctrl_53
    case ctrl_54
    case ctrl_55
    case ctrl_56
    case ctrl_57
    case ctrl_58
    case ctrl_59
    case ctrl_60
    case ctrl_61
    case ctrl_62
    case ctrl_63
    case ctrl_64
    case ctrl_65
    case ctrl_66
    case ctrl_67
    case ctrl_68
    case ctrl_69
    case ctrl_70
    case ctrl_71
    case ctrl_72
    case ctrl_73
    case ctrl_74
    case ctrl_75
    case ctrl_76
    case ctrl_77
    case ctrl_78
    case ctrl_79
    case ctrl_80
    case ctrl_81
    case ctrl_82
    case ctrl_83
    case ctrl_84
    case ctrl_85
    case ctrl_86
    case ctrl_87
    case ctrl_88
    case ctrl_89
    case ctrl_90
    case ctrl_91
    case ctrl_92
    case ctrl_93
    case ctrl_94
    case ctrl_95
    case ctrl_96
    case ctrl_97
    case ctrl_98
    case ctrl_99
    case ctrl_100
    case ctrl_101
    case ctrl_102
    case ctrl_103
    case ctrl_104
    case ctrl_105
    case ctrl_106
    case ctrl_107
    case ctrl_108
    case ctrl_109
    case ctrl_110
    case ctrl_111
    case ctrl_112
    case ctrl_113
    case ctrl_114
    case ctrl_115
    case ctrl_116
    case ctrl_117
    case ctrl_118
    case ctrl_119
    case ctrl_120
    case ctrl_121
    case ctrl_122
    case ctrl_123
    case ctrl_124
    case ctrl_125
    case ctrl_126
    case ctrl_127
    
    public static var knownControls : [MIDIControl] {
        return [ctrl_0, ctrl_1, ctrl_2, ctrl_3, ctrl_4, ctrl_5, ctrl_6, ctrl_7, ctrl_8, ctrl_9, ctrl_10, ctrl_11, ctrl_12, ctrl_13, ctrl_14, ctrl_15, ctrl_16, ctrl_17, ctrl_18, ctrl_19, ctrl_20, ctrl_21, ctrl_22, ctrl_23, ctrl_24, ctrl_25, ctrl_26, ctrl_27, ctrl_28, ctrl_29, ctrl_30, ctrl_31, ctrl_32, ctrl_33, ctrl_34, ctrl_35, ctrl_36, ctrl_37, ctrl_38, ctrl_39, ctrl_40, ctrl_41, ctrl_42, ctrl_43, ctrl_44, ctrl_45, ctrl_46, ctrl_47, ctrl_48, ctrl_49, ctrl_50, ctrl_51, ctrl_52, ctrl_53, ctrl_54, ctrl_55, ctrl_56, ctrl_57, ctrl_58, ctrl_59, ctrl_60, ctrl_61, ctrl_62, ctrl_63, ctrl_64, ctrl_65, ctrl_66, ctrl_67, ctrl_68, ctrl_69, ctrl_70, ctrl_71, ctrl_72, ctrl_73, ctrl_74, ctrl_75, ctrl_76, ctrl_77, ctrl_78, ctrl_79, ctrl_80, ctrl_81, ctrl_82, ctrl_83, ctrl_84, ctrl_85, ctrl_86, ctrl_87, ctrl_88, ctrl_89, ctrl_90, ctrl_91, ctrl_92, ctrl_93, ctrl_94, ctrl_95, ctrl_96, ctrl_97, ctrl_98, ctrl_99, ctrl_100, ctrl_101, ctrl_102, ctrl_103, ctrl_104, ctrl_105, ctrl_106, ctrl_107, ctrl_108, ctrl_109, ctrl_110, ctrl_111, ctrl_112, ctrl_113, ctrl_114, ctrl_115, ctrl_116, ctrl_117, ctrl_118, ctrl_119, ctrl_120, ctrl_121, ctrl_122, ctrl_123, ctrl_124, ctrl_125, ctrl_126, ctrl_127]
    }
    
    public var shortDescription : String {
        return "Ctrl-\(rawValue)"
    }
    
    public var description : String {
        switch self {
        case .ctrl_0:
            return "Bank Select (0)"
        case .ctrl_1:
            return "Modulation (1)"
        case .ctrl_2:
            return "Breath (2)"
        case .ctrl_3:
            return "Control 3 (3)"
        case .ctrl_4:
            return "Foot Pedal (4)"
        case .ctrl_5:
            return "Portamento Time (5)"
        case .ctrl_6:
            return "Data MSB (6)"
        case .ctrl_7:
            return "Volume (7)"
        case .ctrl_8:
            return "Balance (8)"
        case .ctrl_9:
            return "Ctrl_9 (9)"
        case .ctrl_10:
            return "Pan (10)"
        case .ctrl_11:
            return "Expression (11)"
        case .ctrl_12:
            return "Effect #1 MSB (12)"
        case .ctrl_13:
            return "Effect #2 MSB (13)"
        case .ctrl_14:
            return "Ctrl_14 (14)"
        case .ctrl_15:
            return "Ctrl_15 (15)"
        case .ctrl_16:
            return "General #1 (16)"
        case .ctrl_17:
            return "General #2 (17)"
        case .ctrl_18:
            return "General #3 (18)"
        case .ctrl_19:
            return "General #4 (19)"
        case .ctrl_20:
            return "Ctrl_20 (20)"
        case .ctrl_21:
            return "Ctrl_21 (21)"
        case .ctrl_22:
            return "Ctrl_22 (22)"
        case .ctrl_23:
            return "Ctrl_23 (23)"
        case .ctrl_24:
            return "Ctrl_24 (24)"
        case .ctrl_25:
            return "Ctrl_25 (25)"
        case .ctrl_26:
            return "Ctrl_26 (26)"
        case .ctrl_27:
            return "Ctrl_27 (27)"
        case .ctrl_28:
            return "Ctrl_28 (28)"
        case .ctrl_29:
            return "Ctrl_29 (29)"
        case .ctrl_30:
            return "Ctrl_30 (30)"
        case .ctrl_31:
            return "Ctrl_31 (31)"
        case .ctrl_32:
            return "Bank LSB (32)"
        case .ctrl_33:
            return "(#1 LSB) (33)"
        case .ctrl_34:
            return "(#2 LSB) (34)"
        case .ctrl_35:
            return "(#3 LSB) (35)"
        case .ctrl_36:
            return "(#4 LSB) (36)"
        case .ctrl_37:
            return "(#5 LSB) (37)"
        case .ctrl_38:
            return "(#6 LSB) (38)"
        case .ctrl_39:
            return "(#7 LSB) (39)"
        case .ctrl_40:
            return "(#8 LSB) (40)"
        case .ctrl_41:
            return "(#9 LSB) (41)"
        case .ctrl_42:
            return "(#10 LSB) (42)"
        case .ctrl_43:
            return "(#11 LSB) (43)"
        case .ctrl_44:
            return "Effect #1 LSB (44)"
        case .ctrl_45:
            return "Effect #2 LSB (45)"
        case .ctrl_46:
            return "(#14 LSB) (46)"
        case .ctrl_47:
            return "(#15 LSB) (47)"
        case .ctrl_48:
            return "(#16 LSB) (48)"
        case .ctrl_49:
            return "(#17 LSB) (49)"
        case .ctrl_50:
            return "(#18 LSB) (50)"
        case .ctrl_51:
            return "(#19 LSB) (51)"
        case .ctrl_52:
            return "(#20 LSB) (52)"
        case .ctrl_53:
            return "(#21 LSB) (53)"
        case .ctrl_54:
            return "(#22 LSB) (54)"
        case .ctrl_55:
            return "(#23 LSB) (55)"
        case .ctrl_56:
            return "(#24 LSB) (56)"
        case .ctrl_57:
            return "(#25 LSB) (57)"
        case .ctrl_58:
            return "(#26 LSB) (58)"
        case .ctrl_59:
            return "(#27 LSB) (59)"
        case .ctrl_60:
            return "(#28 LSB) (60)"
        case .ctrl_61:
            return "(#29 LSB) (61)"
        case .ctrl_62:
            return "(#30 LSB) (62)"
        case .ctrl_63:
            return "(#31 LSB) (63)"
        case .ctrl_64:
            return "Sustain (64)"
        case .ctrl_65:
            return "Portamento (65)"
        case .ctrl_66:
            return "Sostenuto (66)"
        case .ctrl_67:
            return "Soft Pedal (67)"
        case .ctrl_68:
            return "Legato (68)"
        case .ctrl_69:
            return "Hold 2 (69)"
        case .ctrl_70:
            return "Sound Variation (70)"
        case .ctrl_71:
            return "Timbre (71)"
        case .ctrl_72:
            return "Release Time (72)"
        case .ctrl_73:
            return "Attack Time (73)"
        case .ctrl_74:
            return "Brightness (74)"
        case .ctrl_75:
            return "Decay Time (75)"
        case .ctrl_76:
            return "Vebrato Rate (76)"
        case .ctrl_77:
            return "Vebrato Depth (77)"
        case .ctrl_78:
            return "Vebrato Delay (78)"
        case .ctrl_79:
            return "Ctrl_79 (79)"
        case .ctrl_80:
            return "Decay (80)"
        case .ctrl_81:
            return "HPF Frequency (81)"
        case .ctrl_82:
            return "General #7 (82)"
        case .ctrl_83:
            return "General #8 (83)"
        case .ctrl_84:
            return "Portamento Ctrl (84)"
        case .ctrl_85:
            return "Ctrl_85 (85)"
        case .ctrl_86:
            return "Ctrl_86 (86)"
        case .ctrl_87:
            return "Ctrl_87 (87)"
        case .ctrl_88:
            return "High Resolution Velocity Prefix (88)"
        case .ctrl_89:
            return "Ctrl_89 (89)"
        case .ctrl_90:
            return "Ctrl_90 (90)"
        case .ctrl_91:
            return "Reverb (91)"
        case .ctrl_92:
            return "Tremolo Depth (92)"
        case .ctrl_93:
            return "Chorus Send Level (93)"
        case .ctrl_94:
            return "Celeste (Detune) Depth (94)"
        case .ctrl_95:
            return "Phaser Depth (95)"
        case .ctrl_96:
            return "Data Increment (96)"
        case .ctrl_97:
            return "Data Decrement (97)"
        case .ctrl_98:
            return "Non-Reg. LSB (98)"
        case .ctrl_99:
            return "Non-Reg. MSB (99)"
        case .ctrl_100:
            return "Reg.Par. LSB (100)"
        case .ctrl_101:
            return "Reg.Par. MSB (101)"
        case .ctrl_102:
            return "Ctrl_102 (102)"
        case .ctrl_103:
            return "Ctrl_103 (103)"
        case .ctrl_104:
            return "Ctrl_104 (104)"
        case .ctrl_105:
            return "Ctrl_105 (105)"
        case .ctrl_106:
            return "Ctrl_106 (106)"
        case .ctrl_107:
            return "Ctrl_107 (107)"
        case .ctrl_108:
            return "Ctrl_108 (108)"
        case .ctrl_109:
            return "Ctrl_109 (109)"
        case .ctrl_110:
            return "Ctrl_110 (110)"
        case .ctrl_111:
            return "Ctrl_111 (111)"
        case .ctrl_112:
            return "Ctrl_112 (112)"
        case .ctrl_113:
            return "Ctrl_113 (113)"
        case .ctrl_114:
            return "Ctrl_114 (114)"
        case .ctrl_115:
            return "Ctrl_115 (115)"
        case .ctrl_116:
            return "Ctrl_116 (116)"
        case .ctrl_117:
            return "Ctrl_117 (117)"
        case .ctrl_118:
            return "Ctrl_118 (118)"
        case .ctrl_119:
            return "Ctrl_119 (119)"
        case .ctrl_120:
            return "All Sound Off (120)"
        case .ctrl_121:
            return "Reset All Controllers (121)"
        case .ctrl_122:
            return "Local Control (122)"
        case .ctrl_123:
            return "All Notes Off (123)"
        case .ctrl_124:
            return "Omni Mode Off (124)"
        case .ctrl_125:
            return "Omni Mode On (125)"
        case .ctrl_126:
            return "Mono Mode On (126)"
        case .ctrl_127:
            return "Poly Mode On (127)"
        }
    }
    
}
