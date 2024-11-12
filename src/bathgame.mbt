struct BathGame {
    mut step: Int
}

pub fn start_bath_game(pet: Pet) -> Unit {
    let bath_game: BathGame = {
        step: 1
    }
    play_bath_game(pet, bath_game)
}

pub fn play_bath_game(pet: Pet, bath_game: BathGame) -> Unit {
  @wasm4.set_draw_colors(0x4U, index=1) //设置黑色字体
  // 根据步骤提示玩家下一步操作
  if bath_game.step == 1 {
    //@wasm4.set_draw_colors(0x4U, index=1)
    @wasm4.text("Step 1: Apply soap", 10, 100)
    // 鼠标点击检测代码
    if mouse_clicked() {
      bath_game.step = 2
    }
  }else if bath_game.step == 2 {
    @wasm4.text("Step 2: Rinse with water", 10, 100)
    if mouse_clicked() {
      bath_game.step = 3
      }
    }else if bath_game.step == 3 {
      @wasm4.text("Step 3: Dry with towel", 10, 100)
      if mouse_clicked() {
        pet.cleanliness = 100  // 清洁度满值
        // 游戏结束
      }
    }
}

fn mouse_clicked() -> Bool {
    // 检测鼠标点击事件
    // 返回true/false
    let mouse_clicked = @wasm4.get_mouse()
    return mouse_clicked.left  // 如果鼠标左键按下，返回 true
}
