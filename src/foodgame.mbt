struct FoodGame {
    mut food_x: Int
    mut food_y: Int
}

pub fn start_food_game(pet: Pet) -> Unit {
    // 初始化游戏状态
    let food_game: FoodGame = {
        food_x: 80,
        food_y: 0
    }
    play_food_game(pet, food_game)
}
//let rng: @random.Rand = @random.new()
pub fn play_food_game(pet: Pet, food_game: FoodGame) -> Unit {
    food_game.food_y += 2  // 食物向下移动

    // 检测食物是否被宠物接住
    if (food_game.food_x - pet.x).abs() < 10 && (food_game.food_y - pet.y).abs() < 10 {
        pet.hunger += 10  // 增加饥饿度
        food_game.food_y = 0  // 重置食物位置
        food_game.food_x = rng.int() % 140 + 10
    }
    
    // 在屏幕上绘制食物
    @wasm4.set_draw_colors(0x2U, index=1)
    @wasm4.rect(food_game.food_x, food_game.food_y, 5, 5)
}
