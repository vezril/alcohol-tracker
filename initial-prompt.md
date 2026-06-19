This is an iOS App that helps me track alcohol intake, an habit app. Similar in design as the Intake App: https://intaketracker.app/
Tech stack:
- Swift + Swift UI + HealthKit

TDD is REQUIRED (non-negotiable):
- Follow Red–Green–Refactor.
- For every behavior in the specs, write tests FIRST (failing), then implement.
- The task list must explicitly sequence: tests → implementation → refactor.
- Always RUN tests after each implementation to ensure they pass.

Include a comprehensive README.md file in the root of the project that explains how to run the application and how to run the tests.

Extra
- Use the repo located on the local filesystem `/Users/cference/Code/claude-toolkit` for relevant skills and agents.

Features (minimal, more features to be added later, this is just to get started). Features will be described as Acceptance Criteria, use these for your TDD tests, additionally, think of at least two edge cases for the tests:
1. Basic Github Project Scaffolding with CICD on Github using Github Actions
    - Version Control should follow semantic versioning schema
    - `main` branch has the latest major release (this builds and ships the main package via CICD)
    - `development` branch has the latest dev changes (experimental builds)
    - Feel free to propose a different strategy (and update this spec as needed)
2. Basic iOS App Built for scaffolding, an apple watch widget is in mind from this point forward but will be built after core functionality has been fleshed out. App name is TBD.
3. Ability to add a drink in the tracker, for now drink is extremely generic
4. Ability to remove a drink in the tracker
5. Calendar view of the tracker
6. Dashboard with the current week, and stats such as number of drinks tracked during the week
7. Settings view, that allows to configure various settings such as light mode, dark mode, or system
7. Stats view, that shows this week, the best day, this month, this year
8. Additional data in the Stats view that shows Trends in a bar graph, with the ability to view by weekly, monthly, and yearly
9. Additional data in the Stats view that shows Drinking patterns by Weekly, monthly, yearly, with the ability to select "time of day" as either morning, afternoon, evening, night
10. Additional view to requirement 9, that allows to view a Timeline view instead, x axis is the day of the week, y axis is the hour of the day
11. Defining what a drink is. One drink, is a can of 355 ml, at 5 ABV. That is "one unit". The app will now have the option of adding a drink of lets say 7%, and will adjust the number accordingly to the basic unit.
12. The ability to set drinking goals, x unit of drinks per day
12. iPhone Widget
13. Apple Watch Widget
14. HealthKit Integration

More features to come.

Constraints / non-goals:
- Provide Given/When/Then acceptance criteria with at least 2 edge cases per feature.
- Functional Programming highly desired over imperative style
- Swift Best Practices are required
- Clean Code is a must
