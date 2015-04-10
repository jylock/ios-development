//
//  ViewController.swift
//  CalculatorExample
//
//  Created by Junyuan Suo on 3/24/15.
//  Copyright (c) 2015 JYLock. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var historyDisplay: UITextView!

    
    var userIsInTheMiddleOfTypingANumber = false
    
    var brain = CalculatorExampleBrain()
    
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTypingANumber {
            display.text = display.text! + digit
        } else {
            display.text = digit
            userIsInTheMiddleOfTypingANumber = true
        }
    }
    
    @IBAction func constantEntry(sender: UIButton) {
        if userIsInTheMiddleOfTypingANumber {
            enter()
        }
        if let constant = sender.currentTitle {
            if let result = brain.pushConstant(constant) {
                displayValue = result
            } else {
                displayValue = nil
            }
        }
    }
    
    
    @IBAction func operate(sender: UIButton) {
        if userIsInTheMiddleOfTypingANumber {
            enter()
        }
        if let operation = sender.currentTitle {
            if let result = brain.performOperation(operation) {
                displayValue = result
            } else {
                displayValue = nil
            }
        }
    }
    
    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false
        if let result = brain.pushOperand(displayValue!) {
            displayValue = result
        } else {
            displayValue = nil
        }
    }
    
    @IBAction func floatingPoint(sender: UIButton) {
        if display.text!.rangeOfString(".") == nil {
            display.text = display.text! + sender.currentTitle!
            userIsInTheMiddleOfTypingANumber = true
        }
        if userIsInTheMiddleOfTypingANumber == false {//deal with .5 case
            display.text = "0" + sender.currentTitle!
            userIsInTheMiddleOfTypingANumber = true
        }
    }
    
    @IBAction func clear(sender: UIButton) {
        display.text = "0"
        historyDisplay.text = " "
        brain.clearStackAndDictionary()
        userIsInTheMiddleOfTypingANumber = false
    }
    
    
    var displayValue: Double? {
        get {
            if let numberString = NSNumberFormatter().numberFromString(display.text!)? {
                return numberString.doubleValue
            } else {
                return nil
            }
        }
        set {
            if (newValue != nil) {
                display.text = "\(newValue!)"
                userIsInTheMiddleOfTypingANumber = false
                historyDisplay.text = brain.description
            } else {
                display.text = " "
                userIsInTheMiddleOfTypingANumber = false
                historyDisplay.text = brain.description
            }
        }
    }
    
    @IBAction func setVariableM(sender: UIButton) {
        userIsInTheMiddleOfTypingANumber = false
        if let valueOfM = NSNumberFormatter().numberFromString(display.text!)?.doubleValue {
            brain.variableValues["M"] = valueOfM
            if let result = brain.evaluate() {
                displayValue = result
            } else {
                displayValue = nil
            }
        }
    }
    
    @IBAction func getVariableM(sender: UIButton) {
        if userIsInTheMiddleOfTypingANumber {
            enter()
        }
        if let result = brain.pushOperand("M") {
            displayValue = result
        } else {
            displayValue = nil
        }
    }

}

