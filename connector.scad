// Конектор за шкафове от керамични плочки (параметричен)
// Плочките влизат в U-образни канали; челната стена ги спира да не излизат напред/назад.
// Един и същ детайл се ползва отпред и отзад (обръща се огледално).
//
// Печат: с челната стена (плоската страна) върху масата, без подпори.

/* [Плочка] */
// Дебелина на плочката (mm)
tile = 10;
// Хлабина в канала (mm) - увеличи, ако плочката не влиза
clearance = 0.6;

/* [Конектор] */
// Тип: "L" ъгъл, "T" тройник, "X" кръст, "I" прав (снаждане)
type = "X"; // [L, T, X, I]
// Дебелина на стените на канала (mm)
wall = 5;
// Колко навлиза плочката в рамото, по дължината на плочката (mm)
arm = 30;
// Колко навлиза плочката в дълбочина на шкафа (mm)
grip = 40;
// Дебелина на челната стена (mm)
cap = 4;
// Радиус на заобляне (mm)
round_r = 2;
// Фаска на входа на канала (mm)
lead = 1.2;

$fn = 48;

slot = tile + clearance;      // ширина на канала
core = slot + 2 * wall;       // страна на централното ядро
height = cap + grip;

// ъгли на рамената за всеки тип
function arms(t) =
    t == "L" ? [0, 90] :
    t == "T" ? [0, 90, 180] :
    t == "I" ? [0, 180] :
               [0, 90, 180, 270];

module outline(t) {
    // заобля външните ръбове и прави холкер във вътрешните ъгли
    offset(r = -round_r) offset(r = 2 * round_r) offset(r = -round_r)
    union() {
        square(core, center = true);
        for (a = arms(t)) rotate(a)
            translate([0, -core / 2]) square([core / 2 + arm, core]);
    }
}

module slot_cut() {
    x0 = core / 2;
    x1 = core / 2 + arm + 1;
    // самият канал
    translate([x0, -slot / 2, cap]) cube([x1 - x0, slot, grip + 1]);
    // фаска отгоре (по дължината на канала)
    hull() {
        translate([x0, -slot / 2, height - lead]) cube([x1 - x0, slot, 0.01]);
        translate([x0, -slot / 2 - lead, height]) cube([x1 - x0, slot + 2 * lead, 0.01]);
    }
    // фаска на края на рамото
    hull() {
        translate([core / 2 + arm - lead, -slot / 2, cap]) cube([0.01, slot, grip + 1]);
        translate([core / 2 + arm, -slot / 2 - lead, cap]) cube([0.01, slot + 2 * lead, grip + 1]);
    }
}

module connector(t = type) {
    difference() {
        linear_extrude(height) outline(t);
        for (a = arms(t)) rotate(a) slot_cut();
    }
}

connector();
