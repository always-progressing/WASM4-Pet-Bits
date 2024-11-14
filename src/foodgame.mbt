struct FoodGame {
    mut food_x: Int
    mut food_y: Int
}

pub fn start_food_game(game_state: GameState, pet: Pet) -> Unit {
    game_state.food_game = Some({
        food_x: 80,
        food_y: 0
    })  // 使用 Some 包装 FoodGame 实例
}
//let rng: @random.Rand = @random.new()
pub fn play_food_game(pet: Pet, game_state: GameState) -> Unit {
    match game_state.food_game {
        Some(food_game) => {
            // 更新 food_game 的位置
            food_game.food_y += 1  // 食物下落

            // 检查碰撞
            if (food_game.food_x - pet.x).abs() < 10 && (food_game.food_y - pet.y).abs() < 10 {
                pet.hunger += 10
                if pet.hunger >= 100 {
                    pet.hunger = 100
                }
                food_game.food_y = 0
                food_game.food_x = rng.int() % 120 + 40
            }

            // 绘制食物
            @wasm4.set_draw_colors(0x2U, index=1)
            @wasm4.set_draw_colors(0x2U, index=2)
            @wasm4.rect(food_game.food_x, food_game.food_y, 5, 5)
        };
        None => () // 如果 food_game 是 None，可以选择在此处处理，或者忽略
        
    }
}


