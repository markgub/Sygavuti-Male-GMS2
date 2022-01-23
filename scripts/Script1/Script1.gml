// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function alustaLahendamist(kesLahendab, grid){
	var pahaKuningaX = 0;
	var pahaKuningaY = 0;
	var heaKuningaX = 0;
	var heaKuningaY = 0;
	var edu = false;
	var sammudPraegu = 0;

	var kaksKuningat = 0;
	for(var i = 0; i < ds_grid_width(grid); i++){
		for(var j = 0; j < ds_grid_width(grid); j++){
			if(abs(ds_grid_get(grid, i, j)) == 6){
				kaksKuningat += 1;
				if(sign(ds_grid_get(grid, i, j)) != kesLahendab){
					pahaKuningaX = i;
					pahaKuningaY = j;
				} else {
					heaKuningaX = i;
					heaKuningaY = j;
				}
			}
		}
		if(kaksKuningat > 1) break;
	}
	if(kaksKuningat < 2) {
		show_message("Vähem kui 2 kuningat!");
		return;
	}
	var eiSaaAlustada = kasKuningasOhus(pahaKuningaX, pahaKuningaY, -kesLahendab, grid);
	//kasKuningasOhus(heaKuningaX, heaKuningaY, kesLahendab, grid);
	if(eiSaaAlustada){
		show_message("Vaenlane on juba ohus, seega ei tohi alustada!");
	}  else {
		var kuningateKohad = [heaKuningaX, heaKuningaY, pahaKuningaX, pahaKuningaY]
		show_debug_message("Saab alustada!");
		edu = lahenda(grid, kesLahendab, kuningateKohad, sammudPraegu);
		if(edu){
			show_debug_message("Võit on käes!");
			show_debug_message("Lahenduse käigud on: ");
			/*for(var i=0; i < ds_list_size(obj_mang.sammud)-1; i++){
				show_debug_message(ds_list_find_value(obj_mang.sammud, i));
			}*/
			for(var i=0; i<array_length(obj_mang.vastused); i++){
				show_debug_message(obj_mang.vastused[i]);
			}
			var sama = false;
			if(string_length(obj_mang.vastused[array_length(obj_mang.vastused)-1]) == 5){
				sama = true;
				for(var i=0; i<6; i++){
					//string_char_at(obj_mang.vastused[array_length(obj_mang.vastused)-1]);
					if(string_char_at(obj_mang.vastused[array_length(obj_mang.vastused)-1], i) != string_char_at(obj_mang.vastused[array_length(obj_mang.vastused)-2], i)){
						sama = false;
						break;
					}
				}
			}
			if(sama) show_message("Võit on käes!\n"+"Lahenduse käigud on: \n"+obj_mang.vastused[array_length(obj_mang.vastused)-2]); else show_message("Võit on käes!\n"+"Lahenduse käigud on: \n"+obj_mang.vastused[array_length(obj_mang.vastused)-1]);
		}else show_debug_message("Seda ülesannet ei saa lahendata");
	}
}

function lahenda(grid, kesLahendab, kuningateKohad, sammudPraegu){
	var uusGrid = ds_grid_create(8, 8);
	ds_grid_copy(uusGrid, grid);
	var v6it = false;
	sammudPraegu++;
	prindi(uusGrid);
	/*show_debug_message(string(kesLahendab)+ " " +string(kuningateKohad[0])+ " "  + string(kuningateKohad[1]))
	show_debug_message(string(sammudPraegu))
	show_debug_message(string(obj_mang.sammudeArv))*/
	
	for(var i = 0; i < ds_grid_width(grid); i++){
		for(var j = 0; j < ds_grid_width(grid); j++){
			ds_grid_copy(uusGrid, grid);
			if(sign(ds_grid_get(grid, i, j)) == kesLahendab) {
				switch(abs(ds_grid_get(grid, i, j))){
					case 1:
						v6it = etturLiigub(uusGrid, kuningateKohad, kesLahendab, i, j, sammudPraegu);
						if(v6it) return true;
						break;
					case 2:
						v6it = ratsuLiigub(uusGrid, kuningateKohad, kesLahendab, i, j, sammudPraegu);
						if(v6it) return true;
						break;
					case 3:
						v6it = odaLiigub(uusGrid, kuningateKohad, kesLahendab, i, j, sammudPraegu);
						if(v6it) return true;
						break;
					case 4:
						v6it = vankerLiigub(uusGrid, kuningateKohad, kesLahendab, i, j, sammudPraegu);
						if(v6it) return true;
						break;
					case 5:
						v6it = vankerLiigub(uusGrid, kuningateKohad, kesLahendab, i, j, sammudPraegu);
						if(v6it) return true; else 
						v6it = odaLiigub(uusGrid, kuningateKohad, kesLahendab, i, j, sammudPraegu);
						if(v6it) return true;
						break;
					case 6:
						v6it = kuningasLiigub(uusGrid, kuningateKohad, kesLahendab, sammudPraegu);
						if(v6it) return true;
						break;
				}
			}
		}
	}
	if(kesLahendab == obj_mang.kesKaitseb && !(kasKuningasOhus(kuningateKohad[0], kuningateKohad[1], kesLahendab, uusGrid))) return true;
	return false;
}

