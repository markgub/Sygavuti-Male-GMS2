/// @description Insert description here
// You can write your code in this editor
//show_debug_message(string(gridX)+string(gridY));
instance_activate_layer("Valikud");
if(!obj_mang.MKOlemas) instance_activate_layer("MK");
if(!obj_mang.VKOlemas) instance_activate_layer("VK");
obj_mang.viimaneX = gridX;
obj_mang.viimaneY = gridY;
show_debug_message(string(obj_mang.viimaneX)+string(obj_mang.viimaneY));
