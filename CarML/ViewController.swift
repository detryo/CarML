//
//  ViewController.swift
//  CarML
//
//  Created by Cristian Sedano Arenas on 5/9/18.
//  Copyright © 2018 Cristian Sedano Arenas. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var modelSegmentedControl: UISegmentedControl!
    @IBOutlet weak var extraSwitch: UISwitch!
    @IBOutlet weak var kmsLabel: UILabel!
    @IBOutlet weak var kmsSlider: UISlider!
    @IBOutlet weak var statusSegmentedControl: UISegmentedControl!
    @IBOutlet weak var priceLabel: UILabel!
    
    let cars = Cars()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.stackView.setCustomSpacing(25, after: self.modelSegmentedControl)
        self.stackView.setCustomSpacing(25, after: self.extraSwitch)
        self.stackView.setCustomSpacing(25, after: self.kmsLabel)
        self.stackView.setCustomSpacing(50, after: self.statusSegmentedControl)
        self.calculateValue()
    }
    
    @IBAction func calculateValue() {
        
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "en_UK") // cambiar el simbolo del dinero, en este caso £
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        let formattedKms = formatter.string(for: self.kmsSlider.value) ?? "0"
        self.kmsLabel.text = "Kilometre: \(formattedKms) kms"
        
        // Hacer el calculo con el valor del coche con ML
        if let prediction = try? cars.prediction(
            modelo: Double(self.modelSegmentedControl.selectedSegmentIndex),
            extras: self.extraSwitch.isOn ? Double(1.0) : Double(0.0),
            kilometraje: Double(self.kmsSlider.value),
            estado: Double(self.statusSegmentedControl.selectedSegmentIndex)){
            
            let clampValue = max(500, prediction.precio)
            formatter.numberStyle = .currency
            self.priceLabel.text = formatter.string(for: clampValue)
        }else{
            self.priceLabel.text = "Error"
        }
    }
}

