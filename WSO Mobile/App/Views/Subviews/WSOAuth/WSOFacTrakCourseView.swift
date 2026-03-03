//
//  WSOFacTrakCourseView.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2026-02-20.
//

// a view for showing the page for any given course.

import SwiftUI
import Kingfisher
import Logging

struct WSOFacTrakCourseView: View {
    @Environment(\.logger) private var logger
    @Environment(\.openURL) private var openURL
    @Environment(AuthManager.self) private var authManager
    @Environment(NotificationManager.self) private var notificationManager

    let viewModel: WSOFacTrakReviewsViewModel
    let name: String
    let id: Int

    var body: some View {
        NavigationStack {
            if let err = viewModel.error {
                Group {
                    Text(err.localizedDescription)
                        .foregroundStyle(Color.red)
                    Text("""
                         
                         Your attempt to access FacTrak has failed (probably due to not completing your review quota).
                         
                         You step in the stream,
                         but the water has moved on.
                         This page is not here.
                         
                         Did you complete your FacTrak course review quota on desktop? If you did, and you can find this course's page on the desktop site, please contact WSO for help.
                         """)
                        .navigationTitle("Course Page #\(id)")
                }.refreshable {
                    await viewModel.forceRefresh()
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                }.padding(20)
            } else {
                List {
                    if let content = viewModel.data {
                        ForEach(content) { review in
                            Section {
                                VStack(alignment: .leading) {
                                    HStack {
                                        Text(name)
                                        HStack {
                                            if let year = review.semesterYear {
                                                if let season = review.semesterSeason {
                                                    Text(verbatim: "(\(season.capitalized) of \(year))")
                                                } else {
                                                    Text(verbatim: "(\(year))")
                                                }
                                            } else {
                                                Text("(Unknown review semester)")
                                            }
                                        }
                                    }
                                    HStack {
                                        NavigationLink(
                                            destination: WSOFacTrakProfView(
                                                userViewModel: WSOUserViewModel(
                                                    userID: review.professorID,
                                                ),
                                                reviewsViewModel: WSOFacTrakReviewsViewModel(
                                                    id: review.professorID,
                                                    type: .Professor
                                                ),
                                                viewModel: WSOFacTrakProfViewModel(
                                                    id: review.professorID,
                                                ),
                                                id: review.professorID
                                            )
                                        ) {
                                            Image(systemName: "person")
                                            Text("View reviews for this professor...")
                                        }
                                        .buttonStyle(.plain)
                                        .foregroundStyle(Color.secondary)
                                    }
                                    // TODO: fix this on backend and this fixes itself
                                    if review.totalAgree != 0 && review.totalDisagree != 0 {
                                        HStack {
                                            Image(systemName: "hand.thumbsdown.filled.hand.thumbsup")
                                            Text("Agree: \(review.totalAgree),")
                                            Text("Disagree: \(review.totalDisagree)")
                                        }
                                    }
                                    if review.flagged {
                                        HStack {
                                            Image(systemName: "exclamationmark.octagon")
                                            Text("(This review has been flagged)")
                                                .italic()
                                        }
                                    }
                                    Divider()
                                    HStack {
                                        Text(review.comment)
                                    }.padding()
                                    if review.wouldRecommendCourse != nil || review.wouldTakeAnother != nil {
                                        Divider()
                                        if let recommend = review.wouldRecommendCourse {
                                            if recommend {
                                                HStack {
                                                    Image(systemName: "checkmark")
                                                        .foregroundStyle(.green)
                                                    Text("User *recommends* this course")
                                                }
                                            } else {
                                                HStack {
                                                    Image(systemName: "xmark")
                                                        .foregroundStyle(.red)
                                                    Text("User *does not recommend* this course")
                                                }
                                            }
                                        }

                                        if let another = review.wouldTakeAnother {
                                            if another {
                                                HStack {
                                                    Image(systemName: "checkmark")
                                                        .foregroundStyle(.green)
                                                    Text("User *would* take more courses")
                                                }
                                            } else {
                                                HStack {
                                                    Image(systemName: "xmark")
                                                        .foregroundStyle(.red)
                                                    Text("User *would not* take more courses")
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        if content.isEmpty {
                            Text("(No reviews for this course)")
                        }
                    } else if let err = viewModel.error {
                        Group {
                            Text(err.localizedDescription).foregroundStyle(Color.red)
                            Text("""
                                    
                                The Web site you seek
                                cannot be located but
                                endless more exist.
                                """)
                        }.padding(20)
                    } else {
                        ProgressView()
                    }
                }
            }
        }
        .task {
            await viewModel.fetchIfNeeded()
        }
        .refreshable {
            await viewModel.forceRefresh()
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                HStack {
                    NavigationLink(destination: WSOFacTrakAreaKeyView()) {
                        Image(systemName: "questionmark")
                    }.simultaneousGesture(TapGesture().onEnded {
                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    })
                }
            }
        }
        .navigationTitle("\(name) Reviews")
        .modifier(NavSubtitleIfAvailable(subtitle: "Reviews may not be truthful nor helpful"))
        .listStyle(.sidebar)
    }
}
