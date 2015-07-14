SegueContext
==================

You can pass the context to destination view controller easily.

## Do you have no complaints on the view controller transition now?

```swift
override func prepareForSegue(segue: UIStoryboardSegue, sender sender: AnyObject?) {
    switch segue.identifier {
    case "Next":
        if let nextViewController = segue.destinationViewController as? NextViewController {
            nextViewController.value = 10
        }
    case "Navi":
        if let navigationController = segue.destinationViewController as? UINavigationController {
            if let nextViewController = navigationController.viewControllers.first as? NextViewController {
              nextViewController.value = 20
            }
        }
    default:
        break
    }
}
```

- Tight coupling!
- That's a bother...

**SegueContext will solve these problems!**

## Simple Usage

All you need to pass the values when the timing of the view controller transition.


- Source View Controller

```swift
self.performSegueWithIdentifier("Next", context: 10)
```

-  Destination View Controller

```swift
if let value: Int = self.contextValue() {
    self.value = value
}
```
