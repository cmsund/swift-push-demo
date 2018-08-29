//
//  DefaultData.swift
//  PushMessagingSample
//
//  Created by Christina on 8/5/18.
//  Copyright © 2018 Christina. All rights reserved.
//

import Foundation

struct DefaultData {
   
    static var customer_id = "CUST1234"
    
    static var product_id = ["1234"]
    static var product_price = ["99.99"]
    static var product_name = ["Cool Shirt"]
    
    static var order_id = "TESTORD123"
    static var order_subtotal = "109.98"
    static var order_tax_amount = "4.00"
    static var order_shipping_amount = "5.99"
    
    static var addToCartData = [
        "product_id": product_id,
        "product_price": product_price,
        "product_name": product_name
    ]
    
    static var orderData = [
        "product_id": product_id,
        "product_price": product_price,
        "product_name": product_name,
        "order_id": order_id,
        "order_subtotal": order_subtotal,
        "order_tax_amount": order_tax_amount,
        "order_shipping_amount": order_shipping_amount
    ] as [String : Any]
}
