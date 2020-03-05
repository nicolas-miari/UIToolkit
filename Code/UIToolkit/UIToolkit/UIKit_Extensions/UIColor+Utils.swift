//
//  UIColor+Utils.swift
//  UIToolkit
//
//  Created by Nicolás Miari on 2020/03/05.
//  Copyright © 2020 Nicolás Miari. All rights reserved.
//

import UIKit

public extension UIColor {

    // MARK: - Convenience Initializers

    /**
     - parameter grayScale: The desired luminosity, in the range 0 (black) ~ 255 (white).
     - parameter alpha: The desired opacity, in the range 0 (fully transparent) ~ 1 (fully opaque).
     */
    convenience init(grayscale: Int, alpha: CGFloat = 1) {
        let white = max(0.0, min(CGFloat(grayscale) / 255.0, 1.0))
        self.init(white: white, alpha: 1)
    }

    /**
     Initializes an instance from three color components in the [0, 255] range (unsinged byte).

     The opacity argument alone is a floating point in the range [0.0, 1.0].

     - parameter r: The red component, in the range [0, 255].
     - parameter g: The green component, in the range [0, 255].
     - parameter b: The blue component, in the range [0, 255].
     - parameter a: The alpha (opacity) component, in the range [0.0, 1.0].
     */
    convenience init(r: UInt8, g: UInt8, b: UInt8, a: CGFloat = 1) {
        let red = max(0.0, min(CGFloat(r) / 255.0, 1.0))
        let green = max(0.0, min(CGFloat(g) / 255.0, 1.0))
        let blue = max(0.0, min(CGFloat(b) / 255.0, 1.0))
        let alpha = max(0.0, min(a, 1.0))
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }

    // MARK: - 8 Bit Integer Component Support

    /**
     Creates an instance with RGB values specified in the `0` ~ `255` range that is popular among graphic designers
     (as opposed to the "normalized" `0.0` ~ `1.0` range supported by the iOS SDK interface).
     Additionally, the arguments are strongly typed as `UInt8` to coerce the passed values into the valid range.

     - parameter redByte: The red component, in the range 0 ~ 255. Because the type is `UInt8`, conformance to the valid
     range is unavoidable.
     - parameter greenByte: The green component, in the range 0 ~ 255.  Because the type is `UInt8`, conformance to the
     valid range is unavoidable.
     - parameter blueByte: The blue component, in the range 0 ~ 255.  Because the type is `UInt8`, conformance to the
     valid range is unavoidable.
     - parameter alpha: The desired opacity, in the range 0.0 (fully transaprent) to 1.0 (fully opaque). The default is 1.0.
     */
    convenience init(redByte: UInt8, greenByte: UInt8, blueByte: UInt8, alpha: CGFloat = 1.0) {
        let r: CGFloat = CGFloat(redByte) / 255.0
        let g: CGFloat = CGFloat(greenByte) / 255.0
        let b: CGFloat = CGFloat(blueByte) / 255.0

        self.init(red: r, green: g, blue: b, alpha: alpha)
    }

    // MARK: - Hexadecimal Support

    /**
     Creates an instance with RGB values specified in the `0` ~ `255` range, expressed in hexadecimal as a concatenated
     string (as in HTML/CSS). Supports only 6 digit strings (e.g.: `"FF0055"`), possibly prefixed with a single `#`.
     Alpha (opacity) defaults to `1.0` (fully opaque).

     Based on [this StackOverflow answer](https://stackoverflow.com/a/27203596/433373).

     - parameter hex: A string representing the color as 6 hexadecimal digits (e.g., "FF0000"). A leading "#" will be
     safely ignored.
     - parameter alpha: The opacity for the color. The default is 1.0 (fully opaque).
     */
    convenience init?(hex: String, alpha: CGFloat = 1) {
        var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if cString.hasPrefix("#") {
            cString.remove(at: cString.startIndex)
        }
        guard cString.count == 6 else {
            return nil
        }

        var rgbValue: UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)

        self.init(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }

