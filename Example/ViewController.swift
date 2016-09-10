//
//  ViewController.swift
//
//  Created by ToKoRo on 2015-07-14.
//

import UIKit
import SegueContext

class ViewController: UIViewController {

    var value: Int = 10 {
        willSet(value) {
            label?.text = String(value)
        }
    }

    @IBOutlet weak var label: UILabel?

    @IBAction func buttonDidTap(_ sender: AnyObject) {
        performSegue(withIdentifier: "Tab", context: self.value) { [weak self] (value: Int) -> Void in
            self?.value = value
        }
    }

}
