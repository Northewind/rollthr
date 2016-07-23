function [C] = err(droll, P, Ph, alp, dalp, ddroll, d2nom, C5)
	%% Расчёт суммарной поправки на измерение резьбы методом трёх проволочек
	%%
	%% Usage:
	%%     [C1 C3 C4 C5] = err(droll, P, Ph, alp, dalp, ddroll, d2nom, C5)
	%%
	%% Returns:
	%%     C1    поправка, учитывающая действительное отклонение угла профиля, мм
	%%     C3    поправка, учитывающая действительное отклонение диаметров проволочек, мм
	%%     C4    поправка, учитывающая расположение проволочек под углом к оси резьбы, мм
	%%     C5    поправка, учитывающая измерительное усилие, мм
	%%
	%% Inputs:
	%%     droll  номинальный диаметр роликов, мм
	%%     P      номинальное значение шага резьбы, мм
	%%     Ph     номинальное значение хода резьбы, мм
	%%     alp    угол профиля резьбы, град
	%%     dalp   отклонение угла профиля, мин
	%%     ddroll отклонения диаметров проволочек (3-вектор) от номинала, мкм
	%%     d2nom  номинальный средний диаметр контролируемой резьбы, мм
	%%     C5     поправка, учитывающая измерительное усилие 2Н, мкм

	if (droll != dp(P,alp))
		C1 = err1(droll, P, dalp);
		C3 = err3(ddroll(1), ddroll(2), ddroll(3));
	else
		C1 = C3 = 0;
	end
	C4 = err4(d2nom, P, Ph, droll, alp);
	C = [C1/1000  C3/1000  C4  C5/1000];

	%return;
	% Debug output
	printf("Deviations:\n");
	printf("  C1 = %g\n", C1);
	printf("  C3 = %g\n", C3);
	printf("  C4 = %g\n", C4);
	printf("  C5 = %g\n", C5);
	printf("  Csum = %g\n", sum(C));
end



function C1 = err1(droll, P, dalp)
	%% Поправка, учитывающая действительное отклонение угла профиля
	%%   (только при пользовании проволочками непредпочтительного диаметра)
	C1 = (2.1*droll - 1.1*P) * dalp;
end



function C3 = err3(ddroll1, ddroll2, ddroll3)
	%% Поправка, учитывающая действительное отклонение диаметров проволочек
	%%   (только при пользовании проволочками непредпочтительного диаметра)
	C3 = -2.4 * (ddroll1 + (ddroll2 + ddroll3)/2);
end



function C4 = err4(d2, P, Ph, droll, alp)
	%% Поправка, учитывающая расположение проволочек под углом к оси резьбы
	n = Ph / P; 
	if (thrang(d2, Ph) < 7)
		C4 = d2 - 1.866*P;
		C4 = (C4 + 3.6049*droll) * (C4 + 3.8637*droll); 
		C4 = -0.1826 * P^2 * n^2 * droll / C4;
	else
		a2 = alp/2;
		x1 = d2 - P/2*cotd(a2) + droll/sind(a2);
		y1 = P*n*droll*cosd(a2)/pi/x1^2;
		[xi yi] = err4gt7(x1, y1, d2, P, n, droll, a2);
		do
			C4pre = x1 - xi;
			[xi yi] = err4gt7(xi, yi, d2, P, n, droll, a2);
			C4 = x1 - xi;
		until (C4pre == C4);
	end
end


function [xi yi] = err4gt7(xi, yi, d2, P, n, droll, a2)
		xi = d2 - P/2*cotd(a2) + ...
		     droll/sind(a2) + ...
		     P*n*cotd(a2)/pi*yi - ...
			 xi/2*(xi/droll/sind(a2) - 1)*yi^2 - ...
			 xi^4/8/droll^3/sind(a2)*yi^4;
		yi = P*n*droll*cosd(a2)/pi/xi^2 * ...
		     (1 - xi^2/2/droll^2*yi^2 - xi^4/8/droll^4*yi^4) / ...
			 (1 - droll/xi*sind(a2) + ...
			 ((1/6 - xi^2/2/droll^2)*droll*sind(a2)/xi - 2/3)*yi^2);
end

