//
//  ColorAnnotationViewModel.swift
//  ReactiveColorPicker
//
//  Created by Rafael Kayumov on 05/06/2020.
//  Copyright © 2020 Rafael Kayumov. All rights reserved.
//

import UIKit

struct ColorAnnotationViewModel {

    let red: String
    let green: String
    let blue: String

    init(color: UIColor) {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        color.getRed(&red, green: &green, blue: &blue, alpha: nil)

        self.red = String(Int(red * 256))
        self.green = String(Int(green * 256))
        self.blue = String(Int(blue * 256))
    }
}

private let kFont = UIFont.systemFont(ofSize: 16)
private let redTitle = "Red: "
private let greenTitle = "Green: "
private let blueTitle = "Blue: "

private let redTitleAttributes = [
    NSAttributedString.Key.foregroundColor: UIColor.red,
    NSAttributedString.Key.font: kFont
]
private let greenTitleAttributes = [
    NSAttributedString.Key.foregroundColor: UIColor.green,
    NSAttributedString.Key.font: kFont
]
private let blueTitleAttributes = [
    NSAttributedString.Key.foregroundColor: UIColor.cyan,
    NSAttributedString.Key.font: kFont
]

class ColorAnnotationAttributedStringFacroty {

    static func attributedStringWith(_ viewModel: ColorAnnotationViewModel) -> NSAttributedString {
        let resultString = NSMutableAttributedString()

        let redTitleAttributedString = NSAttributedString(string: redTitle + viewModel.red + "  ", attributes: redTitleAttributes)
        let greenTitleAttributedString = NSAttributedString(string: greenTitle + viewModel.green + "  ", attributes: greenTitleAttributes)
        let blueTitleAttributedString = NSAttributedString(string: blueTitle + viewModel.blue, attributes: blueTitleAttributes)

        resultString.append(NSAttributedString(string: "  "))
        resultString.append(redTitleAttributedString)
        resultString.append(greenTitleAttributedString)
        resultString.append(blueTitleAttributedString)
        resultString.append(NSAttributedString(string: "  "))

        return resultString
    }
}
