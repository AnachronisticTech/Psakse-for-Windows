//
//  Colors.swift
//  Psakse
//
//  Created by Daniel Marriner on 29/06/2019.
//  Copyright © 2019 Daniel Marriner. All rights reserved.
//

enum Colors {//: CaseIterable {
    case Green
    case Yellow
    case Purple
    case Orange
    
    var color: Color {
        switch self {
            case .Green: return Color.FromRgb(175, 227, 70)
            case .Yellow: return Color.FromRgb(255, 220, 115)
            case .Purple: return Color.FromRgb(236, 167, 238)
            case .Orange: return Color.FromRgb(225, 153, 51)
        }
    }
    
    var ID: String {
        switch self {
            case .Green:  return "g"
            case .Yellow: return "y"
            case .Purple: return "p"
            case .Orange: return "o"
        }
    }
}
