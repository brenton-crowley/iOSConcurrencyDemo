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
        .navigationTitle("Posts")
        .navigationBarTitleDisplayMode(.inline)
        .listStyle(.plain)
        .onAppear {
            model.userId = userId
            model.fetchPosts() }
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
