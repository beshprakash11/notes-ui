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
    
    @State var showAlert = false
    @State var deleteItem: Note?
    
    var alert: Alert{
        Alert(title: Text("Delete"), message: Text("Are you sure you want to delete this note"), primaryButton: .destructive(Text("Delete"), action: deleteNode), secondaryButton: .cancel())
    }
    var body: some View {
        NavigationView{
            List(self.notes){ note in
                Text("\(note.note)")
                    .padding(0)
                    .onLongPressGesture {
                        self.showAlert.toggle()
                        deleteItem = note
                    }
            }//: List
            .alert(isPresented: $showAlert, content: { alert })
            .sheet(isPresented: $showAdd, onDismiss: fetchNotes ,content: {
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
    
    func deleteNode(){
        guard let id = deleteItem?._id else { return }
        let url = URL(string: "http://85.214.238.109:3000/notes/\(id)")!
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "DELETE"
        
        let task = URLSession.shared.dataTask(with: request) { data, res, err in
            guard err == nil else { return }
            guard let data = data else { return }
            
            do{
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any]{
                    
                    debugPrint(json)
                }
            }catch{
                debugPrint(err ?? "Notes can not be delete")
            }
        }
        task.resume()
        
        fetchNotes()
    }
}
