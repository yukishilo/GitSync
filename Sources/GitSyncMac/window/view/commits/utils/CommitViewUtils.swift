import Foundation
@testable import Utils

typealias CommitLogOperation = (task:Process,pipe:Pipe,repoTitle:String,repoIndex:Int)
class CommitViewUtils {
    typealias ProcessedCommitData = (date:Date,relativeDate:String,descendingDate:String,body:String,subject:String,hash:String,author:String)
    /**
     * ProcessedCommitData
     * NOTE: conforms dates, msg-desc, msg-title,
     */
    static func processCommitData(_ repoTitle:String,_ commitData:CommitData)->ProcessedCommitData{
        let date:Date = GitDateUtils.date(commitData.date)
        //Swift.print("date.shortDate: " + "\(date.shortDate)")
        let relativeTime:(value:Int,type:String) = DateParser.relativeTime(Date(),date)[0]
        let relativeDate:String = relativeTime.value.string + relativeTime.type/*create date like 3s,4m,5h,6w,2y*/
        let descendingDate:String = DateParser.descendingDate(date)
        let compactBody:String = GitLogParser.compactBody(commitData.body)/*Compact the commit msg body*/
        let subject:String = StringParser.trim(commitData.subject, "'", "'")
        return (date,relativeDate,descendingDate,compactBody,subject,commitData.hash,commitData.author)
    }
    /**
     * -> Dictionary<String, String>
     * TODO: Use the new CommitDataItem
     */
    static func processCommitData(_ repoTitle:String,_ commitData:CommitData)-> [String:String]{
        let data:ProcessedCommitData = processCommitData(repoTitle,commitData)
        let dict:[String:String] = [
            CommitItem.repoName:repoTitle,
            CommitItem.contributor:commitData.author,
            CommitItem.title:data.subject,
            CommitItem.description:data.body,
            CommitItem.date:data.relativeDate,
            CommitItem.sortableDate:data.descendingDate,
            CommitItem.hash:commitData.hash,
            CommitItem.gitDate:commitData.date]
        return dict
    }
    /**
     * PARAM: max = max Items Allowed per repo
     */
    static func commitItems(_ localPath:String,_ max:Int)->[String]{
        let commitCount:Int = GitUtils.commitCount(localPath).int - 1/*Get the commitCount of this repo*/
        //Swift.print("commitCount: " + ">\(commitCount)<")
        let length:Int = commitCount > max ? max : commitCount//20 = maxCount
        //Swift.print("length: \(length) max: \(max)")
        var args:[String] = []
        let formating:String = " --pretty=format:Hash:%h%nAuthor:%an%nDate:%ci%nSubject:%s%nBody:%b"//"-3 --oneline"//
        for i in 0..<length{
            let cmd:String = "git show head~" + "\(i)" + formating + " --no-patch"//--no-patch suppresses the diff output of git show
            args.append(cmd)
        }
        return args
    }
    /**
     * Sets up a NSTask
     * PARAM: index: repoIndex aka repoHash aka repoUniversalIdentifier
     */
    static func configOperation(_ args:[String],_ localPath:String,_ repoTitle:String, _ repoIndex:Int) -> CommitLogOperation{
        let task = Process()
        task.currentDirectoryPath = localPath
        task.launchPath = "/bin/sh"//"/usr/bin/env"//"/bin/bash"//"~/Desktop/my_script.sh"//
        task.arguments = ["-c",args[0]]//["echo", "hello world","  echo","again","&& echo again","\n echo again"]//["ls"]//"-c", "/usr/bin/killall Dock",
        let pipe = Pipe()
        task.standardOutput = pipe

        //task.waitUntilExit()/*not needed if we use NSNotification*/
        return (task,pipe,repoTitle,repoIndex)
    }
}
enum CommitItem {
    static let repoName:String = "repo-name"
    static let contributor:String = "contributor"
    static let title:String = "title"
    static let description:String = "description"
    static let date:String = "date"
    static let sortableDate:String = "sortableDate"
    static let hash:String = "hash"
    static let gitDate:String = "gitDate"
}

//DEPRECATED
extension CommitViewUtils{
    /**
     * -> Commit
     * DEPRECATED
     */
    /*static func processCommitData(_ repoTitle:String,_ commitData:CommitData, _ repoIndex:Int)->Commit{
        let data:ProcessedCommitData = processCommitData(repoTitle,commitData,repoIndex)
        let commit:Commit = Commit(repoTitle,data.author, data.subject, data.body, data.relativeDate, data.descendingDate.int, data.hash,0)
        //return
        return commit
    }*/
}
