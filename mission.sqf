_edge = worldSize; // Размер мира
	// -------- Техническая вставка (ХИНТЫ)
	hint (srt _edge); // Хинт worldSize
	copyToClipboard (str _edge); // Копирование в буфер обмена значенния WorldSize

_half = _edge / 2; // Половина мира

_radius = _centerOfMap distanec2D[0,0]; // Радиус

_centerOfMap = [_half, _half]; // Центр Карты
	// -------- Техническая вставка (Создание маркера)
	_mkr = createMarker ["markerCenterOfMap",_centerOfMap];
	_mkr = setMarkerType "mil_dot";
	_mkr setMarkerColor "ColorRed";

_nearestLocations = nearestLocation[_centerOfMap, ["NameVillage"], _radius]; // Получение списка всех локаций типа "NameVillage"

_location = selectRandom _nearestLocations; // Получения 1 рандомной локации
_position = locationPosition _location; // Координаты локации
	// -------- Техническая вставка (Маркера на все локации)
	{
		_mkr = createMarker("mkr" + (str _forEachIndex), locationPosition _x);
		_mkr = setMarkerType "mil_dot";
		_mkr = setMarkerColor "ColorBlue";
	} forEach _nearestLocations;

	hint str count _nearestLocations; // Хинт на количество локаций заданого типа

// ---------------------------------------------------------------- Создание противников


_enemyUnitTypes = ["O_G_Soldier_F","O_G_Soldier_SL_F","O_G_Soldier_F"]; // Типы противников
_groupEnemy = createGroup [east,true] // [Направление(Восток), Значение BOOL]

for[{_i = 0},{_i < (count _enemyUnitTypes)},{_i = _i + 1}]
do
{
	_groupEnemy createUnit [(_enemyUnitTypes select _i), _position,[],0,"FORM"]; // Цикл на создание отряда
};


// ---------------------------------------------------------------- Создание отряда для игрока и игрока


_playerPosition = _position getPos [50, random 360]; // [Метров от точки, рандомное направление]
player setPos _playerPosition;

_alliasUnitTypes = ["B_Soldier_F","B_Soldier_F","B_Soldier_F"]; // Типы союзников

for[{_i = 0},{_i < (count _alliasUnitTypes)},{_i = _i + 1}]
do
{
	(group player) createUnit [(_alliasUnitTypes select _i)], _playerPosition,[],0,"FORM"]; // Цикл на создание отряда
};

// ---------------------------------------------------------------- Миссия

[player, "task_1", ["Text of task.","text of doing"], _position, "CREATED", -1, false, "attack", true] call BIS_fnc_taskSetState; // Создание миссии
["task_1", "ASSIGNED", true] call BIS_fnc_taskSetState; // Назначить задачу

// -------------------------------- Проверка условия

waitUntil {(east countSide allUnits) == 0} // Проверка на убийство всех врагов
["task_1", "SUCCEEDED", true] call BIS_fnc_taskSetState; // Task как выполненый

sleep 3; // Ожидание 3 секунды

endMission "END1"; // Завершение миссии