#region Malendite liikumine
function etturLiigub(uusGrid, kuningateKohad, kesLahendab, i, j, sammudPraegu){
	var sobib = false;
	if(kesLahendab == -1 && i == 1 && ds_grid_get(uusGrid, i+1, j) == 0 && ds_grid_get(uusGrid, i+2, j) == 0){
		ds_grid_set(uusGrid, i, j, 0);
		ds_grid_set(uusGrid, i+2, j, kesLahendab);
		//salvestaKaik(kesLahendab, i+2, j);
		sobib = kasLahenduselOhus(kuningateKohad[0], kuningateKohad[1], kuningateKohad[2], kuningateKohad[3], kesLahendab, kesLahendab, uusGrid, i+2, j, sammudPraegu);
		if(sobib) return true;
		//kustutaViimaneKaik();
		ds_grid_set(uusGrid, i, j, kesLahendab);
		ds_grid_set(uusGrid, i+2, j, 0);
	}
	if(kesLahendab == 1 && i == 6 && ds_grid_get(uusGrid, i-1, j) == 0 && ds_grid_get(uusGrid, i-2, j) == 0){
		ds_grid_set(uusGrid, i, j, 0);
		ds_grid_set(uusGrid, i-2, j, kesLahendab);
		//salvestaKaik(kesLahendab, i-2, j);
		sobib = kasLahenduselOhus(kuningateKohad[0], kuningateKohad[1], kuningateKohad[2], kuningateKohad[3], kesLahendab, kesLahendab, uusGrid, i-2, j, sammudPraegu);
		if(sobib) return true;
		//kustutaViimaneKaik();
		ds_grid_set(uusGrid, i, j, kesLahendab);
		ds_grid_set(uusGrid, i-2, j, 0);
	}
	if(i+1*(-kesLahendab) > -1 && i+1*(-kesLahendab) < 8 && ds_grid_get(uusGrid, i+1*(-kesLahendab), j) == 0){
		if(i+1*(-kesLahendab) == 0 || i+1*(-kesLahendab) == 7) {
			for(r=5; r>1; r--){
				ds_grid_set(uusGrid, i, j, 0);
				ds_grid_set(uusGrid, i-kesLahendab, j, r*kesLahendab);
				sobib = kasLahenduselOhus(kuningateKohad[0], kuningateKohad[1], kuningateKohad[2], kuningateKohad[3], kesLahendab, r*kesLahendab, uusGrid, i-kesLahendab, j, sammudPraegu);
				if(sobib) return true;
				ds_grid_set(uusGrid, i, j, kesLahendab);
				ds_grid_set(uusGrid, i-kesLahendab, j, 0);
			}
		} else {
			ds_grid_set(uusGrid, i, j, 0);
			ds_grid_set(uusGrid, i+1*(-kesLahendab), j, 1*kesLahendab);
			sobib = kasLahenduselOhus(kuningateKohad[0], kuningateKohad[1], kuningateKohad[2], kuningateKohad[3], kesLahendab, kesLahendab, uusGrid, i-kesLahendab, j, sammudPraegu);
			if(sobib) return true;
			ds_grid_set(uusGrid, i, j, kesLahendab);
			ds_grid_set(uusGrid, i-kesLahendab, j, 0);
		}
	}
	for(var r = 1; r > - 2; r-=2){
		if(i+1*(-kesLahendab) > -1 && i+1*(-kesLahendab) < 8 && j+r > -1 && j+r < 8 && sign(ds_grid_get(uusGrid, i+1*(-kesLahendab), j+r)) == -kesLahendab){
			ds_grid_set(uusGrid, i, j, 0);
			var sobib = false;
			var tapetudNupp = ds_grid_get(uusGrid, i+1*(-kesLahendab), j+r);
			ds_grid_set(uusGrid, i+(-kesLahendab), j+r, kesLahendab);
			sobib = kasLahenduselOhus(kuningateKohad[0], kuningateKohad[1], kuningateKohad[2], kuningateKohad[3], kesLahendab, kesLahendab, uusGrid, i+(-kesLahendab), j+r, sammudPraegu);
			if(sobib) return true;
			ds_grid_set(uusGrid, i, j, kesLahendab);
			ds_grid_set(uusGrid, i+(-kesLahendab), j+r, tapetudNupp);
		}
	}
	return false;
}

