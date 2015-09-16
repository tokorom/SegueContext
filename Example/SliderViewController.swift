//
//  SliderViewController.swift
//
//  Created by ToKoRo on 2015-07-14.
//

import UIKit

class SliderViewController: UIViewController {

    var value: Int = 0 {
        didSet {
            self.label?.text = String(self.value)
        }
    }

    @IBOutlet weak var label: UILabel?
    @IBOutlet weak var slider: UISlider?

    override func viewDidLoad() {
        super.viewDidLoad()
    
        if let value: Int = self.contextValue() {
            self.value = value
            if let slider = self.slider {
                slider.value = max(slider.minimumValue, min(slider.maximumValue, Float(value)))
            }
        }
    }

    @IBAction func sliderDidChange(slider: UISlider) {
        self.value = Int(slider.value)
    }

    @IBAction func buttonDidTap(sender: AnyObject) {
        if let callback: (Int) -> Void = self.callback() {
            callback(self.value)
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func othersButtonDidTap(sender: AnyObject) {
        self.presentViewControllerWithIdentifier("NavigationController", context: context, callback: self.rawCallback)
    }
}
