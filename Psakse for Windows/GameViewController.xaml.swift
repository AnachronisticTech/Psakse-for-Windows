import System.Collections.Generic
import System.Linq
import System.Windows
import System.Windows.Controls
import System.Windows.Data
import System.Windows.Documents
import System.Windows.Media
import System.Windows.Navigation
import System.Windows.Shapes
import System.Windows.Media.Imaging

public __partial class GameViewController {
    
    let gridSize = 5
    let wildcards = 2
    var grid:Grid? = nil
    var deck:Deck? = nil
    var activeCard:Card? = nil
    var lastSelected = -1
    var randArray = [Int]()
    var gameComplete = false
    var puzzleID: String? = nil
    var stringOverride: String? = nil
    var puzzleSig: String = ""

	public init() {
		InitializeComponent()
        resetGame()
	}
    
    func resetGame() {
        gameComplete = false
        deck = Deck()
        if let grid = grid {
            // Reset all buttons in main and side grids
            grid.reset()
        } else {
            // Create main and side grids with all buttons
            let buttons = [
                mg0, mg1, mg2, mg3, mg4, 
                mg5, mg6, mg7, mg8, mg9, 
                mg10, mg11, mg12, mg13, mg14, 
                mg15, mg16, mg17, mg18, mg19, 
                mg20, mg21, mg22, mg23, mg24, 
                sg0, sg1, sg2, sg3, sg4
            ]
            grid = Grid(with: buttons)
            grid!.reset()
        }
        
        // Create deck from override or procedurally
        if let puzzle = stringOverride {
//            var locked = puzzle.dropLast(17)
//            for _ in 0..<3 {
//                let pos = Int(String(locked.removeFirst()) + String(locked.removeFirst()))!
//                let col = String(locked.removeFirst())
//                let sym = String(locked.removeFirst())
//                let card = deck!.stringToCard(col: col, sym: sym)
//                setCard(atLocation: pos, card: card)
//                grid!.buttonGrid[pos].setBorder(width: 3, color: .yellow)
//                grid!.buttonGrid[pos].isEnabled = false
//                grid!.grid[pos] = card
//            }
//            deck!.arr = deck!.createDeckFromString(string: String(puzzle.dropFirst(12)))
        } else {
            deck!.populateDeck()
            deck!.finalShuffle()
            deck!.removeCards(gridSize: gridSize, wildcards: wildcards)
            // three random starting cards section
            randArray = []
            for _ in 1...3 {
                var randPosition = UInt32(gridSize * gridSize)
                while (
                    randArray.contains(Int(randPosition)) ||
                    randPosition == gridSize * gridSize ||
                    randArray.contains(Int(randPosition) - 1) ||
                    randArray.contains(Int(randPosition) + 1) ||
                    randArray.contains(Int(randPosition) - gridSize) ||
                    randArray.contains(Int(randPosition) + gridSize)
                ) {
                    randPosition = Int(Random().NextDouble() * (gridSize * gridSize - 1))
                    if randPosition == 0 { randPosition = 1 }
                }
                randArray.append(Int(randPosition))
            }
            for i in randArray {
                let image = deck!.arr[0].filename
                let color = deck!.arr[0].color
                grid!.buttonGrid[i].setAttrs(image: image, bgColor: color)
                grid!.buttonGrid[i].setBorder(width: 3, color: Color.FromRgb(255, 255, 0))
                grid!.grid[i] = deck!.arr[0]
                let card = deck!.arr.remove(at: 0)
//                deck!.updateQuantities(card: card)
                puzzleSig += (i < 10 ? "0" : "") + String(i) + card.ID
            }
//            puzzleSig += deck!.cardQuantities.contentsToString()
            //
            
            deck!.addWildCards(count: wildcards)
        }
        
        // Shuffle deck and set draw tile
        deck!.finalShuffle()
        setCard(atLocation: (gridSize * gridSize), card: deck!.arr[0])
    }

	func select(_ sender: System.Object!, _ e: System.Windows.RoutedEventArgs!) {
        let sender = sender as! Button
        if randArray.contains(Convert.ToInt32(sender.Tag)) { return }
        if let currentActiveCard = activeCard {
            // if sender == gridSize^2 or sender == lastSelected
            // deselect
            // else if sender empty
            // try move()
            // else
            // try swap()
            if Convert.ToInt32(sender.Tag) == (gridSize * gridSize) || Convert.ToInt32(sender.Tag) == lastSelected {
                // If location is card location or deck location deselect
                deselect()
            } else {
                let location = Convert.ToInt32(sender.Tag) as! Int
                if grid!.grid[location] == nil {
                    // If location empty try move
                    if checker(position: location, card: currentActiveCard) || location > (gridSize * gridSize) {
                        // If no tile conflicts place card
                        setCard(atLocation: location, card: currentActiveCard)
                        // clear previous location
                        clearTile(position: lastSelected)
                    } else {
                        // Warn of tile move conflict
                        MessageBox.Show("That tile can't be placed there.")
                    }
                    deselect()
                    if deck!.arr.count == 0 {
                        // If deck empty check grid full
                        var arr: [Bool] = grid!.grid.map({ $0 != nil })
                        for _ in 0..<5 { arr.removeLast() }
                        if !arr.contains(false) {
                            // If grid full, game is complete
                            gameComplete = true
                            for i in grid!.buttonGrid {
                                i.IsEnabled = false
                            }
                            let result = MessageBox.Show("You solved the puzzle! Would you like to play again?", "Puzzle complete!", .YesNo)
                            switch result {
                                case .Yes: resetGame()
                                default: break
                            }
                        }
                    }
                } else {
                    // If location not empty try swap
                    if lastSelected != (gridSize * gridSize) {
                        // If last selected card was not from the deck
                        if let card = grid!.grid[location], (checker(position: lastSelected, card: card) || lastSelected > (gridSize * gridSize)) && (checker(position: location, card: currentActiveCard) ||  location > (gridSize * gridSize)) {
                            // If cards won't conflict when swapped, swap cards
                            setCard(atLocation: lastSelected, card: grid?.grid[location])
                            setCard(atLocation: location, card: currentActiveCard)
                        } else {
                            // Warn of tile swap conflict
                            MessageBox.Show("Those tiles can't be swapped.")
                        }
                    }
                    deselect()
                }
            }
        } else {
            // set card to active
            // set border
            // lastSelected = tag
            let location = Convert.ToInt32(sender.Tag) as! Int
            if let selectedCard = grid!.grid[location] {
                activeCard = selectedCard
                grid!.buttonGrid[location].setBorder(width: 3, color: Color.FromRgb(0, 0, 0))
            }
            lastSelected = location
        }
    }
    
    func deselect() {
        activeCard = nil
        grid!.buttonGrid[lastSelected].setBorder(width: 0, color: Color.FromRgb(0, 0, 0))
        lastSelected = -1
    }
    
    func setCard(atLocation location: Int, card: Card?) {
        if let card = card {
            grid!.grid[location] = card
            grid!.buttonGrid[location].setAttrs(image: card.filename, bgColor: card.color)
            grid!.buttonGrid[location].setBorder(width: 0, color: Color.FromRgb(0, 0, 0))
        } else {
            grid!.grid[location] = nil
            grid!.buttonGrid[location].setAttrs(image: nil, bgColor: Color.FromRgb(255, 255, 255))
            grid!.buttonGrid[location].setBorder(width: 0, color: Color.FromRgb(0, 0, 0))
        }
    }
    
    func clearTile(position: Int) {
        if position == (gridSize * gridSize) {
            deck!.arr.remove(at: 0)
            if deck!.arr.count >= 1 {
                setCard(atLocation: (gridSize * gridSize), card: deck?.arr[0])
            } else {
                grid!.grid[(gridSize * gridSize)] = nil
                grid!.buttonGrid[(gridSize * gridSize)].setAttrs(image: "none.png", bgColor: Color.FromRgb(255, 255, 255))
                randArray.append(gridSize * gridSize)
            }
        } else {
            setCard(atLocation: position, card: nil)
        }
    }
    
    func checker(position: Int, card: Card) -> Bool {
        func checkTile(position: Int, card: Card) -> Bool {
            if position > (gridSize * gridSize) { return true }
            if let placedCard = grid!.grid[position] {
                return card.matches(other: placedCard)
            } else { return true }
        }
        func left(x: Int) -> Int { return x + 1 }
        func right(x: Int) -> Int { return x - 1 }
        func up(x: Int) -> Int { return x + gridSize }
        func down(x: Int) -> Int { return x - gridSize }
        
        if position < gridSize {
            if position == 0 {
                // Bottom right corner; check tiles left and above
                if !checkTile(position: left(x: position), card: card) { return false }
                if !checkTile(position: up(x: position), card: card) { return false }
            } else if position == gridSize - 1 {
                // Bottom left corner; check tiles right and above
                if !checkTile(position: right(x: position), card: card) { return false }
                if !checkTile(position: up(x: position), card: card) { return false }
            } else {
                // Bottom edge; check tiles left, right and above
                if !checkTile(position: left(x: position), card: card) { return false }
                if !checkTile(position: right(x: position), card: card) { return false }
                if !checkTile(position: up(x: position), card: card) { return false }
            }
        } else if position % gridSize == 0 {
            if position == gridSize * (gridSize - 1) {
                // Top right corner; check tiles left and below
                if !checkTile(position: left(x: position), card: card) { return false }
                if !checkTile(position: down(x: position), card: card) { return false }
            } else {
                // Right edge; check tiles left, above and below
                if !checkTile(position: left(x: position), card: card) { return false }
                if !checkTile(position: up(x: position), card: card) { return false }
                if !checkTile(position: down(x: position), card: card) { return false }
            }
        } else if position % gridSize == gridSize - 1 {
            if position == (gridSize * gridSize) - 1 {
                // Top left corner; check tiles right and below
                if !checkTile(position: right(x: position), card: card) { return false }
                if !checkTile(position: down(x: position), card: card) { return false }
            } else {
                // Left edge; check tiles right, above and below
                if !checkTile(position: right(x: position), card: card) { return false }
                if !checkTile(position: up(x: position), card: card) { return false }
                if !checkTile(position: down(x: position), card: card) { return false }
            }
        } else if position > gridSize * (gridSize - 1) {
            // Top edge; check tiles left, right and below
            if !checkTile(position: left(x: position), card: card) { return false }
            if !checkTile(position: right(x: position), card: card) { return false }
            if !checkTile(position: down(x: position), card: card) { return false }
        } else {
            // Central tile; check tiles left, right, above and below
            if !checkTile(position: left(x: position), card: card) { return false }
            if !checkTile(position: right(x: position), card: card) { return false }
            if !checkTile(position: up(x: position), card: card) { return false }
            if !checkTile(position: down(x: position), card: card) { return false }
        }
        return true
    }
}
