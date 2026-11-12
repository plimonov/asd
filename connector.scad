// Конектор за шкафове от керамични плочки (параметричен)
// Плочките влизат в канали на куб или сфера; плътната челна стена ги спира
// да не излизат напред/назад. Един и същ детайл се ползва отпред и отзад.
//
// Печат: с челната (плоската) страна върху масата, без подпори.

/* [Плочка] */
// Дебелина на плочката (mm)
tile = 10;
// Хлабина в канала (mm) - увеличи, ако плочката не влиза
clearance = 0.6;

/* [Конектор] */
// Форма: "cube" куб, "sphere" сфера
shape = "cube"; // [cube, sphere]
// Тип: "L" ъгъл, "T" тройник, "X" кръст
type = "X"; // [L, T, X]
// Страна на куба (mm)
cube_size = 56;
// Диаметър на сферата (mm)
sphere_d = 70;
// Плътна стена около канала в центъра (mm)
wall = 5;
// Дебелина на челната стена (mm)
cap = 5;
// Радиус на заобляне на куба (mm)
round_r = 2.5;
// Фаска на входа на канала (mm)
lead = 1.2;
// Декоративни фуги по куба
grooves = true;

$fn = 64;

slot = tile + clearance;      // ширина на канала
core = slot + 2 * wall;       // плътно ядро, в което опират плочките
BIG = 200;

// ъгли на рамената за всеки тип
function arms(t) =
    t == "L" ? [0, 90] :
    t == "T" ? [0, 90, 180] :
               [0, 90, 180, 270];

function body_h(s) = s == "sphere" ? sphere_d / 2 * (1 + cos(45)) : cube_size;

// канал за една плочка: от ядрото навън, отворен към гърба
module slot_cut(h) {
    x0 = core / 2;
    translate([x0, -slot / 2, cap]) cube([BIG, slot, BIG]);
    // фаска на входа откъм гърба
    hull() {
        translate([x0, -slot / 2, h - lead]) cube([BIG, slot, 0.01]);
        translate([x0, -slot / 2 - lead, h + 0.01]) cube([BIG, slot + 2 * lead, 0.01]);
    }
}

module cube_body() {
    s = cube_size; r = round_r;
    difference() {
        hull() for (x = [-1, 1], y = [-1, 1], z = [r, s - r])
            translate([x * (s / 2 - r), y * (s / 2 - r), z]) sphere(r, $fn = 24);
        if (grooves) for (a = [0, 90]) rotate(a) for (m = [-1, 1])
            translate([m * (slot / 2 + 0.4), 0, s / 2]) difference() {
                cube([0.8, s + 2, s + 2], center = true);
                cube([1, s - 1.4, s - 1.4], center = true);
            }
    }
}

module sphere_body() {
    r = sphere_d / 2;
    // отрязана под 45 градуса, за да стъпва плоско на масата без подпори
    intersection() {
        translate([0, 0, r * cos(45)]) sphere(r, $fn = 96);
        translate([0, 0, BIG / 2]) cube(BIG, center = true);
    }
}

// a = списък с ъгли на каналите (0 = +X, 90 = +Y ...)
module connector_arms(a, s = shape) {
    difference() {
        if (s == "sphere") sphere_body(); else cube_body();
        for (ang = a) rotate(ang) slot_cut(body_h(s));
    }
}

module connector(t = type, s = shape) connector_arms(arms(t), s);

connector();
