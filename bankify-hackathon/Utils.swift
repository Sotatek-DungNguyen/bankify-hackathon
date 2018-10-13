//
//  Utils.shared.swift
//  babynames
//
//  Created by Robert Nguyen on 7/9/18.
//

import UIKit
import SnapKit
import AVFoundation
import Alamofire
import Arrow
import RealmSwift

func loadFontFrom(fileUrl: URL) -> (name: String, success: Bool) {
    guard let fontData = try? Data(contentsOf: fileUrl) as CFData else {
        print("UIFont+:  Failed to register font - font data could not be loaded.", fileUrl)
        return ("", false)
    }
    
    guard let dataProvider = CGDataProvider(data: fontData) else {
        print("UIFont+:  Failed to register font - data provider could not be loaded.")
        return ("", false)
    }
    
    guard let fontRef = CGFont(dataProvider) else {
        print("UIFont+:  Failed to register font - font could not be loaded.")
        return ("", false)
    }
    
    var errorRef: Unmanaged<CFError>? = nil
    let success = CTFontManagerRegisterGraphicsFont(fontRef, &errorRef)
    
    return (fontRef.postScriptName! as String, success)
}

func radius(from I: CGFloat, degree: CGFloat)  -> CGFloat {
    return I / degree.degreesToRadians
}

extension UIViewController {
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension Int {
    var boolValue: Bool {
        return self > 0
    }
    
    var cgFloatValue: CGFloat {
        return CGFloat(self)
    }
    
    var timeUnitFormat: String {
        return self < 10 ? "0\(self)" : "\(self)"
    }
}

extension Bool {
    var intValue: Int {
        return self ? 1 : 0
    }
}

extension UIButton {
    func centerVertically(spacing: CGFloat = 8) {
        let imageSize = imageView?.bounds.size ?? .zero
        let titleSize = titleLabel?.bounds.size ?? .zero
        
        imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: spacing + 2, right: -titleSize.width);
        titleEdgeInsets = UIEdgeInsets(top: frame.height - titleSize.height - 2, left: -imageSize.width, bottom: 3, right: 0);
    }
}

extension String {
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
    
    func localized(lang: String) -> String {
        if let path = Bundle.main.path(forResource: lang, ofType: "lproj") {
            let bundle = Bundle(path: path)
            
            return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
        }
        
        return self
    }
}

extension UIView {
    func forceConstraintToSuperview() {
        if let spView = superview {
            self.snp.makeConstraints {
                make in
                make.leading.equalTo(spView.snp.leading)
                make.top.equalTo(spView.snp.top)
                make.bottom.equalTo(spView.snp.bottom)
                make.trailing.equalTo(spView.snp.trailing)
            }
        }
    }
    
    func removeAllSubviews() {
        subviews.forEach {
            $0.removeFromSuperview()
        }
    }
    
    static func flattenSubviews(from view: UIView) -> [UIView] {
        var flatArray: [UIView] = []
        flatArray.append(view)
        
        for subview in view.subviews {
            flatArray += flattenSubviews(from: subview)
        }
        return flatArray
    }
}

extension UIImage {
    func rotate(radians: CGFloat) -> UIImage {
        let rotatedSize = CGRect(origin: .zero, size: size)
            .applying(CGAffineTransform(rotationAngle: radians))
            .integral.size
        UIGraphicsBeginImageContext(rotatedSize)
        if let context = UIGraphicsGetCurrentContext() {
            let origin = CGPoint(x: rotatedSize.width / 2.0,
                                 y: rotatedSize.height / 2.0)
            context.translateBy(x: origin.x, y: origin.y)
            context.rotate(by: radians)
            draw(in: CGRect(x: -origin.x, y: -origin.y,
                            width: size.width, height: size.height))
            let rotatedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            return rotatedImage ?? self
        }
        
        return self
    }
}

extension CGFloat {
    var floatValue: Float {
        return Float(self)
    }
}

extension BinaryInteger {
    var degreesToRadians: CGFloat { return CGFloat(Int(self)) * .pi / 180 }
}

extension FloatingPoint {
    var degreesToRadians: Self { return self * .pi / 180 }
    var radiansToDegrees: Self { return self * 180 / .pi }
}

extension UIColor {
    convenience init?(hexRGBA: String?) {
        guard let rgba = hexRGBA, let val = Int(rgba.replacingOccurrences(of: "#", with: ""), radix: 16) else {
            return nil
        }
        self.init(red: CGFloat((val >> 24) & 0xff) / 255.0, green: CGFloat((val >> 16) & 0xff) / 255.0, blue: CGFloat((val >> 8) & 0xff) / 255.0, alpha: CGFloat(val & 0xff) / 255.0)
    }
    
    convenience init?(hexRGB: String?) {
        guard let rgb = hexRGB, let val = Int(rgb.replacingOccurrences(of: "#", with: ""), radix: 16) else {
            return nil
        }
        self.init(red: CGFloat((val >> 16) & 0xff) / 255.0, green: CGFloat((val >> 8) & 0xff) / 255.0, blue: CGFloat(val & 0xff) / 255.0, alpha: 1.0)
    }
}

