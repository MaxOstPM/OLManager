import OLManager
import UIKit

// MARK: - OverlayFlowSetup
enum OverlayViewType: OverlayLevelHolder {
    
    var level: OverlayLevel {
        return .local
    }
    
    case greenTest
    case blackTest
    case redTest
}

final class OverlayFactoryImp: OverlayFactory {
    
    typealias EnumType = OverlayViewType
    
    func makeOverlayWith(type: OverlayViewType) -> UIView {
        let testOverlay: UIView = UIView()
        
        var color: UIColor
        
        switch type {
        case .greenTest:
            color = .green
            
        case .blackTest:
            color = .black
            
        case .redTest:
            color = .red
        }
        
        testOverlay.backgroundColor = color.withAlphaComponent(0.5)
        return testOverlay
    }
}

final class OverlayManagerProvider {
    
    static let provider = OverlayManagerProvider()
    var overlayManager: OverlayManagerOf<OverlayFactoryImp>
    
    init() {
        let factory = OverlayFactoryImp()
        self.overlayManager = OverlayManagerOf<OverlayFactoryImp>(factory: factory)
    }
}

// MARK: - TestViewController
final class ViewController: UIViewController {
    
    let overlayManager = OverlayManagerProvider.provider.overlayManager
    var overlayManageable: OverlayManageable?
    
    override var localOverlayInsets: UIEdgeInsets {
        let navBarY = self.navigationController?.navigationBar.frame.origin.y ?? 0.0
        let navBarHeight = self.navigationController?.navigationBar.frame.size.height ?? 0.0
        let tabBarHeight = self.tabBarController?.tabBar.frame.size.height ?? 0.0
        
        return UIEdgeInsets(top: navBarY + navBarHeight * 2, left: 0.0, bottom: tabBarHeight, right: 0.0)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        overlayManager.viewControllerBecomeActive(self)
    }
    
    // MARK: - UserInteraction
    @IBAction func testButtonAction(_ sender: Any) {
        let location = PinningLocation(horizontalEdge: .left, verticalEdge: .top)
        let config = OverlayDisplayConfiguration(animationType: .slide, pinningLocation: location)
        overlayManageable = overlayManager.displayOverlay(OverlayViewType.greenTest, configuration: config)
    }
}