function ratsuLiigub(uusGrid, kuningateKohad, kesLahendab, i, j, sammudPraegu){
	var ratsuSuunad = [[-1, -2], [-2, -1], [-2, 1], [-1, 2], [1, 2], [2, 1], [2, -1], [1, -2]];
	for(var r= 0; r < array_length(ratsuSuunad); r++){
		if(-1 < i+ratsuSuunad[r][0]) &&  (i+ratsuSuunad[r][0] < 8) && (-1 < j+ratsuSuunad[r][1]) && (j+ratsuSuunad[r][1] < 8) && (sign(ds_grid_get(uusGrid, i+ratsuSuunad[r][0], j+ratsuSuunad[r][1])) != kesLahendab){
			ds_grid_set(uusGrid, i, j, 0);
			var sobib = false;
			var tapetudNupp = ds_grid_get(uusGrid, i+ratsuSuunad[r][0], j+ratsuSuunad[r][1]);
			ds_grid_set(uusGrid, i+ratsuSuunad[r][0], j+ratsuSuunad[r][1], 2*kesLahendab);
			sobib = kasLahenduselOhus(kuningateKohad[0], kuningateKohad[1], kuningateKohad[2], kuningateKohad[3], kesLahendab, 2*kesLahendab, uusGrid, i+ratsuSuunad[r][0], j+ratsuSuunad[r][1], sammudPraegu);
			if(sobib) return true;
			ds_grid_set(uusGrid, i, j, 2*kesLahendab);
			ds_grid_set(uusGrid, i+ratsuSuunad[r][0], j+ratsuSuunad[r][1], tapetudNupp);
		}
	}
	return false;
}

function odaLiigub(uusGrid, kuningateKohad, kesLahendab, i, j, sammudPraegu){
	var rida = i - 1;
	var veerg = j - 1;
	var kes = 0;
	
	while(rida > -1 && veerg > -1){
		kes = odaDiagonaalneCheck(rida, veerg, kesLahendab, uusGrid, kuningateKohad, i, j, sammudPraegu);
		if(kes == 2) return true; else if(kes == 1) break;
		rida--;
		veerg--;
	}
	rida = i + 1;
	veerg = j - 1;
	while(rida < 8 && veerg > -1){
		kes = odaDiagonaalneCheck(rida, veerg, kesLahendab, uusGrid, kuningateKohad, i, j, sammudPraegu);
		if(kes == 2) return true; else if(kes == 1) break;
		rida++;
		veerg--;
	}
	rida = i + 1;
	veerg = j + 1;
	while(rida < 8 && veerg < 8){
		kes = odaDiagonaalneCheck(rida, veerg, kesLahendab, uusGrid, kuningateKohad, i, j, sammudPraegu);
		if(kes == 2) return true; else if(kes == 1) break;
		rida++;
		veerg++;
	}
	rida = i - 1;
	veerg = j + 1;
	while(rida > -1 && veerg < 8){
		kes = odaDiagonaalneCheck(rida, veerg, kesLahendab, uusGrid, kuningateKohad, i, j, sammudPraegu);
		if(kes == 2) return true; else if(kes == 1) break;
		rida--;
		veerg++;
	}
	return false;
}

