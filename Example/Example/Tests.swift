import OLManager

enum Overlays {
    case provideStatistic
    case paidSocialFailure
}

final class OverlayFactoryImp: OverlayFactory {
    
    func makeOverlayWith(type: Overlays) -> UIView {
        return UIView()
    }
}

final class OverlayManagerProvider {
    
    static let provider = OverlayManagerProvider()
    
    var overlayManager: OverlayManagerOf<OverlayFactoryImp>
    
    init() {
        let factory = OverlayFactoryImp()
        overlayManager = OverlayManagerOf<OverlayFactoryImp>(factory: factory)
    }
}

final class TestClass: UIViewController {
    
    let overlayManager = OverlayManagerProvider.provider.overlayManager
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let configuration = OverlayDisplayConfiguration(pinToEdge: .top, animationType: .none)
        let remover = overlayManager.displayOverlay(.paidSocialFailure, configuration: configuration)
    }
    
    @objc override var overlayInsets: UIEdgeInsets {
        let navBarY = self.navigationController?.navigationBar.frame.origin.y ?? 0.0
        let navBarHeight = self.navigationController?.navigationBar.frame.size.height ?? 0.0
        let tabBarHeight = self.tabBarController?.tabBar.frame.size.height ?? 0.0
        
        return UIEdgeInsets(top: navBarY + navBarHeight, left: 0.0, bottom: tabBarHeight, right: 0.0)
    }
}
