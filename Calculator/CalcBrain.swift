//
//  CalcBrain.swift
//  connerRidus
//
//  Created by liu on 2020/5/8.
//  Copyright © 2020 laoliu. All rights reserved.
//

import Foundation

var userIsInMiddleOfTyping = true

var formatter: NumberFormatter = {
    let f = NumberFormatter()
    f.minimumFractionDigits = 0
    f.maximumFractionDigits = 8
    f.numberStyle = .decimal
    
    return f
}()

enum CalcBrain {
    case left(String)
    case leftOp(left: String, op: ButtonItem.Op)
    case leftOpRight(left: String, op: ButtonItem.Op, right: String)
    case error
    
    var output: String {
        let result: String
        
        switch self {
        case .left(let left):
            result = left
        case .leftOp(let left, _):
            result = left
        case .leftOpRight(_, _, let right):
            result = right
        case .error:
            return "Error"
        }
        
        guard let value = Double(result) else {
            return "Error"
        }
        
        if userIsInMiddleOfTyping {
            return result
        } else {
            return formatter.string(from: value as NSNumber)!
        }
    }
    
    func apply(item: ButtonItem) -> CalcBrain {
        switch item {
        case .digit(let num):
            userIsInMiddleOfTyping = true
            return apply(num: num)
        case .dot:
            userIsInMiddleOfTyping = true
            return applyDot()
        case .back:
            userIsInMiddleOfTyping = false
            return applyBack()
        case .op(let op):
            userIsInMiddleOfTyping = false
            return apply(op: op)
        case .command(let command):
            userIsInMiddleOfTyping = false
            return apply(command: command)
        }
    }
    
    private func apply(num: Int) -> CalcBrain {
        switch self {
        case .left(let left):
            return .left(left.apply(num: num))
        case .leftOp(let left, let op):
            return .leftOpRight(left: left, op: op, right: "0".apply(num: num))
        case .leftOpRight(let left, let op, let right):
            return .leftOpRight(left: left, op: op, right: right.apply(num: num))
        case .error:
            return .left("0".apply(num: num))
        }
    }
    
    private func applyDot() -> CalcBrain {
        switch self {
        case .left(let left):
            return .left(left.applyDot())
        case .leftOp(let left, let op):
            return .leftOpRight(left: left, op: op, right: "0".applyDot())
        case .leftOpRight(let left, let op, let right):
            return .leftOpRight(left: left, op: op, right: right.applyDot())
        case .error:
            return .left("0".applyDot())
        }
    }
    
    private func applyBack() -> CalcBrain {
        switch self {
        case .left(let left):
            return .left(left.applyBack())
        case .leftOp(let left, _):
            return .left(left.applyBack())
        case .leftOpRight(let left, let op, let right):
            return .leftOpRight(left: left, op: op, right: right.applyBack())
        case .error:
            return .left("0")
        }
    }
    
    private func apply(op: ButtonItem.Op) -> CalcBrain {
        switch self {
        case .left(let left):
            switch op {
            case .plus, .minus, .multiply, .divide:
                return .leftOp(left: left, op: op)
            case .equal:
                return self
            }
        case .leftOp(let left, _):
            switch op {
            case .plus, .minus, .multiply, .divide:
                return .leftOp(left: left, op: op)
            case .equal:
                return .left(left)
            }
        case .leftOpRight(let left, let currentOp, let right):
            switch op {
            case .plus, .minus, .multiply, .divide:
                if let result = currentOp.calculate(l: left, r: right) {
                    return .leftOp(left: result, op: op)
                } else {
                    return .error
                }
            case .equal:
                if let result = currentOp.calculate(l: left, r: right) {
                    return .left(result)
                } else {
                    return .error
                }
            }
        case .error:
            return self
        }
    }
    
    private func apply(command: ButtonItem.Command) -> CalcBrain {
        switch command {
        case .clear:
            return .left("0")
        case .flip:
            switch self {
            case .left(let left):
                return .left(left.flipped())
            case .leftOp(let left, let op):
                return .leftOpRight(left: left, op: op, right: "-0")
            case .leftOpRight(left: let left, let op, let right):
                return .leftOpRight(left: left, op: op, right: right.flipped())
            case .error:
                return .left("-0")
            }
        case .percent:
            switch self {
            case .left(let left):
                return .left(left.percentaged())
            case .leftOp:
                return self
            case .leftOpRight(left: let left, let op, let right):
                return .leftOpRight(left: left, op: op, right: right.percentaged())
            case .error:
                return .left("-0")
            }
        }
    }
}

extension String {
    var containsDot: Bool {
        return contains(".")
    }
    
    var startWithNegative: Bool {
        return starts(with: "-")
    }
    
    func apply(num: Int) -> String {
        return self == "0" ? "\(num)" : "\(self)\(num)"
    }
    
    func applyDot() -> String {
        return containsDot ? self : "\(self)."
    }
    
    func applyBack() -> String {
        if starts(with: "-") && self.count > 2 {
            var s = self
            s.removeLast()
            return s
        } else if !starts(with: "-") && self.count > 1 {
            var s = self
            s.removeLast()
            return s
        } else {
            return "0"
        }
    }
    
    func flipped() -> String {
        if startWithNegative {
            var s = self
            s.removeFirst()
            return s
        } else {
            return "-\(self)"
        }
    }
    
    func percentaged() -> String {
        return String(Double(self)! / 100)
    }
}

extension ButtonItem.Op {
    func calculate(l: String, r: String) -> String? {
        guard let left = Double(l), let right = Double(r) else {
            return nil
        }

        let result: Double?
        
        switch self {
        case .plus: result = left + right
        case .minus: result = left - right
        case .multiply: result = left * right
        case .divide: result = right == 0 ? nil : left / right
        case .equal: fatalError()
        }
        
        return result.map { String($0) }
    }
}
