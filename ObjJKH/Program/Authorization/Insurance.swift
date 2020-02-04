//
//  Insurance.swift
//  ObjJKH
//
//  Created by Sergey Ivanov on 04/02/2020.
//  Copyright © 2020 The Best. All rights reserved.
//

import Foundation
import Gloss

struct InsuranceJson: JSONDecodable {
    
    let data: [InsuranceDataJson]?
    
    init?(json: JSON) {
        data = "data" <~~ json
    }
    
}

struct InsuranceDataJson: JSONDecodable {
    
    let dataBeg:String?
    let dataEnd:String?
    let date:String?
    let shopCode:String?
    let orgName:String?
    let dateCredited:String?
    let paymentId:String?
    let ident:String?
    let sumDecimal:String?
    let sumCreditedDecimal:String?
    let comissionDecimal:String?
    
    init?(json: JSON) {
        dataBeg             = "Databeg"             <~~ json
        dataEnd             = "Dataend"             <~~ json
        date                = "Date"                <~~ json
        shopCode            = "ShopCode"            <~~ json
        orgName             = "OrgName"             <~~ json
        dateCredited        = "DateCredited"        <~~ json
        paymentId           = "PaymentId"           <~~ json
        ident               = "Ident"               <~~ json
        sumDecimal          = "SumDecimal"          <~~ json
        sumCreditedDecimal  = "SumCreditedDecimal"  <~~ json
        comissionDecimal    = "ComissionDecimal"    <~~ json
    }
}

class Insurance {
    let dataBeg:String?
    let dataEnd:String?
    let date:String?
    let shopCode:String?
    let orgName:String?
    let dateCredited:String?
    let paymentId:String?
    let ident:String?
    let sumDecimal:String?
    let sumCreditedDecimal:String?
    let comissionDecimal:String?
    
    init(dataBeg:String,dataEnd:String,date:String,shopCode:String,orgName:String,dateCredited:String,paymentId:String,ident:String,sumDecimal:String,sumCreditedDecimal:String,comissionDecimal:String) {
        self.dataBeg = dataBeg
        self.dataEnd = dataEnd
        self.date = date
        self.shopCode = shopCode
        self.orgName = orgName
        self.dateCredited = dateCredited
        self.paymentId = paymentId
        self.ident = ident
        self.sumDecimal = sumDecimal
        self.sumCreditedDecimal = sumCreditedDecimal
        self.comissionDecimal = comissionDecimal
    }
}
