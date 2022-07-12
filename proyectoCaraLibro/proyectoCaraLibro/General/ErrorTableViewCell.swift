//
//  ErrorTableViewCell.swift
//  proyectoCaraLibro
//
//  Created by user191554 on 7/11/22.
//

import UIKit

class ErrorTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var lblErrorMessage: UILabel!
    
    func updateData(_ errorMessage: String) {
        self.lblErrorMessage.text = errorMessage
    }
}

extension ErrorTableViewCell {
    
    class func buildIn(_ tableView: UITableView, indexPath: IndexPath, errorMessage: String) -> ErrorTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ErrorTableViewCell", for: indexPath) as? ErrorTableViewCell
        cell?.updateData(errorMessage)
        return cell ?? ErrorTableViewCell()
    }
}
