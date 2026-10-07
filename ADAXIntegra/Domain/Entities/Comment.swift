//
//  Comment.swift
//  ADAXIntegra
//
//  Created by Oscar Alexander Vilchis Soto on 07/10/26.
//
// Entity that tepresents the entities for case comments and author information

import Foundation

// Represents a comment  in a particular case  Identifiable is used for  tracking each item using  a unique id
struct Comment: Identifiable {
    let id: String
    let caseId: String
    let content: String
    let timeSent: Date
    let author: CommentAuthor
}

// Represents the author details of a comment
struct CommentAuthor {
    let userId: String
    let name: String
    let lastName: String

    // We assign formats and returns the author's full name
    var fullName: String {
        let full = "\(name) \(lastName)".trimmingCharacters(in: .whitespaces)
        return full.isEmpty ? "Usuario" : full
    }
}
