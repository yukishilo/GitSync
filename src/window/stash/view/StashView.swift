import Cocoa

class StashView:CustomView {
    var leftSideBar:LeftSideBar?
    override func resolveSkin() {
       
        var cssString = "@import url(\"mainContent.css\");\nButton{fill:blue;}"
        Swift.print("cssString: " + "\(cssString)")
        cssString += ""
        
        let result = CSSFileParser.separateImportsAndStyles(cssString)
        
        Swift.print("result.imports: " + "\(result.imports)")
        Swift.print("result.style: " + "\(result.style)")
        
        
        return
        
        var css = ""//E8E8E8
        css += "Window Element#background{fill:#EFEFF4;fill-alpha:0;}"//<--you should target a bg element not the window it self, since now everything inherits these values
        StyleManager.addStyle(css)
        super.resolveSkin()
        leftSideBar = addSubView(LeftSideBar(LeftSideBar.w,height,self)) as? LeftSideBar
        createCustomTitleBar()
        leftSideBar!.createButtons()
        addSubView(MainContent(frame.width-LeftSideBar.w,frame.height,self))
    }
    func createCustomTitleBar() {
        StyleManager.addStylesByURL("~/Desktop/css/titleBar.css")
        StyleManager.addStyle("Section#titleBar{padding-top:16px;padding-left:12px;}")
        
        section = leftSideBar!.addSubView(Section(75,16,leftSideBar,"titleBar")) as? Section
        closeButton = section!.addSubView(Button(0,0,section!,"close")) as? Button/*<--TODO: the w and h should be NaN, test if it supports this*/
        minimizeButton = section!.addSubView(Button(0,0,section!,"minimize")) as? Button
        maximizeButton = section!.addSubView(Button(0,0,section!,"maximize")) as? Button
    }
    override func createTitleBar() {
    }
}

