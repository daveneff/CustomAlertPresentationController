//
//  CustomAlertAnimations.swift
//
//  Created by Dave Neff
//

import UIKit

// MARK: - Presentation

final class CustomAlertPresentationAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    
    private let duration: TimeInterval = 0.15
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toController = transitionContext.viewController(forKey: .to),
            let toView = toController.view else { fatalError("Failed to retrieve toController") }
        
        transitionContext.containerView.addSubview(toView)
        
        UIView.animate(
            withDuration: duration,
            animations: {
                /*   Presentation animation itself is handled in PresentationController
                 //  This UIView.animate method must be invoked for two reasons:
                 //  1. Determines the duration of animation
                 //  2. Tell the transitionContext that the transition has completed  */
        },
            completion: { didComplete in
                transitionContext.completeTransition(didComplete)
        })
        
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
}

// MARK: - Dismissal

final class CustomAlertDismissalAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    
    private let duration: TimeInterval = 0.2
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromController = transitionContext.viewController(forKey: .from),
            let fromView = fromController.view else { fatalError("Failed to retrieve fromController") }
        
        UIView.animate(
            withDuration: duration,
            animations: {
                fromView.alpha = 0.0
        },
            completion: { didComplete in
                fromView.removeFromSuperview()
                transitionContext.completeTransition(didComplete)
        })
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
}
