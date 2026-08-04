import Combine
import UIKit

// MARK: - UITextField
public extension UITextField {
    /// 文本内容（用户编辑与代码赋值均会发出，订阅时立即重放当前值）。
    var dy_textPublisher: ControlProperty<String?> {
        ControlProperty(
            values: publisher(for: \.text, options: [.initial, .new]).eraseToAnyPublisher(),
            setter: { self.text = $0 }
        )
    }

    /// 富文本内容（可读当前值、可绑定写回）。
    var dy_attributedTextPublisher: ControlProperty<NSAttributedString?> {
        ControlProperty(
            values: publisher(for: \.attributedText, options: [.initial, .new]).eraseToAnyPublisher(),
            setter: { self.attributedText = $0 }
        )
    }
}
