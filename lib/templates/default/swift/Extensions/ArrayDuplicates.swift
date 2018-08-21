//
//  ArrayDuplicates.swift
//  MVCGEN
//
//  Created by Daniel Martinez on 23/7/18.
//  Copyright © 2018 Houlak. All rights reserved.
//

/*
 Extension for Array that will compare two elements and put an element into an array if it is NOT a duplicate.
 The returned array will be the filtered list that contains only unique values.
 Example:
 // Use the .filterDuplicates function on an array of beacons to create a new array of only unique UUID's
 let beaconRegions: [iBeaconItem] = iBeacons.filterDuplicates { $0.uuid == $1.uuid && $0.uuid == $1.uuid }
 */

extension Array {
    
    func filterDuplicates(includeElement: @escaping (_ lhs: Element, _ rhs: Element) -> Bool) -> [Element] {
        
        var results = [Element]()
        
        forEach { (element) in
            
            let existingElements = results.filter {
                return includeElement(element, $0)
            }
            
            if existingElements.count == 0 {
                results.append(element)
            }
        }
        return results
    }
}
