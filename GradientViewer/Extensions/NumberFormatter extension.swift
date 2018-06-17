//
//  NumberFormatter extension.swift
//  GradientViewer
//
//  Created by Frédéric ADDA on 17/06/2018.
//  Copyright © 2018 Frédéric ADDA. All rights reserved.
//

import Foundation
import CoreGraphics

extension NumberFormatter {

    func string(from value: CGFloat) -> String {
        return string(from: NSNumber(value: Float(value))) ?? ""
    }
}
