class Game_Player < Game_Character
  def jump(x_plus, y_plus)
    super
    @followers.each { |f| f.jump(@x - f.x, @y - f.y) }
  end
end