//
//  SliderViewController.swift
//
//  Created by ToKoRo on 2015-07-14.
//

import UIKit
import SegueContext

class SliderViewController: UIViewController {

    var value: Int = 0 {
        didSet {
            self.label?.text = String(value)
        }
    }

    @IBOutlet weak var label: UILabel?
    @IBOutlet weak var slider: UISlider?

    override func viewDidLoad() {
        super.viewDidLoad()

        if let value: Int = contextValue() {
            self.value = value
            if let slider = slider {
                slider.value = max(slider.minimumValue, min(slider.maximumValue, Float(value)))
            }
        }
    }

    @IBAction func sliderDidChange(_ slider: UISlider) {
        self.value = Int(slider.value)
    }

    @IBAction func buttonDidTap(_ sender: AnyObject) {
        if let callback: (Int) -> Void = callback() {
            callback(value)
        }
        dismiss(animated: true, completion: nil)
    }

    @IBAction func othersButtonDidTap(_ sender: AnyObject) {
        relayPresent(viewControllerIdentifier: "NavigationController", context: context, anyCallback: anyCallback)
    }
}
