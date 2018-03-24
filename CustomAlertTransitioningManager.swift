//
//  CustomAlertTransitioningManager.swift
//
//  Created by Dave Neff
//

import UIKit

// MARK: - Transitioning delegate

final class CustomAlertTransitioningManager: NSObject, UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController,
                             presenting: UIViewController,
                             source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CustomAlertPresentationAnimation()
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CustomAlertDismissalAnimation()
    }
    
    func presentationController(forPresented presented: UIViewController,
                                presenting: UIViewController?,
                                source: UIViewController) -> UIPresentationController? {
        return CustomAlertPresentationController(presentedViewController: presented,
                                      presenting: presenting)
    }
    
}
