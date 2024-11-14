struct PlayGame {
    mut ball_x: Int
    mut ball_y: Int
    //ball_y: Int
    mut ball_direction_x: Int
    mut ball_direction_y: Int
    mut duration: Int  // 存活的帧数
}

pub fn start_play_game(game_state:GameState, pet: Pet) -> Unit {
    // let play_game: PlayGame = {
    //     ball_x: 80,
    //     ball_y: 80,
    //     ball_direction: 1
    // }
    // play_pass_ball_game(pet, play_game)
    game_state.play_game = Some({
        ball_x: 80,
        ball_y: 80,
        ball_direction_x: 1,
        ball_direction_y: 0,
        duration: 600, // 游戏实例持续 100 帧
    })
}

pub fn play_pass_ball_game(pet: Pet, game_state: GameState) -> Unit {
    // play_game.ball_x += play_game.ball_direction * 2

    // if play_game.ball_x > 160 || play_game.ball_x < 0 {
    //     play_game.ball_direction *= -1  // 改变方向
    // }

    // // 在屏幕上绘制球
    // @wasm4.rect(play_game.ball_x, play_game.ball_y, 5, 5)
    match game_state.play_game{
        Some(play_game) => {
            // 减少剩余时间
            play_game.duration -= 1
            if play_game.duration <= 0 {
                game_state.play_game = None
                return  // 退出函数，停止进一步的游戏逻辑
            }
            play_game.ball_x += play_game.ball_direction_x * 2
            play_game.ball_y += play_game.ball_direction_y * 1
            // if play_game.ball_x > 160 || play_game.ball_x < 0 {
            //     play_game.ball_direction_x *= -1  // 改变方向
            //     if(rng.int()%2==1){
            //         play_game.ball_direction_y = -1
            //     }else{
            //         play_game.ball_direction_y = 1
            //     }
            // }

            // 碰到屏幕左右边缘反弹
            if play_game.ball_x > 160 || play_game.ball_x < 0 {
                play_game.ball_direction_x *= -1  // 水平方向反弹
                // 引入随机角度变化，增加反弹的不规则性
                play_game.ball_direction_y = if rng.int() % 2 == 0 { 1 } else { -1 } 
            }

            // 碰到屏幕上下边缘反弹
            if play_game.ball_y > 160 || play_game.ball_y < 0 {
                play_game.ball_direction_y *= -1  // 垂直方向反弹
                // 引入随机角度变化，增加反弹的不规则性
                play_game.ball_direction_x = if rng.int() % 2 == 0 { 1 } else { -1 }
            }

            // 检查是否与宠物碰撞
            if (play_game.ball_x - pet.x).abs() < 10 && (play_game.ball_y - pet.y).abs() < 10 {
                
                if pet.happiness >= 100 {
                    pet.happiness = 100
                }else{
                    pet.happiness += 20
                }
                // 水平和垂直方向都反弹
                play_game.ball_direction_x *= -1
                play_game.ball_direction_y *= -1
            }

            @wasm4.set_draw_colors(0x1U, index=1)
            // 在屏幕上绘制球
            @wasm4.rect(play_game.ball_x, play_game.ball_y, 5, 5)
        }
        None => ()
    }
}
