import SwiftUI

struct IntentionView: View {
    let onActivate: (OutingDuration) -> Void

    @State private var selected: OutingDuration = .block
    @State private var atmosphericLine: String = SensoryPromptBank.randomSeed()
    @State private var showingAbout = false

    var body: some View {
        ZStack {
            Theme.paper.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 22) {
                HStack(spacing: 10) {
                    BrandMark()
                        .frame(width: 28, height: 28)
                    Text("POCKET ANCHOR")
                        .font(.system(size: 13, weight: .medium))
                        .tracking(2)
                        .foregroundStyle(Theme.charcoal)
                }
                .padding(.top, 12)

                VStack(alignment: .leading, spacing: 10) {
                    Text("You don't have to go far.")
                        .font(.system(size: 28, weight: .medium, design: .serif))
                        .foregroundStyle(Theme.charcoal)

                    Text(atmosphericLine)
                        .font(.system(size: 15))
                        .foregroundStyle(Theme.softInk)
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(.top, 12)

                VStack(alignment: .leading, spacing: 12) {
                    ForEach(OutingDuration.allCases) { duration in
                        DurationRow(duration: duration, isSelected: duration == selected) {
                            selected = duration
                        }
                    }
                }

                VStack(alignment: .leading, spacing: 6) {
                    Text("What happens next")
                        .font(.system(size: 11, weight: .medium))
                        .foregroundStyle(Theme.softInk)
                    Text("Your screen will turn dark and quiet — that's meant to happen, nothing's wrong. When you're back, just tap \"I'm back\" to return.")
                        .font(.system(size: 13))
                        .foregroundStyle(Theme.charcoal)
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(14)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Theme.moss.opacity(0.15))
                .clipShape(RoundedRectangle(cornerRadius: 14))

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

                    Button {
                        showingAbout = true
                    } label: {
                        Text("About")
                            .font(.system(size: 11))
                            .foregroundStyle(Theme.softInk.opacity(0.7))
                            .underline()
                            .frame(minWidth: 44, minHeight: 44)
                    }
                    .contentShape(Rectangle())
                }
                }
                .padding(24)
            }
        }
        .sheet(isPresented: $showingAbout) {
            AboutView()
        }
    }
}

private struct AboutView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            Theme.paper.ignoresSafeArea()

            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    Spacer()
                    Button {
                        dismiss()
                    } label: {
                        Text("Done")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundStyle(Theme.forest)
                    }
                }

                Spacer()

                HStack(spacing: 10) {
                    BrandMark()
                        .frame(width: 30, height: 30)
                    Text("Pocket Anchor")
                        .font(.system(size: 20, weight: .medium, design: .serif))
                        .foregroundStyle(Theme.charcoal)
                }

                Text("Every doorway leads somewhere.")
                    .font(.system(size: 13))
                    .italic()
                    .foregroundStyle(Theme.softInk)

                Text("Part of the Life Forecast family of calm, private, local-only tools — from the maker of EchoSink and Downstep.")
                    .font(.system(size: 14))
                    .foregroundStyle(Theme.softInk)
                    .fixedSize(horizontal: false, vertical: true)

                Text("No accounts. No ads. No streaks. Your data never leaves this device.")
                    .font(.system(size: 12))
                    .foregroundStyle(Theme.softInk.opacity(0.8))
                    .fixedSize(horizontal: false, vertical: true)

                Spacer()
                Spacer()
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
                    if duration == .doorway {
                        Text("Some days, the doorway is the whole thing.")
                            .font(.system(size: 11))
                            .italic()
                            .foregroundStyle(Theme.softInk.opacity(0.8))
                            .padding(.top, 2)
                    }
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

private struct BrandMark: View {
    var body: some View {
        Canvas { context, size in
            let w = size.width
            let h = size.height

            var doorPath = Path()
            doorPath.move(to: CGPoint(x: w * 0.30, y: h * 0.80))
            doorPath.addLine(to: CGPoint(x: w * 0.30, y: h * 0.46))
            doorPath.addQuadCurve(to: CGPoint(x: w * 0.70, y: h * 0.46), control: CGPoint(x: w * 0.5, y: h * 0.22))
            doorPath.addLine(to: CGPoint(x: w * 0.70, y: h * 0.80))

            context.stroke(doorPath, with: .color(Theme.forest), style: StrokeStyle(lineWidth: w * 0.09, lineCap: .round, lineJoin: .round))

            let dotRect = CGRect(x: w * 0.5 - w * 0.11, y: h * 0.56 - w * 0.11, width: w * 0.22, height: w * 0.22)
            context.fill(Path(ellipseIn: dotRect), with: .color(Theme.clay))
        }
    }
}

#Preview {
    IntentionView(onActivate: { _ in })
}
