require "gosu"

class TicTacToe < Gosu::Window
  STEP = Math::PI / 300
  SCREEN_WIDTH = 900.0
  SCREEN_HEIGHT = 900.0
  ACCELERATION = 0.1
  GRAVITY = -0.1
  def initialize
    super(SCREEN_WIDTH.to_i, SCREEN_HEIGHT.to_i, false)

    @font = Gosu::Font.new(self, Gosu::default_font_name, 20)

    @blue = 40
    @x_vel = 0.0
    @y_vel = 0.0

    @x = SCREEN_WIDTH / 2.0
    @y = SCREEN_HEIGHT / 2.0
    @angle = 0.0
    @score = 0
  end

  def update
    # called 60 times per second
    @angle += STEP

    if button_down?(Gosu::KbDown)
      @y_vel -= GRAVITY
    end

    if button_down?(Gosu::KbUp)
      @y_vel += GRAVITY
    end

    @y += @y_vel

    if button_down?(Gosu::KbLeft)
      @x_vel -= ACCELERATION
    end

    if button_down?(Gosu::KbRight)
      @x_vel += ACCELERATION
    end

    @x += @x_vel

    @blue += 1
    if @blue > 255
      @blue = 40
    end
  end

  def draw
    triangle_size = 100.0
    first_angle = @angle
    second_angle = first_angle + (2.0 * Math::PI / 3.0)
    third_angle = first_angle - (2.0 * Math::PI / 3.0)

    x1 = (Math.cos(first_angle) * triangle_size) + @x
    y1 = (Math.sin(first_angle) * triangle_size) + @y

    x2 = (Math.cos(second_angle) * triangle_size) + @x
    y2 = (Math.sin(second_angle) * triangle_size) + @y

    x3 = (Math.cos(third_angle) * triangle_size) + @x
    y3 = (Math.sin(third_angle) * triangle_size) + @y

    # @color = # ...
    #color_a = Gosu::Color.new(rand(255), rand(255), rand(255))
    color_b = Gosu::Color.new(rand(250), rand(150), rand(255))
    color_c = Gosu::Color.new(rand(180), rand(255), rand(200) )

    draw_triangle(
      x1, y1, Gosu::Color.new(@blue, 180, 501),
      x2, y2, color_b,
      x3, y3, color_c
      )
  end

  def button_down(key)
    # if key == Gosu::KbLeft
    #   @x -= 10
    # if key == Gosu::KbRight
    #   @x += 10
    #if key == Gosu::KbUp
    #  @y -= 10
  #  elsif key == Gosu::KbDown
    #  @y += 10
    if key == Gosu::KbSpace
        @angle -= 50
        @x_vel = 0
        @y_vel = 0
    end
  end

  # if key == Gosu::KbLeft
  #   @x -= 10
  # elsif key == Gosu::KbRight
  #   @x += 10
  # elsif key == Gosu::KbUp
  #   # move the triangle up
  # elsif key == Gosu::KbDown
  #   # move the triangle down
  # end
end

game = TicTacToe.new
game.show