function odaDiagonaalneCheck(uusX, uusY, kesLahendab, uusGrid, kuningateKohad, i, j, sammudPraegu){
	var nupp = ds_grid_get(uusGrid, i, j);
	if(sign(ds_grid_get(uusGrid, uusX, uusY)) == kesLahendab) return 1; else{
		var tapetudNupp = ds_grid_get(uusGrid, uusX, uusY);
		var sobib = 0;
		ds_grid_set(uusGrid, i, j, 0);
		ds_grid_set(uusGrid, uusX, uusY, nupp);
		sobib = kasLahenduselOhus(kuningateKohad[0], kuningateKohad[1], kuningateKohad[2], kuningateKohad[3], kesLahendab, nupp, uusGrid, uusX, uusY, sammudPraegu);
		if(sobib == 2) return 2;
		ds_grid_set(uusGrid, i, j, nupp);
		ds_grid_set(uusGrid, uusX, uusY, tapetudNupp);
		if (tapetudNupp != 0) return 1;
	}
	return 0;
}

function vankerLiigub(uusGrid, kuningateKohad, kesLahendab, vankriX, vankriY, sammudPraegu){
	var kes = 0;
	
	//Horisontaalne kontroll
	for(var i = vankriY-1; i > -1; i--){
		kes = vankerCheck(vankriX, i, kuningateKohad, kesLahendab, uusGrid, vankriX, vankriY, sammudPraegu);
		if(kes == 2) return true; else if(kes == 1) break;
	}
	for(var i = vankriY+1; i < 8; i++){
		kes = vankerCheck(vankriX, i, kuningateKohad, kesLahendab, uusGrid, vankriX, vankriY, sammudPraegu);
		if(kes == 2) return true; else if(kes == 1) break;
	}
	
	//Vertikaalne kontroll
	for(var i = vankriX-1; i > -1; i--){
		kes = vankerCheck(i, vankriY, kuningateKohad, kesLahendab, uusGrid, vankriX, vankriY, sammudPraegu);
		if(kes == 2) return true; else if(kes == 1) break;
	}
	for(var i = vankriX+1; i < 8; i++){
		kes = vankerCheck(i, vankriY, kuningateKohad, kesLahendab, uusGrid, vankriX, vankriY, sammudPraegu);
		if(kes == 2) return true; else if(kes == 1) break;
	}
	return false;
}

function vankerCheck(uusX, uusY, kuningateKohad, kesLahendab, uusGrid, vankriX, vankriY, sammudPraegu){
	var nupp = ds_grid_get(uusGrid, vankriX, vankriY);
	if(sign(ds_grid_get(uusGrid, uusX, uusY)) == kesLahendab) return 1; else {
		var tapetudNupp = ds_grid_get(uusGrid, uusX, uusY);
		var sobib = 0;
		ds_grid_set(uusGrid, vankriX, vankriY, 0);
		ds_grid_set(uusGrid, uusX, uusY, nupp);
		//salvestaKaik(nupp, uusX, uusY)
		sobib = kasLahenduselOhus(kuningateKohad[0], kuningateKohad[1], kuningateKohad[2], kuningateKohad[3], kesLahendab, nupp, uusGrid, uusX, uusY, sammudPraegu);
		if(sobib == 2) return 2;
		//kustutaViimaneKaik();
		ds_grid_set(uusGrid, vankriX, vankriY, nupp);
		ds_grid_set(uusGrid, uusX, uusY, tapetudNupp);
		if (tapetudNupp != 0) return 1;
	}
	return 0;
}

function kuningasLiigub(uusGrid, kuningateKohad, kesLahendab, sammudPraegu){
	var kuningaSuunad = [[-1, -1], [-1, 0], [-1, 1], [0, 1], [1, 1], [1, 0], [1, -1], [0, -1]];
	for(var i = 0; i< array_length(kuningaSuunad); i++){
		var uusX = kuningateKohad[0] + kuningaSuunad[i][0];
		var uusY = kuningateKohad[1] + kuningaSuunad[i][1];
		if(uusX > -1) && (uusX < 8) && (uusY > -1) && (uusY < 8){
			if (sign(ds_grid_get(uusGrid, uusX, uusY)) != kesLahendab){
				var sobib = false;
				ds_grid_set(uusGrid, kuningateKohad[0], kuningateKohad[1], 0);
				var tapetudNupp = ds_grid_get(uusGrid, uusX, uusY);
				ds_grid_set(uusGrid, uusX, uusY, 6*kesLahendab);
				//salvestaKaik(6*kesLahendab, uusX, uusY);
				sobib = kasLahenduselOhus(uusX, uusY, kuningateKohad[2], kuningateKohad[3], kesLahendab, 6*kesLahendab, uusGrid, uusX, uusY, sammudPraegu);
				if(sobib) return true;
				//kustutaViimaneKaik();
				ds_grid_set(uusGrid, kuningateKohad[0], kuningateKohad[1], 6*kesLahendab);
				ds_grid_set(uusGrid, uusX,  uusY, tapetudNupp);
			}
		}
	}
	return false;
}

