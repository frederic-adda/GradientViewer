//
//  CAGradientLayer extension.swift
//  LLSBook2016
//
//  Created by Frédéric ADDA on 04/04/2018.
//  Copyright © 2018 Lelivrescolaire.fr. All rights reserved.
//

import UIKit

extension CAGradientLayer {
    
    convenience init(frame: CGRect, colors: [UIColor], isVertical: Bool = true) {
        self.init()
        self.setupGradient(frame: frame, colors: colors, isVertical: isVertical)
    }
    
    
    /// Useful for instances of CAGradientLayer already created (e.g. for get-only properties on a view)
    /// 'startPoint' and 'endPoint' are optional. If they both are set, 'isVertical' will be ignored
    func setupGradient(frame: CGRect, colors: [UIColor], isVertical: Bool = true, startPoint: CGPoint? = nil, endPoint: CGPoint? = nil) {
        self.frame = frame
        self.colors = colors.map { $0.cgColor }
        
        if let startPoint = startPoint,
            let endPoint = endPoint {
            self.startPoint = startPoint
            self.endPoint = endPoint
            
        } else {
            self.startPoint = CGPoint(x: 0, y: 0)
            if isVertical {
                self.endPoint = CGPoint(x: 0, y: 1)
            } else { // horizontal
                self.endPoint = CGPoint(x: 1, y: 0)
            }
        }
    }
    
    
    func createGradientImage() -> UIImage? {
        
        var image: UIImage? = nil
        UIGraphicsBeginImageContext(bounds.size)
        if let context = UIGraphicsGetCurrentContext() {
            render(in: context)
            image = UIGraphicsGetImageFromCurrentImageContext()
        }
        UIGraphicsEndImageContext()
        return image
    }
    
}
