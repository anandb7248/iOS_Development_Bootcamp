//
//  ContentView.swift
//  Business_Card
//
//  Created by Anand Batjargal on 1/20/20.
//  Copyright © 2020 anandbatjargal. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack{
            Color(red:0.04, green:0.52, blue:0.89)
                .edgesIgnoringSafeArea(.all)
            VStack {
                Image("pic")
                    .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                    .overlay(
                        Circle()
                            .stroke(Color.white, lineWidth: 5))
                Text("Anand Batjargal")
                    .font(Font.custom("Oswald", size: 40))
                    .foregroundColor(.white)
                Text("Software Developer")
                    .foregroundColor(.white).font(.system(size: 25))
                Divider()
                InfoView(text: "415-933-7248", iconName: "phone.fill")
                InfoView(text: "anandb7248@gmail.com", iconName: "envelope.fill")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
