//
//  Symbols.swift
//  Psakse
//
//  Created by Daniel Marriner on 29/06/2019.
//  Copyright © 2019 Daniel Marriner. All rights reserved.
//

import System.Collections.Generic
import System.Linq
import System.Windows

enum Symbols {//: CaseIterable {
    case Psi
    case A
    case Xi
    case E
    
    var filename: String {
        switch self {
        case .Psi: return "psi.png"
        case .A:   return "a.png"
        case .Xi:  return "xi.png"
        case .E:   return "e.png"
        }
    }
    
    var ID: String {
        switch self {
        case .Psi: return "p"
        case .A:   return "a"
        case .Xi:  return "x"
        case .E:   return "e"
        }
    }
}
