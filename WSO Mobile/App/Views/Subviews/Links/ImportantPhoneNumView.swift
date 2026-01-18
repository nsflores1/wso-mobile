//
//  ImportantPhoneNumView.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2026-01-18.
//

// this is for literally vital phone numbers. don't put random stuff here

import SwiftUI

struct ImportantPhoneNumView: View {
    var body: some View {
        NavigationStack {
            List {
                Section {
                    Text("Clicking on the buttons opens the Phone app and calls the number. Please ensure that you THINK before you CALL.")
                    Button(action: {
                        UIApplication.shared.open(URL(string: "tel://413-458-5646")!)
                    }) {
                        HStack {
                            Image(systemName: "phone")
                            VStack(alignment: .leading) {
                                Text("Police, Ambulance, Fire")
                                    .fontWeight(.regular)
                                    .font(.title3)
                                Text("413-458-5646")
                                    .fontWeight(.regular)
                                    .font(.subheadline)
                            }
                        }
                    }
                    Button(action: {
                        UIApplication.shared.open(URL(string: "tel://413-597-3551")!)
                    }) {
                        HStack {
                            Image(systemName: "phone")
                            VStack(alignment: .leading) {
                                Text("CSS: Emergency")
                                    .fontWeight(.regular)
                                    .font(.title3)
                                Text("413-597-3551")
                                    .fontWeight(.regular)
                                    .font(.subheadline)
                            }
                        }
                    }
                    Button(action: {
                        UIApplication.shared.open(URL(string: "tel://413-597-4444")!)
                    }) {
                        HStack {
                            Image(systemName: "phone")
                            VStack(alignment: .leading) {
                                Text("CSS: Non-Emergency")
                                    .fontWeight(.regular)
                                    .font(.title3)
                                Text("413-597-4444")
                                    .fontWeight(.regular)
                                    .font(.subheadline)
                            }
                        }
                    }
                    Button(action: {
                        UIApplication.shared.open(URL(string: "tel://413-597-4100")!)
                    }) {
                        HStack {
                            Image(systemName: "phone")
                            VStack(alignment: .leading) {
                                Text("RASAN: Rape & Sexual Assault Network")
                                    .fontWeight(.regular)
                                    .font(.title3)
                                Text("413-597-4100")
                                    .fontWeight(.regular)
                                    .font(.subheadline)
                            }
                        }
                    }
                    Button(action: {
                        UIApplication.shared.open(URL(string: "tel://413-597-4400")!)
                    }) {
                        HStack {
                            Image(systemName: "phone")
                            VStack(alignment: .leading) {
                                Text("Student Escort Service")
                                    .fontWeight(.regular)
                                    .font(.title3)
                                Text("413-597-4400")
                                    .fontWeight(.regular)
                                    .font(.subheadline)
                            }
                        }
                    }
                }
            }
            .navigationTitle(Text("Emergency Numbers"))
            .modifier(NavSubtitleIfAvailable(subtitle: "Call these numbers to save a life"))
        }
    }
}

#Preview {
    ImportantPhoneNumView()
}
