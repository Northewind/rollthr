function [dpref dmax] = dp(P, ang)
	## Выбор предпочтительного диаметра ролика
	##   
	## [dpref dmax] = dp(P, ang)
	##
	## Результат:
	##   dpref  Предпочтительный диаметр ролика
	##   dmax   Максимальный допустимый диаметр ролика
	##
	## Параметры:
	##   P      Шаг резьбы
	##   ang    Угол профиля резьбы
	##
	dpref = P / (2 * cosd(ang / 2));

	if (ang <= 30)
		dmax = 1.1 * dpref;
	else
		dmax = 1.2 * dpref;
	endif
endfunction

