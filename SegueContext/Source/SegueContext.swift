//
//  SegueContext.swift
//
//  Created by ToKoRo on 2015-07-14.
//

import UIKit

// MARK: - Context

public class Context {
    public let object: Any?
    public var callback: Any?
    public var segueIdentifier: String?

    public init<T>(object: T?) {
        self.object = object
    }

    public convenience init() {
        self.init(object: nil as Any?)
    }

    public convenience init(callback: Any?) {
        self.init(object: nil as Any?)
        self.callback = callback
    }

    public convenience init(anyCallback: Any) {
        self.init(object: nil as Any?)
        self.callback = anyCallback
    }

    public convenience init<T, A, R>(object: T?, callback: (A) -> R) {
        self.init(object: object)
        self.callback = callback
    }

    public subscript(key: String) -> Any? {
        get {
            if let dictionary = self.object as? [String : Any] {
                return dictionary[key]
            } else if let dictionary = self.object as? [String : AnyObject] {
                return dictionary[key]
            } else if let dictionary = self.object as? NSDictionary {
                return dictionary[key]
            } else {
                return nil
            }
        }
    }

    public subscript(index: Int) -> Any? {
        get {
            if let array = self.object as? [Any] {
                return array[index]
            } else if let array = self.object as? [AnyObject] {
                return array[index]
            } else if let array = self.object as? NSArray {
                return array[index]
            } else {
                return nil
            }
        }
    }

}

public func toContext(object: Any?) -> Context {
    if let context = object as? Context {
        return context
    } else {
        return Context(object: object)
    }
}

public func toContext(object1: Any?, _ object2: Any?, _ object3: Any? = nil, _ object4: Any? = nil, _ object5: Any? = nil) -> Context {
    var dict = [String : Any]()
    dict["1"] = object1
    dict["2"] = object2
    dict["3"] = object3
    dict["4"] = object4
    dict["5"] = object5
    let context = Context(object: dict)
    return context
}

// MARK: - PresentType

public enum PresentType {
    case Popup
    case Push
    case Custom((UIViewController) -> Void)
}

// MARK: - UIViewController

extension UIViewController {

    struct CustomProperty {
        static var context = "CustomProperty.context"
        static var callback = "CustomProperty.callback"
        static var sendContext = "CustomProperty.sendContext"
        static var sendCallback = "CustomProperty.sendCallback"
    }

    public func contextValue<T>() -> T? {
        return self.customContext?.object as? T
    }

    public func contextValue<A, B>() -> (A?, B?) {
        if let context = self.customContext {
            let object1 = context["1"] as? A
            let object2 = context["2"] as? B
            return (object1, object2)
        }
        return (nil, nil)
    }

    public func contextValue<A, B, C>() -> (A?, B?, C?) {
        if let context = self.customContext {
            let object1 = context["1"] as? A
            let object2 = context["2"] as? B
            let object3 = context["3"] as? C
            return (object1, object2, object3)
        }
        return (nil, nil, nil)
    }

    public func contextValueForKey<T>(key: String) -> T? {
        return self.customContext?[key] as? T
    }

    public var rawCallback: Any? {
        if let customContextForCallback = self.customContextForCallback {
            return customContextForCallback.callback
        } else {
            return self.customContext?.callback
        }
    }

    public func callback<A, R>() -> ((A) -> R)? {
        if let callback = self.customContextForCallback?.callback as? ((A) -> R) {
            return callback
        } else {
            return self.customContext?.callback as? ((A) -> R)
        }
    }

    public private(set) var context: Context? {
        get {
            return self.customContext
        }
        set {
            self.customContext = context
        }
    }

    private var customContext: Context? {
        get {
            if let object: AnyObject = objc_getAssociatedObject(self, &CustomProperty.context) {
                if let context = object as? Context {
                    return context
                } else {
                    return Context(object: object)
                }
            }
            return nil
        }
        set {
            if let context = newValue {
                objc_setAssociatedObject(self, &CustomProperty.context, context, .OBJC_ASSOCIATION_RETAIN)
            } else {
                objc_setAssociatedObject(self, &CustomProperty.context, nil, .OBJC_ASSOCIATION_RETAIN)
            }
        }
    }

