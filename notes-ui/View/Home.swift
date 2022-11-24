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
    @State var updateNote = ""
    @State var updateNoteId = ""
    
    @State var isEditMode: EditMode = .inactive
    
    var alert: Alert{
        Alert(title: Text("Delete"), message: Text("Are you sure you want to delete this note"), primaryButton: .destructive(Text("Delete"), action: deleteNode), secondaryButton: .cancel())
    }
    var body: some View {
        NavigationView{
            List(self.notes){ note in
                if(self.isEditMode == .inactive){
                    Text("\(note.note)")
                        .padding(0)
                        .onLongPressGesture {
                            self.showAlert.toggle()
                            deleteItem = note
                        }
                }else{
                    HStack{
                        Image(systemName: "pencil.circle.fill")
                            .foregroundColor(.yellow)
                        Text(note.note)
                            .padding()
                    }//:Hstack
                    .onTapGesture {
                        self.updateNote = note.note
                        self.updateNoteId = note._id
                        self.showAdd.toggle()
                    }
                }
            }//: List
            .alert(isPresented: $showAlert, content: { alert })
            .sheet(isPresented: $showAdd, onDismiss: fetchNotes ,content: {
                if (self.isEditMode == .inactive){
                    AddNoteView()
                }else{
                    UpdateNoteView(text: $updateNote, noteId: $updateNoteId)
                }
            })
            .onAppear(perform: { fetchNotes()})
            .navigationTitle("Notes")
            .navigationBarItems(
                leading: Button(action: {
                    if (self.isEditMode == .inactive){
                        self.isEditMode = .active
                    }else{
                        self.isEditMode = .inactive
                    }
                                    }, label: {
                    if (self.isEditMode == .inactive){
                        Text("Edit")
                    }else{
                        Text("Done")
                    }
                }),
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
        
        if (self.isEditMode == .active){
            self.isEditMode = .inactive
        }
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
