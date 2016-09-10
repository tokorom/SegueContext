//
//  ViewController.swift
//
//  Created by ToKoRo on 2015-07-14.
//

import UIKit
import SegueContext

class ViewController: UIViewController {

    var value: Int = 10 {
        didSet {
            self.label?.text = String(self.value)
        }
    }

    @IBOutlet weak var label: UILabel?

    @IBAction func buttonDidTap(_ sender: AnyObject) {
        /* self.performSegue(withIdentifier: "Tab", context: self.value) { (value: Int) -> Void in
            self.value = value
        } */
        self.performSegue(withIdentifier: "Tab", context: self.value, callback: { (value: Int) -> Void in
            self.value = value
        } as Any?)
    }

}
