struct BathGame {
    mut step: Int
    mut time_left: Int  // 每个步骤的时间限制
    mut difficulty: Int  // 难度系数
}

pub fn start_bath_game(game_state:GameState, pet: Pet) -> Unit {
    // let bath_game: BathGame = {
    //     step: 1,
    //     time_left: 30,  // 每个步骤时间为 30 帧
    //     difficulty: 1,  // 初始难度系数为 1
    // }
    // play_bath_game(pet, bath_game)
    game_state.bath_game = Some({
        step: 1,
        time_left: 120,  // 每个步骤时间为 120 帧
        difficulty: 1,  // 初始难度系数为 1
    })
}

pub fn play_bath_game(pet: Pet, game_state:GameState) -> Unit {
    @wasm4.set_draw_colors(0x4U, index=1) // 设置黑色字体

    match game_state.bath_game{
      Some(bath_game) => {
        // 每帧减少剩余时间
        bath_game.time_left -= 1

        // 显示剩余时间
        @wasm4.text("Time: " + bath_game.time_left.to_string(), 35, 130) // 直接显示数字
        @wasm4.text("CLICK [OK]!", 30, 140)

        // 如果时间到了，则提示玩家失败
        if bath_game.time_left <= 0 {
            game_state.event_message = "Bath failed!"
            game_state.event_timer = 60
            game_state.bath_game = None
            return
        }

        // 根据步骤提示玩家下一步操作
        if bath_game.step == 1 {
            @wasm4.text("1.soap [OK]", 30, 60)
            // 玩家必须点击并且避免障碍
            if mouse_clicked_() && not_obstacle() {
                bath_game.step = 2
                bath_game.time_left = 30  // 重置时间
            }
        } else if bath_game.step == 2 {
            @wasm4.text("2.rinse [OK]", 30, 70)
            if mouse_clicked_() && not_obstacle() {
                bath_game.step = 3
                bath_game.time_left = 30  // 重置时间
            }
        } else if bath_game.step == 3 {
            @wasm4.text("3.towel [OK]", 30, 80)
            if mouse_clicked_() && not_obstacle() {
                pet.cleanliness = 100  // 清洁度满值
                //@wasm4.text("You finished the bath!", 10, 150)
                game_state.event_message = "Finished bath!"
                game_state.event_timer = 60
                game_state.bath_game = None
                // 游戏结束
            }
        }
      }
      None => ()
    }
    
}

// 模拟一些障碍物，增加难度
fn not_obstacle() -> Bool {
    // 随机生成障碍
    return rng.int() % 10 < 7  // 70% 概率不出现障碍
}

//防抖鼠标点击
fn mouse_clicked_() -> Bool {
    // 检测鼠标点击事件
    let mouse_state = @wasm4.get_mouse()
    let current_frame = game_state.frame_counter
    
    // 判断是否在冷却时间之外点击
    if mouse_state.left && (current_frame - game_state.last_click_frame) > game_state.click_cooldown {
        game_state.last_click_frame = current_frame // 更新上次点击的帧数
        return true
    }
    return false
}
