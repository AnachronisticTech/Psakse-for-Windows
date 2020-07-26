//
//  Grid.swift
//  Psakse
//
//  Created by Daniel Marriner on 29/06/2019.
//  Copyright © 2019 Daniel Marriner. All rights reserved.
//

import System.Windows.Controls

class Grid {
    var grid: [Card?] = Array<Card?>(withCapacity: 30)
    var buttonGrid = [Button]()
    
    init(with buttons: [Button]) {
        self.buttonGrid = buttons
        for _ in 0..<buttons.count { grid.append(nil) }
    }
    
    func reset() {
        for i in 0..<buttonGrid.count {
            grid[i] = nil
            buttonGrid[i].reset()
        }
    }
}
