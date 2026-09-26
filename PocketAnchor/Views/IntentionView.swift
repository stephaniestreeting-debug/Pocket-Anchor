import SwiftUI
import UserNotifications

struct IntentionView: View {
    let onActivate: (OutingDuration) -> Void

    @State private var selected: OutingDuration = .block
    @State private var selectedCategory: NoticeCategory?
    @State private var chosenNotice: String?
    @State private var noticeQueue: [String] = []
    @State private var showingAbout = false
    @State private var notificationsDenied = false

    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    init(onActivate: @escaping (OutingDuration) -> Void) {
        self.onActivate = onActivate
    }

    /// Reveals the next notice for a category: cycles through all of that
    /// category's items in shuffled order before any repeat, rather than
    /// picking independently at random each time (which could repeat an
    /// item or skip others entirely across several taps).
    private func revealNotice(for category: NoticeCategory) {
        if selectedCategory != category {
            selectedCategory = category
            noticeQueue = category.items.shuffled()
        }
        if noticeQueue.isEmpty {
            noticeQueue = category.items.shuffled()
        }
        chosenNotice = noticeQueue.removeFirst()
    }

    private func categoryPill(_ category: NoticeCategory) -> some View {
        Button {
            withAnimation(.easeInOut(duration: 0.2)) {
                revealNotice(for: category)
            }
        } label: {
            Text(category.label)
                .font(.scalable(12))
                .foregroundStyle(selectedCategory == category ? Theme.cream : Theme.charcoal)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 7)
                .background(selectedCategory == category ? Theme.forest : Theme.moss.opacity(0.15))
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .buttonStyle(.plain)
        .accessibilityAddTraits(selectedCategory == category ? [.isButton, .isSelected] : .isButton)
    }

    var body: some View {
        ZStack {
            Theme.paper.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                HStack(spacing: 10) {
                    BrandMark()
                        .frame(width: 26, height: 26)
                        .accessibilityHidden(true)
                    Text("POCKET ANCHOR")
                        .font(.scalable(13, weight: .medium))
                        .tracking(2)
                        .foregroundStyle(Theme.charcoal)
                }
                .padding(.top, 8)
                .accessibilityElement(children: .combine)

                Text("You don't have to go far.")
                    .font(.scalable(26, weight: .medium, design: .serif))
                    .foregroundStyle(Theme.charcoal)

                VStack(alignment: .leading, spacing: 10) {
                    ForEach(OutingDuration.allCases) { duration in
                        DurationRow(duration: duration, isSelected: duration == selected) {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                selected = duration
                            }
                        }
                    }
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Optional: choose something to notice, then look for it. Selective attention does the rest.")
                        .font(.scalable(13))
                        .foregroundStyle(Theme.softInk)
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: true)

                    if dynamicTypeSize.isAccessibilitySize {
                        // At large accessibility text sizes, four across a
                        // row leaves too little width per pill and words
                        // like "Texture" break mid-word. A single column
                        // gives each label the full row to wrap on word
                        // boundaries instead.
                        VStack(spacing: 8) {
                            ForEach(NoticeCategory.allCases) { category in
                                categoryPill(category)
                            }
                        }
                    } else {
                        HStack(spacing: 8) {
                            ForEach(NoticeCategory.allCases) { category in
                                categoryPill(category)
                            }
                        }
                    }

                    if let chosenNotice {
                        Text(chosenNotice)
                            .font(.scalable(14))
                            .italic()
                            .foregroundStyle(Theme.softInk)
                            .lineLimit(nil)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.top, 2)
                    }
                }

                VStack(alignment: .leading, spacing: 5) {
                    Text("What happens next")
                        .font(.scalable(11, weight: .medium))
                        .foregroundStyle(Theme.softInk)
                    Text("Your screen will turn dark and quiet — that's meant to happen, nothing's wrong. If notifications are on, you'll hear a soft sound at the halfway point — no need to do anything. When you're back, just tap \"I'm back\" to return.")
                        .font(.scalable(12))
                        .foregroundStyle(Theme.charcoal)
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: true)
                    if notificationsDenied {
                        Text("Notifications are currently off, so you won't hear that sound — you can still head back whenever feels right.")
                            .font(.scalable(11))
                            .italic()
                            .foregroundStyle(Theme.softInk)
                            .lineLimit(nil)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.top, 2)
                    }
                }
                .padding(12)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Theme.moss.opacity(0.15))
                .clipShape(RoundedRectangle(cornerRadius: 14))

                VStack(spacing: 6) {
                    Button {
                        onActivate(selected)
                    } label: {
                        Text("Activate Pocket Anchor")
                            .font(.scalable(16, weight: .medium))
                            .foregroundStyle(Theme.cream)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Theme.forest)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                    }

                    Text("We'll keep time. You enjoy the air.")
                        .font(.scalable(12))
                        .foregroundStyle(Theme.softInk)

                    Text("Nothing leaves your phone.")
                        .font(.scalable(11))
                        .foregroundStyle(Theme.softInk.opacity(0.7))

                    Button {
                        showingAbout = true
                    } label: {
                        Text("About")
                            .font(.scalable(11))
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
        .onAppear(perform: refreshNotificationStatus)
    }

    private func refreshNotificationStatus() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                notificationsDenied = settings.authorizationStatus == .denied
            }
        }
    }
}

private struct AboutView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            Theme.paper.ignoresSafeArea()

            VStack {
                HStack {
                    Spacer()
                    Button {
                        dismiss()
                    } label: {
                        Text("Done")
                            .font(.scalable(14, weight: .medium))
                            .foregroundStyle(Theme.forest)
                    }
                }
                .padding([.horizontal, .top], 24)

                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        HStack(spacing: 10) {
                            BrandMark()
                                .frame(width: 30, height: 30)
                                .accessibilityHidden(true)
                            Text("Pocket Anchor")
                                .font(.scalable(20, weight: .medium, design: .serif))
                                .foregroundStyle(Theme.charcoal)
                        }
                        .accessibilityElement(children: .combine)
                        .padding(.top, 20)

                        Text("Every doorway leads somewhere.")
                            .font(.scalable(13))
                            .italic()
                            .foregroundStyle(Theme.softInk)
                            .fixedSize(horizontal: false, vertical: true)

                        Text("Part of the Life Forecast family of calm, private, local-only tools — from the maker of Echo Sink and Downstep.")
                            .font(.scalable(14))
                            .foregroundStyle(Theme.softInk)
                            .fixedSize(horizontal: false, vertical: true)

                        Text("No accounts. No ads. No streaks. Your data never leaves this device.")
                            .font(.scalable(12))
                            .foregroundStyle(Theme.softInk.opacity(0.8))
                            .fixedSize(horizontal: false, vertical: true)

                        Text("The Nature, Texture, Life, and Sound prompts aren't a game or a checklist — they're just there to help you notice more. Nothing is scored, tracked, or checked afterward.")
                            .font(.scalable(12))
                            .foregroundStyle(Theme.softInk.opacity(0.8))
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(24)
                }
            }
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
                        .font(.scalable(15, weight: .medium))
                    Text(duration.subtitle)
                        .font(.scalable(12))
                        .foregroundStyle(Theme.softInk)
                    if let reassurance = duration.reassurance {
                        Text(reassurance)
                            .font(.scalable(11))
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
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(duration.label), \(duration.subtitle)\(duration.reassurance.map { ". \($0)" } ?? "")")
        .accessibilityAddTraits(isSelected ? [.isButton, .isSelected] : .isButton)
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