    private var customContextForCallback: Context? {
        get {
            if let object: AnyObject = objc_getAssociatedObject(self, &CustomProperty.callback) {
                if let context = object as? Context {
                    return context
                } else {
                    return Context(object: object)
                }
            }
            return nil
        }
        set {
            if let context = newValue {
                objc_setAssociatedObject(self, &CustomProperty.callback, context, .OBJC_ASSOCIATION_RETAIN)
            } else {
                objc_setAssociatedObject(self, &CustomProperty.callback, nil, .OBJC_ASSOCIATION_RETAIN)
            }
        }
    }

    private var sendCustomContext: Context? {
        get {
            if let object: AnyObject = objc_getAssociatedObject(self, &CustomProperty.sendContext) {
                if let context = object as? Context {
                    return context
                }
            }
            return nil
        }
        set {
            if let context = newValue {
                objc_setAssociatedObject(self, &CustomProperty.sendContext, context, .OBJC_ASSOCIATION_RETAIN)
            } else {
                objc_setAssociatedObject(self, &CustomProperty.sendContext, nil, .OBJC_ASSOCIATION_RETAIN)
            }
        }
    }

    private var sendCustomContextForCallback: Context? {
        get {
            if let object: AnyObject = objc_getAssociatedObject(self, &CustomProperty.sendCallback) {
                if let context = object as? Context {
                    return context
                }
            }
            return nil
        }
        set {
            if let context = newValue {
                objc_setAssociatedObject(self, &CustomProperty.sendCallback, context, .OBJC_ASSOCIATION_RETAIN)
            } else {
                objc_setAssociatedObject(self, &CustomProperty.sendCallback, nil, .OBJC_ASSOCIATION_RETAIN)
            }
        }
    }

    public func performSegueWithIdentifier(identifier: String, sender: AnyObject? = nil, context: Any?) {
        self.performSegueWithIdentifier(identifier, sender: sender, context: context, callback: nil)
    }

    public func performSegueWithIdentifier(identifier: String, sender: AnyObject? = nil, callback: Any?) {
        self.performSegueWithIdentifier(identifier, sender: sender, context: nil, callback: callback)
    }

    public func performSegueWithIdentifier(identifier: String, sender: AnyObject? = nil, context: Any?, callback: Any?) {
        objc_sync_enter(self.dynamicType)

        self.replacePrepareForSegueIfNeeded()

        let customContext: Context
        if let context = context as? Context {
            customContext = context
        } else {
            customContext = Context(object: context)
        }
        customContext.segueIdentifier = identifier
        self.sendCustomContext = customContext

        let customContextForCallback = Context(callback: callback)
        customContextForCallback.segueIdentifier = identifier
        self.sendCustomContextForCallback = customContextForCallback

        self.performSegueWithIdentifier(identifier, sender: sender)

        objc_sync_exit(self.dynamicType)
    }

    public func presentViewControllerWithStoryboardName(storyboardName: String, identifier: String? = nil, bundle: NSBundle? = nil, animated: Bool = true, transitionStyle: UIModalTransitionStyle? = nil, context: Any? = nil, callback: Any? = nil) {
        self.presentViewControllerWithType(.Popup, storyboardName: storyboardName, identifier: identifier, bundle: bundle, animated: animated, transitionStyle: transitionStyle, context: context, callback: callback)
    }

    public func presentViewControllerWithIdentifier(identifier: String, animated: Bool = true, transitionStyle: UIModalTransitionStyle? = nil, context: Any? = nil, callback: Any? = nil) {
        if let storyboard = self.storyboard {
            self.presentViewControllerWithStoryboard(storyboard, identifier: identifier, animated: animated, transitionStyle: transitionStyle, context: context, callback: callback)
        }
    }

    public func presentViewControllerWithStoryboard(storyboard: UIStoryboard, identifier: String? = nil, animated: Bool = true, transitionStyle: UIModalTransitionStyle? = nil, context: Any? = nil, callback: Any? = nil) {
        self.presentViewControllerWithType(.Popup, storyboard: storyboard, identifier: identifier, animated: animated, transitionStyle: transitionStyle, context: context, callback: callback)
    }

