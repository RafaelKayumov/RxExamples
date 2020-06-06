import UIKit
import RxSwift
import RxCocoa

class PaletteView : UIView, PaletteOutput {

    private let saturationExponentTop: Float = 2.0
    private let saturationExponentBottom: Float = 1.3
    private let elementSize: CGFloat = 1.0

    private lazy var touchGesture: UILongPressGestureRecognizer = {
        let disposeBag = DisposeBag()
        let touchGesture = UILongPressGestureRecognizer()
        touchGesture.minimumPressDuration = 0
        touchGesture.allowableMovement = CGFloat.greatestFiniteMagnitude
        return touchGesture
    }()

    private lazy var gestureEvent: Observable<UILongPressGestureRecognizer> = {
        return touchGesture.rx.event.share()
    }()

    internal lazy var touchStateOutput: Observable<Bool> = {
        return gestureEvent
            .compactMap { $0.state == .began || $0.state == .changed }
            .distinctUntilChanged()
            .share()
    }()

    internal lazy var positionOutput: Observable<CGPoint> = {
        return gestureEvent
            .compactMap { [weak self] in $0.location(in: self) }
            .distinctUntilChanged()
            .share()
    }()

    internal lazy var colorOutput: Observable<UIColor> = {
        return self.positionOutput
            .map { [unowned self] in self.getColorAtPoint($0) }
            .share()
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        for y : CGFloat in stride(from: 0.0 ,to: rect.height, by: elementSize) {
            var saturation = y < rect.height / 2.0 ? CGFloat(2 * y) / rect.height : 2.0 * CGFloat(rect.height - y) / rect.height
            saturation = CGFloat(powf(Float(saturation), y < rect.height / 2.0 ? saturationExponentTop : saturationExponentBottom))
            let brightness = y < rect.height / 2.0 ? CGFloat(1.0) : 2.0 * CGFloat(rect.height - y) / rect.height
            for x : CGFloat in stride(from: 0.0 ,to: rect.width, by: elementSize) {
                let hue = x / rect.width
                let color = UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1.0)
                context!.setFillColor(color.cgColor)
                context!.fill(CGRect(x:x, y:y, width:elementSize,height:elementSize))
            }
        }
    }
}

private extension PaletteView {

    func setup() {
        addGestureRecognizer(touchGesture)
    }
}

private extension PaletteView {

    func getColorAtPoint(_ point:CGPoint) -> UIColor {

        func round(_ value:CGFloat) -> CGFloat {
            return elementSize * CGFloat(Int(value / elementSize))
        }

        let roundedX = round(point.x)
        let roundedY = round(point.y)
        let roundedPoint = CGPoint(x:roundedX, y:roundedY)
        var saturation = roundedPoint.y < self.bounds.height / 2.0 ? CGFloat(2 * roundedPoint.y) / self.bounds.height
        : 2.0 * CGFloat(self.bounds.height - roundedPoint.y) / self.bounds.height
        saturation = CGFloat(powf(Float(saturation), roundedPoint.y < self.bounds.height / 2.0 ? saturationExponentTop : saturationExponentBottom))
        let brightness = roundedPoint.y < self.bounds.height / 2.0 ? CGFloat(1.0) : 2.0 * CGFloat(self.bounds.height - roundedPoint.y) / self.bounds.height
        let hue = roundedPoint.x / self.bounds.width
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1.0)
    }
}
