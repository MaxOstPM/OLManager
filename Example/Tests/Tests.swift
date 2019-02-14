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
    
    var overlayManager: OverlayManagerOf<OverlayFactoryImp> {
        let factory = OverlayFactoryImp()
        return OverlayManagerOf<OverlayFactoryImp>(factory: factory)
    }
}

final class TestClass: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @objc override var overlayInsets: UIEdgeInsets {
        let navBarY = self.navigationController?.navigationBar.frame.origin.y ?? 0.0
        let navBarHeight = self.navigationController?.navigationBar.frame.size.height ?? 0.0
        let tabBarHeight = self.tabBarController?.tabBar.frame.size.height ?? 0.0
        
        return UIEdgeInsets(top: navBarY + navBarHeight, left: 0.0, bottom: tabBarHeight, right: 0.0)
    }
}
