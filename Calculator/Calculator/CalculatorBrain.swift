//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Артем on 19/08/16.
//  Copyright © 2016 Artem Salimyanov. All rights reserved.
//

import Foundation

func multiply(op1: Double, op2: Double) -> Double {
    return op1 * op2
}

class CalculatorBrain {
    private var accumulator = 0.0
    private var pending: PendingBinaryOperationInfo?
    
    func setOperand(operand: Double) {
        accumulator = operand
    }
    
    private func executePendingBinaryOpeartion() {
        if pending != nil {
            accumulator = pending!.binaryFunction(pending!.firstOperand, accumulator)
            pending = nil
        }
    }
    
    private var description = ""
    
    func performOperation(symbol: String) {
        if let operation = operations[symbol] {
            switch operation {
            case .Constant(let value): accumulator = value
            case .UnaryOperation(let function): accumulator = function(accumulator)
            case .BinaryOperation(let function) :
                executePendingBinaryOpeartion()
                pending = PendingBinaryOperationInfo(binaryFunction: function, firstOperand: accumulator)
            case .Equals :
                executePendingBinaryOpeartion()
            }
        }
    }
    
    var result: Double {
        get {
            return accumulator
        }
    }
    
    private var operations: Dictionary <String, Operation> = [
        "√" : Operation.UnaryOperation(sqrt),
        "³√" : Operation.UnaryOperation(cbrt),
        "x²" : Operation.UnaryOperation({ $0 * $0 }),
        "x³" : Operation.UnaryOperation({ $0 * $0 * $0 }),
        "xʸ" : Operation.BinaryOperation({ pow($0, $1) }),
        "e" : Operation.Constant(M_E),
        "eˣ" : Operation.UnaryOperation({ pow(M_PI, $0) }),
        "sin" : Operation.UnaryOperation(sin),
        "cos" : Operation.UnaryOperation(cos),
        "tan" : Operation.UnaryOperation(tan),
        "ln" : Operation.UnaryOperation(log),
        "π" : Operation.Constant(M_PI),
        "x⁻¹" : Operation.UnaryOperation({ 1 / $0 }),
        "×" : Operation.BinaryOperation({ $0 * $1 }),
        "÷" : Operation.BinaryOperation({ $0 / $1 }),
        "+" : Operation.BinaryOperation({ $0 + $1 }),
        "−" : Operation.BinaryOperation({ $0 - $1 }),
        "±" : Operation.UnaryOperation({ -$0 }),
        "=" : Operation.Equals
    ]
    
    private enum Operation {
        case Constant(Double)
        case UnaryOperation((Double) -> Double)
        case BinaryOperation((Double,Double) -> Double)
        case Equals
    }
    
    private struct PendingBinaryOperationInfo {
        var binaryFunction: (Double, Double) -> Double
        var firstOperand: Double
    }
}
