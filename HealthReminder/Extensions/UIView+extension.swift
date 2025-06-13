import UIKit

enum Edges {
    case top, bottom, leading, trailing
}

extension UIView {
    
    func pinEdges(inset: CGFloat = 0) {
        guard let superView = self.superview else { return }
        
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: superView.safeAreaLayoutGuide.topAnchor, constant: inset),
            bottomAnchor.constraint(equalTo: superView.safeAreaLayoutGuide.bottomAnchor, constant: -inset),
            leadingAnchor.constraint(equalTo: superView.safeAreaLayoutGuide.leadingAnchor, constant: inset),
            trailingAnchor.constraint(equalTo: superView.safeAreaLayoutGuide.trailingAnchor, constant: -inset)
        ])
    }
    
    func pinEdges(inset: CGFloat, for edges: [Edges]) {
        guard let superView = self.superview else { return }
        
        NSLayoutConstraint.activate([
            topAnchor.constraint(
                equalTo: superView.safeAreaLayoutGuide.topAnchor,
                constant: edges.contains(.top) ? inset : 0
            ),
            bottomAnchor.constraint(
                equalTo: superView.safeAreaLayoutGuide.bottomAnchor,
                constant: edges.contains(.bottom) ? -inset : 0
            ),
            leadingAnchor.constraint(
                equalTo: superView.safeAreaLayoutGuide.leadingAnchor,
                constant: edges.contains(.leading) ? inset : 0
            ),
            trailingAnchor.constraint(
                equalTo: superView.safeAreaLayoutGuide.trailingAnchor,
                constant: edges.contains(.trailing) ? -inset : 0
            )
        ])
    }
    
    func autoLayout() -> Self {
        translatesAutoresizingMaskIntoConstraints = false
        return self
    }
    
    func addShadow(
        color: UIColor = .label,
        opacity: Float = 0.25,
        offset: CGSize = CGSize(width: 0, height: 2),
        radius: CGFloat = 3,
        shouldRasterize: Bool = false
    ) {
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offset
        layer.shadowRadius = radius
        layer.shouldRasterize = shouldRasterize
        layer.rasterizationScale = UIScreen.main.scale
    }
    
    func addGlow(
        color: UIColor,
        radius: CGFloat = 10,
        opacity: Float = 0.8
    ) {
        layer.shadowColor = color.cgColor
        layer.shadowOffset = .zero
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
        layer.masksToBounds = false
    }
    
    func removeGlow() {
        layer.shadowColor = nil
        layer.shadowOffset = .zero
        layer.shadowRadius = 0
        layer.shadowOpacity = 0
    }
}
