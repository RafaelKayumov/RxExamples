//
//  ViewController.swift
//  ReactiveColorPicker
//
//  Created by Rafael Kayumov on 05/06/2020.
//  Copyright © 2020 Rafael Kayumov. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

fileprivate let kColorPinSize = CGSize(width: 70, height: 70)

class ViewController: UIViewController {

    private let disposeBag = DisposeBag()

    private let palette = {
        return PaletteView()
    }()

    private let colorPin: ColorPinView = {
        let colorPinView = ColorPinView(frame: CGRect(origin: CGPoint.zero, size: kColorPinSize))
        colorPinView.isUserInteractionEnabled = false
        colorPinView.borderWidth = 0.5
        colorPinView.borderColor = .gray
        return colorPinView
    }()

    private let colorAnnotationLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor(white: 0.1, alpha: 1)
        label.layer.cornerRadius = 4
        label.clipsToBounds = true
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(palette)

        setupBindings()
    }
}

private extension ViewController {

    func setColorPinVisible(_ visible: Bool) {
        if visible {
            view.addSubview(colorPin)
            view.addSubview(colorAnnotationLabel)
        } else {
            colorPin.removeFromSuperview()
            colorAnnotationLabel.removeFromSuperview()
        }
    }
}

private extension ViewController {

    func setupBindings() {
        //bind palette size to view size
        view.rx.observe(CGRect.self, #keyPath(UIView.bounds))
            .compactMap { $0 }
            .bind { [unowned self] in self.palette.frame = $0 }
            .disposed(by: disposeBag)

        //move color selection pin
        palette.positionOutput
            .bind { [unowned self] in self.colorPin.center = $0 }
            .disposed(by: disposeBag)

        //display or hide pin
        palette.touchStateOutput
            .bind { [unowned self] in self.setColorPinVisible($0) }
            .disposed(by: disposeBag)

        //set pin color
        palette.colorOutput
            .bind(to: colorPin.rx.backgroundColor)
            .disposed(by: disposeBag)

        //set rgb text
        palette.colorOutput
            .map { ColorAnnotationViewModel(color: $0) }
            .map { ColorAnnotationAttributedStringFacroty.attributedStringWith($0) }
            .bind(to: colorAnnotationLabel.rx.attributedText)
            .disposed(by: disposeBag)

        //update rbg label size after each text update
        colorAnnotationLabel.rx.observe(String.self, #keyPath(UILabel.attributedText))
            .bind { [unowned self] _ in self.colorAnnotationLabel.sizeToFit() }
            .disposed(by: disposeBag)

        //place rgb label above color pin
        colorPin.rx.observe(CGPoint.self, #keyPath(UIView.center))
            .compactMap {
                var center = $0
                center?.y -= 60
                return center
            }
            .bind { [unowned self] in self.colorAnnotationLabel.center = $0 }
            .disposed(by: disposeBag)
    }
}