function kasLahenduselOhus(heaX, heaY, pahaX, pahaY, kesLahendab, nupp, uusGrid, uusX, uusY, sammudPraegu){
	salvestaKaik(nupp, uusX, uusY);
	if(!kasKuningasOhus(heaX, heaY, kesLahendab, uusGrid)){
		var kuningateKohad = [pahaX, pahaY, heaX, heaY];
		var vastasElab = false;
		if(kesLahendab != obj_mang.kesKaitseb){
			if(kasKuningasOhus(pahaX, pahaY, -kesLahendab, uusGrid)){
				vastasElab = lahenda(uusGrid, -kesLahendab, kuningateKohad, sammudPraegu);
				if(abs(nupp) == 3|| abs(nupp) == 4 || abs(nupp) == 5) && (!vastasElab){
					//array_push(obj_mang.sammud, string(obj_mang.nuppudeTahed[abs(nupp)-1])+ " " + obj_mang.tahestik[uusY] + string(8-uusX) + "; ");
					var uusLahend = listToString();
					array_push(obj_mang.vastused, uusLahend);
					//show_debug_message(uusLahend);
					//obj_mang.sammudeArv = sammudPraegu;
					kustutaViimaneKaik();
					return 2; 
				}else if(!vastasElab){ 
					//array_push(obj_mang.sammud, string(obj_mang.nuppudeTahed[abs(nupp)-1])+ " " + string(uusX) + string(uusY) + "; ");
					var uusLahend = listToString();
					array_push(obj_mang.vastused, uusLahend);
					//show_debug_message(uusLahend);
					//obj_mang.sammudeArv = sammudPraegu;
					kustutaViimaneKaik();
					return true;
				}
				//kustutaViimaneKaik();
			} else if (sammudPraegu < obj_mang.sammudeArv+1){
				//array_push(obj_mang.sammud, string(obj_mang.nuppudeTahed[abs(nupp)-1])+ " " + string(uusX) + string(uusY) + "; ");
				vastasElab = lahenda(uusGrid, -kesLahendab, kuningateKohad, sammudPraegu);
				if(abs(nupp) == 3|| abs(nupp) == 4 || abs(nupp) == 5) && (!vastasElab){
					kustutaViimaneKaik();
					return 2;
				}else if(!vastasElab){
					kustutaViimaneKaik();
					return true;
				}
			} 
		} else if(sammudPraegu < obj_mang.sammudeArv+1){
			vastasElab = lahenda(uusGrid, -kesLahendab, kuningateKohad, sammudPraegu);
			if(abs(nupp) == 3|| abs(nupp) == 4 || abs(nupp) == 5) && (!vastasElab){
				kustutaViimaneKaik();
				return 2;
			}else if(!vastasElab){
				kustutaViimaneKaik();
				return true;
			}
		} else {
			if(abs(nupp) == 3|| abs(nupp) == 4 || abs(nupp) == 5){
				kustutaViimaneKaik();
				return 2; 
			} else{
				kustutaViimaneKaik();
				return true;
			}
		}
	}
	kustutaViimaneKaik();
	return false;
}
#endregion

