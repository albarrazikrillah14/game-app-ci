//
//  DateFormatter+Ext.swift
//  GameApp
//
//  Created by BEI-Zikri on 07/03/24.
//

import Foundation

class DateFormatterHelper {
  
  func dateFormatter(date: String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    let date = dateFormatter.date(from: date)
    let dateFormatter1 = DateFormatter()
    dateFormatter1.dateFormat = "MMM, d YYYY"
    return dateFormatter1.string(from: date ?? Date())
  }
}
