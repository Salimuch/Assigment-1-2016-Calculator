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
    
    private var userInTheMiddleOfTyping = false
    
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
            brain.setOperand(displayValue)
            userInTheMiddleOfTyping = false
        }
        if let mathematicalSymbol = sender.currentTitle {
            brain.performOperation(mathematicalSymbol)
        }
        displayValue = brain.result
        
        history.text = brain.description
        if brain.isPartialResult {
            history.text! += "..."
        } else { history.text! += " = " }
    }
    
    private var brain = CalculatorBrain()
    
    private var displayValue: Double {
        get {
            return Double(display.text!)!
        }
        set {
            display.text = String(newValue)
        }
    }
}

