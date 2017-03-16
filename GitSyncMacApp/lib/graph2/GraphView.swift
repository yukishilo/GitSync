import Cocoa
@testable import Element
@testable import Utils

class GraphView:Containable2{
    var maskSize:CGSize = CGSize()
    var contentSize:CGSize = CGSize()
    //var contentContainer:Element?
    var itemSize:CGFloat {return 48}//override this for custom value
    var interval:CGFloat{return floor(contentSize.w - maskSize.w)/itemSize}
    var progress:CGFloat{return SliderParser.progress(contentContainer!.x, maskSize.w, contentSize.w)}
    var timeBar:TimeBar?
    var valueBar:ValueBar?
    /*Anim*/
    var iterimScroll:InterimScroll = InterimScroll()
    
    
    override func resolveSkin() {
        StyleManager.addStyle("GraphView{float:left;clear:left;fill:green;fill-alpha:0.0;}")
        super.resolveSkin()
        /*config*/
        maskSize = CGSize(width,height)/*represents the visible part of the content *///TODO: could be ranmed to maskRect
        contentSize = CGSize(1600,height)/*represents the total size of the content *///TODO: could be ranmed to contentRect
        
        contentContainer = addSubView(Container(width,height,self,"content"))
        //addEllipse()
        addGraphLine()
        createTimeBar()
        createValueBar()
    }
    /*override func scrollWheel(with event: NSEvent) {//TODO: move to displaceview
        Swift.print("scrollWheel: ")
        //scroll(event)/*forward the event to the extension which adjust Slider and calls setProgress in this method*/
        super.scrollWheel(with: event)/*forward the event other delegates higher up in the stack*/
        switch event.phase{
            case NSEventPhase.changed:onScrollWheelChange(event)/*Fires everytime there is direct scrollWheel gesture movment and momentum, the momentum fades.*/
            case NSEventPhase(rawValue:0):onScrollWheelChange(event);/*Swift.print("none");*/break;//swift 3 update, was -> NSEventPhase.none
            default:break;
        }
    }*/
    /**
     * NOTE: Basically when you perform a scroll-gesture on the touch-pad
     */
    func onScrollWheelChange(_ event:NSEvent) {/*Direct scroll, not momentum*/
        Swift.print("📜 Scrollable.onScrollWheelChange: \(event.type)")
        let progressVal:CGFloat = SliderListUtils.progress(event.deltaX, interval, progress)
        setProgress(progressVal)
    }
    func setProgress(_ progress:CGFloat){
        Swift.print("🖼️ moving lableContainer up and down progress: \(progress)")
        //Swift.print("IScrollable.setProgress() progress: \(progress)")
        let progressValue = contentSize.w < maskSize.w ? 0 : progress/*pins the lableContainer to the top if itemsHeight is less than height*/
        //Swift.print("progressValue: " + "\(progressValue)")
        
        let x:CGFloat = ScrollableUtils.scrollTo(progressValue, maskSize.w, contentSize.w)
        contentContainer!.x = x/*we offset the y position of the lableContainer*/
        timeBar!.x = x
    }
    
}

extension GraphView{
    /**
     *
     */
    func addEllipse(){
        let gradient = LinearGradient(Gradients.blue(),[],π/2)
        let lineGradient = LinearGradient(Gradients.deepPurple(0.5),[],π/2)
        /*Styles*/
        let fill:GradientFillStyle = GradientFillStyle(gradient);
        let lineStyle = LineStyle(20,NSColorParser.nsColor(Colors.green()).alpha(0.5),CGLineCap.round)
        let line = GradientLineStyle(lineGradient,lineStyle)
        
        let objSize:CGSize = CGSize(200,200)
        Swift.print("objSize: " + "\(objSize)")
        let viewSize:CGSize = CGSize(width,height)
        Swift.print("viewSize: " + "\(viewSize)")
        let p = Align.alignmentPoint(objSize, viewSize, Alignment.centerCenter, Alignment.centerCenter,CGPoint())
        Swift.print("p: " + "\(p)")
        
        /*let rect = RectGraphic(0,0,width,height,fill,line)
         zoomContainer!.addSubview(rect.graphic)
         rect.draw()*/
        
        let ellipse = EllipseGraphic(p.x,p.y,200,200,fill.mix(Gradients.green()),line.mix(Gradients.lightGreen(0.5)))
        contentContainer!.addSubview(ellipse.graphic)
        ellipse.draw()
    }
    /**
     *
     */
    func addGraphLine(){
        //
        var css:String = "GraphLine{"
        css +=    "float:none;"
        css +=    "clear:none;"
        css +=    "line:#2AA3EF;"
        css +=    "line-alpha:1;"
        css +=    "line-thickness:0.5px;"
        css += "}"
        StyleManager.addStyle(css)
        typealias P = CGPoint
        
        //let points:[P] = [P(0,0),P(50,300),P(100,50),P(150,350),P(200,250),P()]
        
        var points:[P] = []
        for i in 0..<20{
            let x:CGFloat = 100*i
            let y:CGFloat = (0..<(height.int-32)).random.cgFloat
            let p = P(x,y)
            points.append(p)
        }
        
        let path:IPath = PolyLineGraphicUtils.path(points)
        let graphLine = contentContainer!.addSubView(GraphLine(width,height,path))
        _ = graphLine
        
        
    }

    /**
     *
     */
    func createTimeBar(){
        
        timeBar = addSubView(TimeBar(contentSize.width,32,self))
        let objSize = CGSize(timeBar!.w,32)
        Swift.print("objSize: " + "\(objSize)")
        let canvasSize = CGSize(w,h)
        Swift.print("canvasSize: " + "\(canvasSize)")
        let p = Align.alignmentPoint(objSize, canvasSize, Alignment.bottomLeft, Alignment.bottomLeft, CGPoint())
        Swift.print("p: " + "\(p)")
        //align timeBar to bottom with Align
        timeBar!.point = p
    }
    
    /**
     *
     */
    func createValueBar(){
        valueBar = addSubView(ValueBar(32,height-32,self))
        let objSize = CGSize(32,valueBar!.h)
        Swift.print("objSize: " + "\(objSize)")
        let canvasSize = CGSize(w,h)
        Swift.print("canvasSize: " + "\(canvasSize)")
        let p = Align.alignmentPoint(objSize, canvasSize, Alignment.topLeft, Alignment.topLeft, CGPoint())
        Swift.print("p: " + "\(p)")
        //align timeBar to bottom with Align
        valueBar!.point = p
    }
}
//TimeBar
//ValueBar
//GraphLine2
//HorizontalView
