//
//  Card.swift
//  Psakse
//
//  Created by Daniel Marriner on 29/06/2019.
//  Copyright © 2019 Daniel Marriner. All rights reserved.
//

enum Card {
    
    case Wild
    case Normal(Symbols, Colors)
    
    func matches(other: Card) -> Bool { // Replace with equatable conformance
        switch (self, other) {
            case (.Wild, _), (_, .Wild):
                return true
            case (.Normal(let sym1, let col1), .Normal(let sym2, let col2)):
                return sym1 == sym2 || col1 == col2
        }
    }
    
    var color: Color {
        switch self {
            case .Wild: return Color.FromRgb(255, 180, 188)
            case .Normal(_, let color): return color.color
        }
    }
    
    var filename: String {
        switch self {
            case .Wild: return "dot.png"
            case .Normal(let symbol, _): return symbol.filename
        }
    }
    
    func equals(other: Card) -> Bool {
        switch (self, other) {
            case (.Wild, .Wild):
                return true
            case (.Normal(let sym1, let col1), .Normal(let sym2, let col2)):
                return sym1 == sym2 && col1 == col2
            default:
                return false
        }
    }
    
    var ID: String {
        switch self {
            case .Wild: return ""
            case .Normal(let sym, let col): return col.ID + sym.ID
        }
    }
}
