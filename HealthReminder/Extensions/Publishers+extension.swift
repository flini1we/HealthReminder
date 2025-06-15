import Combine
import Foundation
import SwiftUI

extension Publishers {
    
    static var keyboardHeight: AnyPublisher<CGFloat, Never> {
        
        let willShow = NotificationCenter
            .default
            .publisher(
                for: UIApplication.keyboardWillShowNotification
            )
            .map {
                $0.keyboardHeight
            }
        
        let willHide = NotificationCenter
            .default
            .publisher(
                for: UIApplication.keyboardWillHideNotification
            )
            .map {
                _ in CGFloat(0)
            }
        
        return MergeMany(willShow, willHide)
            .eraseToAnyPublisher()
    }
}
