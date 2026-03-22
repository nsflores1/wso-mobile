//
//  AboutView.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2025-11-23.
//

import SwiftUI
import Logging
import Shimmer

// abstracting view to save doing all the same boilerplate again
// for every single entry. this reduces LoC significantly
// the special value 0 for int deactivates the auth gate and email (for alumni)
struct AboutPersonView: View {
    let name: String
    let email: String
    let idNum: Int

    var body: some View {
        if idNum == 0 {
            HStack {
                Text(name)
                Spacer()
            }
        } else {
            NavigationLink {
                AuthGate {
                    WSOProfileView(viewModel: WSOUserViewModel(userID: idNum))
                }
            } label: {
                VStack {
                    HStack {
                        Text(name)
                        Spacer()
                    }
                    HStack {
                        Text(email)
                            .foregroundStyle(Color(.accent))
                            .font(.footnote)
                        Spacer()
                    }
                }
            }
        }
    }
}

struct AboutView: View {
    @Environment(\.logger) private var logger
    @State private var viewModel = AboutViewModel()
    @Environment(AuthManager.self) private var authManager

    @AppStorage("secretEnabled") private var secretEnabled: Bool = false

    let devList: [(String, String, Int)] =
    [
        ("Nathaniel Flores", "nsf1@williams.edu", 14643),
        ("Charlie Tharas", "cmt8@wiliams.edu", 14774),
        ("Nathan Vosburg", "nvj1@williams.edu", 14656)
    ]

    let appArtistList: [(String, String, Int)] =
    [
        ("Emma Li", "ebl2@williams.edu", 14916)
    ]

    let testersList: [(String, String, Int)] =
    [
        ("Nathaniel Flores (595 Tests)", "nsf1@williams.edu", 14643),
        ("Jenna Shuffelton (316 Tests)", "jms13@williams.edu", 14643),
        ("Addison Kiewert (244 Tests)", "amk12@williams.edu", 15508),
        ("Tiffany Zheng (207 Tests)", "tz10@williams.edu", 15585),
        ("Marlene Ruiz (192 Tests)", "mdr3@williams.edu", 16213),
        ("Chris Pohlmann (189 Tests)", "cp15@williams.edu", 14876),
        ("Alex Moon (150 Tests)", "ahm2@williams.edu", 14737),
        ("Stella Leras (147 Tests)", "sl32@williams.edu", 14875),
        ("Sarah Baker (142 Tests)", "sb25@williams.edu", 16465),
        ("Alex Chao (98 Tests)", "ac48@williams.edu", 15915),
        ("Sam Drescher (96 Tests)", "srd6@williams.edu", 13896),
        ("Lauren Hall (80 Tests)", "lkh3@williams.edu", 14661),
        ("Grey Warren (67 Tests)", "gbw1@williams.edu", 16096),
        ("Eleanor Race (62 Tests)", "epr3@williams.edu", 15346),
        ("Chiaka Leilah Duruaku (61 Tests)", "cjd4@williams.edu", 13745),
        ("Olivia Johnson (52 Tests)", "oj2@williams.edu", 13963),
        ("Nathan Vosburg (52 Tests)", "nvj1@williams.edu", 14656),
        ("Tasis Gemill-Nexon (50 Tests)", "tsg2@williams.edu", 14093),
        ("Leo Margolies (50 Tests)", "lsm4@williams.edu", 14154),
        ("Elsie Qiu (44 Tests)", "", 0),
        ("Kaileen So (42 Tests)", "kws4@williams.edu", 16531),
        ("Eniola Olabode (40 Tests)", "eo6@williams.edu", 14742),
        ("Dylan Sheperd (31 Tests)", "das8@williams.edu", 15758),
        ("Eliana Zitrin (29 Tests)", "edz1@williams.edu", 14113),
        ("Jack Allen Greenfield (27 Tests)", "jag21@williams.edu", 14690),
        ("Amirjon Ulmasov (25 Tests)", "au2@williams.edu", 15538),
        ("Desiree Flores (25 Tests)", "dgf2@williams.edu", 16295),
        ("Kez Osei-Agyemang (25 Tests)", "ko6@williams.edu", 15004),
        ("Peter Refermat (25 Tests)", "pdr1@williams.edu", 14703),
        ("Ramio Ramirez (22 Tests)", "rr16@williams.edu", 14017),
        ("Phaedra Salerno (22 Tests)", "pls4@williams.edu", 14938),
        ("Sam Wexler (21 Tests)", "saw9@williams.edu", 14184),
        ("Adhy Agarwala (14 Tests)", "aea3@williams.edu", 15747),
        ("Faith Wendel (13 Tests)", "few2@williams.edu", 15677),
        ("Arjun Patel (12 Tests)", "amp20@williams.edu", 16548),
        ("David Alfaro (10 Tests)", "daa2@williams.edu", 14884)
    ]

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
                HStack(alignment: .center) {
                    Text(text.replacingOccurrences(of: "\n", with: ""))
                }.padding(.horizontal, 10)
            }
            List {
                Section("Lead Developers (2026-2027)") {
                    ForEach(devList, id: \.1) { dev in
                        AboutPersonView(name: dev.0, email: dev.1, idNum: dev.2)
                    }
                }
                Section("App Artists") {
                    ForEach(appArtistList, id: \.1) { artist in
                        AboutPersonView(name: artist.0, email: artist.1, idNum: artist.2)
                    }
                }
                Section("Student Beta Testers") {
                    ForEach(testersList, id: \.1) { tester in
                        AboutPersonView(name: tester.0, email: tester.1, idNum: tester.2)
                    }
                }
                Section("Special Mentions") {
                    Text("Anderson Flores (https://github.com/andersonf1), Jorge Flores, and Jennifer Flores, who also tested out the app over 148 times, contributed networking code and SQL advice, and provided moral support")
                    AboutPersonView(name: "Dylan Safai, for providing WSU's support to this app's development", email: "das5@williams.edu", idNum: 14046)
                    Text("Ye Shu - https://shuye.dev, for writing a bunch of useful documentation that made all of this possible")
                    AboutPersonView(name: "Matthew Baya, for helping to maintain WSO infrastructure and providing hardware", email: "mjb9@williams.edu", idNum: 5515)
                    AboutPersonView(name: "Professor Dan Barowy for some code review and brainstorming of some app functionality", email: "dwb1@williams.edu", idNum: 9487)
                    AboutPersonView(name: "Aidan Lloyd-Tucker, for writing the prior app implementation, which I used as a baseline for this one", email: "aidanlloydtucker@gmail.com", idNum: 0)
                    Text("The many WSO developers of yore").italic(true)
                }
                // EASTER EGG
                if secretEnabled {
                    Text("Most importantly, WSO is made possible by users like you. Thank you!")
                    NavigationLink {
                        SneakyView()
                    } label: {
                        Text("Nothing to see here...")
                            .shimmering()
                    }
                } else {
                    NavigationLink {
                        EtherialView()
                    } label: {
                        Text("Most importantly, WSO is made possible by users like you. Thank you!")
                    }
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
