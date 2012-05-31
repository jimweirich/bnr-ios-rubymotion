class Point
  attr_reader :x, :y

  def initialize(x, y)
    @x = x
    @y = y
  end

  def +(other_point)
    Point.new(x + other_point.x, y + other_point.y)
  end

  def -(other_point)
    self + other_point*(-1)
  end

  def *(scaler)
    Point.new(scaler*x, scaler*y)
  end

  def to_size
    CGSizeMake(x, y)
  end
end

class Box
  attr_reader :origin, :size

  def initialize(frame_or_rect)
    if frame_or_rect.is_a?(CGRect)
      @origin = Point.new(frame_or_rect.origin.x, frame_or_rect.origin.y)
      @size   = Point.new(frame_or_rect.size.width, frame_or_rect.size.height)
    else
      @origin = Point.new(frame_or_rect[0][0], frame_or_rect[0][1])
      @size   = Point.new(frame_or_rect[1][0], frame_or_rect[1][1])
    end
  end

  def center
    @origin + @size * 0.5
  end

  def translate(delta_x, delta_y)
    self.class.new([[x+delta_x, y+delta_y], [width, height]])
  end

  def scale(scale_x, scale_y)
    self.class.new([[x, y], [scale_x*width, scale_y*height]])
  end

  def +(point)
    translate(point.x, point.y)
  end

  def *(scaler)
    scale(scaler, scaler)
  end

  def x
    @origin.x
  end

  def y
    @origin.y
  end

  def width
    @size.x
  end

  def height
    @size.y
  end

  def diagonal
    Math.sqrt(width**2 + height**2)
  end

  def to_frame
    [[x, y], [width, height]]
  end

  def inspect
    "<Box (#{x},#{y}) / (#{width}x#{height})>"
  end
end

class HypnosisView < UIView
  def initWithFrame(frame)
    super(frame)
    self.backgroundColor = UIColor.clearColor
    @color_index = 0
    @colors = [
      UIColor.lightGrayColor,
      UIColor.redColor,
      UIColor.blueColor,
      UIColor.greenColor,
    ]
    self
  end

  def drawRect(dirty_rect)
    ctx = UIGraphicsGetCurrentContext()

    box = Box.new(bounds)
    center = box.center
    max_radius = box.diagonal / 4.0

    CGContextSetLineWidth(ctx, 10)
    @colors[@color_index].setStroke

    r = max_radius
    while r > 0.0
      CGContextAddArc(ctx, center.x, center.y, r, 0.0, 2*Math::PI, 0)
      CGContextStrokePath(ctx)
      r -= 20
    end

    text = "You are getting sleepy"
    font = UIFont.boldSystemFontOfSize(28)
    text_rect = CGRect.new
    text_rect.size = text.sizeWithFont(font)
    text_rect.origin.x = center.x - text_rect.size.width / 2.0
    text_rect.origin.y = center.y - text_rect.size.height / 2.0
    UIColor.blackColor.setFill

    offset = CGSizeMake(4,3)
    color = UIColor.darkGrayColor.CGColor
    CGContextSetShadowWithColor(ctx, offset, 2.0, color)

    text.drawInRect(text_rect, withFont:font)
  end

  def bump_color
    @color_index = (@color_index + 1) % @colors.size
    setNeedsDisplay
  end

  def canBecomeFirstResponder
    true
  end

  def motionBegan(motion, withEvent:event)
    if motion == UIEventSubtypeMotionShake
      NSLog("Device started shaking")
      bump_color
    end
  end
end

class AppDelegate

  def application(application, didFinishLaunchingWithOptions:launchOptions)
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    @window.backgroundColor = UIColor.whiteColor

    box = Box.new(@window.bounds)
    scroll_view = UIScrollView.alloc.initWithFrame(box.to_frame)
    @window.addSubview(scroll_view)

    @view = HypnosisView.alloc.initWithFrame(box.to_frame)
    scroll_view.addSubview(@view)

    scroll_view.setContentSize(box.size.to_size)
    scroll_view.setMinimumZoomScale(1.0)
    scroll_view.setMaximumZoomScale(5.0)
    scroll_view.delegate = self

    if @view.becomeFirstResponder
      NSLog("HypnosisView became the first responder")
    else
      NSLog("HypnosisView failed to became the first responder")
    end

    @window.makeKeyAndVisible
    true
  end

  def viewForZoomingInScrollView(scroll_view)
    @view
  end
end
