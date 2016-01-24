import Cocoa

class TranslucentWin:NSWindow, NSApplicationDelegate, NSWindowDelegate{
    /**
     *
     */
    override init(contentRect: NSRect, styleMask aStyle: Int, backing bufferingType: NSBackingStoreType, `defer` flag: Bool) {
        super.init(contentRect: Win.sizeRect, styleMask: NSTitledWindowMask|NSResizableWindowMask|NSMiniaturizableWindowMask|NSClosableWindowMask|NSFullSizeContentViewWindowMask, backing: NSBackingStoreType.Buffered, `defer`: false)
        self.contentView!.wantsLayer = true;/*this can and is set in the view*/
        self.backgroundColor = NSColor.whiteColor().alpha(1.0)
        self.opaque = false
        self.makeKeyAndOrderFront(nil)//moves the window to the front
        self.makeMainWindow()//makes it the apps main menu?
        //self.appearance = NSAppearance(named: NSAppearanceNameVibrantDark)
        self.titlebarAppearsTransparent = true
        self.center()
        //view.wantsLayer = true;//this should be set in the iew not here
        //self.contentView = view
        //self.title = ""/*Sets the title of the window*/
        self.title = ""//GitSync
        
        self.delegate = self
        
        let visualEffectView = NSVisualEffectView(frame: NSMakeRect(0, 0, 300, 180))
        visualEffectView.material = NSVisualEffectMaterial.Dark
        visualEffectView.blendingMode = NSVisualEffectBlendingMode.BehindWindow
        visualEffectView.state = NSVisualEffectState.Active
    }
    /*
     * Required by the NSWindow
     */
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}