import Foundation
@testable import Utils
/**
 * Note: We dont use a struct here because struct doesnt do lazy var
 */
class AutoInitConflict{
    let repoItem:RepoItem
    lazy var pathExists:Bool = {
        return FileAsserter.exists(self.repoItem.localPath.tildePath)
    }()
    lazy var isGitRepo:Bool = {
        return self.pathExists && GitAsserter.isGitRepo(self.repoItem.localPath.tildePath)
    }()
    lazy var hasPathContent:Bool = {
        return self.pathExists && FileAsserter.hasContent(self.repoItem.localPath.tildePath)
    }()
    init(_ repoItem:RepoItem){
        self.repoItem = repoItem
    }
}
