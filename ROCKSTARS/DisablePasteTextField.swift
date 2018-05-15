//
//  DisablePasteTextField.swift
//  ROCKSTARS
//
//  Created by Amrit on 09/06/17.
//  Copyright © 2017 SoftProdigy. All rights reserved.
//

import UIKit

class DisablePasteTextField: UITextField {

    override public func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
//        if action == #selector(copy(_:)) || action == #selector(paste(_:)) || action ==  #selector(select(_:)) || action == #selector( selectAll(_:)) || action ==  #selector(delete(_:)) || action == #selector( makeTextWritingDirectionLeftToRight(_:)) || action == #selector(makeTextWritingDirectionRightToLeft(_:)) || action ==  #selector(toggleBoldface(_:)) || action == #selector(toggleItalics(_:)) || action ==  #selector(toggleUnderline(_:)) || action == #selector(increaseSize(_:)) || action == #selector(decreaseSize(_:)) || action == #selector(cut(_:)) {
//            return false
//        }
        
        return false
    }
}
