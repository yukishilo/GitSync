import Foundation
@testable import Utils

class GitSync{
    typealias PushComplete = ()->Void
    /**
     * Handles the process of making a commit for a single repository
     * PARAM: idx: stores the idx of the repoItem in PARAM repoList which is needed in the onComplete to then start the push on the correct item
     */
    static func initCommit(_ repoItem:RepoItem, _ commitMessage:CommitMessage? = nil, _ onPushComplete:@escaping PushComplete){
        func doCommit(){
            _ = commit(repoItem,commitMessage)/*🌵 if there were no commits false will be returned*/
            initPush(repoItem, onPushComplete)//push or check if you need to pull down changes and subsequently merge something
        }
        if let unMergedFiles = GitParser.unMergedFiles(repoItem.local).optional {/*🌵Asserts if there are unmerged paths that needs resolvment, aka remote changes that isnt in local*/
            MergeReslover.shared.resolveConflicts(repoItem, unMergedFiles){
                doCommit()
            }
        }else{
           doCommit()
        }
    }
    /**
     * Handles the process of making a push for a single repository (When a singular commit has competed this method is called)
     * NOTE: We must always merge the remote branch into the local branch before we push our changes.
     * NOTE: this method performs a "manual pull" on every interval
     * TODO: ⚠️️ Contemplate implimenting a fetch call after the pull call, to update the status, whats the diff between git fetch and git remote update again?
     * IMPORTANT: ⚠️️ this is called on a background thread
     */
    private static func initPush(_ repoItem:RepoItem, _ onPushComplete:@escaping PushComplete){
        MergeUtils.manualMerge(repoItem){//🌵🌵🌵 commits, merges with promts, (this method also test if a merge is needed or not, and skips it if needed)
            let repo:GitRepo = repoItem.gitRepo
            let hasLocalCommits = GitAsserter.hasLocalCommits(repo.localPath, repoItem.branch)/*🌵🌵 TODO: maybe use GitAsserter's is_local_branch_ahead instead of this line*/
            if hasLocalCommits { //only push if there are commits to be pushed, hence the has_commited flag, we check if there are commits to be pushed, so we dont uneccacerly push if there are no local commits to be pushed, we may set the commit interval and push interval differently so commits may stack up until its ready to be pushed, read more about this in the projects own FAQ
                guard let keychainPassword:String = KeyChainParser.password("GitSyncApp") else{ fatalError("password not found")}
                let key:GitKey = .init(PrefsView.prefs.login, keychainPassword)
                if PrefsView.prefs.login.isEmpty || keychainPassword.isEmpty {fatalError("need login and pass")}
                _ = GitModifier.push(repo,key)/*🌵*/
            }
            {/*Swift.print("before call");*/onPushComplete()}()
        }
    }
    /**
     * This method generates a git status list,and asserts if a commit is due, and if so, compiles a commit message and then tries to commit
     * Returns true if a commit was made, false if no commit was made or an error occured
     * NOTE: checks git staus, then adds changes to the index, then compiles a commit message, then commits the changes, and is now ready for a push
     * NOTE: only commits if there is something to commit
     * TODO: ⚠️️ add branch parameter to this call
     * NOTE: this a purly local method, does not need to communicate with remote servers etc..
     */
    static func commit(_ repoItem:RepoItem, _ commitMessage:CommitMessage? = nil)->Bool{
//        Swift.print("commit: \(commitMessage)")
        guard let msg:CommitMessage = commitMessage ?? CommitMessage.autoCommitMessage(repoItem: repoItem, commitMessage: commitMessage) else{return false}/*No commitMessage means no commit*/
        if repoItem.notification { NotificationManager.notifyUser(message: msg,repo: repoItem) }
//        Swift.print("msg.title: " + "\(msg.title)")
        _ = GitModifier.commit(repoItem.localPath, CommitMessage(msg.title,msg.description))//🌵 commit
        return true
    }
}

