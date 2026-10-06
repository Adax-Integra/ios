//
//  CodeInputField.swift
//  ADAXIntegra
//
//  Created by Nicolas Bravo Miguel on 06/10/26.
//


import SwiftUI

struct CodeInputField: View {
    @Binding var code: String
    var length: Int = 6
    var hasError: Bool = false
    
    @FocusState private var isFocused: Bool
    
    var body: some View {
        ZStack {
            TextField("", text: $code)
                .keyboardType(.numberPad)
                .textContentType(.oneTimeCode)
                .focused($isFocused)
                .opacity(0.01)
            // keep only number and no more lenght
                .onChange(of: code) { _, newValue in
                    let digits = String(newValue.filter(\.isNumber).prefix(length))
                    if digits != newValue { code = digits }
                }
            
            HStack(spacing: 10) {
                ForEach(0..<length, id: \.self) { index in
                    CodeDigitBox(
                        digit: digit(at: index),
                        isFocused: isFocused && index == min(code.count, length - 1),
                        hasError: hasError
                    )
                    
                }
            }
            .contentShape(Rectangle())
            .onTapGesture { isFocused = true }
        }
    }
    
    // Returns the digit typed in that position, and leaves it empty when there is no digit
    
    private func digit(at index: Int) -> String {
        guard index < code.count else { return "" }
        return String(code[code.index(code.startIndex, offsetBy: index)])
    }
}


#Preview {
    VStack(spacing: 24) {
        CodeInputField(code: .constant("47"))
        CodeInputField(code: .constant("123456"), hasError: true)
    }
    .padding()
    .background(Color("Background"))
}


