//
//  Logic.swift
//  Taschenrechner
//
//  Created by Kjell Behrends on 06.09.24.
//

import Foundation
class Logic : ObservableObject {
    @Published var displayNum: String
    @Published var displayCalculation: String
    private var number1: Float
    private var number2: Float
    private var operatorType: Operator

    init() {
        self.displayNum = ""
        self.displayCalculation = ""
        self.number1 = 0
        self.number2 = 0
        self.operatorType = .none
    }
    
    func numberInput(_ inputNumber: String) {
        if (displayNum.replacingOccurrences(of: " ", with: "") == "0" && inputNumber != ".") {
            displayNum = inputNumber
        } else if (displayNum.replacingOccurrences(of: ".", with: "").count <= 9) {
            displayNum += inputNumber
        }
        //Delets the previous calculation if the calculation result gets changed
        if operatorType == .none {
            displayCalculation = ""
        }
        changeActiveNumber((displayNum as NSString).floatValue)
    }

    func setOperator(_ op: Operator) {
        operatorType = op
        displayNum = ""
        setDisplayCalculation(1)
        if isMonoOperator(op) {
            result()
        } else {
            displayNum = ""
        }
    }

    func addDecimalPoint() {
        if displayNum.replacingOccurrences(of: " ", with: "").isEmpty { displayNum = "0" }
        if !displayNum.contains(".") && displayNum.count < 9 {
            displayNum += "."
        }
        changeActiveNumber((displayNum as NSString).floatValue)
    }

    func clear() {
        number1 = 0
        number2 = 0
        operatorType = .none
        displayNum = ""
        displayCalculation = ""
    }

    func deleteChar() {
        if displayNum.count <= 1 {
            displayNum = ""
        } else {
            displayNum = String(displayNum.dropLast())
        }
        
        //Delets the previous calculation if a char of the calculation result is deleted
        if operatorType == .none {
            displayCalculation = ""
        }
        changeActiveNumber(Float(displayNum) ?? 0)
    }

    func switchSign() {
        if !displayNum.isEmpty {
            if displayNum.hasPrefix("-") {
                displayNum.removeFirst()
            } else {
                displayNum = "-" + displayNum
            }
            changeActiveNumber((displayNum as NSString).floatValue)
        }
        
        if operatorType == .none {
            displayCalculation = ""
        }
    }


    func result() {
        var result: Float
        switch operatorType {
        case .plus:
            result = number1 + number2
        case .minus:
            result = number1 - number2
        case .multi:
            result = number1 * number2
        case .divide:
            result = number1 / number2
        case .none:
            return
        case .power:
            result = pow(number1, number2)
        case .sqrt:
            result = sqrt(number1)
        case .sin:
            result = sin(number1 * .pi / 180)
        case .cos:
            result = cos(number1 * .pi / 180)
        case .tan:
            result = tan(number1 * .pi / 180)
        case .faculty:
            result = faculty(Int(number1))
        case .reciprocal:
            result = 1 / number1
        case .logarithm:
            result = log10(number1)
        case .modulo:
            result = number1.truncatingRemainder(dividingBy: number2)
        }
        
        //Show Result correctly
        displayNum = formatNumber(String(result))
        
        //Show calculation for the result
        setDisplayCalculation(2)
        
        if displayNum.contains("inf") || displayNum.contains("nan") {
            displayNum = ""
            number1 = 0
            displayNum = "Error"
        } else {
            number1 = Float(displayNum) ?? 0
        }
        
        number2 = 0
        operatorType = .none
    }

    private func isMonoOperator(_ op: Operator) -> Bool {
        return [.sqrt, .sin, .cos, .tan, .faculty, .reciprocal, .logarithm].contains(op)
    }

    private func changeActiveNumber(_ number: Float) {
        if operatorType == .none {
            number1 = number
        } else {
            number2 = number
        }
    }

    private func faculty(_ n: Int) -> Float {
        var result: Float = 1
        for i in 1...n {
            result *= Float(i)
        }
        return result
    }
    
    private func setDisplayCalculation(_ numberOfNumbers: Int) {
        if (numberOfNumbers == 1) {
            displayCalculation = formatNumber(String(number1)) + " " + getOperatorString()
        } else {
            displayCalculation = formatNumber(String(number1)) + " " + getOperatorString() + " " + formatNumber(String(number2))
        }
        
    }
    
    private func formatNumber(_ number: String) -> String {
        var result = number.replacingOccurrences(of: "0+$", with: "", options: .regularExpression) //Entfernt alle Nullen am Ende
        result = result.replacingOccurrences(of: "\\.$", with: "", options: .regularExpression) // Entfernt '.' falls es am Ende übrig bleibt
        return result
    }
    
    private func getOperatorString() -> String {
        switch operatorType {
        case .plus:
            return "+"
        case .minus:
            return "-"
        case .multi:
            return "×"
        case .divide:
            return "÷"
        case .power:
            return "^"
        case .sqrt:
            return "√"
        case .sin:
            return "sin"
        case .cos:
            return "cos"
        case .tan:
            return "tan"
        case .faculty:
            return "!"
        case .reciprocal:
            return "1/x"
        case .logarithm:
            return "log"
        case .modulo:
            return "%"
        case .none:
            return ""
        }
    }
}
