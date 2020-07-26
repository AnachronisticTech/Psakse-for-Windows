//
//  Extensions.swift
//  Psakse
//
//  Created by Daniel Marriner on 07/11/2019.
//  Copyright © 2019 Daniel Marriner. All rights reserved.
//

import System.Windows.Controls
import System.Windows.Media
import System.Windows.Media.Imaging

typealias Color = System.Windows.Media.Color

//public extension Array where Element == Int {
//    func contentsToString() -> String {
//        var tmp = ""
//        for i in self {
//            tmp += String(i)
//        }
//        return tmp
//    }
//}

public extension Button {
    func reset() {
        self.Content = ""
        self.setBorder(width: 0, color: Color.FromRgb(255, 255, 255))
        self.setAttrs(image: nil, bgColor: Color.FromRgb(255, 255, 255))
//        self.adjustsImageWhenDisabled = false
        self.IsEnabled = true
    }
    
    func setAttrs(image: String?, bgColor: Color) {
        if let image = image {
            let img = Image()
            let bmp = BitmapImage()
            bmp.BeginInit()
            bmp.UriSource = Uri("/Images/\(image)", .Relative)
            bmp.EndInit()
            img.Source = bmp
            self.Content = img
        } else {
            self.Content = ""
        }
        self.Background = SolidColorBrush(bgColor)
    }
    
    func setBorder(width: Double, color: Color) {
        self.BorderThickness = System.Windows.Thickness(width, width, width, width)
        self.BorderBrush = SolidColorBrush(color)
    }
    
    func setBackgroundColor(color: Color) {
        self.Background = SolidColorBrush(color)
    }
}