func readStringFrom(path: URL) -> String {
    return (try? String(contentsOfFile: path.absoluteString, encoding: String.Encoding.utf8)) ?? ""
}

func heightForView(text: String, font: UIFont, width: CGFloat) -> CGFloat{
    let label = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: .greatestFiniteMagnitude))
    label.numberOfLines = 0
    label.lineBreakMode = NSLineBreakMode.byWordWrapping
    label.attributedText = NSAttributedString(string: text, attributes: [.font : font])
    
    label.sizeToFit()
    return label.frame.height
}

func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage? {
    let scale = newWidth / image.size.width
    let newHeight = image.size.height * scale
    UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
    image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return newImage
}

func getImageSizeFrom(url: URL) -> (height: Double, width: Double) {
    if let imageSource = CGImageSourceCreateWithURL(url as CFURL, nil) {
        if let imageProperties = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, nil) as Dictionary? {
            let pixelWidth = imageProperties[kCGImagePropertyPixelWidth] as! Double
            let pixelHeight = imageProperties[kCGImagePropertyPixelHeight] as! Double
            return (pixelHeight, pixelWidth)
        }
    }
    
    return (0, 0)
}

var appVersion: String {
    return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
}

var appBuild: String {
    return Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String
}

var appBundle: String {
    return Bundle.main.bundleIdentifier!
}

var appIdentifier: String {
    return Bundle.main.object(forInfoDictionaryKey: "CFBundleIdentifier") as! String
}

func parseDuration(timeString: String) -> TimeInterval {
    guard !timeString.isEmpty else {
        return 0
    }
    
    var interval: Double = 0
    
    var parts = timeString.components(separatedBy: ":")
    if parts.count == 1 {
        parts += ["0", "0"]
    }
    else if parts.count == 2 {
        parts.append("0")
    }
    
    for (index, part) in parts.reversed().enumerated() {
        interval += (Double(part) ?? 0) * pow(Double(60), Double(index))
    }
    
    return interval
}

func degreesToRadians(_ degrees: Double) -> Double { return degrees * Double.pi / 180.0 }
func radiansToDegrees(_ radians: Double) -> Double { return radians * 180.0 / Double.pi }

func randomBool() -> Bool {
    return arc4random_uniform(2) == 0
}

func vibrate() {
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
}

extension Array {
    mutating func remove(where: (Element) throws -> Bool) {
        if let i = try? self.index(where: `where`), let _i = i {
            self.remove(at: _i)
        }
    }
}

extension Array where Element : Equatable {
    var unique: [Element] {
        var uniqueValues: [Element] = []
        forEach { item in
            if !uniqueValues.contains(item) {
                uniqueValues += [item]
            }
        }
        return uniqueValues
    }
}

extension Results {
    func toArray() -> [Element] {
        return Array(self)
    }
}

#if swift(>=4.2)
#else
extension MutableCollection {
    /// Shuffles the contents of this collection.
    mutating func shuffle() {
        let c = count
        guard c > 1 else { return }
        
        for (firstUnshuffled, unshuffledCount) in zip(indices, stride(from: c, to: 1, by: -1)) {
            // Change `Int` in the next line to `IndexDistance` in < Swift 4.1
            let d: Int = numericCast(arc4random_uniform(numericCast(unshuffledCount)))
            let i = index(firstUnshuffled, offsetBy: d)
            swapAt(firstUnshuffled, i)
        }
    }
}

extension Sequence {
    /// Returns an array with the contents of this sequence, shuffled.
    func shuffled() -> [Element] {
        var result = Array(self)
        result.shuffle()
        return result
    }
}
#endif

private func readTextFile(filepath: String?) -> String {
    if let filepath = filepath {
        do {
            let contents = try String(contentsOfFile: filepath)
            return contents
        } catch {
            print(error.localizedDescription)
        }
    } else {
        // file not found!
    }
    return ""
}

class Utils {
    static let shared = Utils()
    
    var userId: Int = 3
    let unit = "$"
    
    private init() {}
}

func makeRequest(method: HTTPMethod, endPoint: String, params: Parameters? = nil, completion: @escaping (JSON?) -> Void, errorHandler: ((Error) -> Void)? = nil) {
    request("http://103.97.124.29:8001/api/blinky/\(endPoint)", method: method, parameters: params, headers: nil)
        .responseJSON {
            response in
            switch response.result {
            case .success(let data):
                if let httpResp = HTTPReponse(JSON(data)) {
                    completion(httpResp.item)
                }
                else {
                    errorHandler?(NSError(domain: "Error Parse JSON", code: 9999, userInfo: nil))
                }
            case .failure(let error):
                print(error.localizedDescription)
                errorHandler?(error)
            }
        }
}
