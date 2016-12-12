import Cocoa
/**
 * This is the main class for the application
 * TODO: An idea is to hide the interface when the mouse is not over the app (anim in and out) (maybe)
 */
@NSApplicationMain
class AppDelegate:NSObject, NSApplicationDelegate {
    weak var window: NSWindow!
    var repoFilePath:String = "~/Desktop/repo.xml"
    var win:NSWindow?/*<--The window must be a class variable, local variables doesn't work*/
    var fileWatcher:FileWatcher?
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        NSApp.windows[0].close()/*<--Close the initial non-optional default window*/
        
        Swift.print("GitSync - Simple git automation for macOS")
        
        var testString:String = "Author:Eonist" + "\n"
        testString += "Date:2015-12-03 16:59:09 +0100" + "\n"
        testString += "Subject:'Files modified: 1'" + "\n"
        testString += "Body:'" + "\n"
        testString += "" + "\n"
        testString += "Modified 1 file:" + "\n"
        testString += "README.md" + "\n"
        testString += "'"
        //Swift.print(testString)
        
        let firstIdx:Int = testString.indexOf("\n")
        Swift.print("firstIdx: " + "\(firstIdx)")
        let firstPart:String = testString.subString(0,firstIdx)
        Swift.print("firstPart: " + "\(firstPart)")
        //Swift.print("firstPart: " + "\(firstPart)")
        
        let secondIdx:Int = firstIdx+1 + testString.subString(firstIdx+1,testString.count).indexOf("\n")
        Swift.print("secondIdx: " + "\(secondIdx)")
        
        let secondPart:String = testString.subString(firstIdx+1,secondIdx)
        Swift.print("secondPart: " + "\(secondPart)")
        
        let thirdIdx:Int = secondIdx+1 + testString.subString(secondIdx+1,testString.count).indexOf("\n")
        Swift.print("thirdIdx: " + "\(thirdIdx)")
        
        let thirdPart:String = testString.subString(secondIdx+1,thirdIdx)
        Swift.print("thirdPart: " + "\(thirdPart)")
        
        let fourthPart:String = testString.subString(thirdIdx+1,testString.count)
        Swift.print("fourthPart: " + "\(fourthPart)")
        
        var commitData:(author:String,date:String,subject:String,body:String) = (author:firstPart,date:secondPart,subject:thirdPart,body:fourthPart)
        commitData.author = commitData.author.subString("Author:".count, commitData.author.count)
        commitData.date = commitData.date.subString("Date:".count, commitData.date.count)
        commitData.subject = commitData.subject.subString("Subject:".count, commitData.subject.count)
        commitData.body = commitData.body.subString("Body:".count, commitData.body.count)
        Swift.print("commitData.author: " + "\(commitData.author)")
        Swift.print("commitData.date: " + "\(commitData.date)")
        Swift.print("commitData.subject: " + "\(commitData.subject)")
        Swift.print("commitData.body: " + "\(commitData.body)")
        
        let date:NSDate = GitLogParser.date(commitData.date)
        Swift.print("date.shortDate: " + "\(date.shortDate)")
        
        let today:NSDate = NSDate()
        Swift.print("today.shortDate: " + "\(today.shortDate)")
        
        let threeDaysAgo = today.offsetByDays(-3)
        Swift.print("threeDaysAgo!.shortDate: " + "\(threeDaysAgo.shortDate)")
        
        let relativeTime = DateParser.relativeTime(today,threeDaysAgo)
        Swift.print("relativeTime: " + "\(relativeTime)")
    }
    func sortTest(){
        let sortedArray = customArray.sort { (element1, element2) -> Bool in
            return element1.name < element2.name
        }
    }
    func commitDataTest(){
        
    }
    func initApp(){
        StyleManager.addStylesByURL("~/Desktop/ElCapitan/gitsync.css",true)//<--toggle this bool for live refresh
        
        win = MainWin(MainView.w,MainView.h)
        //win = ConflictDialogWin(380,400)
        //win = CommitDialogWin(400,356)
        
        let url:String = "~/Desktop/ElCapitan/gitsync.css"
        fileWatcher = FileWatcher([url.tildePath])
        fileWatcher!.event = { event in
            //Swift.print(self)
            Swift.print(event.description)
            if(event.fileChange && event.path == url.tildePath) {
                Swift.print("update to the file happened")
                StyleManager.addStylesByURL(url,true)
                let view:NSView = self.win!.contentView!//MainWin.mainView!
                ElementModifier.refreshSkin(view as! IElement)
                ElementModifier.floatChildren(view)
            }
        }
        fileWatcher!.start()
    }
    func applicationWillTerminate(aNotification:NSNotification) {
        //store the app prefs
        if(PrefsView.keychainUserName != nil){//make sure the data has been read and written to first
            let xml:XML = "<prefs></prefs>".xml
            xml.appendChild("<keychainUserName>\(PrefsView.keychainUserName!)</keychainUserName>".xml)
            xml.appendChild("<gitConfigUserName>\(PrefsView.gitConfigUserName!)</gitConfigUserName>".xml)
            xml.appendChild("<gitEmailName>\(PrefsView.gitEmailNameText!)</gitEmailName>".xml)
            xml.appendChild("<uiSounds>\(String(PrefsView.uiSounds!))</uiSounds>".xml)
            FileModifier.write("~/Desktop/gitsyncprefs.xml".tildePath, xml.XMLString)
        }
        //store the repo xml
        if(RepoView.dp != nil){//make sure the data has been read and written to first
            FileModifier.write("~/Desktop/assets/xml/list.xml".tildePath, RepoView.dp!.xml.XMLString)
        }
        print("Good-bye")
    }
}
