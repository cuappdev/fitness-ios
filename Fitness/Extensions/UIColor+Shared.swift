//
//  UIColor+Shared.swift
//  Fitness
//
//  Created by Keivan Shahida on 3/14/18.
//  Copyright © 2018 Keivan Shahida. All rights reserved.
//

import UIKit

extension UIColor {

    @nonobjc static let fitnessWhite = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
    @nonobjc static let fitnessBlack = UIColor(red: 34/255, green: 34/255, blue: 34/255, alpha: 1.0)

    @nonobjc static let fitnessDarkGrey = UIColor(red: 112/255, green: 112/255, blue: 112/255, alpha: 1.0)
    @nonobjc static let fitnessMediumGrey = UIColor(red: 206/255, green: 206/255, blue: 206/255, alpha: 1.0)
    @nonobjc static let fitnessLightGrey = UIColor(red: 216/255, green: 216/255, blue: 216/255, alpha: 1.0)

    @nonobjc static let fitnessYellow = UIColor(red: 248/255, green: 231/255, blue: 28/255, alpha: 1.0)
    @nonobjc static let fitnessGreen = UIColor(red: 100/255, green: 194/255, blue: 112/255, alpha: 1.0)
    @nonobjc static let fitnessRed = UIColor(red: 240/255, green: 125/255, blue: 125/255, alpha: 1.0)

    public static func colorFromCode(_ code: Int) -> UIColor {
        let red = CGFloat(((code & 0xFF0000) >> 16)) / 255
        let green = CGFloat(((code & 0xFF00) >> 8)) / 255
        let blue = CGFloat((code & 0xFF)) / 255

        return UIColor(red: red, green: green, blue: blue, alpha: 1)
    }
}
