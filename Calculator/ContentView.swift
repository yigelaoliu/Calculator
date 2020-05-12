//
//  ContentView.swift
//  connerRidus
//
//  Created by liu on 2020/5/7.
//  Copyright © 2020 laoliu. All rights reserved.
//

import SwiftUI

let buttonWidthFactor: CGFloat = 6
let screenWidthFactor: CGFloat = buttonWidthFactor * 4 + 5

struct ContentView: View {
    @State private var brain: CalcBrain = .left("0")
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                VStack(spacing: geo.size.width / screenWidthFactor) {
                    Spacer()
                    Text(self.brain.output)
                        .font(.system(size: geo.size.width / buttonWidthFactor * 1.5))
                        .foregroundColor(.white)
                        .minimumScaleFactor(0.5)
                        .padding(.trailing, geo.size.width / screenWidthFactor * 1.5)
                        .lineLimit(1)
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .trailing)
                    ButtonPadView(
                        brain: self.$brain,
                        spacing: geo.size.width / screenWidthFactor
                    ).padding(.bottom, geo.size.width / screenWidthFactor)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
            ContentView().previewDevice("iPhone 8")
            ContentView().previewDevice("iPhone SE")
        }
    }
}
