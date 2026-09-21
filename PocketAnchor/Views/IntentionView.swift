import SwiftUI

struct IntentionView: View {
    let onActivate: (OutingDuration) -> Void

    @State private var selected: OutingDuration = .block
    @State private var atmosphericLine: String = SensoryPromptBank.randomSeed().seed

    var body: some View {
        ZStack {
            Theme.paper.ignoresSafeArea()

            VStack(alignment: .leading, spacing: 28) {
                Spacer()

                VStack(alignment: .leading, spacing: 10) {
                    Text("You don't have to go far.")
                        .font(.system(size: 28, weight: .medium, design: .serif))
                        .foregroundStyle(Theme.charcoal)

                    Text(atmosphericLine)
                        .font(.system(size: 15))
                        .foregroundStyle(Theme.softInk)
                }

                VStack(alignment: .leading, spacing: 12) {
                    ForEach(OutingDuration.allCases) { duration in
                        DurationRow(duration: duration, isSelected: duration == selected) {
                            selected = duration
                        }
                    }
                }

                Spacer()

                VStack(spacing: 8) {
                    Button {
                        onActivate(selected)
                    } label: {
                        Text("Activate Pocket Anchor")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundStyle(Theme.paper)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Theme.forest)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                    }

                    Text("We'll keep time. You enjoy the air.")
                        .font(.system(size: 12))
                        .foregroundStyle(Theme.softInk)

                    Text("Nothing leaves your phone.")
                        .font(.system(size: 11))
                        .foregroundStyle(Theme.softInk.opacity(0.7))
                }
            }
            .padding(24)
        }
    }
}

private struct DurationRow: View {
    let duration: OutingDuration
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(duration.label)
                        .font(.system(size: 15, weight: .medium))
                    Text(duration.subtitle)
                        .font(.system(size: 12))
                        .foregroundStyle(Theme.softInk)
                }
                Spacer()
                Circle()
                    .strokeBorder(isSelected ? Theme.forest : Theme.stone, lineWidth: isSelected ? 6 : 1)
                    .frame(width: 18, height: 18)
            }
            .padding(14)
            .background(isSelected ? Theme.moss.opacity(0.25) : Color.clear)
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(Theme.stone.opacity(0.4), lineWidth: 0.5)
            )
        }
        .foregroundStyle(Theme.charcoal)
        .buttonStyle(.plain)
    }
}

#Preview {
    IntentionView(onActivate: { _ in })
}
