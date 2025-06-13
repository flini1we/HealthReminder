import SwiftUI

struct remindTitleTextFieldModifier: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .padding()
            .background(
                RoundedRectangle(
                    cornerRadius: .Padding.normal,
                    style: .continuous
                )
                .fill(Color(.systemGray6))
                .shadow(color: .black.opacity(0.05), radius: .Padding.small, x: 0, y: 2)
            )
            .overlay(
                RoundedRectangle(
                    cornerRadius: .Padding.normal,
                    style: .continuous
                )
                .stroke(.clear, lineWidth: 2)
            )
            .font(.system(size: .Fonts.normal, weight: .medium))
            .foregroundColor(.primary)
    }
}
