import AVFoundation

enum DepartureCue {
    private static var engine: AVAudioEngine?
    private static var playerNode: AVAudioPlayerNode?

    static func play() {
        let sampleRate = 44_100.0
        let gap = 0.05
        // A soft descending two-note cadence (like a settling exhale)
        // rather than a single continuous pitch sweep.
        let notes: [(frequency: Double, duration: Double, startTime: Double)] = [
            (440.00, 0.55, 0.0),
            (329.63, 0.85, 0.55 + gap)
        ]
        let totalDuration = notes.map { $0.startTime + $0.duration }.max() ?? 1.0
        let frameCount = AVAudioFrameCount(sampleRate * totalDuration)

        guard let format = AVAudioFormat(standardFormatWithSampleRate: sampleRate, channels: 1),
              let buffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: frameCount),
              let channel = buffer.floatChannelData?[0] else { return }
        buffer.frameLength = frameCount

        for note in notes {
            let startFrame = Int(note.startTime * sampleRate)
            let noteFrameCount = Int(note.duration * sampleRate)
            let attackFrames = Int(0.01 * sampleRate)

            for i in 0..<noteFrameCount {
                let frame = startFrame + i
                guard frame < Int(frameCount) else { break }
                let t = Double(i) / sampleRate

                // Quick linear attack (avoids a click at note onset), then a
                // natural exponential decay (reads as a bell/chime rather
                // than the abrupt symmetric fade of a plain sine window).
                let attack = i < attackFrames ? Double(i) / Double(attackFrames) : 1.0
                let decay = exp(-t * 3.2)
                let envelope = attack * decay

                // A quiet, slightly detuned overtone adds warmth so the
                // tone doesn't read as a thin, purely synthetic sine wave.
                let fundamental = sin(2.0 * Double.pi * note.frequency * t)
                let overtone = sin(2.0 * Double.pi * note.frequency * 2.01 * t) * 0.18
                let sample = (fundamental + overtone) * envelope * 0.22

                channel[frame] += Float(sample)
            }
        }

        let engine = AVAudioEngine()
        let player = AVAudioPlayerNode()
        engine.attach(player)
        engine.connect(player, to: engine.mainMixerNode, format: format)

        do {
            try AVAudioSession.sharedInstance().setCategory(.ambient, options: [.mixWithOthers])
            try AVAudioSession.sharedInstance().setActive(true)
            try engine.start()
        } catch {
            return
        }

        self.engine = engine
        self.playerNode = player

        player.scheduleBuffer(buffer, at: nil, options: []) {
            DispatchQueue.main.async {
                engine.stop()
            }
        }
        player.play()
    }
}
