function [dpref dmax] = dp(P, ang)
	%% Выбор предпочтительного диаметра ролика
	%%   
	%% Usage:
	%%     [dpref dmax] = dp(P, ang)
	%%
	%% Returns:
	%%     dpref  Предпочтительный диаметр ролика
	%%     dmax   Максимальный допустимый диаметр ролика
	%%
	%% Inputs:
	%%     P      Шаг резьбы
	%%     ang    Угол профиля резьбы
	dpref = P / (2 * cosd(ang / 2));
	if (ang <= 30)
		dmax = 1.1 * dpref;
	else
		dmax = 1.2 * dpref;
	end
end

