//
//  InfoView.swift
//  Business_Card
//
//  Created by Anand Batjargal on 1/20/20.
//  Copyright © 2020 anandbatjargal. All rights reserved.
//

import SwiftUI

struct InfoView: View {
    let text: String
    let iconName: String
    
    var body: some View {
        RoundedRectangle(cornerRadius: 25)
            .fill(Color.white)
            .frame(height: 50)
            .overlay(HStack {
                Image(systemName: iconName).foregroundColor(Color(red:0.04, green:0.52, blue:0.89))
                Text(text)
            })
            .padding(.all)
    }
}

struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        InfoView(text: "Test", iconName: "phone.fill")
    }
}