    /**
     Returns the hexadecimal representation of the receiver. For example, if the receiver was initialized with
     `init(red: 1.0, green: 0.0, blue: 0.0, alpha: 1)`, it returns `"FF0000"`. Alpha (opacity) information is
     ignored.
     */
    var hexString: String {
        if let components = self.cgColor.components {

            switch self.cgColor.numberOfComponents {
            case 4:
                // RGBA
                let r = components[0]
                let g = components[1]
                let b = components[2]
                return  String(format: "%02X%02X%02X", (Int)(r * 255), (Int)(g * 255), (Int)(b * 255))

            case 2:
                // Grayscale + Alpha. Repeat the grayscale value for all three
                // channels.
                let r = components[0]
                let g = components[0]
                let b = components[0]
                return  String(format: "%02X%02X%02X", (Int)(r * 255), (Int)(g * 255), (Int)(b * 255))

            default:
                break
            }
        }
        return "000000"
    }

    /**
     Compares the contents of the receiver to those of the specified color.

     Both the receiver and `otherColor` are first converted to the RGBA color space, because the default
     implementation of `==` for `UIColor` fails when comparing --for example-- RGB black to monochrome black:
     one is `(red: 0, green: 0, blue: 0, alpha: 1)`, the other is `(white: 0, alpha: 1)`.

     - note: Currently does not work as exoected; investigate.
     - parameter otherColor: An instance of UIColor to compare against the receiver.
     - returns: `true` if all four components of both colors (when converted to RGBA) match, `false` otherwise.
     */
    func isEqualToColor(otherColor: UIColor) -> Bool {
        if self == otherColor {
            return true
        }

        let colorSpaceRGB = CGColorSpaceCreateDeviceRGB()

        let convertColorToRGBSpace: ((UIColor) -> UIColor?) = { (color) -> UIColor? in
            if color.cgColor.colorSpace?.model == .monochrome {
                guard let oldComponents = color.cgColor.components else {
                    return nil
                }
                let newComponents = [oldComponents[0], oldComponents[0], oldComponents[0], oldComponents[1]]
                guard let colorRef = CGColor(colorSpace: colorSpaceRGB, components: newComponents) else {
                    return nil
                }
                return UIColor(cgColor: colorRef)
            } else {
                return color
            }
        }

        let selfColor = convertColorToRGBSpace(self)
        let otherColor = convertColorToRGBSpace(otherColor)

        if let selfColor = selfColor, let otherColor = otherColor {
            return selfColor.isEqual(otherColor)
        } else {
            return false
        }
    }

    /**
     Produces an HSBA representation (Hue, Saturation, Brightness, Alpha ) of the receiver.
     */
    func hsba() -> HSBA? {
        var hue: CGFloat = .nan, saturation: CGFloat = .nan, brightness: CGFloat = .nan, alpha: CGFloat = .nan
        guard self.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) else {
            return nil
        }
        return HSBA(hue: hue, saturation: saturation, brightness: brightness, alpha: alpha)
    }

    // MARK: - Utilities

    func changedBrightness(byPercentage perc: CGFloat) -> UIColor? {
        if perc == 0 {
            return self.copy() as? UIColor
        }
        guard let hsba = hsba() else {
            return nil
        }
        let percentage: CGFloat = min(max(perc, -1), 1)
        let newBrightness = min(max(hsba.brightness + percentage, -1), 1)
        return UIColor(hue: hsba.hue, saturation: hsba.saturation, brightness: newBrightness, alpha: hsba.alpha)
    }

    func lightened(byPercentage percentage: CGFloat = 0.1) -> UIColor? {
        return changedBrightness(byPercentage: percentage)
    }

    func darkened(byPercentage percentage: CGFloat = 0.1) -> UIColor? {
        return changedBrightness(byPercentage: -percentage)
    }

    /**
     Produces a solid (constant) based on the receiver, and the specified size.
     */
    func solidImage(_ size: CGSize = CGSize(width: 1, height: 1)) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        let ctx = UIGraphicsGetCurrentContext()
        setFill()
        ctx?.fillPath()
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img
    }
}

// MARK: - Supporting Types

/**
 Represents a color in the HSBA space (Hue, Saturation, Brightness, and Alpha).
 */
public struct HSBA {
    let hue: CGFloat
    let saturation: CGFloat
    let brightness: CGFloat
    let alpha: CGFloat
}
