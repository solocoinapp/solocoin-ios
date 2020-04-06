//
//  SCColorUtil.swift
//  solocoin
//
//  Created by indie dev on 27/03/20.
//

import Foundation
import UIKit

public enum SCColorUtil {
    
    case scClear
    case scWhite
    case scBlack
    case scGray
    case scGrayBorder
    case scGrayBackground
    case scDarkerGrayBackground
    case scBlackGray
    case scRed
    case scBrown
    case scRedDefaultTheme
    case transparentLite
    case customHex(hex: UInt32)
    case customRGBA(r: Float, g: Float, b: Float, a: Float) // e.g. r:255.0, g:212.0, b:123.0, a:0.5
    
    public var value: UIColor {
        
        switch self {
        case .scClear:
            return .clear
        case .scWhite:
            return .white
        case .scBlack:
            return .black
        case .scRed:
            return .red
        case .scBrown:
            return SCColorUtil.customRGBA(r: 112, g: 112, b: 112, a: 1).value
        case .scRedDefaultTheme:
            return SCColorUtil.customRGBA(r: 228, g: 75, b: 093, a: 1).value
        case .scGrayBackground:
            return SCColorUtil.customRGBA(r: 250, g: 250, b: 250, a: 1).value
        case .scDarkerGrayBackground:
            return SCColorUtil.customRGBA(r: 242, g: 242, b: 242, a: 1).value
        case .scBlackGray:
            return SCColorUtil.customRGBA(r: 90.0, g: 96.0, b: 117.0, a: 1).value
        case .scGray:
            return SCColorUtil.customRGBA(r: 129, g: 129, b: 129, a: 1).value
        case .scGrayBorder:
            return SCColorUtil.customRGBA(r: 129, g: 129, b: 129, a: 0.2).value
        case .transparentLite:
            return SCColorUtil.customRGBA(r: 0, g: 0, b: 0, a: 0.2).value
        case .customHex(let hex):
            return UIColor(hex: hex)
        case .customRGBA(let r, let g, let b, let a):
            return UIColor(redInt: r, greenInt: g, blueInt: b, a: a)            
            
        }
    }
    
    public var cgValue: CGColor {
        return self.value.cgColor
    }
}

extension UIColor {
    
    convenience init(hex: UInt32) {
        let a = CGFloat(hex & 0xFF) / 255.0
        let b = CGFloat((hex >> 8) & 0xFF) / 255.0
        let g = CGFloat((hex >> 16) & 0xFF) / 255.0
        let r = CGFloat((hex >> 24) & 0xFF) / 255.0
        self.init(red: r, green: g, blue: b, alpha: a)
    }
    
    convenience init(redInt r: Float, greenInt g: Float, blueInt b: Float, a: Float) {
        let bv = CGFloat(b / 255.0)
        let gv = CGFloat(g / 255.0)
        let rv = CGFloat(r / 255.0)
        self.init(red: rv, green: gv, blue: bv, alpha: CGFloat(a))
    }
    
    convenience init(hexString: String, alpha: CGFloat) {
        var cString: String = hexString.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if cString.hasPrefix("#") {
            cString.remove(at: cString.startIndex)
        }
        
        var rgbValue: UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        self.init(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(alpha)
        )
    }
}
