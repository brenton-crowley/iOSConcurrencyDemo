//
//  PostsListView.swift
//  iOSConcurrencyDemo
//
//  Created by Brent Crowley on 11/6/2022.
//

import SwiftUI

struct PostsListView: View {
    
    @EnvironmentObject private var model:PostsListViewModel
    
    var userId: Int?
    
    var body: some View {
        List {
            
            ForEach(model.posts) { post in
                VStack (alignment: .leading) {
                    Text(post.title)
                        .font(.headline)
                    Text(post.body)
                        .font(.callout)
                        .foregroundColor(.secondary)
                }
            }
            
        }
        .overlay(content: {
            if model.isLoading { ProgressView("Loading Posts") }
        })
        .alert("Application Error",
               isPresented: $model.showAlert,
               actions: {
            Button("OK") {}
        },
               message: {
            if let message = model.errorMessage { Text(message) }
        })
        .navigationTitle("Posts")
        .navigationBarTitleDisplayMode(.inline)
        .listStyle(.plain)
        .task {
            model.userId = userId
            await model.fetchPosts() }
    }
}

struct PostsListView_Previews: PreviewProvider {
    static var previews: some View {
        
        NavigationView {        
            PostsListView(userId: 1)
                .environmentObject(PostsListViewModel(forPreview: true))
        }
        
    }
}
