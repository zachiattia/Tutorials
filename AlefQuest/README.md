# AlefQuest — Hebrew Learning Game for Apple Watch ⌚🔤

A simple, fast, and rewarding watchOS game that helps kids learn the Hebrew
alef-bet — letter names, letter order, and syllable sounds — through
multiple-choice questions.

> Show a Hebrew character → tap the correct English transliteration → build
> streaks and earn rewards. Sessions are designed to last 1–3 minutes, perfect
> for the Watch.

## Gameplay

The game shows a piece of Hebrew text and **4** English transliteration
choices — one correct, three distractors drawn from the rest of the alef-bet.
The correct answer lands in a **random slot every question**, so it is never in
a predictable position. Tap the right one to score a point and grow your
streak. Wrong answers are
never punishing — the correct answer is highlighted in green so you learn it,
and your score never drops below zero.

### Levels

| Level | Name           | What it asks                          | Example |
|-------|----------------|---------------------------------------|---------|
| 1     | Letters        | Name this letter                      | `א` → **Alef** |
| 2     | Letter Order   | Fill the missing letter in a sequence | `ד ג _` (reads right-to-left) → **ב** |
| 3     | Sounds         | Name this vowelled syllable           | `בָ` → **Ba** |

**Letter Order** teaches the alef-bet sequence: it shows three consecutive
letters **right-to-left** (proper Hebrew direction) with one slot blanked out
(the blank can be at the start, middle, or end), and the player taps the
missing **Hebrew letter**. So kids learn what comes before, between, and after —
not just individual letters. The Hebrew is shown right-to-left; the rest of the
UI (scores, streak, labels) stays in English.

*(Words and Phrases levels are planned but disabled for now.)*

Switch levels any time from the slider button (top-right of the game screen).

### Scoring & Streaks

- **Correct:** +1 point, streak increases, light haptic tick.
- **Wrong:** −1 point (floored at 0), streak resets, the answer is revealed.
- **Streak rewards:**
  - 🔥 Flame at a **5** streak
  - ⭐ Star at a **10** streak
  - 🏆 Trophy at a **20** streak (with a celebratory success haptic)

Best streak and total points persist between sessions via `UserDefaults`.

## Project Structure

```
AlefQuest/
├── AlefQuest.xcodeproj          # Xcode 16 project (watchOS, single app target)
└── AlefQuest Watch App/
    ├── AlefQuestApp.swift        # @main entry point
    ├── Models/
    │   ├── HebrewQuestion.swift  # GameLevel enum + HebrewQuestion model
    │   └── QuestionBank.swift     # Content dataset + distractor generation
    ├── ViewModels/
    │   └── GameViewModel.swift    # Game state, scoring, streaks, haptics
    ├── Views/
    │   ├── GameView.swift         # Main gameplay screen
    │   ├── AnswerButton.swift     # Multiple-choice button with feedback
    │   ├── ScoreHeader.swift      # Score + streak header
    │   └── LevelPickerView.swift  # Level switcher + progress sheet
    └── Assets.xcassets/           # App icon + accent color
```

## Building & Running

1. Open `AlefQuest/AlefQuest.xcodeproj` in **Xcode 16** or later.
2. Select the **AlefQuest Watch App** scheme and an Apple Watch simulator.
3. Press **⌘R** to build and run.

Deployment target: **watchOS 10.0**. The app runs independently (no paired
iPhone app required).

## Adding Content

All questions live in `QuestionBank.swift`. To add a new item, append a
`(hebrew, answer)` pair to the relevant level — the answer options (including
plausible distractors drawn from sibling questions) are generated
automatically, so there is nothing else to maintain.

```swift
.letters: [
    ("א", "Alef"),
    ("ב", "Bet"),
    // add new letters here ...
]
```

The **Letter Order** level is generated automatically from the `.letters`
array order — no separate data to maintain.

## Roadmap

- **v2:** Native pronunciation audio, Hebrew vowel (nikud) drills,
  achievements, daily challenge.
- **v3:** Word building, listening mode, parent dashboard / progress tracking,
  classroom mode, multiplayer.

The same engine generalizes to other scripts (Arabic, Greek, Japanese, Morse,
music notes) — it only needs a new `QuestionBank`.
