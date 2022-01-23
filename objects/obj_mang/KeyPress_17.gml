/// @description Insert description here
// You can write your code in this editor
for(var i = 0; i < ds_grid_height(grid); i++){
	for(var j = 0; j < ds_grid_width(grid); j++){
		output_string += string(ds_grid_get(grid, i, j)) + " ";
	}
	output_string += "\n";
}

show_debug_message(output_string);
output_string = "";