/// @description Insert description here
// You can write your code in this editor
nuppudeNr = ds_map_create();
nuppudeNr[? spr_ettur] = 1;
nuppudeNr[? spr_ratsu] = 2;
nuppudeNr[? spr_oda] = 3;
nuppudeNr[? spr_vanker] = 4;
nuppudeNr[? spr_lipp] = 5;
nuppudeNr[? spr_kuningas] = 6;

nuppudeSpr = ds_map_create();
nuppudeSpr[? 1] = spr_ettur;
nuppudeSpr[? 2] = spr_ratsu;
nuppudeSpr[? 3] = spr_oda;
nuppudeSpr[? 4] = spr_vanker;
nuppudeSpr[? 5] = spr_lipp;
nuppudeSpr[? 6] = spr_kuningas;

nuppudeTahed = ["E", "R", "O", "V", "L", "K"];
tahestik = ["A", "B", "C", "D", "E", "F", "G", "H"];

grid = ds_grid_create(8, 8);
spraidid = ds_grid_create(8, 8);

for(var i = 0; i < ds_grid_width(grid); i++){
	for(var j = 0; j < ds_grid_width(grid); j++){
		ds_grid_set(grid, i, j, 0);
		ds_grid_set(spraidid, i, j, 0);
	}
}

output_string = "";
output_string2 = "";

for(var i = 0; i < ds_grid_height(grid); i++){
	for(var j = 0; j < ds_grid_width(grid); j++){
		//output_string += string(ds_grid_get(grid, i, j)) + " ";
		var ruut = instance_create_layer(j*64, i*64, "Ruudud", obj_ruut)
		with (ruut){
			gridX = i;
			gridY = j;
			image_index = (i+j)%2;
		}
	}
	//output_string += "\n";
}

//show_debug_message(output_string);