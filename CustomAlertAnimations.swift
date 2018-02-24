//
//  CustomAlertAnimations.swift
//
//  Created by Dave Neff.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

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
