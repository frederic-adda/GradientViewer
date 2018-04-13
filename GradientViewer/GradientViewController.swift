//
//  GradientViewController.swift
//  GradientViewer
//
//  Created by Frédéric ADDA on 11/04/2018.
//  Copyright © 2018 Frédéric ADDA. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxSwiftExt

class GradientViewController: InputViewController {

    // MARK: - Properties
    
    // Model
    var gradientStart = Variable<CGPoint>(CGPoint.zero)
    var gradientEnd = Variable<CGPoint>(CGPoint(x: 0, y: 1))
    
    // Private properties
    private var bag = DisposeBag()
    private var arrowLayer = CAShapeLayer()
    
    // IBOutlets
    @IBOutlet private weak var gradientView: GradientView!
    
    @IBOutlet private weak var startXLabel: UILabel!
    @IBOutlet private weak var startXStepper: UIStepper!
    @IBOutlet private weak var startYLabel: UILabel!
    @IBOutlet private weak var startYStepper: UIStepper!
    @IBOutlet private weak var endXLabel: UILabel!
    @IBOutlet private weak var endXStepper: UIStepper!
    @IBOutlet private weak var endYLabel: UILabel!
    @IBOutlet private weak var endYStepper: UIStepper!
    
    @IBOutlet private weak var startColorTextField: UITextField!
    @IBOutlet private weak var startColorSampleButton: UIButton!
    @IBOutlet private weak var endColorTextField: UITextField!
    @IBOutlet private weak var endColorSampleButton: UIButton!
    
    @IBOutlet private weak var startMarker: UILabel!
    @IBOutlet private weak var endMarker: UILabel!
    
    // NSLayoutConstraints
    @IBOutlet private weak var startMarkerXConstraint: NSLayoutConstraint!
    @IBOutlet private weak var startMarkerYConstraint: NSLayoutConstraint!
    @IBOutlet private weak var endMarkerXConstraint: NSLayoutConstraint!
    @IBOutlet private weak var endMarkerYConstraint: NSLayoutConstraint!
    
    
    
    // MARK: - View controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Bindings
        bindGradientModel()
        bindSteppers()
        bindTextFields()
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        startMarker.makeRound()
        endMarker.makeRound()
        adjustGradientVector()
    }
    
    
    // MARK: - Custom functions
    private func bindGradientModel() {
        gradientStart.asObservable()
            .subscribe(onNext: { (gradientStart) in
                self.gradientView.startPoint = gradientStart
                self.startXLabel.text = "x: \(gradientStart.x)"
                self.startYLabel.text = "y: \(gradientStart.y)"
                self.startXStepper.value = Double(gradientStart.x)
                self.startYStepper.value = Double(gradientStart.y)
                
                self.adjustStartMarkerPosition(with: gradientStart)
            })
            .disposed(by: bag)
        
        gradientEnd.asObservable()
            .subscribe(onNext: { (gradientEnd) in
                self.gradientView.endPoint = gradientEnd
                self.endXLabel.text = "x: \(gradientEnd.x)"
                self.endYLabel.text = "y: \(gradientEnd.y)"
                self.endXStepper.value = Double(gradientEnd.x)
                self.endYStepper.value = Double(gradientEnd.y)
                
                self.adjustEndMarkerPosition(with: gradientEnd)
            })
            .disposed(by: bag)
    }
    
    
    private func bindSteppers() {
        startXStepper.rx.value
            .map { CGFloat($0) }
            .asDriver(onErrorJustReturn: 0)
            .drive(onNext: { xValue in
                self.gradientStart.value.x = xValue
            })
            .disposed(by: bag)
        
        startYStepper.rx.value
            .map { CGFloat($0) }
            .asDriver(onErrorJustReturn: 0)
            .drive(onNext: { yValue in
                self.gradientStart.value.y = yValue
            })
            .disposed(by: bag)
        
        endXStepper.rx.value
            .map { CGFloat($0) }
            .asDriver(onErrorJustReturn: 0)
            .drive(onNext: { xValue in
                self.gradientEnd.value.x = xValue
            })
            .disposed(by: bag)
        
        endYStepper.rx.value
            .map { CGFloat($0) }
            .asDriver(onErrorJustReturn: 0)
            .drive(onNext: { yValue in
                self.gradientEnd.value.y = yValue
            })
            .disposed(by: bag)
    }
    
    
    private func bindTextFields() {
        startColorTextField.rx.text
            .unwrap()
            .map { UIColor(hexString: $0) }
            .subscribe(onNext: { (color) in
                self.gradientView.startColor = color
                self.startColorSampleButton.backgroundColor = color
            })
            .disposed(by: bag)
        
        endColorTextField.rx.text
            .unwrap()
            .map { UIColor(hexString: $0) }
            .subscribe(onNext: { (color) in
                self.gradientView.endColor = color
                self.endColorSampleButton.backgroundColor = color
            })
            .disposed(by: bag)
        
        startColorSampleButton.rx.tap
            .asDriver()
            .drive(onNext: { _ in
            self.startColorTextField.becomeFirstResponder()
        })
        
        endColorSampleButton.rx.tap
            .asDriver()
            .drive(onNext: { _ in
                self.endColorTextField.becomeFirstResponder()
            })
    }
    
    
    private func adjustStartMarkerPosition(with gradientStart: CGPoint) {
        startMarkerXConstraint.constant = gradientView.bounds.width * gradientStart.x
        startMarkerYConstraint.constant = gradientView.bounds.height * gradientStart.y
        gradientView.layoutIfNeeded()
        
        adjustGradientVector()
    }
    
    
    private func adjustEndMarkerPosition(with gradientEnd: CGPoint) {
        endMarkerXConstraint.constant = gradientView.bounds.width * gradientEnd.x
        endMarkerYConstraint.constant = gradientView.bounds.height * gradientEnd.y
        gradientView.layoutIfNeeded()
        
        adjustGradientVector()
    }
    
    
    // The gradient vector is a line going from the startMarker to the endMarker
    private func adjustGradientVector() {
        arrowLayer.removeFromSuperlayer()
        
        let arrowPath = UIBezierPath()
        arrowPath.move(to: startMarker.center)
        arrowPath.addLine(to: endMarker.center)

        arrowLayer.path = arrowPath.cgPath
        arrowLayer.lineWidth = 1
        arrowLayer.strokeColor = UIColor.darkGray.cgColor
        
        self.gradientView.layer.insertSublayer(arrowLayer, below: startMarker.layer)
    }
}

