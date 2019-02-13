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
