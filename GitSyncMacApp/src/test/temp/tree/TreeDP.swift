import Foundation
@testable import Element
@testable import Utils

class TreeDP:DataProvidable {
    var tree:Tree
    var hashList:HashList = {return TreeUtils.hashList(self.tree)}()
    init(_ tree:Tree){
        self.tree = tree
    }
}

extension TreeDP{
    /**
     * PARAM: at:
     */
    func item(_ at:Int) -> [String:String]?{
       
        return nil
    }
    var count:Int{
        return 0
    }
}
