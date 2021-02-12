//
//  ViewController.swift
//  PALIAP
//
//  Created by pikachu987 on 02/12/2021.
//  Copyright (c) 2021 pikachu987. All rights reserved.
//

import UIKit
import PALIAP
import StoreKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        IAP.shared.delegate = self
        IAP.fetchData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

// MARK: ViewController: IAPDelegate
extension ViewController: IAPDelegate {
    func iapProducts(_ products: [SKProduct], error: Error?) {
        print(products)
        if let error = error {
            print(error)
        }
    }

    func iapPurchaseProduct(_ transaction: SKPaymentTransaction) {
        print(transaction)
    }
    
    func iapPurchaseProductError() {
        print("iapPurchaseProductError")
    }
    
    
    func iapPurchaseProductEmpty() {
        print("iapPurchaseProductEmpty")
    }
}
