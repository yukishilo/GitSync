import Cocoa

class GraphicsTest:Graphic{
    var x:Int
    var y:Int
    var width:Int
    var height:Int
    var color:NSColor
    var thePath:CGMutablePath
    init(_ x:Int = 0, _ y:Int = 0,_ width:Int = 100, _ height:Int = 100, _ color:NSColor = NSColor.blueColor()) {
        self.x = x
        self.y = y
        self.width = width
        self.height = height
        self.color = color
        self.thePath = CGPathParser.rect(CGFloat(width/*/2*/),CGFloat(height/*/2*/))//Shapes
        super.init(FillStyle(NSColor.yellowColor().alpha(0.5)),LineStyle(20,NSColor.blueColor().alpha(0.5)),OffsetType(OffsetType.center))
        
        //frame = NSRect(x: x,y: y,width: width,height: height)
        //self.wantsLayer = true//this avoids calling drawLayer() and enables drawingRect()
        //needsDisplay = true;
        //Swift.print("graphics: " + String(graphics.context))
        
        //a.masksToBounds = false
        Swift.print("layer!.contentsScale: " + "\(layer!.contentsScale)")
        let rect:CGRect = CGRect(50,50,100,100)
        
        fillShape.path = CGRect(0,0,rect.width,rect.height).path/*Draws in the local coordinate space of the shape*/
        fillShape.frame = rect/*,position and set the size of the frame*/
        fillShape.display()
        //alignStroke(self)
        let offsetRects = RectGraphicUtil.offsetRect(fillShape.frame, lineShape.lineStyle!, lineOffsetType)
        lineShape.frame = offsetRects.frameRect
        lineShape.path = offsetRects.lineRect.path
        lineShape.display()/*draw the lineShape*/
        Swift.print("lineShape.contentsScale: " + "\(lineShape.contentsScale)")
    }
    required init?(coder: NSCoder) {fatalError("init(coder:) has not been implemented")}/*Required by super class*/
    /**
     * NOTE: this is for offseting rectangle
     * NOTE: The fill.frame is the position and location of the Graphic (the frame of the graphic is a ZeroRect, with no clipping)
     * NOTE: The path in fill.path is the path that line.path will be based on
     */
    func alignStroke(graphic:Graphic){
        
        //continue here
        //return a tuple with (frameRect and pathRect)
        //Mimic the current RectUtil setup
        //support all the different left right top bottom etc. 
        //write a note that you can optimize by storing halfsizes etc
        //test in the current element framework with a simple shape
        //the move on to do the same to round rect and circle and ellipse
        //add support for positioning 
        //test with the tabbar example
        //move on
        
    }
    
        
}

private class RectGraphicUtil {
    /**
     *
     */
    class func offsetRect(rect:CGRect, _ lineStyle:ILineStyle, _ offsetType:OffsetType)->(lineRect:CGRect, frameRect:CGRect) {
        var lineRect:CGRect = CGRect()
        var frameRect:CGRect = CGRect()
        //graphic.frame.width
        //graphic.frame.height
        //graphic.lineOffsetType
        //graphic.lineStyle!.thickness
        let thickness:CGFloat = lineStyle.thickness
        if(offsetType == OffsetType(OffsetType.center)){/*Asserts if all props of the lineOffsetType is of the center type*/
            /*frame*/
            let offsetRect = rect.outset(thickness/2, thickness/2)
            frameRect = offsetRect
            Swift.print("offsetRect: " + "\(offsetRect)")
            lineRect = offsetRect
            /*path*/
            //graphic.lineShape.path = graphic.fillShape.path.copy()
            //graphic.lineShape.path = CGPathModifier.translate(&graphic.lineShape.path, thickness/2, thickness/2)/*move the path half the thickness left and down*/
            //graphic.lineShape.path = linePath//graphic.fillShape.path
            lineRect += CGPoint(thickness/2, thickness/2)
        }else if(offsetType == OffsetType(OffsetType.inside)){/*inside*/
            /*frame*/
            frameRect = rect
            /*path*/
            let offsetRect = CGRect(0,0,rect.width,rect.height).inset(thickness/2, thickness/2)
            Swift.print("offsetRect: " + "\(offsetRect)")
            lineRect = offsetRect
        }else{/*outside*/
            /*frame*/
            let frameOffsetRect = rect.outset(thickness, thickness)
            Swift.print("frameOffsetRect: " + "\(frameOffsetRect)")
            frameRect = frameOffsetRect
            /*path*/
            let lineOffsetRect = CGRect(thickness/2,thickness/2,rect.width+thickness,rect.height+thickness)/*you expand the rect in the 0,0 coordinatespace*/
            Swift.print("lineOffsetRect: " + "\(lineOffsetRect)")
            
            lineRect = lineOffsetRect
        }
        
        
        return (lineRect,frameRect)
    }
}