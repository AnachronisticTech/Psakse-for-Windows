//
//  Deck.swift
//  Psakse
//
//  Created by Daniel Marriner on 29/06/2019.
//  Copyright © 2019 Daniel Marriner. All rights reserved.
//

class Deck {
    let allCards: [Card] = [
        .Normal(.Psi, .Green),
        .Normal(.A, .Green),
        .Normal(.Xi, .Green),
        .Normal(.E, .Green),
        .Normal(.Psi, .Yellow),
        .Normal(.A, .Yellow),
        .Normal(.Xi, .Yellow),
        .Normal(.E, .Yellow),
        .Normal(.Psi, .Purple),
        .Normal(.A, .Purple),
        .Normal(.Xi, .Purple),
        .Normal(.E, .Purple),
        .Normal(.Psi, .Orange),
        .Normal(.A, .Orange),
        .Normal(.Xi, .Orange),
        .Normal(.E, .Orange),
        .Wild
    ]
    var cardQuantities = Array<Int>(repeating: 2, count: 17)
    
    var arr = [Card]()
    
    func populateDeck() {
        
        for symbol in [Symbols.Psi, Symbols.A, Symbols.Xi, Symbols.E] {
            for color in [Colors.Green, Colors.Yellow, Colors.Purple, Colors.Orange] {
                self.arr.append(Card.Normal(symbol, color))
                self.arr.append(Card.Normal(symbol, color))
            }
        }
    }
    
    func addWildCards(count: Int)  {
        for _ in 0..<count {
            self.arr.append(Card.Wild)
        }
    }
    
    func removeCards(gridSize: Int, wildcards: Int) {
        let gridTotal = self.arr.count - (gridSize * gridSize) + wildcards
        for _ in 0..<gridTotal {
            let card = self.arr.removeLast()
//            updateQuantities(card: card)
        }
    }
    
//    func updateQuantities(card: Card) {
//        let index = allCards.firstIndex { $0.equals(other: card) } // No .firstIndex()
//        cardQuantities[index!] -= 1
//    }
    
//    func createDeckFromString(string: String) -> [Card] {
//        var str = string
//        var deck = [Card]()
//        for i in 0..<allCards.count {
//            let quantity = Int(String(str.removeFirst())) // No .removeFirst()
//            deck += Array<Card>(repeating: allCards[i], count: quantity!)
//        }
//        return deck
//    }
    
    func stringToCard(col: String, sym: String) -> Card {
        func symbol(_ sym: String) -> Symbols {
            switch sym {
            case "p": return .Psi
            case "a": return .A
            case "x": return .Xi
            default : return .E
            }
        }
        func color(_ col: String) -> Colors {
            switch col {
            case "g": return .Green
            case "y": return .Yellow
            case "p": return .Purple
            default : return .Orange
            }
        }
        return .Normal(symbol(sym), color(col))
    }
    
    func finalShuffle() {
        var last = self.arr.count - 1
        while last > 0 {
            let rand = Int(Random().NextDouble() * last)
            self.arr.swapAt(last, rand)
            last -= 1
        }
    }
}
