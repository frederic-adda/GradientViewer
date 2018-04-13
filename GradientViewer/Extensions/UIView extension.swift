//
//  UIView extension.swift
//  GradientViewer
//
//  Created by Frédéric ADDA on 13/04/2018.
//  Copyright © 2018 Frédéric ADDA. All rights reserved.
//

import UIKit

extension UIView {
    
    func makeRound() {
        self.layer.cornerRadius = self.bounds.height/2
        self.layer.masksToBounds = true
    }
}
