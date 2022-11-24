//
//  UpdateNoteView.swift
//  notes-ui
//
//  Created by Besh P.Yogi on 24.11.22.
//

import SwiftUI

struct UpdateNoteView: View {
    @Binding var text: String
    @Binding var noteId: String
    
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        HStack{
            TextField("Update a note...", text: $text)
                .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                .clipped()
            Button(action: updateNote) {
                Text("Update")
            }
            .padding(8)
        }//:stack
    }
}

extension UpdateNoteView{
    func updateNote(){
        let params = ["note" : text] as [String: Any]
        
        let url = URL(string: "http://85.214.238.109:3000/notes/\(noteId)")!
        
        let session = URLSession.shared
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "PATCH" // method is post
        //Serialize the input data
        do{
            request.httpBody = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
        }catch{
            debugPrint(error)
        }
        
        // Defining the data
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = session.dataTask(with: request) { data, res, err in
            guard err == nil else { return }
            guard let data = data else { return }
            do{
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any]{
                    
                    debugPrint(json)
                }
            }catch{
                debugPrint(err ?? "Notes can not be post")
            }
        }
        task.resume()
        
        self.text = ""
        presentationMode.wrappedValue.dismiss()
    }
}
