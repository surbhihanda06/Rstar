//
//  ExtensionsClass.swift
//  
//
//  Created by Rakesh Kumar on 7/4/17.
//
//

import Foundation
import UIKit

extension Date {
    
    var currentUTCTimeZoneDate: String {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: "UTC")
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let curentLocale: NSLocale = NSLocale.current as NSLocale
        formatter.locale = NSLocale(localeIdentifier: curentLocale.localeIdentifier) as Locale!
         return formatter.string(from: self)
    }
    
    func currentTimeZoneDate() -> String {
        let dtf = DateFormatter()
        dtf.timeZone = TimeZone.current
        dtf.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let curentLocale: NSLocale = NSLocale.current as NSLocale
        dtf.locale = NSLocale(localeIdentifier: curentLocale.localeIdentifier) as Locale!
         return dtf.string(from: self)
    }
}


extension String {
    
    func currentTimeZoneStr() -> String {
        let dtf = DateFormatter()
        dtf.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let curentLocale: NSLocale = NSLocale.current as NSLocale
        dtf.locale = NSLocale(localeIdentifier: curentLocale.localeIdentifier) as Locale!
        let date = dtf.date(from: self)
        print(date ?? "")
        dtf.timeZone = TimeZone(identifier: "UTC")
        return dtf.string(from: date!)
    }
    
    func currentDateZoneStrToUTC() -> String
    {
        let dtf = DateFormatter()
        dtf.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let curentLocale: NSLocale = NSLocale.current as NSLocale
        dtf.locale = NSLocale(localeIdentifier: curentLocale.localeIdentifier) as Locale!
        let date = dtf.date(from: self)
        print(date ?? "")
        dtf.dateFormat = "yyyy-MM-dd"
        dtf.timeZone = TimeZone(identifier: "UTC")
        return dtf.string(from: date!)
    }

      
    func TimeConversion() -> String {
        let dtf = DateFormatter()
        dtf.dateFormat = "MMMM yyyy h:mm a"
        let curentLocale: NSLocale = NSLocale.current as NSLocale
        dtf.locale = NSLocale(localeIdentifier: curentLocale.localeIdentifier) as Locale!
        let date = dtf.date(from: self)
        print(date ?? "")
        dtf.timeZone = TimeZone(identifier: "UTC")
        return dtf.string(from: date!)
        
    }
    
    func FinishTimeZoneStr() -> String {
        let dtf = DateFormatter()
        dtf.dateFormat = "HH:mm"
        let curentLocale: NSLocale = NSLocale.current as NSLocale
        dtf.locale = NSLocale(localeIdentifier: curentLocale.localeIdentifier) as Locale!
        let date = dtf.date(from: self)
        print(date ?? "")
        dtf.timeZone = TimeZone(identifier: "UTC")
        return dtf.string(from: date!)
    }
    
