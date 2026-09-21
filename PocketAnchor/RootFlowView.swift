import SwiftUI

enum FlowStage {
    case intention
    case pocket(duration: OutingDuration, startedAt: Date)
    case summary(record: OutingRecord)
}

struct RootFlowView: View {
    @State private var stage: FlowStage

    init() {
        if let pending = PendingSessionStore.load() {
            _stage = State(initialValue: .pocket(duration: pending.duration, startedAt: pending.startedAt))
        } else {
            _stage = State(initialValue: .intention)
        }
    }

    var body: some View {
        Group {
            switch stage {
            case .intention:
                IntentionView { duration in
                    let startedAt = Date.now
                    PendingSessionStore.save(PendingSession(startedAt: startedAt, duration: duration))
                    withAnimation(.easeInOut(duration: 0.5)) {
                        stage = .pocket(duration: duration, startedAt: startedAt)
                    }
                }
                .transition(.opacity)
            case .pocket(let duration, let startedAt):
                PocketStateView(duration: duration, startedAt: startedAt) { finishedAt in
                    PendingSessionStore.clear()
                    let record = OutingRecord(
                        startDate: startedAt,
                        actualDuration: finishedAt.timeIntervalSince(startedAt),
                        duration: duration
                    )
                    withAnimation(.easeInOut(duration: 0.5)) {
                        stage = .summary(record: record)
                    }
                }
                .transition(.opacity)
            case .summary(let record):
                ReturnSummaryView(record: record) {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        stage = .intention
                    }
                }
                .transition(.opacity)
            }
        }
    }
}

#Preview {
    RootFlowView()
        .modelContainer(for: OutingRecord.self, inMemory: true)
}
