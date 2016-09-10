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

    public convenience init<T, A, R>(object: T?, callback: @escaping (A) -> R) {
        self.init(object: object)
        self.callback = callback
    }

    public subscript(key: String) -> Any? {
        get {
            if let dictionary = object as? [String : Any] {
                return dictionary[key]
            } else if let dictionary = object as? [String : AnyObject] {
                return dictionary[key]
            } else if let dictionary = object as? NSDictionary {
                return dictionary[key]
            } else {
                return nil
            }
        }
    }

    public subscript(index: Int) -> Any? {
        get {
            if let array = object as? [Any] {
                return array[index]
            } else if let array = object as? [AnyObject] {
                return array[index]
            } else if let array = object as? NSArray {
                return array[index]
            } else {
                return nil
            }
        }
    }

}

public func toContext(_ object: Any?) -> Context {
    if let context = object as? Context {
        return context
    } else {
        return Context(object: object)
    }
}

public func toContext(_ object1: Any?, _ object2: Any?, _ object3: Any? = nil, _ object4: Any? = nil, _ object5: Any? = nil) -> Context {
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
    case popup
    case push
    case custom((UIViewController) -> Void)
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
        return customContext?.object as? T
    }

    public func contextValue<A, B>() -> (A?, B?) {
        if let context = customContext {
            let object1 = context["1"] as? A
            let object2 = context["2"] as? B
            return (object1, object2)
        }
        return (nil, nil)
    }

    public func contextValue<A, B, C>() -> (A?, B?, C?) {
        if let context = customContext {
            let object1 = context["1"] as? A
            let object2 = context["2"] as? B
            let object3 = context["3"] as? C
            return (object1, object2, object3)
        }
        return (nil, nil, nil)
    }

    public func contextValueForKey<T>(_ key: String) -> T? {
        return customContext?[key] as? T
    }

    public var anyCallback: Any? {
        if let customContextForCallback = customContextForCallback {
            return customContextForCallback.callback
        } else {
            return customContext?.callback
        }
    }

    public func callback<A, R>() -> ((A) -> R)? {
        if let callback = customContextForCallback?.callback as? ((A) -> R) {
            return callback
        } else {
            return customContext?.callback as? ((A) -> R)
        }
    }

    public fileprivate(set) var context: Context? {
        get {
            return customContext
        }
        set {
            self.customContext = context
        }
    }

    fileprivate var customContext: Context? {
        get {
            if let object: AnyObject = objc_getAssociatedObject(self, &CustomProperty.context) as AnyObject? {
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

    fileprivate var customContextForCallback: Context? {
        get {
            if let object: AnyObject = objc_getAssociatedObject(self, &CustomProperty.callback) as AnyObject? {
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

    fileprivate var sendCustomContext: Context? {
        get {
            if let object: AnyObject = objc_getAssociatedObject(self, &CustomProperty.sendContext) as AnyObject? {
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

    fileprivate var sendCustomContextForCallback: Context? {
        get {
            if let object: AnyObject = objc_getAssociatedObject(self, &CustomProperty.sendCallback) as AnyObject? {
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

    public func performSegue<A, R>(withIdentifier identifier: String, sender: AnyObject? = nil, context: Any? = nil, callback: @escaping ((A) -> R)) {
        relayPerformSegue(withIdentifier: identifier, sender: sender, context: context, anyCallback: callback as Any?)
    }

    public func relayPerformSegue(withIdentifier identifier: String, sender: AnyObject? = nil, context: Any? = nil, anyCallback: Any? = nil) {
        objc_sync_enter(type(of: self))

        replacePrepareForSegueIfNeeded()

        let customContext: Context
        if let context = context as? Context {
            customContext = context
        } else {
            customContext = Context(object: context)
        }
        customContext.segueIdentifier = identifier
        sendCustomContext = customContext

        let customContextForCallback = Context(callback: anyCallback)
        customContextForCallback.segueIdentifier = identifier
        sendCustomContextForCallback = customContextForCallback

        performSegue(withIdentifier: identifier, sender: sender)

        objc_sync_exit(type(of: self))
    }

    public func present<A, R>(storyboardName: String, viewControllerIdentifier: String? = nil, bundle: Bundle? = nil, animated: Bool = true, transitionStyle: UIModalTransitionStyle? = nil, context: Any? = nil, callback: @escaping ((A) -> R)) {
        present(presentType: .popup, storyboardName: storyboardName, viewControllerIdentifier: viewControllerIdentifier, bundle: bundle, animated: animated, transitionStyle: transitionStyle, context: context, callback: callback)
    }

    public func relayPresent(storyboardName: String, viewControllerIdentifier: String? = nil, bundle: Bundle? = nil, animated: Bool = true, transitionStyle: UIModalTransitionStyle? = nil, context: Any? = nil, anyCallback: Any? = nil) {
        relayPresent(presentType: .popup, storyboardName: storyboardName, viewControllerIdentifier: viewControllerIdentifier, bundle: bundle, animated: animated, transitionStyle: transitionStyle, context: context, anyCallback: anyCallback)
    }

    public func present<A, R>(viewControllerIdentifier: String, animated: Bool = true, transitionStyle: UIModalTransitionStyle? = nil, context: Any? = nil, callback: @escaping ((A) -> R)) {
        guard let storyboard = storyboard else {
            return
        }
        present(storyboard: storyboard, viewControllerIdentifier: viewControllerIdentifier, animated: animated, transitionStyle: transitionStyle, context: context, callback: callback)
    }

    public func relayPresent(viewControllerIdentifier: String, animated: Bool = true, transitionStyle: UIModalTransitionStyle? = nil, context: Any? = nil, anyCallback: Any? = nil) {
        guard let storyboard = storyboard else {
            return
        }
        relayPresent(storyboard: storyboard, viewControllerIdentifier: viewControllerIdentifier, animated: animated, transitionStyle: transitionStyle, context: context, anyCallback: anyCallback)
    }

    public func present<A, R>(storyboard: UIStoryboard, viewControllerIdentifier: String? = nil, animated: Bool = true, transitionStyle: UIModalTransitionStyle? = nil, context: Any? = nil, callback: @escaping ((A) -> R)) {
        present(presentType: .popup, storyboard: storyboard, viewControllerIdentifier: viewControllerIdentifier, animated: animated, transitionStyle: transitionStyle, context: context, callback: callback)
    }

    public func relayPresent(storyboard: UIStoryboard, viewControllerIdentifier: String? = nil, animated: Bool = true, transitionStyle: UIModalTransitionStyle? = nil, context: Any? = nil, anyCallback: Any? = nil) {
        relayPresent(presentType: .popup, storyboard: storyboard, viewControllerIdentifier: viewControllerIdentifier, animated: animated, transitionStyle: transitionStyle, context: context, anyCallback: anyCallback)
    }

    public func pushViewController<A, R>(storyboardName: String, viewControllerIdentifier: String? = nil, bundle: Bundle? = nil, animated: Bool = true, context: Any? = nil, callback: @escaping ((A) -> R)) {
        present(presentType: .push, storyboardName: storyboardName, viewControllerIdentifier: viewControllerIdentifier, bundle: bundle, animated: animated, context: context, callback: callback)
    }

    public func relayPushViewController(storyboardName: String, viewControllerIdentifier: String? = nil, bundle: Bundle? = nil, animated: Bool = true, context: Any? = nil, anyCallback: Any? = nil) {
        relayPresent(presentType: .push, storyboardName: storyboardName, viewControllerIdentifier: viewControllerIdentifier, bundle: bundle, animated: animated, context: context, anyCallback: anyCallback)
    }

    public func pushViewController<A, R>(viewControllerIdentifier: String, animated: Bool = true, context: Any? = nil, callback: @escaping ((A) -> R)) {
        guard let storyboard = storyboard else {
            return
        }
        pushViewController(storyboard: storyboard, viewControllerIdentifier: viewControllerIdentifier, animated: animated, context: context, callback: callback)
    }

    public func relayPushViewController(viewControllerIdentifier: String, animated: Bool = true, context: Any? = nil, anyCallback: Any? = nil) {
        guard let storyboard = storyboard else {
            return
        }
        relayPushViewController(storyboard: storyboard, viewControllerIdentifier: viewControllerIdentifier, animated: animated, context: context, anyCallback: anyCallback)
    }

    public func pushViewController<A, R>(storyboard: UIStoryboard, viewControllerIdentifier: String? = nil, animated: Bool = true, context: Any? = nil, callback: @escaping ((A) -> R)) {
        present(presentType: .push, storyboard: storyboard, viewControllerIdentifier: viewControllerIdentifier, animated: animated, context: context, callback: callback)
    }

    public func relayPushViewController(storyboard: UIStoryboard, viewControllerIdentifier: String? = nil, animated: Bool = true, context: Any? = nil, anyCallback: Any? = nil) {
        relayPresent(presentType: .push, storyboard: storyboard, viewControllerIdentifier: viewControllerIdentifier, animated: animated, context: context, anyCallback: anyCallback)
    }

    public func present<A, R>(presentType type: PresentType, storyboardName: String, viewControllerIdentifier: String? = nil, bundle: Bundle? = nil, animated: Bool = true, transitionStyle: UIModalTransitionStyle? = nil, context: Any? = nil, callback: @escaping ((A) -> R)) {
        let storyboard = UIStoryboard(name: storyboardName, bundle: bundle)
        present(presentType: type, storyboard: storyboard, viewControllerIdentifier: viewControllerIdentifier, animated: animated, transitionStyle: transitionStyle, context: context, callback: callback)
    }

    public func relayPresent(presentType type: PresentType, storyboardName: String, viewControllerIdentifier: String? = nil, bundle: Bundle? = nil, animated: Bool = true, transitionStyle: UIModalTransitionStyle? = nil, context: Any? = nil, anyCallback: Any? = nil) {
        let storyboard = UIStoryboard(name: storyboardName, bundle: bundle)
        relayPresent(presentType: type, storyboard: storyboard, viewControllerIdentifier: viewControllerIdentifier, animated: animated, transitionStyle: transitionStyle, context: context, anyCallback: anyCallback)
    }

    fileprivate var _navigationController: UINavigationController? {
        if let navi = navigationController {
            return navi
        } else if let navi = parent as? UINavigationController {
            return navi
        } else if let navi = presentingViewController as? UINavigationController {
            return navi
        } else if let tabBarController = self as? UITabBarController {
            if let navi = tabBarController.selectedViewController as? UINavigationController {
                return navi
            } else if let navi = tabBarController.selectedViewController?.navigationController {
                return navi
            }
        }
        return nil
    }

    public func present<A, R>(presentType type: PresentType, storyboard: UIStoryboard, viewControllerIdentifier: String? = nil, animated: Bool = true, transitionStyle: UIModalTransitionStyle? = nil, context: Any? = nil, callback: @escaping ((A) -> R)) {
        relayPresent(presentType: type, storyboard: storyboard, viewControllerIdentifier: viewControllerIdentifier, animated: animated, transitionStyle: transitionStyle, context: context, anyCallback: callback as Any?)
    }

    public func relayPresent(presentType type: PresentType, storyboard: UIStoryboard, viewControllerIdentifier: String? = nil, animated: Bool = true, transitionStyle: UIModalTransitionStyle? = nil, context: Any? = nil, anyCallback: Any? = nil) {
        guard let viewController = UIViewController.relayViewController(fromStoryboard: storyboard, viewControllerIdentifier: viewControllerIdentifier, context: context, anyCallback: anyCallback) else {
            return
        }

        switch type {
        case .push:
            _navigationController?.pushViewController(viewController, animated: animated)
        case .custom(let customFunction):
            customFunction(viewController)
        default:
            if let transitionStyle = transitionStyle {
                viewController.modalTransitionStyle = transitionStyle
            }
            present(viewController, animated: animated, completion: nil)
        }
    }

    public class func viewController<A, R>(fromStoryboardName storyboardName: String, viewControllerIdentifier: String? = nil, bundle: Bundle? = nil, context: Any? = nil, callback: @escaping ((A) -> R)) -> UIViewController? {
        let storyboard = UIStoryboard(name: storyboardName, bundle: bundle)
        return viewController(fromStoryboard: storyboard, viewControllerIdentifier: viewControllerIdentifier, context: context, callback: callback)
    }

    public class func relayViewController(fromStoryboardName storyboardName: String, viewControllerIdentifier: String? = nil, bundle: Bundle? = nil, context: Any? = nil, anyCallback: Any? = nil) -> UIViewController? {
        let storyboard = UIStoryboard(name: storyboardName, bundle: bundle)
        return relayViewController(fromStoryboard: storyboard, viewControllerIdentifier: viewControllerIdentifier, context: context, anyCallback: anyCallback)
    }

    public class func viewController<A, R>(fromStoryboard storyboard: UIStoryboard, viewControllerIdentifier: String? = nil, context: Any? = nil, callback: @escaping ((A) -> R)) -> UIViewController? {
        return relayViewController(fromStoryboard: storyboard, viewControllerIdentifier: viewControllerIdentifier, context: context, anyCallback: callback as Any?)
    }

    public class func relayViewController(fromStoryboard storyboard: UIStoryboard, viewControllerIdentifier: String? = nil, context: Any? = nil, anyCallback: Any? = nil) -> UIViewController? {
        let viewController: UIViewController?
        if let viewControllerIdentifier = viewControllerIdentifier {
            viewController = storyboard.instantiateViewController(withIdentifier: viewControllerIdentifier)
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
            if let anyCallback = anyCallback {
                let context = Context(callback: anyCallback)
                viewController.configureCustomContext(forCallback: context)
            }
        }
        return viewController
    }

    @discardableResult public func sendContext(_ object1: Any?, _ object2: Any?, _ object3: Any? = nil, _ object4: Any? = nil, _ object5: Any? = nil) -> Context {
        return sendContext(toContext(object1, object2, object3, object4, object5))
    }

    @discardableResult public func sendContext(_ object: Any?) -> Context {
        let context = toContext(object)
        configureCustomContext(context)
        return context
    }

    fileprivate func configureCustomContext(_ customContext: Context) {
        let viewController = self
        viewController.customContext = customContext
        for viewController in viewController.childViewControllers {
            viewController.configureCustomContext(customContext)
        }
        switch viewController {
        case let navi as UINavigationController:
            if let viewController = navi.viewControllers.first {
                viewController.configureCustomContext(customContext)
            }
        case let tab as UITabBarController:
            if let viewControllers = tab.viewControllers {
                for viewController in viewControllers {
                    viewController.configureCustomContext(customContext)
                }
            }
        default:
            break
        }
    }

    fileprivate func configureCustomContext(forCallback customContextForCallback: Context) {
        let viewController = self
        viewController.customContextForCallback = customContextForCallback
        for viewController in viewController.childViewControllers {
            viewController.configureCustomContext(forCallback: customContextForCallback)
        }
        if let navi = viewController as? UINavigationController {
            if let viewController = navi.viewControllers.first {
                viewController.configureCustomContext(forCallback: customContextForCallback)
            }
        } else if let tab = viewController as? UITabBarController {
            if let viewControllers = tab.viewControllers {
                for viewController in viewControllers {
                    viewController.configureCustomContext(forCallback: customContextForCallback)
                }
            }
        }
    }

}

// MARK: - Swizzling

var SWCSwizzledAlready: UInt8 = 0

extension UIViewController {

    public func contextSender(forSegue segue: UIStoryboardSegue, callback: (String, UIViewController, (Any?) -> Void) -> Void) {
        if let segueIdentifier = segue.identifier {
            let viewController = segue.destination
            let sendContext: (Any?) -> Void = { context in
                let _ = viewController.sendContext(context)
            }
            callback(segueIdentifier, viewController, sendContext)
        }
    }

    class func replacePrepareForSegueIfNeeded() {
        if nil == objc_getAssociatedObject(self, &SWCSwizzledAlready) {
            objc_setAssociatedObject(self, &SWCSwizzledAlready, NSNumber(value: true), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            let original = class_getInstanceMethod(self, #selector(prepare(for:sender:)))
            let replaced = class_getInstanceMethod(self, #selector(swc_wrapped_prepareForSegue(_:sender:)))
            method_exchangeImplementations(original, replaced)
        }
    }

    class func revertReplacedPrepareForSegueIfNeeded() {
        if nil != objc_getAssociatedObject(self, &SWCSwizzledAlready) {
            objc_setAssociatedObject(self, &SWCSwizzledAlready, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            let original = class_getInstanceMethod(self, #selector(prepare(for:sender:)))
            let replaced = class_getInstanceMethod(self, #selector(swc_wrapped_prepareForSegue(_:sender:)))
            method_exchangeImplementations(original, replaced)
        }
    }

    func replacePrepareForSegueIfNeeded() {
        type(of: self).replacePrepareForSegueIfNeeded()
    }

    func revertReplacedPrepareForSegueIfNeeded() {
        type(of: self).revertReplacedPrepareForSegueIfNeeded()
    }

    func swc_wrapped_prepareForSegue(_ segue: UIStoryboardSegue, sender: AnyObject?) {
        swc_wrapped_prepareForSegue(segue, sender: sender)
        swc_prepareForSegue(segue, sender: sender)

        revertReplacedPrepareForSegueIfNeeded()
    }

    func swc_prepareForSegue(_ segue: UIStoryboardSegue, sender: AnyObject?) {
        let destination = segue.destination
        let source = segue.source
        if let customContext = source.sendCustomContext {
            if let targetIdentifier = customContext.segueIdentifier, targetIdentifier != segue.identifier {
                return
            }

            destination.configureCustomContext(customContext)
            source.sendCustomContext = nil
        }
        if let customContextForCallback = source.sendCustomContextForCallback {
            if let targetIdentifier = customContextForCallback.segueIdentifier, targetIdentifier != segue.identifier {
                return
            }

            destination.configureCustomContext(forCallback: customContextForCallback)
            source.sendCustomContextForCallback = nil
        }
    }

}
