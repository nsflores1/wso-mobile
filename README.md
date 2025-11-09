# wso-mobile
Rewrite of the WSO Mobile iOS app in Swift. 

This project is in a very early state, but at some point will completely replace the existing WSO Mobile app. 

## Introduction
Swift is a programming language made by Apple. Because Swift iOS projects can only be built and maintained on macOS, this project has a special layout that you should respect.

- The `App` folder is for `Views`, which are the GUI screens of the app, and `ViewModels`, which are the underlying data structure that represent the stateful data which will be rendered by `Views`.
- The `CLI` folder is for the CLI client to WSO Mobile. Why create this? The main reason was that we wanted it to be easy to test some features without running the iOS simulator, which is computationally expensive. Since only macOS can build the iOS app, this gives a way for Windows-using contributors to work on the code.
- The `Shared` folder contains all core logic code that both the `App` and `CLI` share. It is where basically all non-GUI code should go. 

## To-Do List
- Write up the general GUI and get that design working
- Make enough `ViewModels` with simple dummy data to test out the GUI
- Make the CLI not painful to use
- Figure out how to do LDAP authentication in Swift (this requires bridging out to Objective-C, which will not be fun)


