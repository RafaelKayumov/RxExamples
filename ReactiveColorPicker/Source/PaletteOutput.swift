//
//  PaletteOutput.swift
//  ReactiveColorPicker
//
//  Created by Rafael Kayumov on 05/06/2020.
//  Copyright © 2020 Rafael Kayumov. All rights reserved.
//

import RxSwift
import RxCocoa

protocol PaletteOutput {
    var touchStateOutput: Observable<Bool> { get }
    var positionOutput: Observable<CGPoint> { get }
    var colorOutput: Observable<UIColor> { get }
}
