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
                
                ForEach(model.users) { user in
                    
                    NavigationLink {
                        PostsListView(userId: user.id)
                    } label: {
                        VStack (alignment: .leading) {
                            Text(user.name)
                                .font(.title)
                            Text(user.email)
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
            .onAppear { model.fetchUsers() }
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
