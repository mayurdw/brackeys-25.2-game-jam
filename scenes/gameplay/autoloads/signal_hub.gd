extends Node

# Game Elements
signal player_hit
signal obstacle_dangered

# UI Elements related to Game
signal score_updated(additional_value: int)
signal current_score(current_score: int)
signal current_hp(current_hp: int)
signal current_fuel(current_fuel: float)
signal current_danger_level(danger_level: float)
signal upgrade_bought
