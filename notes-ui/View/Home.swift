//
//  ContentView.swift
//  notes-ui
//
//  Created by Besh P.Yogi on 24.11.22.
//

import SwiftUI

struct Home: View {
    @State var notes = [Note]()
    @State var showAdd = false
    var body: some View {
        NavigationView{
            List(self.notes){ note in
                Text("\(note.note)")
                    .padding(0)
            }//: List
            .sheet(isPresented: $showAdd, content: {
                AddNoteView()
            })
            .onAppear(perform: { fetchNotes()})
            .navigationTitle("Notes")
            .navigationBarItems(
                trailing: Button(action: {
                    showAdd.toggle()
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


extension Home{
    func fetchNotes(){
        let url = URL(string: "http://85.214.238.109:3000/notes")!
        
        let task = URLSession.shared.dataTask(with: url) { data, res, err in
            guard let data = data else { return }
            do{
                let notes = try JSONDecoder().decode([Note].self, from: data)
                self.notes = notes
                //debugPrint(String(data: data, encoding: .utf8))
            }catch{
                print(err ?? "Server is not found")
            }
            
        }
        task.resume()
    }
}
