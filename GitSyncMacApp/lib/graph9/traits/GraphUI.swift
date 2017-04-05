import Cocoa
@testable import Element
@testable import Utils
/*CreateContent*/
extension Graph9{
    /**
     * Creates the TimeBar
     */
    func createTimeBar(){
        StyleManager.addStylesByURL("~/Desktop/ElCapitan/basic/list/vlist.css")//changes the css to align sideways
        StyleManager.addStyle("Graph9 VList{float:none;clear:none;}")
        /**/
        let dp:TimeDP = TimeDPUtils.timeDP(curTimeType,range)
        timeBar = addSubView(TimeBar3(w,24,24,dp,self,nil,.hor,100))
        alignTimeBar()
    }
    /**
     * Creates the ValueBar
     */
    func createValueBar(){
        valueBar = addSubView(ValueBar(32,height-32,self))
        let objSize = CGSize(32,valueBar!.h)
        Swift.print("ValueBar.objSize: " + "\(objSize)")
        let canvasSize = CGSize(w,h)
        Swift.print("ValueBar.canvasSize: " + "\(canvasSize)")
        let p = Align.alignmentPoint(objSize, canvasSize, Alignment.topLeft, Alignment.topLeft, CGPoint())
        Swift.print("p: " + "\(p)")
        //align timeBar to bottom with Align
        valueBar!.point = p
    }
    /**
     *
     */
    func createGraphLine(){
        addGraphLineStyle()
        /**/
        graphPts = randomGraphPoints()
        let path:IPath = PolyLineGraphicUtils.path(graphPts!)
        graphLine = contentContainer!.addSubView(GraphLine(width,height,path,contentContainer!))
    }
    /**
     * Creates The visual Graph points that hover above the Graph line
     * NOTE: We could create something called GraphPoint, but it would be another thing to manager so instead we just use an Element with id: graphPoint
     */
    func createGraphPoints(){
        addGraphPointStyle()
        /**/
        graphPoints = []
        graphPts!.forEach{
            let graphPoint:Element = contentContainer!.addSubView(Element(NaN,NaN,contentContainer!,"graphPoint"))
            graphPoints!.append(graphPoint)
            graphPoint.setPosition($0)
        }
    }
    func alignTimeBar(){
        let objSize = CGSize(w,24)
        //Swift.print("objSize: " + "\(objSize)")
        let canvasSize = CGSize(w,h)
        //Swift.print("canvasSize: " + "\(canvasSize)")
        let p = Align.alignmentPoint(objSize, canvasSize, Alignment.bottomLeft, Alignment.bottomLeft, CGPoint())
        //Swift.print("p: " + "\(p)")
        //align timeBar to bottom with Align
        timeBar!.point = p
    }
}
