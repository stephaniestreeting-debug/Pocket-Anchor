import Foundation

struct SensoryPrompt: Identifiable, Equatable {
    let id: String
    let seed: String
    let callback: String

    static func == (lhs: SensoryPrompt, rhs: SensoryPrompt) -> Bool {
        lhs.id == rhs.id
    }
}

enum SensoryPromptBank {
    static let all: [SensoryPrompt] = [
        SensoryPrompt(id: "texture", seed: "Maybe there's a texture worth touching today.", callback: "Did you find a texture?"),
        SensoryPrompt(id: "smell", seed: "Rain always smells like something before it arrives.", callback: "Did a smell arrive and leave?"),
        SensoryPrompt(id: "color", seed: "There might be a color out there you didn't expect.", callback: "Did a color surprise you?"),
        SensoryPrompt(id: "clouds", seed: "Clouds are usually pretending to be something else.", callback: "Did you notice a shape in the clouds?"),
        SensoryPrompt(id: "sound", seed: "Some sounds only exist outside.", callback: "Did you hear something you don't hear indoors?"),
        SensoryPrompt(id: "temperature", seed: "The air might feel different on your skin today.", callback: "Did you notice the warmth or the cold?"),
        SensoryPrompt(id: "movement", seed: "Something out there is probably moving on its own.", callback: "Did you see something moving that wasn't a car or a person?"),
        SensoryPrompt(id: "plant", seed: "Plants have a way of showing up where they shouldn't.", callback: "Did you spot a plant pushing through somewhere unexpected?"),
        SensoryPrompt(id: "light", seed: "Light does strange things to surfaces in the late day.", callback: "Did light catch a surface in a way you noticed?"),
        SensoryPrompt(id: "animal", seed: "Somewhere out there, someone else's dog is having a very important day.", callback: "Did you notice someone else's dog, cat, or bird?")
    ]

    static func randomSeed() -> SensoryPrompt {
        all.randomElement() ?? all[0]
    }

    static func bonusPrompts(excluding used: SensoryPrompt, count: Int) -> [SensoryPrompt] {
        Array(all.filter { $0.id != used.id }.shuffled().prefix(count))
    }
}
