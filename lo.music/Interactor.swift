//
//  PercentDrivenInteractiveTransition.swift
//  lo.music
//
//  Created by Султан Магомедкадиев on 05/12/2016.
//  Copyright © 2016 lo.music. All rights reserved.
//

import Foundation
import UIKit

/// Interacted class contains parameters.
class Interactor: UIPercentDrivenInteractiveTransition {
    
    // MARK: - Properties
    
    /// The has started value.
    var hasStarted = false
    
    /// The should finish value.
    var shouldFinish = false
}
