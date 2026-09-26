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
                    // Resolve the (usually invisible, one-time) notification
                    // permission dialog on the bright Intention screen before
                    // the screen goes dark, rather than racing the dialog
                    // against the darkening transition.
                    HalfwayChimeScheduler.schedule(for: duration) {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            stage = .pocket(duration: duration, startedAt: startedAt)
                        }
                    }
                }
                .transition(.opacity)
            case .pocket(let duration, let startedAt):
                PocketStateView(duration: duration, startedAt: startedAt) { finishedAt in
                    PendingSessionStore.clear()
                    HalfwayChimeScheduler.cancel()
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
}
