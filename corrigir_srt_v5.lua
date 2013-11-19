--[[
 Copyright (c) 2012-2013, Leinad4Mind
 All rights reserved®.
 
 Um grande agradecimento a todos os meus amigos
 que sempre me apoiaram, e a toda a comunidade
 de anime portuguesa.
--]]

script_name = "Corrigir SRT"
script_description = "Adiciona espaço onde existe reticências no início da frase. Corrige os hífens. Corrige as aspas. Corrige I por l. Corrige á por à. Corrige a quando é há. Corrige concerteza para Com certeza. Corrige Porfavor para Por Favor. Aplica estilo 'Música' com todas as suas regras. E corrige problema de linhas sobrepostas existentes nos SRTs."
script_author = "Leinad4Mind"
script_version = "5.1"

include("karaskel.lua")

function corrigir(subs,sel)
	for i = 1,#subs do
        local line = subs[i]
        if line.class == "dialogue" then
            line.i = i + 1
			-- Reticências com .. ficar ...
            line.text = line.text:gsub("(%.%.)([^ .\\]?)","%1.%2")
			line.text = line.text:gsub("(%.%.)([%.]+)","%1.")
			-- Espaços - FUNCIONA
			line.text = line.text:gsub("(%.%.%.)([^ ^\{^\\])","%1 %2")
			-- Espaço antes da , e ; - FUNCIONA
            line.text = line.text:gsub("(% )(%,)","%2")
			line.text = line.text:gsub("(% )(%;)","%2")
			-- Duplo Espaço! - FUNCIONA
			line.text = line.text:gsub("([^ ])(% )(% )([^ ])","%1%2%4")
			-- Hífens - FUNCIONA
			line.text = line.text:gsub("- ([^ ])","– %1")
			line.text = line.text:gsub("^-([^ ])","– %1")
			line.text = line.text:gsub("(\\[Nn])-([^ ])","%1– %2")
			line.text = line.text:gsub("^({.-}+)-([^ ])","%1– %2")
			-- '' por " - FUNCIONA
			line.text = line.text:gsub("''","\"")
			--I por l - FUNCIONA
			line.text = line.text:gsub("-I([^ ])","-l%1")
			line.text = line.text:gsub("([AEIOUaeiouÁÉÍÓÚáéíóúà])It","%1lt")
			-- á por à e - FUNCIONA
			line.text = line.text:gsub("^á ([^ ])","à %1")
			line.text = line.text:gsub("^Á ([^ ])","À %1")
			line.text = line.text:gsub("([^ ]) á ([^ ])","%1 à %2")
			line.text = line.text:gsub("([^ ]) Á ([^ ])","%1 À %2")
			line.text = line.text:gsub("(\\[Nn])á ([^ ])","%1à %2")
			line.text = line.text:gsub("(\\[Nn])Á ([^ ])","%1À %2")

			
			--a muito tempo por há muito tempo - FUNCIONA
			--line.text = line.text:gsub("([aA])(muito%|bastante%|algum%|pouco%|um) tempo","%1há %2 tempo")
			line.text = line.text:gsub("a muito tempo","há muito tempo")
			line.text = line.text:gsub("a bastante tempo","há bastante tempo")
			line.text = line.text:gsub("a algum tempo","há algum tempo")
			line.text = line.text:gsub("a pouco tempo","há pouco tempo")
			line.text = line.text:gsub("a um tempo","há um tempo")
			line.text = line.text:gsub("a uns tempos","há uns tempos")
			line.text = line.text:gsub("A muito tempo","Há muito tempo")
			line.text = line.text:gsub("A bastante tempo","Há bastante tempo")
			line.text = line.text:gsub("A algum tempo","Há algum tempo")
			line.text = line.text:gsub("A pouco tempo","Há pouco tempo")
			line.text = line.text:gsub("A um tempo","Há um tempo")
			line.text = line.text:gsub("A uns tempos","Há uns tempos")
			--dias
			line.text = line.text:gsub("a um dia","há um dia")
			line.text = line.text:gsub("a uns dias","há uns dias")
			line.text = line.text:gsub("a poucos dias","há poucos dias")
			line.text = line.text:gsub("a alguns dias","há alguns dias")
			line.text = line.text:gsub("a bastantes dias","há bastantes dias")
			line.text = line.text:gsub("a muitos dias","há muitos dias")
			line.text = line.text:gsub("A um dia","Há um dia")
			line.text = line.text:gsub("A uns dias","Há uns dias")
			line.text = line.text:gsub("A poucos dias","Há poucos dias")
			line.text = line.text:gsub("A alguns dias","Há alguns dias")
			line.text = line.text:gsub("A bastantes dias","Há bastantes dias")
			line.text = line.text:gsub("A muitos dias","Há muitos dias")
			--horas
			line.text = line.text:gsub("a uma hora","há uma hora")
			line.text = line.text:gsub("a umas horas","há umas horas")
			line.text = line.text:gsub("a poucas horas","há poucas horas")
			line.text = line.text:gsub("a algumas horas","há algumas horas")
			line.text = line.text:gsub("a bastantes horas","há bastantes horas")
			line.text = line.text:gsub("a muitas horas","há muitas horas")
			line.text = line.text:gsub("A uma hora","Há uma hora")
			line.text = line.text:gsub("A umas horas","Há umas horas")
			line.text = line.text:gsub("A poucas horas","Há poucas horas")
			line.text = line.text:gsub("A algumas horas","Há algumas horas")
			line.text = line.text:gsub("A bastantes horas","Há bastantes horas")
			line.text = line.text:gsub("A muitas horas","Há muitas horas")
			--minutos
			line.text = line.text:gsub("a um minuto","há um minuto")
			line.text = line.text:gsub("a uns minutos","há uns minutos")
			line.text = line.text:gsub("a poucos minutos","há poucos minutos")
			line.text = line.text:gsub("a alguns minutos","há alguns minutos")
			line.text = line.text:gsub("a bastantes minutos","há bastantes minutos")
			line.text = line.text:gsub("a muitos minutos","há muitos minutos")
			line.text = line.text:gsub("A um minuto","Há um minuto")
			line.text = line.text:gsub("A uns minutos","Há uns minutos")
			line.text = line.text:gsub("A poucos minutos","Há poucos minutos")
			line.text = line.text:gsub("A alguns minutos","Há alguns minutos")
			line.text = line.text:gsub("A bastantes minutos","Há bastantes minutos")
			line.text = line.text:gsub("A muitos minutos","Há muitos minutos")
			--segundos
			line.text = line.text:gsub("a um segundo","há um segundo")
			line.text = line.text:gsub("a uns segundos","há uns segundos")
			line.text = line.text:gsub("a poucos segundos","há poucos segundos")
			line.text = line.text:gsub("a alguns segundos","há alguns segundos")
			line.text = line.text:gsub("a bastantes segundos","há bastantes segundos")
			line.text = line.text:gsub("a muitos segundos","há muitos segundos")
			line.text = line.text:gsub("A um segundo","Há um segundo")
			line.text = line.text:gsub("A uns segundos","Há uns segundos")
			line.text = line.text:gsub("A poucos segundos","Há poucos segundos")
			line.text = line.text:gsub("A alguns segundos","Há alguns segundos")
			line.text = line.text:gsub("A bastantes segundos","Há bastantes segundos")
			line.text = line.text:gsub("A muitos segundos","Há muitos segundos")

			--concerteza para com certeza - FUNCIONA
			line.text = line.text:gsub("concerteza","com certeza")
			line.text = line.text:gsub("Concerteza","Com certeza")
			--Porfavor para Por favor - FUNCIONA
			line.text = line.text:gsub("porfavor","por favor")
			line.text = line.text:gsub("Porfavor","Por favor")
			--Onomatopeias - FUNCIONA
			line.text = line.text:gsub("H[Ee]+[Yy]+([ .,?!])","Ei%1")
			line.text = line.text:gsub("h[e]+[y]+([ .,?!])","ei%1")
			line.text = line.text:gsub("[H]+[Uu]+[Hh]+([ .,?!])","Hum%1")
			line.text = line.text:gsub("[h]+[u]+[h]+([ .,?!])","hum%1")
			line.text = line.text:gsub("[W]+[Oo]+[Ww]+([ .,?!])","Uau%1")
			line.text = line.text:gsub("[w]+[o]+[w]+([ .,?!])","uau%1")
			line.text = line.text:gsub("[H]+[Mm]+([ .,?!])","Hmm%1")
			line.text = line.text:gsub("[h]+[m]+([ .,?!])","hmm%1")
			line.text = line.text:gsub("[O]+[Ww]+([ .,?!])","Au%1")
			line.text = line.text:gsub("[o]+[w]+([ .,?!])","au%1")
			line.text = line.text:gsub("[W]+[Aa]+[Hh]+","Buá")
			line.text = line.text:gsub("[w]+[a]+[h]+","buá")


			--Colocar estilo musica em todas linhas com ♪ e caso exista \N alinha a 2º linha correctamente.
			local b = string.find(line.text,"♪")
			local c = string.find(line.text,"\\N")
			local d = string.find(line.text,"\\i1")
			local z = string.find(line.text,"\\alpha")
			if b then --se tiver simbolo musical faz
				if c and not z then -- se tiver 2 linhas e ainda n tiver sido aplicado entao
					if d then -- aplica com italico
						line.text = line.text:gsub("^({.-}*)♪ ({.-})(.-)\\N(.-)","%1♪ %2%3\\N{\\alpha&HFF&}♪ {\\r}%1%2%4")
					else -- senao aplica sem italico
						line.text = line.text:gsub("^({.-}*)♪ (.-)\\N(.-)","%1♪ %2%3\\N{\\alpha&HFF&}♪ {\\r}%1%3")
					end
				end
				line.style = "Música"
			end
		end
        subs[i] = line
    end
	--Corrigir timing pro roca que ele é chato...
		--PROBLEMA
		--Dialogue: 0,0:32:18.74,0:32:21.96,Default,,0000,0000,0000,,texto antes
		--Dialogue: 0,0:32:21.96,0:32:22.29,Default,,0000,0000,0000,,texto test depois\Ntexto antes
		--Dialogue: 0,0:32:22.29,0:32:24.90,Default,,0000,0000,0000,,texto test depois

		--RESULTADO
		--Dialogue: 0,0:32:18.74,0:32:21.96,Default,,0000,0000,0000,,texto antes
		--Dialogue: 0,0:32:21.96,0:32:24.90,Default,,0000,0000,0000,,texto test depois
		
	for i=#subs,1,-1 do --#sel = numero total das linhas e vai do fim da legenda pro inicio
		local line = subs[i]
		local del = i
		local dur = 800 -- duracao maxima em ms, que a linha poderá ter
		if line.class == "dialogue" then
		line.duration = line.end_time - line.start_time --cria a duracao... senao tinha de carregar o karaskel.preproc_line -.-
			if line.text ~= "" and line.duration < dur then -- se duracao for menor que 800ms = 0:00:00.80 entao
				if i > 1 and i < #subs then -- se não for a 1º linha nem a última então
					local antes = subs[i-1]		--buscar linha anterior
					local depois = subs[i+1]	--buscar linha posterior
					confirmar = line.text == depois.text.."\\N"..antes.text --comparar se a linha actual (line.text) contém ambas as linhas.
					--aegisub.debug.out(2, "Debug: '%s' \n", confirmar)
					especial = antes.text:gsub("^({.-}+)(.-)","%2")
					tags = line.text == depois.text.."\\N"..especial --comparar se a linha actual (line.text) contém ambas as linhas.
					--{\be1\blur1}♪ {\i1}O amor distante vou buscar{\i} ♪
					music_antes = antes.text:gsub("^({.-}+)♪ ({.-})(.-)({.-}) ♪$","%3")
					music_depois = depois.text:gsub("^({.-}+)♪ ({.-})(.-)({.-}) ♪$","%3")
					--{\be1\blur1}♪ {\i1}Está numa estrela para nos guiar\N{\alpha&HFF&}♪ {\r\i1\be1\blur1}O amor distante vou buscar{\i} ♪
					music_actual = line.text:gsub("^({.-}+)♪ ({.-})(.-)\\N({.-})♪ ({.-}+)(.-)({.-}) ♪$","%3\\N%6")
					musicas = music_actual == music_depois.."\\N"..music_antes --comparar se a linha actual (line.text) contém ambas as linhas.				
					if confirmar or tags or musicas then --se realmente contiver então
						depois.start_time = antes.end_time -- torna os tempos continuos
						subs[i+1] = depois --insere o tempo alterado na legenda
						subs.delete(del) --apaga a linha que mete nojo
					end
				end
			end
		end
	end
end

aegisub.register_macro(script_name, script_description, corrigir)
aegisub.register_filter(script_name, script_description, 0, corrigir)
