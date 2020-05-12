//
//  ButtonItem.swift
//  connerRidus
//
//  Created by liu on 2020/5/7.
//  Copyright © 2020 laoliu. All rights reserved.
//

import Foundation
import SwiftUI

enum ButtonItem {
    enum Op: String {
        case plus, minus, multiply, divide, equal
    }
    
    enum Command: String {
        case clear = "AC"
        case flip = "plus.slash.minus"
        case percent
    }
    
    case digit(Int)
    case dot
    case back
    case op(Op)
    case command(Command)
}

extension ButtonItem {
    var isText: Bool {
        switch self {
        case .digit, .dot:
            return true
        case .command(let command):
            if command == .clear {
                return true
            } else {
                return false
            }
        default:
            return false
        }
    }
    
    var title: String {
        switch self {
        case .digit(let value):
            return String(value)
        case .dot:
            return "."
        case .back:
            return "arrow.left"
        case .op(let op):
            return op.rawValue
        case .command(let command):
            return command.rawValue
        }
    }
    
    var size: CGSize {
        CGSize(width: 88, height: 88)
    }
    
    var fontSizeScale: CGFloat {
        switch self {
        case .digit:
            return 0.45
        default:
            if isText {
                return 0.38
            } else {
                return 0.30
            }
        }
    }
    
    var backgroundColor: Color {
        switch self {
        case .digit, .dot, .back:
            return Color(red: 0.3, green: 0.3, blue: 0.3)
        case .op:
            return .orange
        case .command:
            return .gray
        }
    }
}

extension ButtonItem: Hashable {}
