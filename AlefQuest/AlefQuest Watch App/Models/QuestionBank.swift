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

    /// Letter Order questions: show a letter and ask for the letter that comes
    /// immediately NEXT or BEFORE it in the alef-bet. Teaches the sequence.
    private static func orderQuestions() -> [HebrewQuestion] {
        let letters = alphabet
        let allNames = letters.map { $0.answer }
        var questions: [HebrewQuestion] = []

        for (index, letter) in letters.enumerated() {
            // "What comes NEXT?" — valid for every letter except the last.
            if index < letters.count - 1 {
                let answer = letters[index + 1].answer
                questions.append(
                    HebrewQuestion(
                        hebrew: letter.hebrew,
                        answer: answer,
                        options: makeOptions(correct: answer, pool: allNames),
                        level: .order,
                        hint: "What comes NEXT? →"
                    )
                )
            }

            // "What comes BEFORE?" — valid for every letter except the first.
            if index > 0 {
                let answer = letters[index - 1].answer
                questions.append(
                    HebrewQuestion(
                        hebrew: letter.hebrew,
                        answer: answer,
                        options: makeOptions(correct: answer, pool: allNames),
                        level: .order,
                        hint: "← What comes BEFORE?"
                    )
                )
            }
        }
        return questions
    }

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
