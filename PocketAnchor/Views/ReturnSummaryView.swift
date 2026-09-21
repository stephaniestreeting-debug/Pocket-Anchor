import SwiftUI
import SwiftData

struct ReturnSummaryView: View {
    let record: OutingRecord
    let onDone: () -> Void

    @Environment(\.modelContext) private var modelContext

    @State private var noticedCount: Int = 0
    @State private var selectedMood: String?
    @State private var encouragementNote: String = EncouragementBank.randomNote()

    private let moodOptions = ["Light", "Steady", "Heavy"]
    private let maxDots = 6

    private var minutes: Int {
        max(1, Int((record.actualDuration / 60).rounded()))
    }

    private var welcomeLine: String {
        let minuteWord = "minute\(minutes == 1 ? "" : "s")"
        switch record.duration {
        case .doorway:
            return "You spent \(minutes) \(minuteWord) at the door. That's the whole thing today. Your phone stayed in your pocket where it belonged."
        case .nearby:
            return "You spent \(minutes) \(minuteWord) close to home. Your phone stayed in your pocket where it belonged."
        case .block, .wander, .open:
            return "You spent \(minutes) \(minuteWord) outside. Your phone stayed in your pocket where it belonged."
        }
    }

    private var recapLine: String? {
        let countPart: String?
        switch noticedCount {
        case 0: countPart = nil
        case 1: countPart = "One small thing caught your eye"
        case 2...3: countPart = "A few things caught your eye"
        case 4...5: countPart = "Quite a few things caught your eye"
        default: countPart = "Plenty caught your eye today"
        }

        let moodLower: String?
        let moodStandalone: String?
        switch selectedMood {
        case "Light":
            moodLower = "you're feeling light"
            moodStandalone = "You're feeling light."
        case "Steady":
            moodLower = "you're feeling steady"
            moodStandalone = "You're feeling steady."
        case "Heavy":
            moodLower = "you're feeling heavy right now, and that's alright"
            moodStandalone = "You're feeling heavy right now, and that's alright."
        default:
            moodLower = nil
            moodStandalone = nil
        }

        if let countPart, let moodLower {
            return "\(countPart), and \(moodLower)."
        } else if let countPart {
            return "\(countPart)."
        } else if let moodStandalone {
            return moodStandalone
        }
        return nil
    }

    var body: some View {
        ZStack {
            Theme.paper.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 28) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Welcome back.")
                            .font(.scalable(26, weight: .medium, design: .serif))
                            .foregroundStyle(Theme.charcoal)

                        Text(welcomeLine)
                            .font(.scalable(15))
                            .foregroundStyle(Theme.softInk)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(.top, 20)

                    VStack(alignment: .leading, spacing: 10) {
                        Text("Did anything catch your eye?")
                            .font(.scalable(14, weight: .medium))
                            .foregroundStyle(Theme.charcoal)
                        Text("Tap for each thing you remember, however small.")
                            .font(.scalable(12))
                            .foregroundStyle(Theme.softInk)

                        HStack(spacing: 14) {
                            ForEach(0..<maxDots, id: \.self) { index in
                                Circle()
                                    .fill(index < noticedCount ? Theme.clay : Color.clear)
                                    .overlay(Circle().stroke(Theme.clay.opacity(0.5), lineWidth: 1))
                                    .frame(width: 26, height: 26)
                                    .contentShape(Circle())
                                    .onTapGesture {
                                        withAnimation(.easeInOut(duration: 0.2)) {
                                            noticedCount = (index < noticedCount) ? index : index + 1
                                        }
                                        save()
                                    }
                            }
                        }
                        .padding(.top, 4)
                        .accessibilityElement(children: .ignore)
                        .accessibilityLabel("Things noticed")
                        .accessibilityValue("\(noticedCount) of \(maxDots)")
                        .accessibilityAdjustableAction { direction in
                            switch direction {
                            case .increment:
                                noticedCount = min(maxDots, noticedCount + 1)
                            case .decrement:
                                noticedCount = max(0, noticedCount - 1)
                            @unknown default:
                                break
                            }
                            save()
                        }
                    }

                    VStack(alignment: .leading, spacing: 10) {
                        Text("How do you feel right now?")
                            .font(.scalable(14, weight: .medium))
                            .foregroundStyle(Theme.charcoal)

                        HStack(spacing: 8) {
                            ForEach(moodOptions, id: \.self) { option in
                                Button {
                                    withAnimation(.easeInOut(duration: 0.2)) {
                                        selectedMood = (selectedMood == option) ? nil : option
                                    }
                                    save()
                                } label: {
                                    Text(option)
                                        .font(.scalable(12))
                                        .foregroundStyle(selectedMood == option ? Theme.paper : Theme.charcoal)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 8)
                                        .background(selectedMood == option ? Theme.forest : Theme.moss.opacity(0.15))
                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                                }
                                .buttonStyle(.plain)
                                .accessibilityAddTraits(selectedMood == option ? [.isButton, .isSelected] : .isButton)
                            }
                        }
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        if let recapLine {
                            Text(recapLine)
                                .font(.scalable(15, weight: .medium))
                                .foregroundStyle(Theme.charcoal)
                                .fixedSize(horizontal: false, vertical: true)
                        }

                        Text(encouragementNote)
                            .font(.scalable(13))
                            .italic()
                            .foregroundStyle(Theme.softInk)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(16)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Theme.moss.opacity(0.15))
                    .clipShape(RoundedRectangle(cornerRadius: 16))

                    VStack(spacing: 8) {
                        Button {
                            onDone()
                        } label: {
                            Text("That's it")
                                .font(.scalable(16, weight: .medium))
                                .foregroundStyle(Theme.paper)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(Theme.forest)
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                        }

                        Text("Nothing to finish, nothing to log.")
                            .font(.scalable(12))
                            .foregroundStyle(Theme.softInk)
                    }
                    .padding(.top, 12)
                }
                .padding(24)
            }
        }
        .onAppear {
            modelContext.insert(record)
            try? modelContext.save()
        }
    }

    private func save() {
        record.noticedCount = noticedCount
        record.mood = selectedMood
        try? modelContext.save()
    }
}

#Preview {
    ReturnSummaryView(
        record: OutingRecord(startDate: .now, actualDuration: 620, duration: .block),
        onDone: {}
    )
    .modelContainer(for: OutingRecord.self, inMemory: true)
}
