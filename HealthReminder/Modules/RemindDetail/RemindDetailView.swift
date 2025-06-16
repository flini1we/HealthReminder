import SwiftUI

struct RemindDetailView: View {
    let remind: Remind
    var usingAnimation: Bool
    @State private var animate = false

    var body: some View {
        ZStack(alignment: .center) {
            Color.white
                .ignoresSafeArea()

            VStack(spacing: .Padding.semiMidium) {
                
                Image(systemName: remind.category.systemIcon)
                    .font(.system(size: .Padding.huge, weight: .semibold))
                    .foregroundStyle(.blue)
                    .symbolEffect(.bounce.up.byLayer, value: animate)

                Text(remind.category.displayName)
                    .font(.largeTitle.bold())
                    .transition(.opacity)
                    .opacity(usingAnimation ? animate ? 1 : 0 : 1)
                    .animation(.easeInOut(duration: usingAnimation ? 0.5 : 0).delay(usingAnimation ? 0.1 : 0), value: animate)

                VStack(spacing: .Padding.normal) {
                    animatedInfoRow(
                        icon: .titleImage,
                        title: .titleTitle,
                        value: remind.title,
                        delay: usingAnimation ? 0.2 : 0
                    )
                    animatedInfoRow(
                        icon: .priorityImage,
                        title: .priorityTitle,
                        value: remind.priority.rawValue,
                        delay: usingAnimation ? 0.3 : 0
                    )
                    animatedInfoRow(
                        icon: .notificationImage,
                        title: .notificationTitle,
                        value: "\(remind.notificationInterval) hour\(remind.getTail())",
                        delay: usingAnimation ? 0.4 : 0
                    )
                    animatedInfoRow(
                        icon: .calendarImage,
                        title: .calendarTitle,
                        value: DateFormatter.standard.formatRelative(remind.createdAt),
                        delay: usingAnimation ? 0.5 : 0
                    )
                }
                .padding(.horizontal)
                .padding(.top, .Padding.semiSmall)

                Spacer()
            }
            .padding(.top, .Padding.huge)
            .onAppear {
                if usingAnimation {
                    animate = true
                }
            }
        }
    }

    @ViewBuilder
    private func animatedInfoRow(
        icon: String,
        title: String,
        value: String,
        delay: Double
    ) -> some View {
        HStack(spacing: .Padding.semiSmall) {
            ZStack {
                RoundedRectangle(cornerRadius: .Padding.small)
                    .fill(.blue.opacity(0.15))
                    .frame(width: .Padding.big, height: .Padding.big)
                
                Image(systemName: icon)
                    .foregroundColor(.blue)
                    .font(.system(size: .Padding.normal, weight: .semibold))
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text(value)
                    .font(.body.weight(.medium))
                    .foregroundColor(.primary)
            }

            Spacer()
        }
        .padding()
        .background(
            .ultraThinMaterial,
            in: RoundedRectangle(cornerRadius: .Padding.normal)
        )
        .shadow(color: .black.opacity(0.1), radius: .Padding.tiny, x: 2, y: 2)
        .offset(y: animate ? 0 : 20)
        .opacity(usingAnimation ? animate ? 1 : 0 : 1)
        .animation(.spring(response: 0.6, dampingFraction: 0.75).delay(usingAnimation ? delay : 0), value: animate)
    }
}


private extension String {
    
    static let titleImage = "textformat"
    static let priorityImage = "flag.fill"
    static let notificationImage = "bell.and.waves.left.and.right"
    static let calendarImage = "calendar"
    static let titleTitle = "Title"
    static let priorityTitle = "Priority"
    static let notificationTitle = "Interval"
    static let calendarTitle = "Created"
}
