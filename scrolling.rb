require "gosu"

class Scrolling < Gosu::Window
  STEP = Math::PI / 300
  SCREEN_WIDTH = 900.0
  SCREEN_HEIGHT = 900.0
  ACCELERATION = 0.1
  GRAVITY = -0.05
  GROUND = 800.0
  WALL = 800
  BACKWALL = 1
  JUMP = 2.5
  ROOF = 50

  def initialize
    super(SCREEN_WIDTH.to_i, SCREEN_HEIGHT.to_i, false)

    @font = Gosu::Font.new(self, Gosu::default_font_name, 20)

    @blue = 40
    @x_vel = 0.0
    @y_vel = 0.0

    @target_vel_x = -5.0
    @target_vel_y = -5.0

    # green square
    @target_x = 600.0
    @target_y = 200.0
    @target_width = 40.0
    @target_height = 40.0

    # red square
    @x = SCREEN_WIDTH / 2.0
    @y = SCREEN_HEIGHT / 2.0
    @width = 100.0
    @height = 100.0

    @score = 0
    @timer = 0
    @seconds = 0

    @angle = 0.0
    @game_over = false
  end

  def update
    if !@game_over
      @timer += 1
      if @timer >= 60
        @timer = 0
        @seconds += 1
      end

      if @seconds == 60
        @game_over = true
      end

      @angle += STEP
      @y_vel -= GRAVITY

      if button_down?(Gosu::KbDown)
        @y_vel -= ACCELERATION
      end

      if button_down?(Gosu::KbUp)
        @y_vel += ACCELERATION
      end

      @y += @y_vel

      if @y >= GROUND
        @y = GROUND
        @y_vel = 0
      elsif @y <= ROOF
            @y = ROOF
          @y_vel = 0
      end

      if button_down?(Gosu::KbLeft)
        @x_vel -= ACCELERATION
      end

      if button_down?(Gosu::KbRight)
        @x_vel += ACCELERATION
      end

      @x += @x_vel

      if @x >= WALL
        @x = WALL
        @x_vel = 0
      elsif @x <= BACKWALL
           @x = BACKWALL
           @x_vel = 0
      end

      @blue += 1
      if @blue > 255
        @blue = 40
      end

      @target_x += @target_vel_x
      @target_y += @target_vel_y

#      if @target_y >= ROOF

#        if @target_y >= GROUND

    target_accel_y = (@target_y - @y) * 0.005
    target_accel_x = (@target_x - @x) * 0.005

    target_accel_x += (@target_x - SCREEN_WIDTH) * 0.01
    target_accel_x -= (@target_x - SCREEN_WIDTH) * 0.01

    #target_accel_y += (@target_y - SCREEN_HEIGHT) * 0.01
    #target_accel_y -= (@target_y + SCREEN_HEIGHT) * 0.01


     @target_vel_y += target_accel_y
     @target_vel_x += target_accel_x

  #    if @target_y >= @y
  #      @target_vel_y = -@y_vel
  #    end

      if @target_x > SCREEN_WIDTH && @target_vel_x > 0
        @target_vel_x = -@target_vel_x
      elsif @target_x < 0 && @target_vel_x < 0
        @target_vel_x = -@target_vel_x
      end

      if @target_y >= SCREEN_HEIGHT && @target_vel_y > 0
        @target_vel_y = -@target_vel_y

      elsif @target_y < 0 && @target_vel_y < 0
        @target_vel_y = -@target_vel_y
      end

      if (@x <= @target_x + @target_width &&
         @x + @width >= @target_x &&
         @y <= @target_y + @target_height &&
         @y + @height >= @target_y)

         @score += 1


         # move the green square to a random location on the screen
         @target_x = rand(SCREEN_WIDTH)
         @target_y = rand(SCREEN_HEIGHT)

         # TODO: try changing the direction it is moving in
      end

      if @target_vel_y > 10.0
        @target_vel_y = 10.0
      elsif @target_vel_y < -10.0
        @target_vel_y = -10.0
      end

      if @target_vel_x > 10.0
        @target_vel_x = 10.0
      elsif @target_vel_x < -10.0
        @target_vel_x = -10.0
      end

    end
  end

  def draw
    @font.draw("score: #{@score}", 0, 0, 1)
    @font.draw("time: #{@seconds}", 0, 25, 1)

    if @game_over
      draw_quad(0.0, 0.0, Gosu::Color::GREEN,
        SCREEN_WIDTH, 0.0, Gosu::Color::GREEN,
        SCREEN_WIDTH, SCREEN_HEIGHT, Gosu::Color::GREEN,
        0.0, SCREEN_HEIGHT, Gosu::Color::GREEN)

      if @score >= 20
        draw_quad(240.0, -140.0, Gosu::Color::BLACK,
          SCREEN_WIDTH, 0.0, Gosu::Color::RED,
          SCREEN_WIDTH, SCREEN_HEIGHT, Gosu::Color::YELLOW,
          240.0, SCREEN_HEIGHT, Gosu::Color::BLUE)
      end
        @font.draw(" SCORE RECORD - #{@score}", 400, 450, 1)

    else


      x1 = @x
      y1 = @y

      x2 = @x + @width
      y2 = @y

      x3 = @x + @width
      y3 = @y + @height

      x4 = @x
      y4 = @y + @height

      color = Gosu::Color::RED

      draw_quad(
        x1, y1, color,
        x2, y2, color,
        x3, y3, color,
        x4, y4, color
        )

      draw_quad(
        @target_x, @target_y, Gosu::Color::GREEN,
        @target_x + @target_width, @target_y, Gosu::Color::GREEN,
        @target_x + @target_width, @target_y + @target_height, Gosu::Color::GREEN,
        @target_x, @target_y + @target_height, Gosu::Color::GREEN
      )
    end
  end

  def button_down(key)
    if key == Gosu::KbSpace
      @y_vel -= JUMP
    elsif key == Gosu::KbUp
#      @game_over = true
    end
  end
end

game = Scrolling.new
game.show
