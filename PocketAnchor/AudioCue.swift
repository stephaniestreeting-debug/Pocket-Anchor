import AVFoundation

enum DepartureCue {
    private static var engine: AVAudioEngine?
    private static var playerNode: AVAudioPlayerNode?

    static func play() {
        let sampleRate = 44_100.0
        let duration = 1.4
        let startFrequency = 523.25
        let endFrequency = 349.23
        let frameCount = AVAudioFrameCount(sampleRate * duration)

        guard let format = AVAudioFormat(standardFormatWithSampleRate: sampleRate, channels: 1),
              let buffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: frameCount),
              let channel = buffer.floatChannelData?[0] else { return }
        buffer.frameLength = frameCount

        var phase = 0.0
        for frame in 0..<Int(frameCount) {
            let t = Double(frame) / sampleRate
            let progress = t / duration
            let frequency = startFrequency + (endFrequency - startFrequency) * progress
            phase += 2.0 * Double.pi * frequency / sampleRate
            let envelope = sin(Double.pi * progress)
            channel[frame] = Float(sin(phase) * envelope * 0.2)
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
