import Foundation

enum SensoryPromptBank {
    static let seeds: [String] = [
        "Maybe there's a texture worth touching today — bark, stone, a cold railing.",
        "There's a particular smell in the air right before rain.",
        "A leaf, a door, a parked car — some color out there might be brighter than you expect.",
        "Clouds can look like a dog, a boat, a face, if you watch for a moment.",
        "Birds, traffic hum, wind in the leaves — some sounds only exist outdoors.",
        "The air might be cooler or warmer than you expect against your skin.",
        "A bird, a leaf, a squirrel — something small might be moving nearby, worth noticing.",
        "A small plant might be growing somewhere unexpected, like a crack in the pavement.",
        "Late-day light can do lovely things to walls, windows, and puddles.",
        "A dog is probably out there right now, wagging at something."
    ]

    static func randomSeed() -> String {
        seeds.randomElement() ?? seeds[0]
    }
}

enum EncouragementBank {
    static let notes: [String] = [
        "Fresh air and a bit of noticing does more for a tired brain than people expect.",
        "Turns out paying attention to small things like this is genuinely restful for your mind.",
        "A few minutes of this is apparently enough to help a busy mind settle a little.",
        "Noticing things outside is one of the simpler ways to give your brain a break.",
        "Small moments like this add up more than they seem to."
    ]

    static func randomNote() -> String {
        notes.randomElement() ?? notes[0]
    }
}
