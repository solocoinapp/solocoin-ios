//
//  QuizSegControl.swift
//  Solocoin
//
//  Created by Mishaal Kandapath on 8/2/20.
//  Copyright © 2020 Solocoin. All rights reserved.
//

import UIKit

class QuizSegControl: UISegmentedControl {

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 0
        //setBackgroundImage(UIImage(systemName: "circle.fill")?.maskWithColor(color: .clear), for: .normal, barMetrics: .default)
        clipsToBounds = true
        let maskPath1 = UIBezierPath(roundedRect: bounds,
            byRoundingCorners: [.topLeft , .topRight],
            cornerRadii: CGSize(width: frame.width/25, height: frame.width/25))
        let maskLayer1 = CAShapeLayer()
        maskLayer1.frame = bounds
        maskLayer1.path = maskPath1.cgPath
        /*layer.mask = maskLayer1
        layer.borderColor = UIColor.red.cgColor
        layer.borderWidth = 5*/
        layer.cornerRadius = frame.width/25
        layer.maskedCorners = [.layerMaxXMinYCorner,.layerMinXMinYCorner]
        layer.masksToBounds = true
        layer.borderColor = UIColor.init(red: 16/255, green: 32/255, blue: 90/255, alpha: 1).cgColor
        layer.borderWidth = 4
        
        /*let lineView = UIView(frame: CGRect(x: 0, y: frame.size.height - 3, width: frame.size.width, height: 3))
        lineView.backgroundColor = UIColor.init(red: 16/255, green: 32/255, blue: 90/255, alpha: 1)
        addSubview(lineView)*/
    }
}

extension UIImage {

    func maskWithColor(color: UIColor) -> UIImage? {
        let maskImage = cgImage!

        let width = size.width
        let height = size.height
        let bounds = CGRect(x: 0, y: 0, width: width, height: height)

        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let context = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)!

        context.clip(to: bounds, mask: maskImage)
        context.setFillColor(color.cgColor)
        context.fill(bounds)

        if let cgImage = context.makeImage() {
            let coloredImage = UIImage(cgImage: cgImage)
            return coloredImage
        } else {
            return nil
        }
    }

}
