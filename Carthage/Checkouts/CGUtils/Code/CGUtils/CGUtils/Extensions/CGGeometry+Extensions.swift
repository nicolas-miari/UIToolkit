//
//  CGGeometry+Extensions.swift
//  CGUtils
//
//  Created by Nicolás Miari on 2018/09/21.
//  Copyright © 2018 Nicolás Miari. All rights reserved.
//

import CoreGraphics

public extension CGPoint {

    public static func + (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        return CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }

    public static func - (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        return CGPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }

    public static func * (scale: CGFloat, point: CGPoint) -> CGPoint {
        return CGPoint(x: scale * point.x, y: scale * point.y)
    }

    public static func * (point: CGPoint, scale: CGFloat) -> CGPoint {
        return scale * point
    }
}

// MARK: -

public extension CGSize {

    var aspectRatio: CGFloat {
        return width / height
    }

    public static func * (scale: CGFloat, size: CGSize) -> CGSize {
        return CGSize(width: scale * size.width, height: scale * size.height)
    }

    public static func * (size: CGSize, scale: CGFloat) -> CGSize {
        return scale * size
    }

    public static func / (size: CGSize, fraction: CGFloat) -> CGSize {
        return CGSize(width: size.width / fraction, height: size.height / fraction)
    }
}

// MARK: -

public extension CGRect {
    public static func * (scale: CGFloat, rect: CGRect) -> CGRect {
        let origin = scale * rect.origin
        let size = scale * rect.size
        return CGRect(origin: origin, size: size)
    }

    public static func * (rect: CGRect, scale: CGFloat) -> CGRect {
        return scale * rect
    }

    public func offsetBy(_ vector: CGVector) -> CGRect {
        return self.offsetBy(dx: vector.dx, dy: vector.dy)
    }
}
