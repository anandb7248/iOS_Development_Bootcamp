//
//  ContentView.swift
//  Dicee_SwiftUI
//
//  Created by Anand Batjargal on 1/20/20.
//  Copyright © 2020 anandbatjargal. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State var leftDiceNum = 1
    @State var rightDiceNum = 1
    
    var body: some View {
        ZStack {
            Image("background")
                .resizable()
                .edgesIgnoringSafeArea(.all)
            VStack {
                Image("diceeLogo")
                Spacer()
                HStack {
                    DiceView(diceNumber: leftDiceNum)
                    DiceView(diceNumber: rightDiceNum)
                }.padding(.horizontal)
                Spacer()
                Button(action: {
                    self.leftDiceNum = Int.random(in: 1 ... 6)
                    self.rightDiceNum = Int.random(in: 1 ... 6)
                }) {
                    Text("Roll")
                        .font(.system(size: 50))
                        .fontWeight(.heavy).foregroundColor(.white).padding()
                }.background(Color.red)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct DiceView: View {
    let diceNumber: Int
    
    var body: some View {
        Image("dice\(diceNumber)")
            .resizable()
            .aspectRatio(1, contentMode: .fit)
            .padding()
    }
}
