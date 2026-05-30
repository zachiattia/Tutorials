//
//  QuestionBank.swift
//  AlefQuest Watch App
//
//  The static dataset of questions, organized by level. Distractor answer
//  options are generated automatically from sibling questions so we only
//  have to maintain the hebrew → answer mapping in one place.
//

import Foundation

enum QuestionBank {

    /// Raw (hebrew, answer) pairs grouped by level. This is the only place
    /// content needs to be edited to add or change questions.
    private static let content: [GameLevel: [(hebrew: String, answer: String)]] = [
        .letters: [
            ("א", "Alef"),
            ("ב", "Bet"),
            ("ג", "Gimel"),
            ("ד", "Dalet"),
            ("ה", "He"),
            ("ו", "Vav"),
            ("ז", "Zayin"),
            ("ח", "Chet"),
            ("ט", "Tet"),
            ("י", "Yod"),
            ("כ", "Kaf"),
            ("ל", "Lamed"),
            ("מ", "Mem"),
            ("נ", "Nun"),
            ("ס", "Samech"),
            ("ע", "Ayin"),
            ("פ", "Pe"),
            ("צ", "Tsadi"),
            ("ק", "Qof"),
            ("ר", "Resh"),
            ("ש", "Shin"),
            ("ת", "Tav"),
        ],
        .sounds: [
            ("בָ", "Ba"),
            ("מוֹ", "Mo"),
            ("לִי", "Li"),
            ("דָ", "Da"),
            ("רֵ", "Re"),
            ("שׁוּ", "Shu"),
            ("נָ", "Na"),
            ("טִי", "Ti"),
            ("גוֹ", "Go"),
            ("קֵ", "Ke"),
        ],
    ]

    /// Convenience: the alef-bet in order (reused for the Letter Order level).
    private static var alphabet: [(hebrew: String, answer: String)] {
        content[.letters] ?? []
    }

    /// Number of answer options shown per question (1 correct + 3 distractors).
    /// The correct answer is placed in a random slot for every question, so the
    /// right choice is never in a predictable position.
    private static let optionCount = 4

    /// Builds the full question list for a level with randomized distractors.
    static func questions(for level: GameLevel) -> [HebrewQuestion] {
        if level == .order {
            return orderQuestions()
        }

        let pairs = content[level] ?? []
        let allAnswers = pairs.map { $0.answer }

        return pairs.map { pair in
            let options = makeOptions(correct: pair.answer, pool: allAnswers)
            return HebrewQuestion(
                hebrew: pair.hebrew,
                answer: pair.answer,
                options: options,
                level: level
            )
        }
    }

    /// Letter Order questions: show three consecutive letters of the alef-bet
    /// with one position blanked out (e.g. "_ , ג, ד"), and the player picks the
    /// missing Hebrew letter. The blank can be in any of the three positions, so
    /// kids learn what comes before, between, and after. Answer options are
    /// Hebrew letters.
    private static func orderQuestions() -> [HebrewQuestion] {
        let letters = alphabet                       // ordered alef-bet
        let allHebrew = letters.map { $0.hebrew }
        var questions: [HebrewQuestion] = []

        // Slide a 3-letter window across the alphabet.
        guard letters.count >= 3 else { return [] }
        for start in 0...(letters.count - 3) {
            let window = Array(letters[start..<(start + 3)])

            // Blank out each position in turn to make three questions.
            for blankIndex in 0..<3 {
                let answer = window[blankIndex].hebrew
                let tokens = window.enumerated().map { index, item in
                    index == blankIndex ? Self.blankToken : item.hebrew
                }
                questions.append(
                    HebrewQuestion(
                        hebrew: tokens.joined(separator: Self.sequenceSeparator),
                        answer: answer,
                        options: makeOptions(correct: answer, pool: allHebrew),
                        level: .order,
                        hint: "Fill the missing letter"
                    )
                )
            }
        }
        return questions
    }

    /// Placeholder rendered for the blanked slot, and the separator used to join
    /// the sequence into `hebrew` (the view splits on it again).
    static let blankToken = "_"
    static let sequenceSeparator = ","

    /// Builds a shuffled option list: the correct answer plus distractors drawn
    /// from `pool`, with the correct answer landing in a random slot.
    private static func makeOptions(correct: String, pool: [String]) -> [String] {
        let distractors = pool
            .filter { $0 != correct }
            .shuffled()
            .prefix(max(0, optionCount - 1))
        return ([correct] + distractors).shuffled()
    }

    /// A fresh, shuffled set of questions for a level.
    static func shuffledQuestions(for level: GameLevel) -> [HebrewQuestion] {
        questions(for: level).shuffled()
    }
}
