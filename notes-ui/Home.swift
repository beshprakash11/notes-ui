//
//  ContentView.swift
//  notes-ui
//
//  Created by Besh P.Yogi on 24.11.22.
//

import SwiftUI

struct Home: View {
    var body: some View {
        NavigationView{
            List(0..<9){ i in
                Text("Hello, world \(i)")
                    .padding(0)
            }//: List
            .navigationTitle("Notes")
            .navigationBarItems(
                trailing: Button(action: {
                    debugPrint("Add notes")
                }, label: {
                    Text("Add")
                })
                
            )
        }//:NavView
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
