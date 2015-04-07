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
        var constant = sender.currentTitle!
        switch constant {
        case "π":
            constant = "\(M_PI)"
        default:
            constant = ""
        }
        if !userIsInTheMiddleOfTypingANumber {
            display.text = constant
            enter()
        }
    }
    
    
    @IBAction func operate(sender: UIButton) {
        if userIsInTheMiddleOfTypingANumber {
            enter()
        }
        if let operation = sender.currentTitle {
            historyDisplay.text = historyDisplay.text! + operation + "\n"
            if let result = brain.performOperation(operation) {
                displayValue = result
            } else {
                displayValue = 0
            }
        }
    }
    
    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false
        if let result = brain.pushOperand(displayValue) {
            displayValue = result
        } else {
            displayValue = 0
        }
    }
    
    @IBAction func floatingPoint(sender: UIButton) {
        if display.text!.rangeOfString(".") == nil {
            display.text = display.text! + sender.currentTitle!
            userIsInTheMiddleOfTypingANumber = true
        }
        if userIsInTheMiddleOfTypingANumber == false {//deal with second operand
            display.text = "0" + sender.currentTitle!
            userIsInTheMiddleOfTypingANumber = true
        }
    }
    
    @IBAction func clear(sender: UIButton) {
        display.text = "0"
        historyDisplay.text = ""
        brain.clearStack()
        userIsInTheMiddleOfTypingANumber = false
    }
    
    
    var displayValue: Double {
        get {
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        set {
            display.text = "\(newValue)"
            userIsInTheMiddleOfTypingANumber = false
            historyDisplay.text = historyDisplay.text! + "\(newValue)" + "\n"
        }
    }
    

}

