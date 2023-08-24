//
//  Extensions.swift
//  Shorts-Player
//
//  Created by Karthik Reddy on 17/08/23.
//

import Foundation
import UIKit

extension UIFont {
    static func notoFont(size: CGFloat,weight: UIFont.Weight)-> UIFont{
        switch weight {
        case .bold:
            return UIFont(name: "NotoSans-Bold", size: size)!
        case .medium:
            return UIFont(name: "NotoSans-Medium", size: size)!
        default:
            return UIFont(name: "NotoSans-Medium", size: size)!
        }
    }
}

//extension UICollectionView {
//    func isCellAtIndexPathFullyVisible(_ indexPath: IndexPath) -> Bool {
//        let cellFrame = rectForRow(at: indexPath)
//        return bounds.contains(cellFrame)
//    }
//    
//    func indexPathsForFullyVisibleRows() -> [IndexPath] {
//        let visibleIndexPaths = indexPathsForVisibleRows ?? []
//        return visibleIndexPaths.filter { indexPath in
//            return isCellAtIndexPathFullyVisible(indexPath)
//        }
//    }
//}
