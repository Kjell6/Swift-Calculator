//
//  ContentView.swift
//  Taschenrechner
//
//  Created by Kjell Behrends on 05.09.24.
//

import SwiftUI

struct ContentView: View {
    // Logik-Instanz wird hier erstellt
    @StateObject private var logic = Logic()
    let buttons = [
        ["C", "⌫", "+-", "÷"],
        ["7", "8", "9", "×"],
        ["4", "5", "6", "-"],
        ["1", "2", "3", "+"],
        ["0", ".", "="]
    ]
    
    var body: some View {
        ZStack {
            Color.backgroundColorSet.edgesIgnoringSafeArea(.all) // edgesIgnoringSafeArea um die ränder oben und unten
            VStack { //Um Hintergrundfarbe ändern zu können
                HStack {
                    Button(action: {
                        // Aktion für den 3-Dot-Button hier einfügen
                    }) {
                        Image(systemName: "ellipsis")
                            .font(.system(size: 24))
                            .foregroundColor(Color("ForegroundColor"))
                            .frame(width: 44, height: 44)
                            .background(Color.backgroundColorSet)
                            .cornerRadius(22)
                    }
                    .padding(.leading)
                    
                    Spacer()
                }
                Spacer()
                VStack (spacing: 12){
                    Text(logic.displayCalculation)
                        .font(.system(size: 25).bold())
                        .foregroundColor(Color("OperatorColor"))
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .lineLimit(1)  // Begrenze auf eine Zeile
                        .minimumScaleFactor(0.5)  // Verkleinert den Text bis zur Hälfte der ursprünglichen Größe
                    Text(logic.displayNum)
                        .font(.system(size: 80))
                        .foregroundColor(Color("ForegroundColor"))
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .lineLimit(1)  // Begrenze auf eine Zeile
                        .minimumScaleFactor(0.5)  // Verkleinert den Text bis zur Hälfte der ursprünglichen Größe
                    ForEach(buttons, id: \.self) { row in //Geht die Zeilen des Arrays durch, ForEach ist eine Array Methode
                        HStack(spacing: 12) {
                            ForEach(row, id: \.self) { button in // Geht die einzelnen Buttons der Reihe durch
                                Button(action: {
                                    // Hier kommt die Logik für jeden Button
                                    self.buttonTapped(button)
                                }, label: {
                                    Text(button)
                                        .font(.system(size: 38))
                                        .frame(width: button == "0" ? 172 : 80, height: 80)
                                        .background(buttonColor(for: button))
                                        .foregroundColor(foregroundColor(for: button))
                                        .cornerRadius(40)
                                })
                            }
                        }
                    }
                }
            }
            .padding()
        }
    }
    
   
    func foregroundColor(for button: String) -> Color {
        switch button {
        case "+", "-", "×", "÷", "C", "⌫", "+-":
            return Color("OperatorColor") //Bug?
        case "=":
            return .backgroundColorSet
        default:
            return Color("ForegroundColor")

        }
    }
    
    private func buttonColor(for button: String) -> Color {
        switch button {
        case "=":
            return .accentColor
        default:
            return .backgroundColorSet

        }
    }
    
    private func oldButtonColor(for button: String) -> Color {
        switch button {
        case "+", "-", "×", "÷", "=":
            return Color(red: 230/255, green: 56/255, blue: 49/255)
        case "C", "⌫", "+-":
            return Color(red: 230, green: 56, blue: 49)
        default:
            return .backgroundColorSet

        }
    }
    
    func buttonTapped(_ button: String) {
        switch button {
        case "0"..."9":
            logic.numberInput(button)
        case ".":            logic.addDecimalPoint()
        case "=":
            logic.result()
        case "+":
            logic.setOperator(Operator.plus)
        case "-":
            logic.setOperator(Operator.minus)
        case "×":
            logic.setOperator(Operator.multi)
        case "÷":
            logic.setOperator(Operator.divide)
        case "C":
            logic.clear()
        case "+-":
            logic.switchSign()
        case "⌫":
            logic.deleteChar()
        default:
            break
        }
    }
}

#Preview {
    ContentView()
}
