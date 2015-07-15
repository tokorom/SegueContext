//
//  ListViewController.swift
//
//  Created by ToKoRo on 2015-07-14.
//

import UIKit

class ListViewController: UITableViewController {

    struct MyContext: ContextConvertible {
        let value: Int
        let multiplier: Int

        var context: Context {
            return Context(object: self)
        }
    }

    var value: Int = 0 {
        didSet {
            self.label?.text = String(self.value)
        }
    }

    var multiplier: Int = 1

    @IBOutlet weak var label: UILabel?

    override func viewDidLoad() {
        super.viewDidLoad()
    
        if let value: Int = self.contextValue() {
            self.value = value
        }

        if let context: MyContext = self.contextValue() {
            self.value = context.value
            self.multiplier = context.multiplier
        }
    }

    func valueWithIndexPath(indexPath: NSIndexPath) -> Int {
        return self.value + (indexPath.row + 1) * self.multiplier
    }
    
}

// MARK: - UITableViewDelegate

extension ListViewController: UITableViewDelegate {

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.section {
        case 1:
            if let callback: (Int) -> Void = self.callback() {
                let value = self.valueWithIndexPath(indexPath)
                callback(value)
            }
            let presentingVC = self.presentingViewController
            self.dismissViewControllerAnimated(true) { _ -> Void in
                presentingVC?.dismissViewControllerAnimated(true, completion: nil)
            }
        case 2:
            let context = MyContext(value: self.value, multiplier: self.multiplier * 2)
            self.pushViewControllerWithIdentifier("ListViewController", context: context, callback: self.rawCallabck)
        default:
            break
        }

        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.section {
        case 1:
            cell.textLabel?.text = String(self.valueWithIndexPath(indexPath))
        default:
            break
        }
    }

}
