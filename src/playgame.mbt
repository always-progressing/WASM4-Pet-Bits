struct PlayGame {
    mut ball_x: Int
    //mut ball_y: Int
    ball_y: Int
    mut ball_direction: Int
}

pub fn start_play_game(pet: Pet) -> Unit {
    let play_game: PlayGame = {
        ball_x: 80,
        ball_y: 80,
        ball_direction: 1
    }
    play_pass_ball_game(pet, play_game)
}

pub fn play_pass_ball_game(pet: Pet, play_game: PlayGame) -> Unit {
    play_game.ball_x += play_game.ball_direction * 2

    if play_game.ball_x > 160 || play_game.ball_x < 0 {
        play_game.ball_direction *= -1  // 改变方向
    }

    // 在屏幕上绘制球
    @wasm4.rect(play_game.ball_x, play_game.ball_y, 5, 5)
}
