//
//  UsersListView.swift
//  iOSConcurrencyDemo
//
//  Created by Brent Crowley on 11/6/2022.
//

import SwiftUI

struct UsersListView: View {
    
    @EnvironmentObject private var model:UsersListViewModel
    
    var body: some View {
        NavigationView {
            
            List {
                
                ForEach(model.userAndPosts) { userAndPosts in
                    
                    NavigationLink {
                        PostsListView(posts: userAndPosts.posts)
                    } label: {
                        VStack (alignment: .leading) {
                            HStack {
                                Text(userAndPosts.user.name)
                                    .font(.title)
                                Spacer()
                                Text("(\(userAndPosts.numberOfPosts))")
                            }
                            Text(userAndPosts.user.email)
                        }
                    }
                }
            }
            .overlay(content: {
                if model.isLoading { ProgressView() }
            })
            .alert("Application Error", isPresented: $model.showAlert, actions: {
                Button("OK") {}
            }, message: {
                if let errorMessage = model.errorMessage {
                    Text(errorMessage)
                }
            })
            .navigationTitle("Users")
            .listStyle(.plain)
            .task {
                await model.fetchUsers()
            }
        }
        .environmentObject(PostsListViewModel())
    }
}

struct UsersListView_Previews: PreviewProvider {
    static var previews: some View {
        UsersListView()
            .environmentObject(UsersListViewModel(forPreview: true))
    }
}