#region Funktsioonid, mis kontrollivad kas kuningas on ohus
function kasKuningasOhus(kuningaX, kuningaY, kuningaVarv, grid){
	//show_debug_message("Funktsioon läheb tööle!");
	var kes = 0;
	//prindi(grid);
	//Horisontaalne kontroll
	for(var i = kuningaY-1; i > -1; i--){
		kes = horisontaalneCheck(kuningaX, kuningaY, kuningaVarv, grid, i);
		if(kes == 2) return true; else if(kes == 1) break;
	}
	for(var i = kuningaY+1; i < 8; i++){
		kes = horisontaalneCheck(kuningaX, kuningaY, kuningaVarv, grid, i);
		if(kes == 2) return true; else if(kes == 1) break;
	}
	
	//Vertikaalne kontroll
	for(var i = kuningaX-1; i > -1; i--){
		kes = vertikaalneCheck(kuningaX, kuningaY, kuningaVarv, grid, i);
		if(kes == 2) return true; else if(kes == 1) break;
	}
	for(var i = kuningaX+1; i < 8; i++){
		kes = vertikaalneCheck(kuningaX, kuningaY, kuningaVarv, grid, i);
		if(kes == 2) return true; else if(kes == 1) break;
	}
	
	//Diagonaalne kontroll vastupäeva
	var rida = kuningaX - 1;
	var veerg = kuningaY - 1;
	while(rida > -1 && veerg > -1){
		kes = diagonaalneCheck(rida, veerg, kuningaVarv, grid, kuningaX, kuningaY);
		if(kes == 2) return true; else if(kes == 1) break;
		rida--;
		veerg--;
	}
	rida = kuningaX + 1;
	veerg = kuningaY - 1;
	while(rida < 8 && veerg > -1){
		kes = diagonaalneCheck(rida, veerg, kuningaVarv, grid, kuningaX, kuningaY);
		if(kes == 2) return true; else if(kes == 1) break;
		rida++;
		veerg--;
	}
	rida = kuningaX + 1;
	veerg = kuningaY + 1;
	while(rida < 8 && veerg < 8){
		kes = diagonaalneCheck(rida, veerg, kuningaVarv, grid, kuningaX, kuningaY);
		if(kes == 2) return true; else if(kes == 1) break;
		rida++;
		veerg++;
	}
	rida = kuningaX - 1;
	veerg = kuningaY + 1;
	while(rida > -1 && veerg < 8){
		kes = diagonaalneCheck(rida, veerg, kuningaVarv, grid, kuningaX, kuningaY);
		if(kes == 2) return true; else if(kes == 1) break;
		rida--;
		veerg++;
	}
	
	//Ratsu kontroll
	var ratsuSuunad = [[-1, -2], [-2, -1], [-2, 1], [-1, 2], [1, 2], [2, 1], [2, -1], [1, -2]];
	for(var i= 0; i< array_length(ratsuSuunad); i++){
		if(-1 < kuningaX+ratsuSuunad[i][0]) &&  (kuningaX+ratsuSuunad[i][0] < 8) && (-1 < kuningaY+ratsuSuunad[i][1]) && (kuningaY+ratsuSuunad[i][1] < 8){
			kes = LCheck(ratsuSuunad[i][0]+kuningaX, ratsuSuunad[i][1]+kuningaY, kuningaVarv, grid);
			if(kes == 2) return true;
		}
	}
	return false;
}

function horisontaalneCheck(kuningaX, kuningaY, kuningaVarv, grid, i){
	if(sign(ds_grid_get(grid, kuningaX, i)) == kuningaVarv) return 1; else if (sign(ds_grid_get(grid, kuningaX, i)) == -kuningaVarv){
		//if(i > kuningaY)show_debug_message("Paremal on vaenlane!"); else show_debug_message("Vasakul on vaenlane!");
		if(ds_grid_get(grid, kuningaX, i) == 4*(-kuningaVarv) || ds_grid_get(grid, kuningaX, i) == 5*(-kuningaVarv)){
			//if(i > kuningaY) show_debug_message("Kuningas on paremalt ohus!"); else show_debug_message("Kuningas on vasakult ohus!");
			return 2;
		} else if (ds_grid_get(grid, kuningaX, i) == 6*(-kuningaVarv) && abs(kuningaY-i) == 1) {
			//if(i > kuningaY) show_debug_message("Kuningas on paremalt ohus!"); else show_debug_message("Kuningas on vasakult ohus!");
			return 2;
		} else return 1;
	}
	return 0;
}

