function [dpref] = dp(P, ang)
	## Выбор предпочтительного диаметра ролика
	##   
	## [dpref] = dp(P, ang)
	##
	##   P      Шаг резьбы
	##   ang    Угол профиля резьбы
	##
	dpref = P / (2 * cosd(ang / 2));
endfunction

