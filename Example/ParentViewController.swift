//
//  ParentViewController.swift
//
//  Created by ToKoRo on 2015-08-09.
//

import UIKit

class ParentViewController: UIViewController {
    
    var value: Int = 0

    override func loadView() {
        super.loadView()

        if let value: Int = self.contextValue() {
            self.value = value
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        self.contextSenderForSegue(segue) { segueIdentifier, viewController, sendContext in
            switch segueIdentifier {
            case "Embedded1", "Embedded2":
                sendContext(self.value)
            default:
                break
            }
        }
    }

}
