//
//  WSOFacTrakProfView.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2026-02-07.
//

// a view for showing the page for any given prof.

import SwiftUI
import Kingfisher
import Logging

struct WSOFacTrakProfView: View {
    @Environment(\.logger) private var logger
    @Environment(\.openURL) private var openURL
    @Environment(AuthManager.self) private var authManager
    @Environment(NotificationManager.self) private var notificationManager

    let userViewModel: WSOUserViewModel
    let reviewsViewModel: WSOFacTrakReviewsViewModel
    let viewModel: WSOFacTrakProfViewModel
    let id: Int

    @State private var imageData: UIImage?

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
                         
                         Did you complete your FacTrak course review quota on desktop? If you did, and you can find this professor's page on the desktop site, please contact WSO for help.
                         """)
                        .navigationTitle("Professor Page #\(id)")

                }.refreshable {
                    await viewModel.forceRefresh()
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                }.padding(20)
            } else {
                List {
                    Section {
                        VStack {
                            Group {
                                if let image = imageData {
                                    Image(uiImage: image)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                                        .frame(width: 200, height: 200)
                                } else {
                                    ProgressView()
                                        .frame(width: 200, height: 200)
                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                                }
                            }.task(id: userViewModel.data?.unixID) {
                                guard let unixID = userViewModel.data?.unixID else { return }
                                let key = "\(userViewModel.userID).jpg"

                                    // check memory
                                if let cached = ImageCache.default.retrieveImageInMemoryCache(forKey: key) {
                                    imageData = cached
                                    return
                                }
                                
                                    // check disk
                                let diskResult = try? await ImageCache.default.retrieveImage(forKey: key)
                                if let diskImage = diskResult?.image {
                                    imageData = diskImage
                                    return
                                }
                                
                                    // fetch
                                guard let data = try? await WSOGetUserImage(unix: unixID),
                                      let image = UIImage(data: data) else { return }
                                
                                imageData = image
                                do {
                                    try await ImageCache.default.store(image, forKey: key, toDisk: true)
                                } catch {
                                    logger.error("Failed to cache image for Unix \(unixID), WSO ID \(userViewModel.userID). Error: \(error.localizedDescription)")
                                }
                            }
                            HStack {
                                Text(userViewModel.data?.name ?? "Loading...").bold()
                                Text("(Professor)").italic()
                            }
                            if let title = viewModel.data?.title {
                                Text(title).font(.headline)
                            }
                        }.frame(maxWidth: .infinity, alignment: .center)
                        VStack(alignment: .leading) {
                            Text("**Total Reviews:** \(viewModel.data?.factrakSurveys.count.description ?? "N/A")")
                            if let rates = viewModel.ratings {
                                Text("- **\((rates.avgWouldRecommendCourse * 100.0).rounded().formatted())%** would recommend this professor's courses.")
                                Text("- **\((rates.avgWouldTakeAnother * 100.0).rounded().formatted())%** would take another course with this professor.")
                            }
                        }
                    }
                    if let content = viewModel.data {
                        ForEach(content.factrakSurveys, id: \.id) { review in
                            Section {
                                VStack(alignment: .leading) {
                                    HStack {
                                        Text("\(review.course.areaOfStudy.abbreviation) \(review.course.number)")
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
                                            destination: WSOFacTrakCourseView(
                                                viewModel: WSOFacTrakReviewsViewModel(
                                                    id: review.courseID,
                                                    type: .Course
                                                ),
                                                name: "\(review.course.areaOfStudy.abbreviation) \(review.course.number)",
                                                id: review.courseID
                                            )
                                        ) {
                                            Image(systemName: "studentdesk")
                                            Text("View reviews for this course...")
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
                        if content.factrakSurveys.isEmpty {
                            Text("(No reviews for this professor)")
                        }
                    } else if let err = reviewsViewModel.error {
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
            await userViewModel.fetchIfNeeded()
            await reviewsViewModel.fetchIfNeeded()
        }
        .refreshable {
            await viewModel.forceRefresh()
            await userViewModel.forceRefresh()
            await reviewsViewModel.forceRefresh()
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                HStack {
                    NavigationLink(destination: WSOFacTrakProfKeyView()) {
                        Image(systemName: "questionmark")
                    }.simultaneousGesture(TapGesture().onEnded {
                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    })
                }
            }
        }
        .navigationTitle("Professor Reviews")
        .modifier(NavSubtitleIfAvailable(subtitle: "Reviews may not be truthful nor helpful"))
        .listStyle(.sidebar)
    }
}
