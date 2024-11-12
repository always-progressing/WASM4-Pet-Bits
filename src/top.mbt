struct GameState {
    mut frame_counter: Int
    update_interval: Int
    mut event_message: String   // 用于显示的随机事件信息
    mut event_timer: Int  // 控制文字显示时长的计时器
    // 新增的功能区域位置
    food_area: (Int, Int)  
    bath_area: (Int, Int)  
    toy_area: (Int, Int)    
    hospital_area: (Int, Int)        
}

// 初始化游戏状态
pub fn GameState::new() -> GameState {
    return {
        frame_counter: 0,       // 帧计数器初始值
        update_interval: 60,    // 每60帧更新一次
        event_message: "",      // 初始化时没有事件信息
        event_timer: 0,          // 初始化时计时器为0
        
        food_area: (10, 100),
        bath_area: (120, 100),
        toy_area: (20, 120),
        hospital_area: (100, 120),
    }
}

let game_state: GameState = GameState::new()

// 宠物的基本状态
struct Pet {
    mut age: Int          // 宠物的年龄
    mut hunger: Int       // 宠物的饥饿状态
    mut happiness: Int    // 宠物的快乐度
    mut cleanliness: Int  // 宠物的清洁度
    mut health: Int       // 宠物的健康状况
    mut stage: Int        // 宠物的成长阶段
    mut x: Int
    mut y: Int
    mut coins: Int
}

//绘制功能区
pub fn draw_areas() -> Unit {
    @wasm4.set_draw_colors(0x1U, index=1)
    @wasm4.set_draw_colors(0x3U, index=2) 
    @wasm4.text("Food", 10, 100)    // 绘制饭桌图标
    @wasm4.text("Bath", 120, 100)   // 绘制浴缸图标
    @wasm4.text("Toy", 20, 120)    // 绘制玩具图标
    @wasm4.text("Hospital", 100, 120)  // 绘制医院图标
}


// 初始化宠物
pub fn Pet::new() -> Pet {
    return {
        age: 0,            // 初始年龄
        hunger: 50,        // 初始饥饿状态
        happiness: 50,     // 初始快乐度
        cleanliness: 50,   // 初始清洁度
        health: 100,       // 初始健康状态
        stage: 1,           // 初始阶段（婴儿）
        x: 75,
        y: 100, 
        coins: 1000,
    }
}

let pet: Pet = Pet::new() // 初始化宠物实例

// 游戏的初始化设置
pub fn start() -> Unit {
    //@wasm4.set_draw_colors(0x3U, index=2)  // 设置背景颜色
    //@wasm4.set_draw_colors(0x2U, index=2)  // 设置其他颜色
    @wasm4.set_palette(1, @wasm4.rgb(0xfbf7f3))
    @wasm4.set_palette(2, @wasm4.rgb(0xe5b083))
    @wasm4.set_palette(3, @wasm4.rgb(0x426e5d))
    @wasm4.set_palette(4, @wasm4.rgb(0x20283d))
}

// 更新宠物状态（每帧调用）
pub fn update() -> Unit {
    game_state.frame_counter += 1
    draw_areas() // 绘制功能区
    check_collision(pet, game_state)  // 调用碰撞检测

    // 每60帧更新一次宠物状态（每秒）
    if game_state.frame_counter % game_state.update_interval == 0 {
        // 更新宠物状态，随着时间推移减少状态值
        pet.age += 1
        pet.hunger -= 1
        pet.happiness -= 1
        pet.cleanliness -= 1

        // 处理宠物的成长阶段
        if pet.age > 100 && pet.stage == 1 {
            pet.stage = 2  // 从婴儿阶段成长到幼年
        } else if pet.age > 200 && pet.stage == 2 {
            pet.stage = 3  // 从幼年成长到成年
        }

        // 随机事件触发（每隔一定时间触发一个事件）
        //let rng: @random.Rand = @random.new() // 创建随机数生成器
        if rng.int() % 10 == 0 {
            trigger_random_event(pet)
        }
        
    }
    // 玩家与宠物的交互（喂食、清洁、玩耍等）
    //handle_interaction(pet)
    handle_movement(pet)
    // 如果有随机事件发生且计时器大于0，显示事件信息
    if game_state.event_timer > 0 {
        game_state.event_timer -= 1  // 每帧减少计时器
        @wasm4.text(game_state.event_message, 30, 150)  // 显示事件信息
    }

    // 绘制宠物和状态
    draw_pet(pet)
    draw_status(pet)
    draw_status1(pet)
}

// 随机事件触发
// pub fn trigger_random_event(pet: Pet) -> Unit {
//     let rng: @random.Rand = @random.new() // 创建随机数生成器
//     let event = rng.int() % 3
//     if event == 0 {
//         pet.health -= 10  // 宠物生病
//         @wasm4.text("Pet is sick!", 10, 50)
//     } else if event == 1 {
//         pet.happiness += 10  // 宠物很开心
//         @wasm4.text("Pet is happy!", 10, 50)
//     } else {
//         pet.cleanliness -= 10  // 宠物变脏了
//         @wasm4.text("Pet is dirty!", 10, 50)
//     }
// }
let rng: @random.Rand = @random.new()
pub fn trigger_random_event(pet: Pet) -> Unit {
    //let rng: @random.Rand = @random.new()
    let event = rng.int() % 3
    if event == 0 {
        pet.health -= 10
        game_state.event_message = "Pet is sick!"
    } else if event == 1 {
        pet.happiness += 10
        game_state.event_message = "Pet is happy!"
    } else {
        pet.cleanliness -= 10
        game_state.event_message = "Pet is dirty!"
    }

    // 设置事件文字显示时长为180帧（大约3秒）
    game_state.event_timer = 60
}

