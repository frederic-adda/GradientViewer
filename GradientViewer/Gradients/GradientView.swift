//
//  GradientView.swift
//  LLSApp
//  Class to enable adding gradient background color to a view directly in Interface builder
//  See http://www.thinkandbuild.it/building-custom-ui-element-with-ibdesignable/
//  Created by Cédric Soubrié on 27/01/2015.
//  Copyright (c) 2015 Cédric Soubrié. All rights reserved.
//

import UIKit

@IBDesignable
class GradientView: UIView {
    // MARK: Inspectable properties ******************************
    
    @IBInspectable var startColor: UIColor = UIColor.white {
        didSet{
            setupView()
        }
    }
    
    @IBInspectable var endColor: UIColor = UIColor.black {
        didSet{
            setupView()
        }
    }
    
    @IBInspectable var isHorizontal: Bool = false {
        didSet{
            setupView()
        }
    }
    
    
    // Optional properties to customize directly the gradient start and end points
    /// If both 'startPoint' and 'endPoint' properties are set, the 'isHorizontal' property is ignored
    var startPoint: CGPoint? {
        didSet {
            setupView()
        }
    }
    /// If both 'startPoint' and 'endPoint' properties are set, the 'isHorizontal' property is ignored
    var endPoint: CGPoint? {
        didSet {
            setupView()
        }
    }
    
    
    // MARK: Overrides ******************************************
    
    override class var layerClass:AnyClass{
        return CAGradientLayer.self
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        setupView()
    }
    
    
    
    // MARK: Internal functions *********************************
    
    // Setup the view appearance
    private func setupView() {
        
        gradientLayer.setupGradient(frame: layer.frame, colors: [startColor, endColor], isVertical: !isHorizontal, startPoint: startPoint, endPoint: endPoint)
        
        self.setNeedsDisplay()
        
    }
    
    // Helper to return the main layer as CAGradientLayer
    var gradientLayer: CAGradientLayer {
        return layer as! CAGradientLayer
    }
}
