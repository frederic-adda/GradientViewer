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

    // MARK: - Model
    var gradientStart = Variable<CGPoint>(CGPoint.zero)
    var gradientEnd = Variable<CGPoint>(CGPoint(x: 1, y: 0))
    
    private var bag = DisposeBag()

    
    // MARK: - IBOutlets
    @IBOutlet weak var gradientView: GradientView!
    
    @IBOutlet weak var startXLabel: UILabel!
    @IBOutlet weak var startXStepper: UIStepper!
    @IBOutlet weak var startYLabel: UILabel!
    @IBOutlet weak var startYStepper: UIStepper!
    @IBOutlet weak var endXLabel: UILabel!
    @IBOutlet weak var endXStepper: UIStepper!
    @IBOutlet weak var endYLabel: UILabel!
    @IBOutlet weak var endYStepper: UIStepper!
    
    @IBOutlet weak var startColorTextField: UITextField!
    @IBOutlet weak var startColorSampleView: UIView!
    @IBOutlet weak var endColorTextField: UITextField!
    @IBOutlet weak var endColorSampleView: UIView!
    
    
    // MARK: - View controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
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

