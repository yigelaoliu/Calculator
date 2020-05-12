//
//  ButtonView.swift
//  connerRidus
//
//  Created by liu on 2020/5/8.
//  Copyright © 2020 laoliu. All rights reserved.
//

import SwiftUI

struct ButtonView: View {
    let item: ButtonItem
    let width: CGFloat
    let height: CGFloat
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Group {
                if item.isText {
                    Text(item.title)
                } else {
                    Image(systemName: item.title)
                }
            }
            .foregroundColor(.white)
            .font(.system(size: width * item.fontSizeScale))
            .frame(width: width, height: height)
            .background(item.backgroundColor)
            .cornerRadius(height * 0.5)
        }
    }
}

struct ButtonRowView: View {
    @Binding var brain: CalcBrain
    
    let row: [ButtonItem]
    let spacing: CGFloat
    
    var body: some View {
        HStack(spacing: spacing) {
            ForEach(row, id: \.self) { item in
                ButtonView(
                    item: item,
                    width: self.spacing * buttonWidthFactor,
                    height: self.spacing * buttonWidthFactor
                ) {
                    self.brain = self.brain.apply(item: item)
                    print(item.title)
                }
            }
        }
    }
}

struct ButtonPadView: View {
    @Binding var brain: CalcBrain
    
    let pad: [[ButtonItem]] = [
        [.command(.clear), .command(.flip),
         .command(.percent), .op(.divide)],
        [.digit(7), .digit(8), .digit(9), .op(.multiply)],
        [.digit(4), .digit(5), .digit(6), .op(.minus)],
        [.digit(1), .digit(2), .digit(3), .op(.plus)],
        [.back, .digit(0), .dot, .op(.equal)],
    ]
    let spacing: CGFloat
    
    var body: some View {
        VStack(spacing: spacing) {
            ForEach(pad, id: \.self) { row in
                ButtonRowView(
                    brain: self.$brain,
                    row: row,
                    spacing: self.spacing)
            }
        }
    }
}


struct ButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ButtonView(
            item: .op(.plus),
            width: 80,
            height: 80
        ) {
            print("+")
        }
    }
}
