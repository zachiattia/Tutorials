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
        .words: [
            ("אַבָּא", "Abba"),
            ("אִמָּא", "Ima"),
            ("שָׁלוֹם", "Shalom"),
            ("כֶּלֶב", "Kelev"),
            ("חָתוּל", "Chatul"),
            ("מַיִם", "Mayim"),
            ("יֶלֶד", "Yeled"),
            ("סֵפֶר", "Sefer"),
            ("תּוֹדָה", "Toda"),
            ("בַּיִת", "Bayit"),
        ],
        .phrases: [
            ("שָׁלוֹם אַבָּא", "Shalom Abba"),
            ("אֲנִי אוֹרִי", "Ani Ori"),
            ("מַה שְׁלוֹמְךָ", "Ma shlomcha"),
            ("בֹּקֶר טוֹב", "Boker tov"),
            ("לַיְלָה טוֹב", "Layla tov"),
            ("תּוֹדָה רַבָּה", "Toda raba"),
        ],
    ]

    /// Number of answer options shown per question (correct + distractors).
    private static let optionCount = 3

    /// Builds the full question list for a level with randomized distractors.
    static func questions(for level: GameLevel) -> [HebrewQuestion] {
        let pairs = content[level] ?? []
        let allAnswers = pairs.map { $0.answer }

        return pairs.map { pair in
            // Pick distractors from the other answers in the same level.
            let distractors = allAnswers
                .filter { $0 != pair.answer }
                .shuffled()
                .prefix(max(0, optionCount - 1))

            let options = ([pair.answer] + distractors).shuffled()

            return HebrewQuestion(
                hebrew: pair.hebrew,
                answer: pair.answer,
                options: options,
                level: level
            )
        }
    }

    /// A fresh, shuffled set of questions for a level.
    static func shuffledQuestions(for level: GameLevel) -> [HebrewQuestion] {
        questions(for: level).shuffled()
    }
}
