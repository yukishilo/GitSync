//import Foundation
//@testable import Utils
//@testable import Element
//
//class AutoInit {
//    /**
//     * Automatically creates a local git repo based on the remote repo, if a local repo already exists, it is unharmfully merged into
//     * TODO: ⚠️️ this method is complete except merge_conflict_file_list needs to be generated somehow
//     * PARAM branch: the branch you want to use as origin branch
//     * EXAMPLE: AutoInit.autoInit("~/dev/welcome/".tildePath, remotePath: "github.com/gitsync/welcome.git", branch: "master")
//     */
//    static func autoInit(_ repoItem:RepoItem,doesPathExist:Bool,isGitFolder:Bool,isFolderEmpty:Bool){
//        let localPath:String = repoItem.localPath
//        let remotePath:String = repoItem.remotePath
//        let branch:String = repoItem.branch
//        Swift.print("AutoInit.autoInit()")
////        let doesPathExist = FileAsserter.exists(localPath)
//        Swift.print("doesPathExist: " + "\(doesPathExist)")
//        if doesPathExist {
////            let isFolderEmpty:Bool = FileParser.contentOfDir(localPath)?.isEmpty ?? false
////            Swift.print("isFolderEmpty: " + "\(isFolderEmpty)")
//            if isFolderEmpty {//--folder is empty
//                //GitUtils.manualClone(localPath, remotePath)
//                _ = GitModifier.clone(remotePath,localPath)
//                //let cloneRetVal = GitModifier.clone(remotePath, localPath)
//                //Swift.print("cloneRetVal: " + "\(cloneRetVal)")
//                //GitUtil's clone(remote_url, local_dir)--git clone with custom file path
//            }else{//--folder is not empty, files already exist
////                let isGitFolder:Bool = GitAsserter.isGitRepo(localPath)
//                if isGitFolder {//--folder already contains a .git folder (aka git repo data)
//                    let has_remote_repo_attached = GitAsserter.hasRemoteRepoAttached(localPath, branch)
//                    if has_remote_repo_attached  {//--the .git folder already has a remote repo attached
//                        _ = GitModifier.detachRemoteRepo(localPath/*branch*/)//--promt the user if he wants to use the existing remote origin, this will skip the user needing to input a remote url
//                        _ = GitModifier.attachRemoteRepo(localPath,branch)
//                    }else{//--does not have remote repo attached
//                        _ = GitModifier.attachRemoteRepo(localPath,branch)//--attach remote repo
//                    }
//                }else{//--has no .git folder, but there are some files like text.txt
//                    _ = GitModifier.initialize(localPath)
//                    _ = GitModifier.attachRemoteRepo(localPath,branch)//--add new remote origin
//                }
////                let gitRepo = GitRepo(localPath,  remotePath,  branch)
////                let repoItem = RepoItem.repoItem(gitRepo)
//                MergeUtils.manualMerge(repoItem){
//                    Swift.print("Manual merge completed")
//                }
//            }
//        }else {//--path does not exist
//            //GitUtils.manualClone(localPath, remotePath)
//            _ = GitModifier.clone(remotePath,localPath)
//            //_ = GitModifier.clone(remotePath, localPath)
//            //GitUtil's clone(remote_url, local_dir)//--this will also create the folders if they dont exist, even nested
//        }
//    }
//}
