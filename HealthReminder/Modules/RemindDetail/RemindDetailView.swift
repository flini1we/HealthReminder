import SwiftUI

struct RemindDetailView: View {
    let remind: Remind
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
                    .opacity(animate ? 1 : 0)
                    .animation(.easeInOut(duration: 0.5).delay(0.1), value: animate)

                VStack(spacing: .Padding.normal) {
                    animatedInfoRow(
                        icon: .titleImage,
                        title: .titleTitle,
                        value: remind.title,
                        delay: 0.2
                    )
                    animatedInfoRow(
                        icon: .priorityImage,
                        title: .priorityTitle,
                        value: remind.priority.rawValue,
                        delay: 0.3
                    )
                    animatedInfoRow(
                        icon: .notificationImage,
                        title: .notificationTitle,
                        value: "\(remind.notificationInterval) hour\(remind.getTail())",
                        delay: 0.4
                    )
                    animatedInfoRow(
                        icon: .calendarImage,
                        title: .calendarTitle,
                        value: remind.createdAt,
                        delay: 0.5
                    )
                }
                .padding(.horizontal)
                .padding(.top, .Padding.semiSmall)

                Spacer()
            }
            .padding(.top, .Padding.huge)
            .onAppear {
                animate = true
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
        .opacity(animate ? 1 : 0)
        .animation(.spring(response: 0.6, dampingFraction: 0.75).delay(delay), value: animate)
    }
}


private extension String {
    
    static let titleImage = "textformat"
    static let priorityImage = "flag.fill"
    static let notificationImage = "bell.fill"
    static let calendarImage = "calendar"
    static let titleTitle = "Title"
    static let priorityTitle = "Priority"
    static let notificationTitle = "Interval"
    static let calendarTitle = "Created"
}
