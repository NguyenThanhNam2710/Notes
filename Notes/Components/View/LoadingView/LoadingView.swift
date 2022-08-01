
import UIKit

class LoadingView: UIView {
    
    @IBOutlet weak var indicatorView: UIActivityIndicatorView! {
        didSet {
            if #available(iOS 13.0, *) {
                indicatorView.style = .large
            } else {
                indicatorView.style = .whiteLarge
            }
        }
    }
    @IBOutlet weak var loadingView: UIView! {
        didSet {
            loadingView.layer.cornerRadius = 16
        }
    }
    class func instance() -> LoadingView {
        return Bundle.main.loadView(with: LoadingView.self)
    }
    
    func show(in view: UIView?) {
        if let containerView = view {
            containerView.addSubview(self)
            self.snp.makeConstraints { maker in
                maker.top.bottom.leading.trailing.equalToSuperview()
            }
        } else if let containerView = UIApplication.shared.windows.last {
            containerView.addSubview(self)
            self.snp.makeConstraints { maker in
                maker.top.bottom.leading.trailing.equalToSuperview()
            }
        }
    }
    
    func dismiss() {
        self.removeFromSuperview()
    }
}
