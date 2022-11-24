//
//  Note.swift
//  notes-ui
//
//  Created by Besh P.Yogi on 24.11.22.
//

import SwiftUI

struct Note: Identifiable, Codable{
    var id: String { _id }
    var _id: String
    var note: String
}
