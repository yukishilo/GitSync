import Foundation
import Cocoa
class TextInput:NSView{
    var title = ""
    var defaultInput = ""
    init(_ width:Int = 200, _ height:Int = 30, _ title:String = "", _ defaultInput:String = "") {
        self.title = title
        self.defaultInput = defaultInput
        let frame = NSRect(x: 0, y: 0, width: width, height: height)
        super.init(frame: frame)
        createContent()
        
    }
    override var wantsDefaultClipping() -> Bool{
        return false
    }
    /**
     * 
     */
    func createContent(){
        let nameText = NSTextField(frame: NSRect(x: 0, y: 0, width: 144, height: 20))
        nameText.stringValue = title
        nameText.editable = false
        nameText.bordered = false
        self.addSubview(nameText)
        
        let spacing = 12
        let x = Int(nameText.frame.origin.x) + Int(nameText.frame.width) + spacing
        let y = Int(nameText.frame.origin.y)
        let nameInputText = NSTextField(frame: NSRect(x: x, y: y, width: 144, height: 20))
        nameInputText.stringValue = defaultInput
        nameInputText.editable = true
        nameInputText.bordered = true
        self.addSubview(nameInputText)
    }
    /*
    * Draws the background
    */
    override func drawRect(dirtyRect: NSRect) {
        /*
        let pathRect = NSInsetRect(self.bounds, 1, 1);
        let path = NSBezierPath(roundedRect:pathRect, xRadius:0, yRadius:0);
        path.lineWidth = 1
        NSColor.whiteColor().setFill();
        NSColor.grayColor().setStroke();
        path.fill()
        path.stroke()
        */
        
    }
    /*
    * required by super class
    */
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /*
    * This makes sure that the view draws from top left corner
    */
    override var flipped:Bool {
        get {
            return true
        }
    }
    
}