// 玩家与宠物的交互 已取消
// pub fn handle_interaction(pet: Pet) -> Unit {
//     if @wasm4.get_gamepad().button_left {  // 喂食操作
//         pet.hunger += 10
//         if pet.hunger > 100 {
//             pet.hunger = 100  // 确保饥饿度不超过100
//         }
//     }
//     if @wasm4.get_gamepad().button_right {  // 清洁操作
//         pet.cleanliness += 10
//         if pet.cleanliness > 100 {
//             pet.cleanliness = 100  // 确保清洁度不超过100
//         }
//     }
//     if @wasm4.get_gamepad().button_up {  // 玩耍操作
//         pet.happiness += 10
//         if pet.happiness > 100 {
//             pet.happiness = 100  // 确保快乐度不超过100
//         }
//     }
// }
pub fn handle_movement(pet: Pet) -> Unit {
    let gamepad = @wasm4.get_gamepad()

    if gamepad.button_up && pet.y >= 10 {
        pet.y -= 1
    }
    if gamepad.button_down && pet.y <= 140{
        pet.y += 1
    }
    if gamepad.button_left && pet.x >= 10{
        pet.x -= 1
    }
    if gamepad.button_right && pet.x <= 140{
        pet.x += 1
    }

    // 限制移动范围，避免宠物移动到屏幕外
    //pet.x = pet.x.clamp(0, 160)  // 假设屏幕宽度为160
    //pet.y = pet.y.clamp(0, 160)  // 假设屏幕高度为160
}

// 绘制宠物
pub fn draw_pet(pet: Pet) -> Unit {
    @wasm4.set_draw_colors(0x3U, index=1)
    @wasm4.set_draw_colors(0x4U, index=2)
    if pet.stage == 1 {
        @wasm4.rect(pet.x, pet.y, 10, 10)  // 绘制婴儿宠物
    } else if pet.stage == 2 {
        @wasm4.rect(pet.x, pet.y, 20, 20)  // 绘制幼年宠物
    } else if pet.stage == 3 {
        @wasm4.rect(pet.x, pet.y, 30, 30)  // 绘制成年宠物
    }
}
// 绘制属性条（例如饥饿度条）
pub fn draw_status_bar(x: Int, y: Int, value: Int, max_value: Int) -> Unit {
    let bar_width = 80
    let bar_height = 8
    let filled_width = (value * bar_width) / max_value
    //绘制属性条背景（黑色）
    @wasm4.set_draw_colors(0x4U, index=2)  // 背景颜色
    @wasm4.set_draw_colors(0x4U, index=1)    // 填充颜色
    @wasm4.rect(x, y, bar_width, bar_height)  // 绘制背景条
    //绘制属性条（白色）
    @wasm4.set_draw_colors(0x1U, index=1)    // 填充颜色
    @wasm4.rect(x, y, filled_width, bar_height)  // 绘制填充条
}

// 主函数中调用绘制不同属性的状态条
pub fn draw_status1(pet: Pet) -> Unit {
    draw_status_bar(60, 20, pet.hunger, 100)       // 饥饿条
    draw_status_bar(60, 30, pet.happiness, 100)    // 快乐条
    draw_status_bar(60, 40, pet.cleanliness, 100)  // 清洁条
    draw_status_bar(60, 50, pet.health, 100)       // 健康条
}

// 绘制宠物状态
pub fn draw_status(pet: Pet) -> Unit {
    @wasm4.set_draw_colors(0x1U, index=1)
    @wasm4.set_draw_colors(0x4U, index=2) 
    @wasm4.text("Age: " + pet.age.to_string(), 10, 10)
    @wasm4.text("Hunger: " + pet.hunger.to_string(), 10, 20)
    @wasm4.text("Happy: " + pet.happiness.to_string(), 10, 30)
    @wasm4.text("Clean: " + pet.cleanliness.to_string(), 10, 40)
    @wasm4.text("Health: " + pet.health.to_string(), 10, 50)
}


pub fn check_collision(pet: Pet, game_state: GameState) -> Unit {
    if is_colliding(pet, game_state.food_area) {
        start_food_game(pet)  // 进入吃饭游戏
    }
    if is_colliding(pet, game_state.bath_area) {
        start_bath_game(pet)  // 进入洗澡游戏
    }
    if is_colliding(pet, game_state.toy_area) {
        start_play_game(pet)  // 进入玩耍游戏
    }
    if is_colliding(pet, game_state.hospital_area) {
        buy_medicine(pet)  // 进入医院购买药品
    }
}
// 碰撞检测的辅助函数
fn is_colliding(pet: Pet, area: (Int, Int)) -> Bool {
    let (area_x, area_y) = area
    (pet.x - area_x).abs() < 10 && (pet.y - area_y).abs() < 10  // 碰撞判定逻辑
}
