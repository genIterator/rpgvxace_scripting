class Window_CommandMine < Window_Command
  def make_command_list
    add_command("Item", :itm)
    add_command("Equip",:eqp)
    add_command("skill",:skl)
  end
end


class Scene_Mine < Scene_MenuBase
  def start
    super
    create_background
    create_windows
  end
  def create_windows
    @mycmd = Window_CommandMine.new(0,0)
    @mycmd.set_handler(:itm,method(:test))
      
  end
  def test
    p "own scene!"
    @mycmd.active= true
  end
end