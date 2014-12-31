class Game_Actor < Game_Battler
  
  alias healOnLevelUp level_up
  def level_up
    healOnLevelUp
    if alive?
      @hp = mhp
      @mp = mmp
    end 
  end
end