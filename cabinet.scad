// Примерна сглобка на шкаф: показва плочките и конекторите заедно.
// Променяй cols/rows и размерите на плочките, за да видиш своя шкаф.
use <connector.scad>

/* [Шкаф] */
cols = 3;          // брой клетки на ширина
rows = 2;          // брой клетки на височина
tile_w = 300;      // дължина на хоризонталната плочка (ширина на клетката)
tile_h = 300;      // дължина на вертикалната плочка (височина на клетката)
depth = 300;       // дълбочина = другата страна на плочките
shape = "cube";    // "cube" или "sphere"

/* [Трябва да съвпадат с connector.scad] */
tile = 10;
core = 20.6;
cap = 5;

px = tile_w + core;
py = tile_h + core;

module node(i, j) {
    a = [ if (i < cols) 0, if (j < rows) 90, if (i > 0) 180, if (j > 0) 270 ];
    // local XY -> world XZ, local Z -> world Y (дълбочина)
    translate([i * px, 0, j * py]) {
        rotate([-90, 0, 0]) mirror([0, 1, 0]) connector_arms(a, shape);
        translate([0, depth + 2 * cap, 0]) rotate([90, 0, 0]) connector_arms(a, shape);
    }
}

color("chocolate") for (i = [0:cols], j = [0:rows]) node(i, j);

color("ivory") {
    for (i = [0:cols - 1], j = [0:rows])
        translate([i * px + core / 2, cap, j * py - tile / 2]) cube([tile_w, depth, tile]);
    for (i = [0:cols], j = [0:rows - 1])
        translate([i * px - tile / 2, cap, j * py + core / 2]) cube([tile, depth, tile_h]);
}
