/// @description Insert description here
// You can write your code in this editor
obj_mang.uusSees = nr;
with(obj_mang){
	if(ds_grid_get(grid, viimaneX, viimaneY) == 6) VKOlemas = false; else if(ds_grid_get(grid, viimaneX, viimaneY) == -6) MKOlemas = false;
	ds_grid_set(grid, viimaneX, viimaneY, uusSees);
	if(ds_grid_get(spraidid, viimaneX, viimaneY) != 0) instance_destroy(ds_grid_get(spraidid, viimaneX, viimaneY));
	ds_grid_set(spraidid, viimaneX, viimaneY, 0);
}
instance_deactivate_layer("VK");
instance_deactivate_layer("MK");
instance_deactivate_layer("Valikud");