const MEDICINE_COST: Int = 10  // 药品的价格
const HEALTH_RECOVERY: Int = 20  // 每次使用药品恢复的健康值

pub fn buy_medicine(pet: Pet) -> Unit {
    if pet.coins >= MEDICINE_COST {
        // 玩家金币足够，可以购买药品
        pet.coins -= MEDICINE_COST
        pet.health += HEALTH_RECOVERY
        
        // 确保健康值不会超过100
        if pet.health > 100 {
            pet.health = 100
        }
        
        game_state.event_message = "Health restored."
        game_state.event_timer = 60  // 设置事件显示时长
    } else {
        // 玩家金币不足，提示信息
        game_state.event_message = "Not enough coins!"
        game_state.event_timer = 60  // 设置事件显示时长
    }
}
