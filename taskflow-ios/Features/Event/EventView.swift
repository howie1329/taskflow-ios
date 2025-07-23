//
//  EventView.swift
//  taskflow-ios
//
//  Created by Howard Thomas on 7/3/25.
//

import SwiftUI

struct EventView: View {
    @State var isPresented: Bool = false
    var body: some View {
        ZStack{
            VStack{
                Text("Event View")
                Button("Present Modal") {
                    isPresented.toggle()
                }
            }
            if isPresented {
                
                ZStack {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                    VStack {
                        Text("Modal View")
                        Button("Close Modal"){
                            isPresented.toggle()
                        }
                    }
                    .background(Color.white)
                }
            }
        }
    }
}

extension View {
    func eventViewSheet(isPresented:Binding<Bool>) -> some View {
        self.sheet(isPresented: isPresented) {
            NavigationView{
                EventView()
            }
        }
    }
}



#Preview {
    EventView()
}
