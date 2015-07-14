//
//  ViewController.swift
//
//  Created by ToKoRo on 2015-07-14.
//

import UIKit

class ViewController: UIViewController {

    var value: Int = 10 {
        didSet {
            self.label?.text = String(self.value)
        }
    }

    @IBOutlet weak var label: UILabel?

    @IBAction func buttonDidTap(sender: AnyObject) {
        self.performSegueWithIdentifier("Tab", context: self.value) { (value: Int) -> Void in
            self.value = value
        }
    }

}

