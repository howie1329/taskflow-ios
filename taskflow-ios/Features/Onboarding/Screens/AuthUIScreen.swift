//
//  AuthUIScreen.swift
//  taskflow-ios
//
//  Created by Howard Thomas on 5/5/25.
//

import SwiftUI

struct AuthUIScreen: View {
    @Binding var isLoggin:Bool
    var body: some View {
        Text("Auth UI Screen")
        Button {
            isLoggin.toggle()
        } label: {
            Text("Press Me")
        }
        .buttonBorderShape(.roundedRectangle)

    }
}
