function ang = thrang(d2, Ph)
	%% Угол подъёма винтовой линии
	%%
	%% Usage:
	%%     ang = thrang(d2, Ph)
	%%
	%% Returns:
	%%     ang   Угол подъёма винтовой, град
	%%
	%% Arguments:
	%%   d2    средний диаметры резьбы, мм
	%%   Ph    ход резьбы, мм
	%%
	ang = atand(Ph / (pi*d2));
end

