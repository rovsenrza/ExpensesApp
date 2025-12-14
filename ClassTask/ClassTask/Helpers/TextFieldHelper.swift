import Foundation
import UIKit

final class InsetTextField: UITextField {
    let inset = UIEdgeInsets(top: 16, left: 8, bottom: 16, right: 8)

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: inset)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: inset)
    }

    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: inset)
    }
}
