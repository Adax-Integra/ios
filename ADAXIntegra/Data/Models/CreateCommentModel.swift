//
//  CreateCommentModel.swift
//  ADAXIntegra
//
//  Created by Oscar Alexander Vilchis Soto on 07/10/26.
//
//  Encodable request body for POST a comment (us b-02)
//

import Foundation

// Body sent in POST request
struct CreateCommentModel: Encodable {
    let content: String
}
