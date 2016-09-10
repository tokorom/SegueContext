//
//  ChildViewController.swift
//
//  Created by ToKoRo on 2015-08-09.
//

import UIKit
import SegueContext

class ChildViewController: UIViewController {
    
    var value: Int = 0 {
        didSet {
            self.label?.text = String(value)
        }
    }

    @IBOutlet weak var label: UILabel?

    override func viewDidLoad() {
        super.viewDidLoad()
    
        if let value: Int = contextValue() {
            self.value = value
        }
    }

}
