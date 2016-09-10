//
//  ListViewController.swift
//
//  Created by ToKoRo on 2015-07-14.
//

import UIKit

class ListViewController: UITableViewController {

    struct MyContext {
        let value: Int
        let multiplier: Int
    }

    var value: Int = 0 {
        didSet {
            self.label?.text = String(value)
        }
    }

    var multiplier: Int = 1

    @IBOutlet weak var label: UILabel?

    override func viewDidLoad() {
        super.viewDidLoad()

        if let value: Int = contextValue() {
            self.value = value
        }

        if let context: MyContext = contextValue() {
            self.value = context.value
            self.multiplier = context.multiplier
        }
    }

    func valueWithIndexPath(_ indexPath: IndexPath) -> Int {
        return value + ((indexPath as NSIndexPath).row + 1) * multiplier
    }

}

// MARK: - UITableViewDelegate

extension ListViewController {

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch (indexPath as NSIndexPath).section {
        case 1:
            if let callback: (Int) -> Void = callback() {
                let value = valueWithIndexPath(indexPath)
                callback(value)
            }
            let presentingVC = presentingViewController
            dismiss(animated: true) { _ -> Void in
                presentingVC?.dismiss(animated: true, completion: nil)
            }
        case 2:
            let context = MyContext(value: value, multiplier: multiplier * 2)
            relayPushViewController(viewControllerIdentifier: "ListViewController", context: context, anyCallback: anyCallback)
        default:
            break
        }

        tableView.deselectRow(at: indexPath, animated: true)
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        switch (indexPath as NSIndexPath).section {
        case 1:
            cell.textLabel?.text = String(valueWithIndexPath(indexPath))
        default:
            break
        }
    }

}