function vertikaalneCheck(kuningaX, kuningaY, kuningaVarv, grid, i){
	if(sign(ds_grid_get(grid, i, kuningaY)) == kuningaVarv) return 1; else if (sign(ds_grid_get(grid, i, kuningaY)) == -kuningaVarv){
		//if(i > kuningaX)show_debug_message("All on vaenlane!"); else show_debug_message("Üleval on vaenlane!");
		if(ds_grid_get(grid, i, kuningaY) == 4*(-kuningaVarv) || ds_grid_get(grid, i, kuningaY) == 5*(-kuningaVarv)){
			//if(i > kuningaX) show_debug_message("Kuningas on alt ohus!"); else show_debug_message("Kuningas on ülevalt ohus!");
			return 2;
		} else if (ds_grid_get(grid, i, kuningaY) == 6*(-kuningaVarv) && abs(kuningaX-i) == 1) {
			//if(i > kuningaX) show_debug_message("Kuningas on alt ohus!"); else show_debug_message("Kuningas on ülevalt ohus!");
			return 2;
		} else return 1;
	}
	return 0;
}

function diagonaalneCheck(uusX, uusY, kuningaVarv, grid, kuningaX, kuningaY){
	//show_debug_message(string(uusX) + " " + string(uusY))
	if(sign(ds_grid_get(grid, uusX, uusY)) == kuningaVarv) return 1; else if (sign(ds_grid_get(grid, uusX, uusY)) == -kuningaVarv){
		//diagonaalneHoiatus(kuningaX, kuningaY, uusX, uusY, false)
		if(ds_grid_get(grid, uusX, uusY) == 3*(-kuningaVarv) || ds_grid_get(grid, uusX, uusY) == 5*(-kuningaVarv)){
			//diagonaalneHoiatus(kuningaX, kuningaY, uusX, uusY, true)
			return 2;
		} else if (ds_grid_get(grid, uusX, uusY) == 6*(-kuningaVarv) && abs(uusX-kuningaX) == 1) {
			//diagonaalneHoiatus(kuningaX, kuningaY, uusX, uusY, true)
			return 2;
		} else if (ds_grid_get(grid, uusX, uusY) == 1*(-kuningaVarv) && abs(uusX-kuningaX) == 1) {
			if(kuningaVarv == -1 && uusX>kuningaX) || (kuningaVarv == 1 && uusX<kuningaX) {
				//diagonaalneHoiatus(kuningaX, kuningaY, uusX, uusY, true)
				return 2;
			}
		} else return 1;
	}
	return 0;
}

function diagonaalneHoiatus(kuningaX, kuningaY, uusX, uusY, ohus){
	if(ohus) {
		if(kuningaX > uusX){
			if(kuningaY > uusY) show_debug_message("Kuningas on loodest ohus!");  else show_debug_message("Kuningas on kirdest ohus!");
		}else {
			if(kuningaY > uusY) show_debug_message("Kuningas on edelast ohus!");  else show_debug_message("Kuningas on kagust ohus!");
		}
	} else {
		if(kuningaX > uusX) {
			if(kuningaY > uusY) show_debug_message("Loodel on vaenlane!");  else show_debug_message("Kirdel on vaenlane!");
		}else {
			if(kuningaY > uusY) show_debug_message("Edelal on vaenlane!"); else show_debug_message("Kagul on vaenlane!");
		}
	}
}

function LCheck(uusX, uusY, kuningaVarv, grid){
	if(ds_grid_get(grid, uusX, uusY) == 2*(-kuningaVarv)){
		 //show_debug_message("Kuningat ründab ratsu kohal: " +string(uusX)+string(uusY));
		 return 2;
	} else return 0;
}

#endregion
function prindi(uusGrid){
	var output_string = "";
	for(var i = 0; i < ds_grid_height(uusGrid); i++){
		for(var j = 0; j < ds_grid_width(uusGrid); j++){
			output_string += string(ds_grid_get(uusGrid, i, j)) + " ";
		}
		output_string += "\n";
	}

	show_debug_message(output_string);
	output_string = "";
}
function salvestaKaik(nupp, uusX, uusY){
	//array_push(obj_mang.sammud, string(obj_mang.nuppudeTahed[abs(nupp)-1])+ " " + obj_mang.tahestik[uusY] + string(8-uusX) + "; ");
	ds_list_add(obj_mang.sammud, string(obj_mang.nuppudeTahed[abs(nupp)-1])+" "+obj_mang.tahestik[uusY]+ string(8-uusX));
}
function kustutaViimaneKaik(){
	ds_list_delete(obj_mang.sammud, ds_list_size(obj_mang.sammud)-1);
}

function listToString(){
	var str = "";
	for(var i=0; i < ds_list_size(obj_mang.sammud); i++){
		str+=" ";
		str+= ds_list_find_value(obj_mang.sammud, i);
	}
	return str;
}