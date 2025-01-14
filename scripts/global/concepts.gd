class_name Concepts

# Directions of the vehicle, 
# where 0 is north - east heading (↗) and
# subsequent values 
# 0 - ↗ (NORTH)
# 1 - →
# 2 - ↘︎ (EAST)
# 3 - ↓
# 4 - ↙︎ (SOUTH)
# 5 - ←
# 6 - ↖ (WEST)
# 7 - ↑
static var vehicle_directions = [
    Vector2(1, -1), # up - right (NORTH)
    Vector2(1, 0), 
    Vector2(1, 1),
    Vector2(0, 1),
    Vector2(-1, 1),
    Vector2(-1, 0),
    Vector2(-1, -1),
    Vector2(0, -1), # up
]


# Check if direction is like another direction that 
# is if one vehicle direction doesn't differ from other vehicle direction by one  
static func are_directions_likewise(direction_a, direction_b) ->  bool:
    var likewise_directions = [
        (direction_a - 1) % 8,
        direction_a,
        (direction_a + 1) % 8,
    ]
    if likewise_directions[0] == -1: 
        likewise_directions[0] = 7

    return direction_b in likewise_directions


static func are_directions_contrary(direction_a, direction_b) -> bool:
    if abs(direction_b - direction_a) == 4: return true
    return false

    # the other more explicit way:
    # var contrary_pairs = [[0,4], [1,5], [2,6], [3,7]]
    # for pair in contrary_pairs:
    #     if direction_a in pair and direction_b in pair:
    #         return true
    # return false