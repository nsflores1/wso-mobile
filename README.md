# New WSO Mobile
Rewrite of the WSO Mobile iOS app in Swift. 

This project will, at some point, completely replace the existing WSO Mobile app, so we need to re-create everything. Pull requests are very welcome! 

Not sure what to do next? Check the To-Do List or the Issues!

## Introduction
Swift is a programming language made by Apple that you should learn; it's pretty good. This project has a special layout that you should respect.

- The `App` folder is for `Views`, which are the GUI screens of the app, and `ViewModels`, which are the underlying data structure that represent the stateful data which will be rendered by `Views`.
- The `CLI` folder is for the CLI client to WSO Mobile. Why create this? The main reason was that we wanted it to be easy to test some features without running the iOS simulator, which is computationally expensive. Since only macOS can build the iOS app, this gives a way for Windows-using contributors to work on the code.
- The `Shared` folder contains all core logic code that both the `App` and `CLI` share. It is where basically all non-GUI code should go, such as helper functions, anything iterative, and all functions that actually do any data parsing. If it modifies a data structure in a non-declarative way, it *must* live here.

Also: `swiftlint` is turned on. To turn it off, add the following to your `.swiftlint.yml`:
```yaml
lenient: true
```
That will make it ignore all your errors. You should probably read what `swiftlint` says at some point, although most of its warnings are more aesthetic than anything, and you should go back and fix them. This is only for when you're in a hurry, or simply want to get something out and fix it later.

## To-Do List
Ordered from most to least important:
- Implement JWT Token support and add that to the user's keychain (unlock with FaceID)
- Complete the radio player show view
- Add views for all core WSO services
- Add good logging support
- Document all the code, agree on a core Swift style
- Make the CLI not painful to use (better debugging mode)
- Decent watchOS support
- Decent iPadOS support

Users are also regularly submitting feedback. You should listen to them, too!

# The Anti-To-Do List
This is a list of things that should *never* be done. They seem like a good idea, but they are actually bad.
- Storing the user's token in `AppSettings` (NEVER do this)
- Implementing Android support (not our problem)
- Releasing to tvOS, visionOS, or macOS (why?)
- Shipping the same code for iOS and iPadOS (don't do this)
