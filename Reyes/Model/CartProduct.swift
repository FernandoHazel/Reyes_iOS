//
//  CartProduct.swift
//  Reyes
//
//  Created by Fernando Hazel Ascencio Baumgarten on 19/10/24.
//

import Foundation

extension CartProduct{
    func toDictionary() -> [String: Any]{
        return [
            "desc": self.desc ?? "",
            "discount": self.discount,
            "imageName": self.imageName ?? "",
            "name": self.name ?? "",
            "price": self.price,
            "quantitySelected": self.quantitySelected,
            "reward": self.reward,
            "selectedSize": self.selectedSize ?? ""
        ]
    }
}
