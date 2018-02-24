# CustomAlertPresentationController

**CustomAlertPresentationController** is a `UIPresentationController` which mimics iOS' native `UIAlertController` presentation, modal display, and dismissal. It is written in Swift 4.

It can be used to present any `UIViewController` in the same style as an iOS alert.

## Example Usage
```swift
final class ViewController: UIViewController {

	let transitioningManager = CustomAlertTransitioningManager()

	// ... 

	func displayCustomAlert() {
		let customAlertController = CustomAlertController()
        customAlertController.transitioningDelegate = addCameraTransitioningManager
        customAlertController.modalPresentationStyle = .custom
        present(customAlertController, animated: true)
	}

}

```