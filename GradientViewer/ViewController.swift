//
//  ViewController.swift
//  GradientViewer
//
//  Created by Frédéric ADDA on 11/04/2018.
//  Copyright © 2018 Frédéric ADDA. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxSwiftExt

class ViewController: UIViewController {

    // MARK: - Properties
    
    // Model
    var gradientStart = Variable<CGPoint>(CGPoint.zero)
    var gradientEnd = Variable<CGPoint>(CGPoint(x: 1, y: 0))
    
    // Private properties
    private var bag = DisposeBag()

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
    @IBOutlet private weak var startColorSampleView: UIView!
    @IBOutlet private weak var endColorTextField: UITextField!
    @IBOutlet private weak var endColorSampleView: UIView!
    
    
    // MARK: - View controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Bindings
        bindGradientModel()
        bindSteppers()
        bindTextFields()
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
            })
            .disposed(by: bag)
        
        gradientEnd.asObservable()
            .subscribe(onNext: { (gradientEnd) in
                self.gradientView.endPoint = gradientEnd
                self.endXLabel.text = "x: \(gradientEnd.x)"
                self.endYLabel.text = "y: \(gradientEnd.y)"
                self.endXStepper.value = Double(gradientEnd.x)
                self.endYStepper.value = Double(gradientEnd.y)
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
                self.startColorSampleView.backgroundColor = color
            })
            .disposed(by: bag)
        
        endColorTextField.rx.text
            .unwrap()
            .map { UIColor(hexString: $0) }
            .subscribe(onNext: { (color) in
                self.gradientView.endColor = color
                self.endColorSampleView.backgroundColor = color
            })
            .disposed(by: bag)
    }
}

