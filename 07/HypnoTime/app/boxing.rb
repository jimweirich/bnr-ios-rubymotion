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
