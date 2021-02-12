//Copyright (c) 2021 pikachu987 <pikachu77769@gmail.com>
//
//Permission is hereby granted, free of charge, to any person obtaining a copy
//of this software and associated documentation files (the "Software"), to deal
//in the Software without restriction, including without limitation the rights
//to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//copies of the Software, and to permit persons to whom the Software is
//furnished to do so, subject to the following conditions:
//
//The above copyright notice and this permission notice shall be included in
//all copies or substantial portions of the Software.
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//THE SOFTWARE.

import UIKit
import StoreKit

public protocol IAPDelegate: class {
    func iapProducts(_ products: [SKProduct], error: Error?)
    func iapPurchaseProduct(_ transaction: SKPaymentTransaction)
    func iapPurchaseProductEmpty()
    func iapPurchaseProductError()
}

public extension IAPDelegate {
    func iapProducts(_ products: [SKProduct]) {
        
    }
    
    func  iapPurchaseProduct(_ transaction: SKPaymentTransaction) {
        
    }
    
    func iapPurchaseProductEmpty() {
        
    }
    
    func iapPurchaseProductError() {
        
    }
}

open class IAP: NSObject {
    public weak var delegate: IAPDelegate?
    
    public static let shared = IAP()

    public static var identifers: [String] = [String]()
    public static var products = [SKProduct]()
    
    private var request: SKProductsRequest?
    private var queue = SKPaymentQueue.default()

    public override init() {
        super.init()
        self.queue.add(self)
    }
    
    open class func fetchData() {
        IAP.shared.fetchData()
    }
    
    open func fetchData() {
        self.request?.cancel()
        if IAP.products.isEmpty {
            var identifersSet = Set<String>()
            IAP.identifers.forEach({ identifersSet.insert($0) })
            self.request = SKProductsRequest(productIdentifiers: identifersSet)
            self.request?.delegate = self
            self.request?.start()
        } else {
            self.delegate?.iapProducts(IAP.products)
        }
    }
    
    open func purchaseProduct(_ identifer: String) {
        if !SKPaymentQueue.canMakePayments() {
            self.delegate?.iapPurchaseProductError()
            return
        }
        guard let product = IAP.products.filter({ $0.productIdentifier == identifer }).first else {
            self.delegate?.iapPurchaseProductError()
            return
        }
        let payment = SKPayment(product: product)
        self.queue.add(payment)
    }
    
    open func restorePurchaseProducts() {
        self.queue.restoreCompletedTransactions()
    }
    
}

// MARK: IAP: SKProductsRequestDelegate
extension IAP: SKProductsRequestDelegate {
    public func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        IAP.products = response.products
        self.delegate?.iapProducts(IAP.products, error: nil)
    }

    public func request(_ request: SKRequest, didFailWithError error: Error) {
        self.delegate?.iapProducts([], error: error)
    }
}

// MARK: IAP: SKPaymentTransactionObserver
extension IAP: SKPaymentTransactionObserver {
    public func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
        self.delegate?.iapPurchaseProductError()
    }

    public func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        if queue.transactions.isEmpty {
            self.delegate?.iapPurchaseProductEmpty()
        } else {
            queue.transactions.forEach({ self.delegate?.iapPurchaseProduct($0) })
        }
    }

    public func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        if transactions.isEmpty {
            self.delegate?.iapPurchaseProductError()
        } else {
            for transaction in transactions {
                if transaction.transactionState == .deferred || transaction.transactionState == .failed ||
                    transaction.transactionState == .purchased || transaction.transactionState == .restored {
                    self.queue.finishTransaction(transaction)
                }
                self.delegate?.iapPurchaseProduct(transaction)
            }
        }
    }
}
