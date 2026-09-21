import SwiftUI
import SwiftData

struct ReturnSummaryView: View {
    let record: OutingRecord
    let onDone: () -> Void

    @Environment(\.modelContext) private var modelContext

    @State private var callbackPrompt: SensoryPrompt
    @State private var bonusPrompts: [SensoryPrompt]
    @State private var affirmed: Set<String> = []
    @State private var declined: Set<String> = []

    init(record: OutingRecord, onDone: @escaping () -> Void) {
        self.record = record
        self.onDone = onDone
        let seed = SensoryPromptBank.randomSeed()
        _callbackPrompt = State(initialValue: seed)
        _bonusPrompts = State(initialValue: SensoryPromptBank.bonusPrompts(excluding: seed, count: 2))
    }

    private var minutes: Int {
        max(1, Int((record.actualDuration / 60).rounded()))
    }

    private var allPrompts: [SensoryPrompt] {
        [callbackPrompt] + bonusPrompts
    }

    var body: some View {
        ZStack {
            Theme.paper.ignoresSafeArea()

            VStack(alignment: .leading, spacing: 28) {
                Spacer()

                VStack(alignment: .leading, spacing: 10) {
                    Text("Welcome back.")
                        .font(.system(size: 26, weight: .medium, design: .serif))
                        .foregroundStyle(Theme.charcoal)

                    Text("You spent \(minutes) minute\(minutes == 1 ? "" : "s") outside. Your phone stayed in your pocket where it belonged.")
                        .font(.system(size: 15))
                        .foregroundStyle(Theme.softInk)
                }

                VStack(alignment: .leading, spacing: 14) {
                    Text("Did anything catch your eye?")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(Theme.charcoal)

                    ForEach(allPrompts) { prompt in
                        NoticingRow(
                            prompt: prompt,
                            state: affirmed.contains(prompt.id) ? .yes : (declined.contains(prompt.id) ? .not : .undecided)
                        ) { didHappen in
                            if didHappen {
                                affirmed.insert(prompt.id)
                                declined.remove(prompt.id)
                            } else {
                                declined.insert(prompt.id)
                                affirmed.remove(prompt.id)
                            }
                            saveNoticedPrompts()
                        }
                    }
                }

                Spacer()

                VStack(spacing: 8) {
                    Button {
                        onDone()
                    } label: {
                        Text("That's it")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundStyle(Theme.paper)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Theme.forest)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                    }

                    Text("Nothing to finish, nothing to log.")
                        .font(.system(size: 12))
                        .foregroundStyle(Theme.softInk)
                }
            }
            .padding(24)
        }
        .onAppear {
            modelContext.insert(record)
            try? modelContext.save()
        }
    }

    private func saveNoticedPrompts() {
        record.noticedPrompts = allPrompts
            .filter { affirmed.contains($0.id) }
            .map { $0.callback }
        try? modelContext.save()
    }
}

private enum NoticeState {
    case undecided, yes, not
}

private struct NoticingRow: View {
    let prompt: SensoryPrompt
    let state: NoticeState
    let onChoose: (Bool) -> Void

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Text(prompt.callback)
                .font(.system(size: 13))
                .foregroundStyle(Theme.charcoal)

            Spacer()

            HStack(spacing: 10) {
                Circle()
                    .fill(state == .yes ? Theme.clay : Color.clear)
                    .overlay(Circle().stroke(Theme.clay.opacity(0.5), lineWidth: 1))
                    .frame(width: 20, height: 20)
                    .onTapGesture { onChoose(true) }

                Text("not today")
                    .font(.system(size: 11))
                    .foregroundStyle(state == .not ? Theme.softInk : Theme.softInk.opacity(0.4))
                    .onTapGesture { onChoose(false) }
            }
        }
    }
}

#Preview {
    ReturnSummaryView(
        record: OutingRecord(startDate: .now, actualDuration: 620, intendedLabel: "10 min"),
        onDone: {}
    )
    .modelContainer(for: OutingRecord.self, inMemory: true)
}