    func ChangeUTCYearToCurrent() -> String
    {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: "UTC")
        formatter.dateFormat = "yyyy"
        let curentLocale: NSLocale = NSLocale.current as NSLocale
        formatter.locale = NSLocale(localeIdentifier: curentLocale.localeIdentifier) as Locale!
        let date = formatter.date(from: self as String)!
        formatter.timeZone = TimeZone.current
        let year = formatter.string(from: date)
        return year
    
    }
    func ChangeUTCMonthToCurrent() -> String
    {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: "UTC")
        formatter.dateFormat = "MM"
        let curentLocale: NSLocale = NSLocale.current as NSLocale
        formatter.locale = NSLocale(localeIdentifier: curentLocale.localeIdentifier) as Locale!
        let date = formatter.date(from: self as String)!
        formatter.timeZone = TimeZone.current
         formatter.dateFormat = "MMM"
        let Month = formatter.string(from: date)
        return Month
        
    }
    func ChangeUTCDayToCurrent() -> String
    {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: "UTC")
        formatter.dateFormat = "dd"
        let curentLocale: NSLocale = NSLocale.current as NSLocale
        formatter.locale = NSLocale(localeIdentifier: curentLocale.localeIdentifier) as Locale!
        let date = formatter.date(from: self as String)!
        formatter.timeZone = TimeZone.current
        let Day = formatter.string(from: date)
        return Day
        
    }
    func ChangeUTCTimeToCurrent() -> String
    {
      
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: "UTC")
        formatter.dateFormat = "HH:mm:ss"
        let curentLocale: NSLocale = NSLocale.current as NSLocale
        formatter.locale = NSLocale(localeIdentifier: curentLocale.localeIdentifier) as Locale!
        let date = formatter.date(from: self as String)!
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "hh:mm a"
        
        let Day = formatter.string(from: date)
        return Day
        
    }
    func ChangeUTCDateStrToCurrent() -> String
    {
        let dateString = NSMutableString(string:self)
        do {
            let regex = try NSRegularExpression(pattern: "[st|nd|rd|th]", options: NSRegularExpression.Options())
            print(regex)
 
            let result = regex.replaceMatches(in: dateString, options: NSRegularExpression.MatchingOptions(), range: NSMakeRange(0, 4), withTemplate: "")
            
            print(result)
            print(dateString)
            let formatter = DateFormatter()
            formatter.timeZone = TimeZone(identifier: "UTC")
            formatter.dateFormat = "dd MMMM, yyyy"
            let curentLocale: NSLocale = NSLocale.current as NSLocale
            formatter.locale = NSLocale(localeIdentifier: curentLocale.localeIdentifier) as Locale!
            let date = formatter.date(from: dateString as String)!
            formatter.timeZone = TimeZone.current
            //let str  = formatter.string(from:date)
            
            let calendar = Calendar.current
            let anchorComponents = calendar.dateComponents([.day, .month, .year], from: date)
            
            // Formate
            let dateFormate = DateFormatter()
            dateFormate.timeZone = TimeZone.current
            dateFormate.dateFormat = "MMMM, yyyy"
           // let curentLocale: NSLocale = NSLocale.current as NSLocale
            dateFormate.locale = NSLocale(localeIdentifier: curentLocale.localeIdentifier) as Locale!
            let newDate = dateFormate.string(from: date)
            
            var day  = "\(anchorComponents.day!)"
            switch (day) {
            case "1" , "21" , "31":
                day.append("st")
            case "2" , "22":
                day.append("nd")
            case "3" ,"23":
                day.append("rd")
            default:
                day.append("th")
            }
            print(date)
            var s = day
            
            if s.hasPrefix("0")
            {
             day.remove(at: day.startIndex)
            }
            print(day)
            if s.characters.first == "a" {  // takes a Character or a literal
            }
            
            print(day + " " + newDate)
            return day + " " + newDate
            
        } catch let error as NSError {
            
            print(error)}
        
        return "Fail"
    }
  
    func ChangeUTCTimeStrToCurrent() -> String
    {
         let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: "UTC")
        formatter.dateFormat = "hh:mm a"
        let curentLocale: NSLocale = NSLocale.current as NSLocale
        formatter.locale = NSLocale(localeIdentifier: curentLocale.localeIdentifier) as Locale!
        let date = formatter.date(from: self as String)!
        formatter.timeZone = TimeZone.current
        let Time = formatter.string(from: date)
        return Time
     }
    func MethodForSuccessTime() -> String
    {
        //rakesh
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: "UTC")
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let curentLocale: NSLocale = NSLocale.current as NSLocale
        formatter.locale = NSLocale(localeIdentifier: curentLocale.localeIdentifier) as Locale!
        // print(dateString)
        let date = formatter.date(from: self as String)!
        formatter.timeZone = TimeZone.current
        //let str  = formatter.string(from:date)
        
            // Formate
            let dateFormate = DateFormatter()
            
            dateFormate.timeZone = TimeZone.current
            dateFormate.dateFormat = "hh:mm a"
       // let curentLocale: NSLocale = NSLocale.current as NSLocale
        dateFormate.locale = NSLocale(localeIdentifier: curentLocale.localeIdentifier) as Locale!
            let newDate = dateFormate.string(from: date)
            print(date)
            print(newDate)
            return newDate
            
        
        return "Fail"
    }
   // hh:mm a
    func MethodForStartTime() -> String
    {
        //rakesh
        let dateString = NSMutableString(string:self)
        do {
            let regex = try NSRegularExpression(pattern: "[st|nd|rd|th]", options: NSRegularExpression.Options())
            print(regex)
            var result:Int
            if(dateString.contains("August"))
            {
                result = regex.replaceMatches(in: dateString, options: NSRegularExpression.MatchingOptions(), range: NSMakeRange(6, 15), withTemplate: "")
            }
            else if(dateString.contains("November") || dateString.contains("September") || dateString.contains("December") || dateString.contains("October")  || dateString.contains("January")   || dateString.contains("February"))
            {
                result = regex.replaceMatches(in: dateString, options: NSRegularExpression.MatchingOptions(), range: NSMakeRange(9, 15), withTemplate: "")
            }
            else
            { result = regex.replaceMatches(in: dateString, options: NSRegularExpression.MatchingOptions(), range: NSMakeRange(5, 15), withTemplate: "")
            }
            
            print(result)
            print(dateString)
            let formatter = DateFormatter()
            formatter.timeZone = TimeZone(identifier: "UTC")
            formatter.dateFormat = "MMMM d, yyyy hh:mm a"
            let curentLocale: NSLocale = NSLocale.current as NSLocale
            formatter.locale = NSLocale(localeIdentifier: curentLocale.localeIdentifier) as Locale!
            print(dateString)
            let date = formatter.date(from: dateString as String)!
            formatter.timeZone = TimeZone.current
            //let str  = formatter.string(from:date)
            
            
            // Formate
            let dateFormate = DateFormatter()
            
            dateFormate.timeZone = TimeZone.current
            dateFormate.dateFormat = "hh:mm a"
           // let curentLocale: NSLocale = NSLocale.current as NSLocale
            dateFormate.locale = NSLocale(localeIdentifier: curentLocale.localeIdentifier) as Locale!
            let newDate = dateFormate.string(from: date)
            print(date)
            print(newDate)
            return newDate
            
        } catch let error as NSError {
            
            print(error)}
        
        return "Fail"
    }
    func MethodForDay() -> String
    {
        //rakesh
        let dateString = NSMutableString(string:self)
        do {
            let regex = try NSRegularExpression(pattern: "[st|nd|rd|th]", options: NSRegularExpression.Options())
            print(regex)
            var result:Int
            if(dateString.contains("August"))
            {
                result = regex.replaceMatches(in: dateString, options: NSRegularExpression.MatchingOptions(), range: NSMakeRange(6, 15), withTemplate: "")
            }
            else if(dateString.contains("November") || dateString.contains("September") || dateString.contains("December") || dateString.contains("October")  || dateString.contains("January")   || dateString.contains("February"))
            {
                result = regex.replaceMatches(in: dateString, options: NSRegularExpression.MatchingOptions(), range: NSMakeRange(9, 15), withTemplate: "")
            }
            else
            { result = regex.replaceMatches(in: dateString, options: NSRegularExpression.MatchingOptions(), range: NSMakeRange(5, 15), withTemplate: "")
            }
            
            print(result)
            print(dateString)
            let formatter = DateFormatter()
            formatter.timeZone = TimeZone(identifier: "UTC")
            formatter.dateFormat = "MMMM d, yyyy hh:mm a"
            let curentLocale: NSLocale = NSLocale.current as NSLocale
            formatter.locale = NSLocale(localeIdentifier: curentLocale.localeIdentifier) as Locale!
            print(dateString)
            let date = formatter.date(from: dateString as String)!
            formatter.timeZone = TimeZone.current
            //let str  = formatter.string(from:date)
            
            
            // Formate
            let dateFormate = DateFormatter()
            
            dateFormate.timeZone = TimeZone.current
            dateFormate.dateFormat = "dd"
          //  let curentLocale: NSLocale = NSLocale.current as NSLocale
            dateFormate.locale = NSLocale(localeIdentifier: curentLocale.localeIdentifier) as Locale!
            let newDate = dateFormate.string(from: date)
                       print(date)
            print(newDate)
            return newDate
            
        } catch let error as NSError {
            
            print(error)}
        
        return "Fail"
    }
    func MethodForMonth() -> String
    {
        //rakesh
        let dateString = NSMutableString(string:self)
        do {
            let regex = try NSRegularExpression(pattern: "[st|nd|rd|th]", options: NSRegularExpression.Options())
            print(regex)
            var result:Int
            if(dateString.contains("August"))
            {
                result = regex.replaceMatches(in: dateString, options: NSRegularExpression.MatchingOptions(), range: NSMakeRange(6, 15), withTemplate: "")
            }
            else if(dateString.contains("November") || dateString.contains("September") || dateString.contains("December") || dateString.contains("October")  || dateString.contains("January")   || dateString.contains("February"))
            {
                result = regex.replaceMatches(in: dateString, options: NSRegularExpression.MatchingOptions(), range: NSMakeRange(9, 15), withTemplate: "")
            }
            else
            { result = regex.replaceMatches(in: dateString, options: NSRegularExpression.MatchingOptions(), range: NSMakeRange(5, 15), withTemplate: "")
            }
            
            print(result)
            print(dateString)
            let formatter = DateFormatter()
            formatter.timeZone = TimeZone(identifier: "UTC")
            formatter.dateFormat = "MMMM d, yyyy hh:mm a"
            let curentLocale: NSLocale = NSLocale.current as NSLocale
            formatter.locale = NSLocale(localeIdentifier: curentLocale.localeIdentifier) as Locale!
            print(dateString)
            let date = formatter.date(from: dateString as String)!
            formatter.timeZone = TimeZone.current
            //let str  = formatter.string(from:date)
            
            
            // Formate
            let dateFormate = DateFormatter()
            
            dateFormate.timeZone = TimeZone.current
            dateFormate.dateFormat = "MMM"
          //  let curentLocale: NSLocale = NSLocale.current as NSLocale
            dateFormate.locale = NSLocale(localeIdentifier: curentLocale.localeIdentifier) as Locale!
            let newDate = dateFormate.string(from: date)
            print(date)
            print(newDate)
            return newDate
            
        } catch let error as NSError {
            
            print(error)}
        
        return "Fail"
    }
    func MethodForDate() -> String
    {
        //rakesh
             let formatter = DateFormatter()
            formatter.timeZone = TimeZone(identifier: "UTC")
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let curentLocale: NSLocale = NSLocale.current as NSLocale
        formatter.locale = NSLocale(localeIdentifier: curentLocale.localeIdentifier) as Locale!
           // print(dateString)
            let date = formatter.date(from: self as String)!
            formatter.timeZone = TimeZone.current
            //let str  = formatter.string(from:date)
            
            let calendar = Calendar.current
            let anchorComponents = calendar.dateComponents([.day, .month, .year], from: date)
            
            // Formate
            let dateFormate = DateFormatter()
            
            dateFormate.timeZone = TimeZone.current
            dateFormate.dateFormat = "MMMM, yyyy"
       // let curentLocale: NSLocale = NSLocale.current as NSLocale
        dateFormate.locale = NSLocale(localeIdentifier: curentLocale.localeIdentifier) as Locale!
            let newDate = dateFormate.string(from: date)
            var day  = "\(anchorComponents.day!)"
            switch (day) {
            case "1" , "21" , "31":
                day.append("st")
            case "2" , "22":
                day.append("nd")
            case "3" ,"23":
                day.append("rd")
            default:
                day.append("th")
            }
            print(date)
            print(day + " " + newDate)
            return day + " " + newDate
            
//        } catch let error as NSError {
//            
//            print(error)}
        
        return "Fail"
    }
    
    func ChangeUTCStringToLocal() -> String
    {
        //rakesh
        let dateString = NSMutableString(string:self)
        do {
            let regex = try NSRegularExpression(pattern: "[st|nd|rd|th]", options: NSRegularExpression.Options())
            print(regex)
            var result:Int
            if(dateString.contains("August"))
            {
                result = regex.replaceMatches(in: dateString, options: NSRegularExpression.MatchingOptions(), range: NSMakeRange(6, 15), withTemplate: "")
            }
            else if(dateString.contains("November") || dateString.contains("September") || dateString.contains("December") || dateString.contains("October")  || dateString.contains("January")   || dateString.contains("February"))
            {
                result = regex.replaceMatches(in: dateString, options: NSRegularExpression.MatchingOptions(), range: NSMakeRange(9, 15), withTemplate: "")
            }
            else
            { result = regex.replaceMatches(in: dateString, options: NSRegularExpression.MatchingOptions(), range: NSMakeRange(5, 15), withTemplate: "")
            }
           
            print(result)
            print(dateString)
            let formatter = DateFormatter()
            formatter.timeZone = TimeZone(identifier: "UTC")
            formatter.dateFormat = "MMMM d, yyyy hh:mm a"
            
            print(dateString)
            let curentLocale: NSLocale = NSLocale.current as NSLocale
            formatter.locale = NSLocale(localeIdentifier: curentLocale.localeIdentifier) as Locale!
            
            let date = formatter.date(from: dateString as String)!
            formatter.timeZone = TimeZone.current
            //let str  = formatter.string(from:date)
            
            let calendar = Calendar.current
            let anchorComponents = calendar.dateComponents([.day, .month, .year], from: date)
            
            // Formate
            let dateFormate = DateFormatter()
            
            dateFormate.timeZone = TimeZone.current
            dateFormate.dateFormat = "MMMM, yyyy hh:mm a"
          //  let curentLocale: NSLocale = NSLocale.current as NSLocale
            dateFormate.locale = NSLocale(localeIdentifier: curentLocale.localeIdentifier) as Locale!
            let newDate = dateFormate.string(from: date)
             var day  = "\(anchorComponents.day!)"
            switch (day) {
            case "1" , "21" , "31":
                day.append("st")
            case "2" , "22":
                day.append("nd")
            case "3" ,"23":
                day.append("rd")
            default:
                day.append("th")
            }
            print(date)
            print(day + " " + newDate)
            return day + " " + newDate
            
        } catch let error as NSError {
            
            print(error)}
        
        return "Fail"
    }
}

extension CALayer
{
    func setBorderUIColor(color: UIColor)
    {
        borderColor = color.cgColor
    }
    
    func borderUIColor() -> UIColor
    {
        return UIColor.init(cgColor: borderColor!)
    }
    
}
extension UITextField{
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSForegroundColorAttributeName: newValue!])
        }
    }
}
extension UIImage
{
    func isEqualToImage(image: UIImage) -> Bool {
        let data1: NSData = UIImagePNGRepresentation(self)! as NSData
        let data2: NSData = UIImagePNGRepresentation(image)! as NSData
        return data1.isEqual(data2)
    }
}
