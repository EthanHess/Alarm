//
//  SwitchTableViewCell.swift
//  Alarm
//
//  Created by Ethan Hess on 5/18/16.
//  Copyright © 2016 Ethan Hess. All rights reserved.
//

import UIKit

class SwitchTableViewCell: UITableViewCell {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var alarmSwitch: UISwitch!
    
    weak var delegate: SwitchTableViewCellDelegate?
    
    @IBAction func switchValueChanged(sender: AnyObject) {
        
        delegate?.switchCellSwitchValueChanged(self)
    }
    
    func updateWithAlarm(alarm: Alarm) {
        
        timeLabel.text = alarm.fireTimeAsString
        nameLabel.text = alarm.name
        alarmSwitch.on = alarm.enabled
    }
    

}

protocol SwitchTableViewCellDelegate: class {
    
    func switchCellSwitchValueChanged(cell: SwitchTableViewCell)
}
