//
//  KCView.m
//  SAVideoRangeSliderExample
//
//  Created by 李康 on 15/7/1.
//  Copyright (c) 2015年 Andrei Solovjev. All rights reserved.
//

#import "KCView.h"

@implementation KCView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
//    [self drawLin2];
    [self drawImage];
    
}
- (void)drawImage{
    UIImage *image = [UIImage imageNamed:@"image"];
    
//    [image drawAtPoint:CGPointMake(100, 100)];
//    压缩
    [image drawInRect:CGRectMake(0, 0, 100, 100)];
//平铺
    [image drawAsPatternInRect:CGRectMake(110, 110, 200, 200)];
}
//绘制文字
- (void)drawText{
    
    NSString *str = @"Star Walk is the most beautiful stargazing app you’ve ever seen on a mobile d";
    CGRect rect = CGRectMake(20, 50, 280, 300);
    
    UIFont *font = [UIFont systemFontOfSize:18];
    UIColor *color =[UIColor redColor];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
    style.alignment = NSTextAlignmentLeft;
    [str drawInRect:rect withAttributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:color,NSParagraphStyleAttributeName:style}];
    
}
//贝塞尔曲线
- (void)drawCurve{
    CGContextRef content = UIGraphicsGetCurrentContext();
    
    //起始点
    CGContextMoveToPoint(content, 20, 100);
    /*绘制二次贝塞尔曲线
     c:图形上下文
     cpx:控制点x坐标
     cpy:控制点y坐标
     x:结束点x坐标
     y:结束点y坐标
     */
    CGContextAddQuadCurveToPoint(content, 60, 0, 300, 100);
    
    
    
    /*绘制三次贝塞尔曲线
     c:图形上下文
     cp1x:第一个控制点x坐标
     cp1y:第一个控制点y坐标
     cp2x:第二个控制点x坐标
     cp2y:第二个控制点y坐标
     x:结束点x坐标
     y:结束点y坐标
     */
    
    //起始点
    CGContextMoveToPoint(content,20, 200);
    
    CGContextAddCurveToPoint(content, 60, 100, 260, 300, 280, 200);
    
    [[UIColor yellowColor] setFill];
    [[UIColor redColor] setStroke];
    CGContextDrawPath(content, kCGPathFillStroke);
}
//绘制圆弧
- (void)drawArc{
    CGContextRef content = UIGraphicsGetCurrentContext();
    
    [[UIColor yellowColor] set];
    
    /*添加弧形对象
     x:中心点x坐标
     y:中心点y坐标
     radius:半径
     startAngle:起始弧度
     endAngle:终止弧度
     closewise:是否逆时针绘制，0则顺时针绘制
     */
    CGContextAddArc(content, 100, 100, 100,0, M_PI, 0);
    CGContextDrawPath(content, kCGPathFillStroke);
}
//绘制圆
- (void)drawEllipse{
    CGContextRef content = UIGraphicsGetCurrentContext();
    CGRect rect = CGRectMake(50, 50, 200, 300);
    CGContextAddEllipseInRect(content , rect);
    CGContextDrawPath(content, kCGPathFillStroke);
}
- (void)draw3{
    CGRect rect = CGRectMake(20, 100, 280, 40);
    
    CGRect rect2 = CGRectMake(20, 200, 280, 40);
    
    //设置边框及填充颜色
    [[UIColor yellowColor] set];
    UIRectFill(rect);
    
    //设置边框颜色
    [[UIColor redColor] setStroke];
    UIRectFrame(rect2);
    
}
- (void)draw2{
    
    //矩形
    
    CGContextRef content = UIGraphicsGetCurrentContext();
    
    CGRect rect = CGRectMake(20, 50, 280, 60);
    
    CGContextAddRect(content, rect);
    
    [[UIColor blueColor] set];
    
    CGContextDrawPath(content, kCGPathFillStroke);
    
    
}
- (void)drawLin2{
    CGContextRef content = UIGraphicsGetCurrentContext();
    
//    绘制路径
    CGContextMoveToPoint(content, 20, 50);
    CGContextAddLineToPoint(content, 220, 50);
    CGContextAddLineToPoint(content, 220, 100);
//    CGContextAddLineToPoint(content, 20, 100);
    CGContextClosePath(content);
    
    //设置图形上下文属性
    CGContextSetRGBFillColor(content, 0.5, 0.9, 0.1, 1.0);
    CGContextSetRGBStrokeColor(content, 0.1, 0.3, 0.7, 1.0);
    //绘制路径
    CGContextDrawPath(content, kCGPathFillStroke);
}
- (void)draw1{
    
    //获取上下文
    CGContextRef content = UIGraphicsGetCurrentContext();
    //设置路径
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, nil, 0, 200);
    CGPathAddLineToPoint(path, nil, 300, 200);
    CGPathAddLineToPoint(path, nil, 0, 300);
    CGPathAddLineToPoint(path, nil, 150, 100);
    CGPathAddLineToPoint(path, nil, 300, 300);
    CGPathAddLineToPoint(path, nil, 0, 200);
    CGContextAddPath(content, path);
    
    //设置图形状态属性
    CGContextSetRGBStrokeColor(content, 1, 0, 1, 1.0);
    CGContextSetRGBFillColor(content, 1, 1, 0, 1.0);
    CGContextSetLineWidth(content, 2.0);
    CGContextSetLineCap(content, kCGLineCapRound);
    CGContextSetLineJoin(content, kCGLineJoinRound);
    
    //设置线段样式
    CGFloat lengths[2] = {18,9};
    CGContextSetLineDash(content, 0, lengths, 2);
    CGContextDrawPath(content, kCGPathFillStroke);
    
    //设置阴影
    /*设置阴影
     context:图形上下文
     offset:偏移量
     blur:模糊度
     color:阴影颜色
     */
    CGColorRef color = [UIColor grayColor].CGColor;
    CGContextSetShadowWithColor(content, CGSizeMake(3, 3), 0.8, color);
    CGContextDrawPath(content, kCGPathFillStroke);
    
    CGPathRelease(path);
}


@end
