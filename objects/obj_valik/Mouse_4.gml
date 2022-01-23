/// @description Insert description here
// You can write your code in this editor
obj_mang.uusSees = nr;
with(obj_mang){
	if(uusSees == 6) VKOlemas = true; else if(uusSees == -6) MKOlemas = true;
	if(ds_grid_get(grid, viimaneX, viimaneY) == 6) VKOlemas = false; else if(ds_grid_get(grid, viimaneX, viimaneY) == -6) MKOlemas = false;
	ds_grid_set(grid, viimaneX, viimaneY, uusSees);
	if(ds_grid_get(spraidid, viimaneX, viimaneY) != 0) instance_destroy(ds_grid_get(spraidid, viimaneX, viimaneY));
	var uusNupp = instance_create_layer(viimaneY*64, viimaneX*64, "Malendid", obj_nupp);
	uusNupp.sprite_index = ds_map_find_value(nuppudeSpr, abs(uusSees));
	if(uusSees>0) uusNupp.image_index = 1; 
	ds_grid_set(spraidid, viimaneX, viimaneY, uusNupp);
	//show_debug_message(uusSees);
	/*for(var i = 0; i < ds_grid_height(grid); i++){
		for(var j = 0; j < ds_grid_width(grid); j++){
			output_string += string(ds_grid_get(grid, i, j)) + " ";
		}
		output_string += "\n";
	}
	show_debug_message(output_string);*/
}
instance_deactivate_layer("VK");
instance_deactivate_layer("MK");
instance_deactivate_layer("Valikud");
