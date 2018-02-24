//
//  CustomAlertPresentationController.swift
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

final class CustomAlertPresentationController: UIPresentationController {
    
    private lazy var dimmingView = UIView()
    
    override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerView = containerView else { fatalError("containerView is nil") }
        
        let containerViewBounds = containerView.bounds
        
        var presentedViewFrame: CGRect = .zero
        
        presentedViewFrame.size = size(forChildContentContainer: presentedViewController,
                                       withParentContainerSize: containerViewBounds.size)
        presentedViewFrame.origin.x = (containerViewBounds.size.width - presentedViewFrame.size.width) / 2
        presentedViewFrame.origin.y = (containerViewBounds.size.height - presentedViewFrame.size.height) / 2
        
        return presentedViewFrame
    }
    
    override init(presentedViewController: UIViewController,
                  presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        configureDimmingView()
    }
    
    override func containerViewWillLayoutSubviews() {
        guard let containerView = containerView else { return }
        presentedView?.frame = frameOfPresentedViewInContainerView
        dimmingView.frame = containerView.bounds
    }
    
    override func size(forChildContentContainer container: UIContentContainer, withParentContainerSize parentSize: CGSize) -> CGSize {
        return CGSize(width: parentSize.width * 0.725, height: parentSize.width * 0.891)
    }
    
}

// MARK: - Presentation Animation

extension CustomAlertPresentationController {
    
    override func presentationTransitionWillBegin() {
        guard let containerView = containerView,
            let transitionCoordinator = presentedViewController.transitionCoordinator,
            let presentedView = presentedView else { fatalError("One of the required views are nil") }
        
        // Dimming view - initial frame
        containerView.insertSubview(dimmingView, at: 0)
        dimmingView.frame = containerView.bounds
        dimmingView.alpha = 0.0
        
        // Presented view - initial frame
        presentedView.layer.cornerRadius = Constants.cornerRadius
        presentedView.frame = frameOfPresentedViewInContainerView
        
        // Snapshot of presented view for CGAffine animation
        guard let presentedSnapshotView = presentedView.snapshotView(afterScreenUpdates: true) else { return }
        containerView.addSubview(presentedSnapshotView)
        presentedSnapshotView.frame = frameOfPresentedViewInContainerView
        presentedSnapshotView.transform = CGAffineTransform(scaleX: 1.15, y: 1.15)
        presentedSnapshotView.alpha = 0

        presentedView.alpha = 0
        
        transitionCoordinator.animate(
            alongsideTransition: { _ in
                self.dimmingView.alpha = 1.0
                presentedSnapshotView.transform = .identity
                presentedSnapshotView.alpha = 1
        },
            completion: { _ in
                presentedView.alpha = 1.0
                presentedSnapshotView.removeFromSuperview()
        })
    }
}

// MARK: - Dismissal Animation

extension CustomAlertPresentationController {
    
    override func dismissalTransitionWillBegin() {
        guard let transitionCoordinator = presentedViewController.transitionCoordinator else { fatalError("coordinator is nil") }
        
        transitionCoordinator.animate(
            alongsideTransition: { _ in
                self.dimmingView.alpha = 0.0
        },
            completion: { _ in
                self.dimmingView.removeFromSuperview()
        })
    }
    
}

// MARK: - Dimming View configuration

extension CustomAlertPresentationController {
    
    private func configureDimmingView() {
        dimmingView.backgroundColor = UIColor(white: 0.0, alpha: 0.50)
        dimmingView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onDimmingViewTapped)))
    }
    
    @objc func onDimmingViewTapped() {
        presentedViewController.view.endEditing(true)
    }
    
}
