function [d2 C] = roll3(M, d, P, Ph, ang, dalp=0, ddpref=[0 0 0], C5=0)
	## Определение среднего диаметра наружной резьбы с симметричным профилем
	##   (по ГОСТ 8.677-2009)
	##
	## Использование:
	##
	##   [d2 C] = roll3(M, d, P, Ph, ang, dalp=0, ddpref=[0 0 0], C5=0)
	##
	##   d2     рассчитанное значение среднего диаметра, мм
	##   C      суммарная поправка (d2 = d2calc + C), мм
	##
	## Входные параметры:
	##
	##   M      измеренное значение размера по роликам, мм
	##   d      номинальное значение наружнго диаметра резьбы, мм
	##   P      номинальное значение шага резьбы, мм
	##   Ph     номинальное значение хода резьбы, мм
	##   ang    угол профиля резьбы, град
	##   dalp   отклонение угла профиля, мин
	##   ddpref отклонения диаметров проволочек (3-вектор), мкм
	##   C5     поправка, учитывающая измерительное усилие 2Н, мкм
	##

	dpref = dp(P, ang);
	d2nom = d - 0.5*P;
	C = sumerr(dpref, P, Ph, dalp, ddpref, d2nom, C5);
	a2 = ang / 2;
	d2 = M - dpref*(1 + 1/sind(a2)) + P*cotd(a2)/2 + C;
endfunction



function C = sumerr(dpref, P, Ph, dalp, ddpref, d2nom, C5)
	C1 = err1(dpref, P, dalp);
	C3 = err3(ddpref(1), ddpref(2), ddpref(3));
	C4 = err4(d2nom, P, Ph, dpref);
	C = C1/1000 + C3/1000 + C4 + C5/1000;
	printf("Deviations:\n");
	printf("  C1 = %g\n", C1);
	printf("  C3 = %g\n", C3);
	printf("  C4 = %g\n", C4);
	printf("  C5 = %g\n", C5);
	printf("  C = %g\n\n", C);
endfunction



function C1 = err1(dpref, P, delta_alp)
	## Поправка, учитывающая действительное отклонение угла профиля
	##   (только при пользовании проволочками непредпочтительного диаметра)
	##
	C1 = (2.1*dpref - 1.1*P) * delta_alp;
endfunction



function C3 = err3(ddpref1, ddpref2, ddpref3)
	## Поправка, учитывающая действительное отклонение диаметров проволочек
	##   (только при пользовании проволочками непредпочтительного диаметра)
	##
	C3 = -2.4 * (ddpref1 + (ddpref2 + ddpref3)/2);
endfunction



function C4 = err4(d2, P, Ph, dpref)
	## Поправка, учитывающая расположение проволочек под углом к оси резьбы
	##
	if (thrang(d2, Ph) < 7)
		n = Ph / P; 
		tmp1 = d2 - 1.866*P;
		C4 = -0.1826 * P^2 * n^2 * dpref / (tmp1 + 3.6049*dpref) / (tmp1 + 3.8637*dpref);
	else
		C4 = 0;
	endif
endfunction

