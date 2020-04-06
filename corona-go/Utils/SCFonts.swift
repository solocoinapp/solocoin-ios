//
//  SCFonts.swift
//  solocoin
//
//  Created by indie dev on 27/03/20.
//

import Foundation
import UIKit

public enum SCFonts {
    
    case defaultStandard(size: Float)
    case defaultMedium(size: Float)
    case defaultBold(size: Float)
    case defaultLight(size: Float)
    case semiBold(size: Float)
    
}

extension SCFonts {
    var value: UIFont? {
        switch self {
        case .defaultStandard(let size):
            return UIFont(name: "Roboto-Regular", size: CGFloat(size))
        case .defaultMedium(let size):
            return UIFont(name: "Roboto-Medium", size: CGFloat(size))
        case .defaultBold(let size):
            return UIFont(name: "Roboto-Bold", size: CGFloat(size))
        case .defaultLight(let size):
            return UIFont(name: "Roboto-Light", size: CGFloat(size))
        case .semiBold(let size):
            return UIFont(name: "Roboto-Condensed", size: CGFloat(size))
        }
    }
}
