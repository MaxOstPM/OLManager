//
//  OverlayWindowRootViewController.swift
//  ViewsManager
//
//  Created by Максим Остапчук on 1/29/19.
//  Copyright © 2019 Максим Остапчук. All rights reserved.
//

import UIKit

final class OverlayWindowRootViewController: UIViewController {
    
    var globalOverlaysContainerView: UIView?
    var localOverlaysContainerView: UIView?

    override func viewDidLoad() {
        super.viewDidLoad()

        addGlobalOverlaysContainerView()
        addLocalOverlaysContainerView()
    }
    
    // MARK: - OverlayContainerViewsSetup
    private func addGlobalOverlaysContainerView() {
        globalOverlaysContainerView = makeAndAddOnSuperviewDefaultOverlayContainer()
    }
    
    private func addLocalOverlaysContainerView() {
        localOverlaysContainerView = makeAndAddOnSuperviewDefaultOverlayContainer()
        localOverlaysContainerView?.backgroundColor = UIColor.blue.withAlphaComponent(0.3)
    }
    
    private func makeAndAddOnSuperviewDefaultOverlayContainer() -> UIView {
        let containerView = UIView(frame: self.view.frame)
        containerView.clipsToBounds = true
        self.view.addSubview(containerView)
        
        return containerView
    }
}

// MARK: - SetupingFrameForOverlaysContainers
extension OverlayWindowRootViewController {
    
    func applyAvailableRegion(_ region: CGRect, for level: OverlayLevel) {
        
        let viewToApply: UIView? = level == .local ? localOverlaysContainerView : globalOverlaysContainerView
        
        viewToApply?.frame = region
        viewToApply?.layoutIfNeeded()
    }
}

// MARK: - OverlayWindowAvailableRegionGetter
extension OverlayWindowRootViewController: OverlayWindowAvailableRegionGetter {
    
    func getAvailableRegionFor(overlayLevel: OverlayLevel) -> CGRect {
        switch overlayLevel {
            
        case .local:
            return localOverlaysContainerView?.frame ?? CGRect.zero
            
        case .global:
            return globalOverlaysContainerView?.frame ?? CGRect.zero
        }
    }
}

// MARK: - ExistedOverlayManagable
extension OverlayWindowRootViewController: ExistedOverlayManagable {
    
    func addNewOverlayWith(animationPerformer: AnimationPerformer) {
        let newOverlay = animationPerformer.overlay
        
        if !animationPerformers.contains(where: { return $0.overlay == newOverlay }) {
            animationPerformers.append(animationPerformer)
        }
        if newOverlay.superview == nil {
            view.addSubview(newOverlay)
        }
    }
    
    func removeOverlayWith(animationPerformer: AnimationPerformer) {
        let overlayToRemove = animationPerformer.overlay
        
        overlayToRemove.removeFromSuperview()
        animationPerformers = animationPerformers.filter({ return $0.overlay != overlayToRemove })
    }
}
