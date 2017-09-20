import Foundation

import Cocoa
@testable import Utils
@testable import Element

extension GraphScrollView5{
    /**
     * Initiates the animation sequence
     * NOTE: this method can be called in quick sucession as it stops any ongoing animation before it is started
     */
    func initAnim(){
        let x = self.contentContainer.layer!.position.x.clip(-(contentSize.w-width), 0)//this clip avoids working on elastic values
        let minY = GraphScrollerHandler3.Utils.minY(x:x, width:width, points:graphArea.points,padding:00)
        let ratio:CGFloat = GraphScrollerHandler3.Utils.calcRatio(minY: minY, height: height)
        animator.targetValue = ratio
        if animator.stopped {animator.start()}
    }
    /**
     * Interpolates between 0 and 1 while the duration of the animation
     * NOTE: ReCalc the hValue indicators (each graph range has a different max hValue etc)
     */
    func interpolateValue(_ val:CGFloat){
        let x = self.contentContainer.layer!.position.x.clip(-(contentSize.w-width), 0)//this clip avoids working on elastic values
        let pts:[CGPoint] = GraphScrollerHandler3.Utils.calcPointsWithin(x: x, width: width, points: graphArea.points,padding: 200)
        let scaledPts:[CGPoint] = GraphScrollerHandler3.Utils.calcScaledPoints(points: pts, ratio: val, height: height)
        /*GraphPoints*/
        for (i,graphDot) in graphArea.graphDots.enumerated(){
            if let pt = scaledPts[safe:i]{
                graphDot.isHidden = false
                graphDot.layer?.position = pt//CGPoint(0,pt.y)
            }else{//dirty fix
                graphDot.isHidden = true
            }
        }
        /*updateGraphLine*/
        let graphLine = graphArea.graphLine
        graphLine.line!.cgPath = CGPathParser.polyLine(scaledPts)//graphArea.graphDots.map{$0.layer!.position}
        graphLine.line!.draw()//draws the path
    }
}

