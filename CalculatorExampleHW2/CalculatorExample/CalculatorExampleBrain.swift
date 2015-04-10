//
//  CalculatorExampleBrain.swift
//  CalculatorExample
//
//  Created by Junyuan Suo on 3/25/15.
//  Copyright (c) 2015 JYLock. All rights reserved.
//

import Foundation

class CalculatorExampleBrain
{
    private enum Op: Printable //Protocal
    {
        case Operand(Double)
        case UnaryOperation(String, Double -> Double)
        case BinaryOperation(String, (Double, Double) -> Double)
        case Variable(String)
        case Constant(String)
        
        var description: String {
            get {
                switch self {
                case .Operand(let operand):
                    return "\(operand)"
                case .UnaryOperation(let symbol, _):
                    return symbol
                case .BinaryOperation(let symbol, _):
                    return symbol
                case .Variable(let symbol):
                    return symbol
                case .Constant(let symbol):
                    return symbol
                }
            }
        }
        
    }
    
    private var opStack = [Op]()
    
    private var knownOps = [String:Op]()
    
    private var knownConstants = [String:Double]()
    
    var variableValues = [String:Double]()
    
    init() {
        knownOps["×"] = Op.BinaryOperation("×", *)
        knownOps["÷"] = Op.BinaryOperation("÷") { $1 / $0 }
        knownOps["+"] = Op.BinaryOperation("+", +)
        knownOps["−"] = Op.BinaryOperation("−") { $1 - $0 }
        knownOps["√"] = Op.UnaryOperation("√", sqrt)
        knownOps["sin"] = Op.UnaryOperation("sin", sin )
        knownOps["cos"] = Op.UnaryOperation("cos", cos )
        
        variableValues = [String:Double]()
        knownConstants["π"] = M_PI
    }
    
    private func evaluate(ops: [Op]) -> (result: Double?, remainingOps: [Op])
    {
        if !ops.isEmpty{
            var remainingOps = ops
            let op = remainingOps.removeLast()
            
            switch op {
            case .Operand(let operand):
                return (operand, remainingOps)
            case .UnaryOperation(_, let operation):
                let operandEvaluation = evaluate(remainingOps)
                if let operand = operandEvaluation.result {
                    return (operation(operand), operandEvaluation.remainingOps)
                }
            case .BinaryOperation(_, let operation):
                let op1Evaluation = evaluate(remainingOps)
                if let operand1 = op1Evaluation.result {
                    let op2Evaluation = evaluate(op1Evaluation.remainingOps)
                    if let operand2 = op2Evaluation.result {
                        return (operation(operand1, operand2), op2Evaluation.remainingOps)
                    }
                }
            case .Variable(let symbol):
                if let variable = variableValues[symbol] {
                    return (variable, remainingOps)
                }
            case .Constant(let symbol):
                if let constant = knownConstants[symbol] {
                    return (constant, remainingOps)
                }
            }
        }
        return (nil, ops)
    }
    
    func evaluate() -> Double? {
        let (result, remainder) = evaluate(opStack)
        println("\(opStack) = \(result) with \(remainder) left over")
        return result
    }
    
    func pushOperand(operand: Double) -> Double? {
        opStack.append(Op.Operand(operand))
        return evaluate()
    }
    
    func performOperation(symbol: String) -> Double? {
        if let operation = knownOps[symbol] {
            opStack.append(operation)
        }
        return evaluate()
    }
    
    func clearStackAndDictionary() {
        opStack.removeAll(keepCapacity: false)
        variableValues.removeAll(keepCapacity: false)
    }
    
    func pushOperand(symbol: String) -> Double? {
        opStack.append(Op.Variable(symbol))
        return evaluate()
    }
    
    func pushConstant(symbol: String) -> Double? {
        if let constant = knownConstants[symbol] {
            opStack.append(Op.Constant(symbol))
        }
        return evaluate()
    }
    
    
    
    var description: String {
        get {
            //println("opStack = \(opStack)")
            var (result, remainder) = descriptionHelper(opStack)
            
            if result != nil {
                while !remainder.isEmpty {
                    var (tempResult, tempRemainder) = descriptionHelper(remainder)
                    if tempResult != nil {
                        result = tempResult! + ", " + result!
                    } else {
                        result = " , " + result!
                    }
                    remainder = tempRemainder
                }
                return result! + " ="
            } else {
                return " "
            }
        }
    }
    
    private func descriptionHelper(ops: [Op]) -> (result: String?, remainingOps: [Op])
    {
        if !ops.isEmpty{
            var remainingOps = ops
            let op = remainingOps.removeLast()
            
            switch op {
            case .Operand(let operand):
                return ("\(operand)", remainingOps)
            case .UnaryOperation(_, let operation):
                let operandEvaluation = descriptionHelper(remainingOps)
                if let operand = operandEvaluation.result {
                    //return (operation(operand), operandEvaluation.remainingOps)
                    return (op.description + "( \(operand) )", operandEvaluation.remainingOps)
                } else {
                    return (op.description + "( ? )", operandEvaluation.remainingOps)
                }
            case .BinaryOperation(_, let operation):
                let op1Evaluation = descriptionHelper(remainingOps)
                if let operand1 = op1Evaluation.result {
                    let op2Evaluation = descriptionHelper(op1Evaluation.remainingOps)
                    if let operand2 = op2Evaluation.result {
                        //return (operation(operand1, operand2), op2Evaluation.remainingOps)
                        return ("( \(operand2) " + op.description + " \(operand1) )", op2Evaluation.remainingOps)
                    } else {
                        return ("( ? " + op.description + " \(operand1) )", op2Evaluation.remainingOps)
                    }
                } else {
                    return ("( ? " + op.description + " ? )", op1Evaluation.remainingOps)
                }
            case .Variable(let symbol):
                return (symbol, remainingOps)
            case .Constant(let symbol):
                if let constant = knownConstants[symbol] {
                    return (symbol, remainingOps)
                }
            }
        }
        return (nil, ops)
    }
}