    public func pushViewControllerWithStoryboardName(storyboardName: String, identifier: String? = nil, bundle: NSBundle? = nil, animated: Bool = true, context: Any? = nil, callback: Any? = nil) {
        self.presentViewControllerWithType(.Push, storyboardName: storyboardName, identifier: identifier, bundle: bundle, animated: animated, context: context, callback: callback)
    }

    public func pushViewControllerWithIdentifier(identifier: String, animated: Bool = true, context: Any? = nil, callback: Any? = nil) {
        if let storyboard = self.storyboard {
            self.pushViewControllerWithStoryboard(storyboard, identifier: identifier, animated: animated, context: context, callback: callback)
        }
    }

    public func pushViewControllerWithStoryboard(storyboard: UIStoryboard, identifier: String? = nil, animated: Bool = true, context: Any? = nil, callback: Any? = nil) {
        self.presentViewControllerWithType(.Push, storyboard: storyboard, identifier: identifier, animated: animated, context: context, callback: callback)
    }

    public func presentViewControllerWithType(type: PresentType, storyboardName: String, identifier: String? = nil, bundle: NSBundle? = nil, animated: Bool = true, transitionStyle: UIModalTransitionStyle? = nil, context: Any? = nil, callback: Any? = nil) {
        let storyboard = UIStoryboard(name: storyboardName, bundle: bundle)
        self.presentViewControllerWithType(type, storyboard: storyboard, identifier: identifier, animated: animated, transitionStyle: transitionStyle, context: context, callback: callback)
    }

    public func presentViewControllerWithType(type: PresentType, storyboard: UIStoryboard, identifier: String? = nil, animated: Bool = true, transitionStyle: UIModalTransitionStyle? = nil, context: Any? = nil, callback: Any? = nil) {
        if let viewController = UIViewController.viewControllerFromStoryboard(storyboard, identifier: identifier, context: context, callback: callback) {
            switch type {
            case .Push:
                var navigationController: UINavigationController?
                if let navi = self.navigationController {
                    navigationController = navi
                } else if let navi = self.parentViewController as? UINavigationController {
                    navigationController = navi
                } else if let navi = self.presentingViewController as? UINavigationController {
                    navigationController = navi
                } else if let tabBarController = self as? UITabBarController {
                    if let navi = tabBarController.selectedViewController as? UINavigationController {
                        navigationController = navi
                    } else if let navi = tabBarController.selectedViewController?.navigationController {
                        navigationController = navi
                    }
                }
                navigationController?.pushViewController(viewController, animated: animated)
            case .Custom(let customFunction):
                customFunction(viewController)
            default:
                if let transitionStyle = transitionStyle {
                    viewController.modalTransitionStyle = transitionStyle
                }
                self.presentViewController(viewController, animated: animated, completion: nil)
            }
        }
    }

    public class func viewControllerFromStoryboardName(storyboardName: String, identifier: String? = nil, bundle: NSBundle? = nil, context: Any? = nil, callback: Any? = nil) -> UIViewController? {
        let storyboard = UIStoryboard(name: storyboardName, bundle: bundle)
        return self.viewControllerFromStoryboard(storyboard, identifier: identifier, context: context, callback: callback)
    }

    public class func viewControllerFromStoryboard(storyboard: UIStoryboard, identifier: String? = nil, context: Any? = nil, callback: Any? = nil) -> UIViewController? {
        let viewController: UIViewController?
        if let identifier = identifier {
            viewController = storyboard.instantiateViewControllerWithIdentifier(identifier)
        } else {
            viewController = storyboard.instantiateInitialViewController()
        }
        if let viewController = viewController {
            if let context = context as? Context {
                viewController.configureCustomContext(context)
            } else if let context = context {
                let customContext = Context(object: context)
                viewController.configureCustomContext(customContext)
            }
            if let callback = callback {
                let context = Context(callback: callback)
                viewController.configureCustomContextForCallback(context)
            }
        }
        return viewController
    }

