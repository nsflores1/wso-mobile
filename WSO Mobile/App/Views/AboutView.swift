//
//  AboutView.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2025-11-23.
//

import SwiftUI
import Logging

struct AboutView: View {
    @Environment(\.logger) private var logger
    @State private var viewModel = AboutViewModel()
    @Environment(AuthManager.self) private var authManager

    var body: some View {
        NavigationStack {
            VStack {
                Text("WSO Mobile")
                    .font(.title)
                    .fontWeight(.bold)
                    // TODO: secretly make this a button as an easter egg
                if viewModel.isLoading {
                    Text("Rolling dice...")
                        .font(.headline)
                        .fontWeight(.medium)
                        .italic(true)
                } else {
                    Text(viewModel.words)
                        .font(.headline)
                        .fontWeight(.medium)
                        .italic(true)
                }
                Divider().tint(Color(.secondarySystemBackground))
                let text = """
                WSO is made possible by the following lovely people,
                 who all contributed greatly:
                """
                Text(text.replacingOccurrences(of: "\n", with: ""))
            }
            List {
                Section("Lead Developers (2026-2027)") {
                    NavigationLink {
                        WSOProfileView(viewModel: WSOUserViewModel(userID: 14643))
                    } label: {
                        Text("Nathaniel Flores - nsf1@williams.edu")
                    }
                    NavigationLink {
                        WSOProfileView(viewModel: WSOUserViewModel(userID: 14774))
                    } label: {
                        Text("Charlie Tharas - cmt8@wiliams.edu")
                    }
                    NavigationLink {
                        WSOProfileView(viewModel: WSOUserViewModel(userID: 14656))
                    } label: {
                        Text("Nathan Vosburg - nvj1@williams.edu")
                    }
                }
                Section("App Artists") {
                    NavigationLink {
                        WSOProfileView(viewModel: WSOUserViewModel(userID: 14916))
                    } label: {
                        Text("Emma Li - ebl2@williams.edu")
                    }
                }
                Section("Student Beta Testers") {
                    Text("Note: Beta testers are not ranked in any particular order")
                        .italic(true)
                    NavigationLink {
                        WSOProfileView(viewModel: WSOUserViewModel(userID: 15346))
                    } label: {
                        Text("Eleanor Race - epr3@williams.edu")
                    }
                    NavigationLink {
                        WSOProfileView(viewModel: WSOUserViewModel(userID: 14154))
                    } label: {
                        Text("Leo Margolies - lsm4@williams.edu")
                    }
                    NavigationLink {
                        WSOProfileView(viewModel: WSOUserViewModel(userID: 14093))
                    } label: {
                        Text("Tasis Gemmill-Nexon - tsg2@williams.edu")
                    }
                    NavigationLink {
                        WSOProfileView(viewModel: WSOUserViewModel(userID: 13963))
                    } label: {
                        Text("Olivia Johnson - oj2@williams.edu")
                    }
                    NavigationLink {
                        WSOProfileView(viewModel: WSOUserViewModel(userID: 16531))
                    } label: {
                        Text("Kaileen So - kws4@williams.edu")
                    }
                    NavigationLink {
                        WSOProfileView(viewModel: WSOUserViewModel(userID: 15758))
                    } label: {
                        Text("Dylan Shepherd - das8@williams.edu")
                    }
                    NavigationLink {
                        WSOProfileView(viewModel: WSOUserViewModel(userID: 14703))
                    } label: {
                        Text("Peter Refermat - pdr1@williams.edu")
                    }
                    NavigationLink {
                        WSOProfileView(viewModel: WSOUserViewModel(userID: 14884))
                    } label: {
                        Text("David Alfaro - daa2@williams.edu")
                    }
                    NavigationLink {
                        WSOProfileView(viewModel: WSOUserViewModel(userID: 14017))
                    } label: {
                        Text("Ramio Ramirez - rr16@williams.edu")
                    }
                    NavigationLink {
                        WSOProfileView(viewModel: WSOUserViewModel(userID: 16548))
                    } label: {
                        Text("Arjun Patel - amp20@williams.edu")
                    }
                    NavigationLink {
                        WSOProfileView(viewModel: WSOUserViewModel(userID: 15056))
                    } label: {
                        Text("Nicolas Gonzalez - ng15@williams.edu")
                    }
                    NavigationLink {
                        WSOProfileView(viewModel: WSOUserViewModel(userID: 13997))
                    } label: {
                        Text("Alexia King - amk10@williams.edu")
                    }
                    NavigationLink {
                        WSOProfileView(viewModel: WSOUserViewModel(userID: 13899))
                    } label: {
                        Text("Bri Kang - bmk6@williams.edu")
                    }
                    NavigationLink {
                        WSOProfileView(viewModel: WSOUserViewModel(userID: 15435))
                    } label: {
                        Text("Logan Spaleta - ls24@williams.edu")
                    }
                    NavigationLink {
                        WSOProfileView(viewModel: WSOUserViewModel(userID: 15571))
                    } label: {
                        Text("Olivia Thorton - ort1@williams.edu")
                    }
                    NavigationLink {
                        WSOProfileView(viewModel: WSOUserViewModel(userID: 14085))
                    } label: {
                        Text("Andrew Gu - amg11@williams.edu")
                    }
                    NavigationLink {
                        WSOProfileView(viewModel: WSOUserViewModel(userID: 14049))
                    } label: {
                        Text("Jenna Shuffelton - jms13@williams.edu")
                    }
                    NavigationLink {
                        WSOProfileView(viewModel: WSOUserViewModel(userID: 15508))
                    } label: {
                        Text("Addison Kiewert - amk12@williams.edu")
                    }
                    NavigationLink {
                        WSOProfileView(viewModel: WSOUserViewModel(userID: 15915))
                    } label: {
                        Text("Alex Chao - ac48@williams.edu")
                    }
                    NavigationLink {
                        WSOProfileView(viewModel: WSOUserViewModel(userID: 14737))
                    } label: {
                        Text("Alex Moon - ahm2@williams.edu")
                    }
                    NavigationLink {
                        WSOProfileView(viewModel: WSOUserViewModel(userID: 15585))
                    } label: {
                        Text("Tiffany Zheng - tz10@williams.edu")
                    }
                    NavigationLink {
                        WSOProfileView(viewModel: WSOUserViewModel(userID: 16213))
                    } label: {
                        Text("Marlene Ruiz - mdr3@williams.edu")
                    }
                    NavigationLink {
                        WSOProfileView(viewModel: WSOUserViewModel(userID: 14876))
                    } label: {
                        Text("Chris Pohlmann - cp15@williams.edu")
                    }
                    NavigationLink {
                        WSOProfileView(viewModel: WSOUserViewModel(userID: 16096))
                    } label: {
                        Text("Grey Warren - gbw1@williams.edu")
                    }
                    NavigationLink {
                        WSOProfileView(viewModel: WSOUserViewModel(userID: 14875))
                    } label: {
                        Text("Stella Leras - sl32@williams.edu")
                    }
                    Text("Cassie Aretsky - jsa1@williams.edu")
                    NavigationLink {
                        WSOProfileView(viewModel: WSOUserViewModel(userID: 16465))
                    } label: {
                        Text("Sarah Baker - sb25@williams.edu")
                    }
                    NavigationLink {
                        WSOProfileView(viewModel: WSOUserViewModel(userID: 13896))
                    } label: {
                        Text("Sam Drescher - srd6@williams.edu")
                    }
                    NavigationLink {
                        WSOProfileView(viewModel: WSOUserViewModel(userID: 14661))
                    } label: {
                        Text("Lauren Hall - lkh3@williams.edu")
                    }
                    NavigationLink {
                        WSOProfileView(viewModel: WSOUserViewModel(userID: 13745))
                    } label: {
                        Text("Chiaka Leilah Duruaku - cjd4@williams.edu")
                    }
                    NavigationLink {
                        WSOProfileView(viewModel: WSOUserViewModel(userID: 15004))
                    } label: {
                        Text("Kez Osei-Agyemang - ko6@williams.edu")
                    }
                    NavigationLink {
                        WSOProfileView(viewModel: WSOUserViewModel(userID: 14690))
                    } label: {
                        Text("Jack Allen Greenfield - jag21@williams.edu")
                    }
                    NavigationLink {
                        WSOProfileView(viewModel: WSOUserViewModel(userID: 14184))
                    } label: {
                        Text("Sam Wexler - saw9@williams.edu")
                    }
                    NavigationLink {
                        WSOProfileView(viewModel: WSOUserViewModel(userID: 14113))
                    } label: {
                        Text("Eliana Zitrin - edz1@williams.edu")
                    }
                    NavigationLink {
                        WSOProfileView(viewModel: WSOUserViewModel(userID: 15747))
                    } label: {
                        Text("Adhy Agarwala - aea3@williams.edu")
                    }
                    NavigationLink {
                        WSOProfileView(viewModel: WSOUserViewModel(userID: 16295))
                    } label: {
                        Text("Desiree Flores - dgf2@williams.edu")
                    }
                    Text("Lucinda Shafer - les7@williams.edu")
                    NavigationLink {
                        WSOProfileView(viewModel: WSOUserViewModel(userID: 14938))
                    } label: {
                        Text("Phaedra Salerno - pls4@williams.edu")
                    }
                    NavigationLink {
                        WSOProfileView(viewModel: WSOUserViewModel(userID: 15538))
                    } label: {
                        Text("Amirjon Ulmasov - au2@williams.edu")
                    }
                    NavigationLink {
                        WSOProfileView(viewModel: WSOUserViewModel(userID: 15895))
                    } label: {
                        Text("Sarah Sousa - sfs6@williams.edu")
                    }
                    NavigationLink {
                        WSOProfileView(viewModel: WSOUserViewModel(userID: 15677))
                    } label: {
                        Text("Faith Wendel - few2@williams.edu")
                    }
                    NavigationLink {
                        WSOProfileView(viewModel: WSOUserViewModel(userID: 14742))
                    } label: {
                        Text("Eniola Olabode - eo6@williams.edu")
                    }
                    NavigationLink {
                        WSOProfileView(viewModel: WSOUserViewModel(userID: 12501))
                    } label: {
                        Text("Simon Socolow - sms12@williams.edu")
                    }
                }
                Section("Special Mentions") {
                    NavigationLink {
                        WSOProfileView(viewModel: WSOUserViewModel(userID: 14046))
                    } label: {
                        Text("Dylan Safai - das5@williams.edu")
                    }
                    Text("Ye Shu - https://shuye.dev")
                    NavigationLink {
                        WSOProfileView(viewModel: WSOUserViewModel(userID: 5515))
                    } label: {
                        Text("Matthew Baya - mjb9@williams.edu")
                    }
                    NavigationLink {
                        WSOProfileView(viewModel: WSOUserViewModel(userID: 9487))
                    } label: {
                        Text("Dan Barowy - dwb1@williams.edu")
                    }
                    Text("Aidan Lloyd-Tucker - aidanlloydtucker@gmail.com")
                    Text("The many WSO developers of yore").italic(true)
                }
                NavigationLink("WSO is made possible by users like you. Thank you!") {
                    SneakyView()
                }
            }
            .task {
                logger.trace("Fetching WSO words...")
                await viewModel.loadWords()
                logger.trace("WSO words fetch complete")
            }
        }
    }
}

#Preview {
    AboutView()
        .environment(AuthManager.shared)
        .environment(NotificationManager.shared)
}
