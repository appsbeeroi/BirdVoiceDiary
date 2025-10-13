import UIKit

extension UIScreen {
    static var isSE: Bool {
        main.bounds.height < 700
    }
}