    public func sendContext(object1: Any?, _ object2: Any?, _ object3: Any? = nil, _ object4: Any? = nil, _ object5: Any? = nil) -> Context {
        return self.sendContext(toContext(object1, object2, object3, object4, object5))
    }

    public func sendContext(object: Any?) -> Context {
        let context = toContext(object)
        self.configureCustomContext(context)
        return context
    }

    private func configureCustomContext(customContext: Context) {
        let viewController = self
        viewController.customContext = customContext
        for viewController in viewController.childViewControllers {
            viewController.configureCustomContext(customContext)
        }
        if let navi = viewController as? UINavigationController {
            if let viewController = navi.viewControllers.first {
                viewController.configureCustomContext(customContext)
            }
        } else if let tab = viewController as? UITabBarController {
            if let viewControllers = tab.viewControllers {
                for viewController in viewControllers {
                    viewController.configureCustomContext(customContext)
                }
            }
        }
    }

    private func configureCustomContextForCallback(customContextForCallback: Context) {
        let viewController = self
        viewController.customContextForCallback = customContextForCallback
        for viewController in viewController.childViewControllers {
            viewController.configureCustomContextForCallback(customContextForCallback)
        }
        if let navi = viewController as? UINavigationController {
            if let viewController = navi.viewControllers.first {
                viewController.configureCustomContextForCallback(customContextForCallback)
            }
        } else if let tab = viewController as? UITabBarController {
            if let viewControllers = tab.viewControllers {
                for viewController in viewControllers {
                    viewController.configureCustomContextForCallback(customContextForCallback)
                }
            }
        }
    }

}

// MARK: - Swizzling

var swc_swizzled_already: UInt8 = 0

extension UIViewController {

    public func contextSenderForSegue(segue: UIStoryboardSegue, callback: (String, UIViewController, (Any?) -> Void) -> Void) {
        if let segueIdentifier = segue.identifier  {
            let viewController = segue.destinationViewController
            let sendContext: (Any?) -> Void = { context in
                viewController.sendContext(context)
            }
            callback(segueIdentifier, viewController, sendContext)
        }
    }

    class func replacePrepareForSegueIfNeeded() {
        if nil == objc_getAssociatedObject(self, &swc_swizzled_already) {
            objc_setAssociatedObject(self, &swc_swizzled_already, NSNumber(bool: true), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            let original = class_getInstanceMethod(self, "prepareForSegue:sender:")
            let replaced = class_getInstanceMethod(self, "swc_wrapped_prepareForSegue:sender:")
            method_exchangeImplementations(original, replaced)
        }
    }

    class func revertReplacedPrepareForSegueIfNeeded() {
        if nil != objc_getAssociatedObject(self, &swc_swizzled_already) {
            objc_setAssociatedObject(self, &swc_swizzled_already, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            let original = class_getInstanceMethod(self, "prepareForSegue:sender:")
            let replaced = class_getInstanceMethod(self, "swc_wrapped_prepareForSegue:sender:")
            method_exchangeImplementations(original, replaced)
        }
    }

    func replacePrepareForSegueIfNeeded() {
        self.dynamicType.replacePrepareForSegueIfNeeded()
    }

    func revertReplacedPrepareForSegueIfNeeded() {
        self.dynamicType.revertReplacedPrepareForSegueIfNeeded()
    }
    
    func swc_wrapped_prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        self.swc_wrapped_prepareForSegue(segue, sender: sender)
        self.swc_prepareForSegue(segue, sender: sender)

        self.revertReplacedPrepareForSegueIfNeeded()
    }

    func swc_prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destination = segue.destinationViewController
        let source = segue.sourceViewController
        if let customContext = source.sendCustomContext {
            if let targetIdentifier = customContext.segueIdentifier where targetIdentifier != segue.identifier {
                return
            }

            destination.configureCustomContext(customContext)
            source.sendCustomContext = nil
        }
        if let customContextForCallback = source.sendCustomContextForCallback {
            if let targetIdentifier = customContextForCallback.segueIdentifier where targetIdentifier != segue.identifier {
                return
            }

            destination.configureCustomContextForCallback(customContextForCallback)
            source.sendCustomContextForCallback = nil
        }
    }

}
