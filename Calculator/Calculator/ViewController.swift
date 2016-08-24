//
//  ViewController.swift
//  Calculator
//
//  Created by Артем on 19/08/16.
//  Copyright © 2016 Artem Salimyanov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet private weak var display: UILabel!
    @IBOutlet private weak var history: UILabel!
    @IBAction func save() {
        savedProgram = brain.program
    }
    @IBAction func restore() {
        if savedProgram != nil {
            brain.program = savedProgram!
            displayValue = brain.result
        }
    }
    
    private var userInTheMiddleOfTyping = false
    
    private var brain = CalculatorBrain()
    
    private var displayValue: Double? {
        get {
            if let value = Double(display.text!) {
                return value
            }
            return nil
        }
        set {
            if let value = newValue {
                display.text = String(value)
                
                history.text = brain.description + (brain.isPartialResult ? " ..." : " =")
            } else {
                display.text = " "
                history.text = " "
                userInTheMiddleOfTyping = false
            }
        }
    }
    
    var savedProgram: CalculatorBrain.PropertyList?
    
    @IBAction func touchBackspace(sender: UIButton) {
        if userInTheMiddleOfTyping {
            display.text!.removeAtIndex(display.text!.endIndex.predecessor())
        }
        if display.text!.isEmpty {
            userInTheMiddleOfTyping = false
            displayValue = 0
        }
    }
    @IBAction private func touchDigit(sender: UIButton) {
        
        let digit = sender.currentTitle!
        let textCurrentlyInDisplay = display.text!
        
        if userInTheMiddleOfTyping {
            if (digit != ".") || (textCurrentlyInDisplay.rangeOfString(".") == nil) {
            display.text = textCurrentlyInDisplay + digit
            }
        } else {
            display.text = digit
        }
        userInTheMiddleOfTyping = true
    }

    @IBAction private func performOperation(sender: UIButton) {
        if userInTheMiddleOfTyping {
            if let value = displayValue {
                brain.setOperand(value)
            }
            userInTheMiddleOfTyping = false
        }
        if let mathematicalSymbol = sender.currentTitle {
            brain.performOperation(mathematicalSymbol)
        }
        displayValue = brain.result
    }

}

