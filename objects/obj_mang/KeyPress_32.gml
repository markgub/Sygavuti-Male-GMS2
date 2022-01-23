/// @description Insert description here
// You can write your code in this editor
instance_deactivate_layer("VK");
instance_deactivate_layer("MK");
instance_deactivate_layer("Valikud");

/*var liitlased = ds_grid_create(8, 8);
var vaenlased = ds_grid_create(8, 8);
for(var i = 0; i < ds_grid_width(grid); i++){
	for(var j = 0; j < ds_grid_width(grid); j++){
		ds_grid_set(liitlased, i, j, 0);
		ds_grid_set(vaenlased, i, j, 0);
	}
}*/

sammud = ds_list_create();
vastused = [];
/*test = [];
array_push(test, 1);
show_debug_message(string(test[0]));
show_debug_message(string(array_length(test)));
array_pop(test);
show_debug_message(string(array_length(test)));*/
/*for(var i = 0; i < ds_grid_height(grid); i++){
	for(var j = 0; j < ds_grid_width(grid); j++){
		output_string += string(ds_grid_get(grid, i, j)) + " ";
	}
	output_string += "\n";
}*/

//show_debug_message(output_string);
alustaLahendamist(kesLahendab, grid);