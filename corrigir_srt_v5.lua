--[[
 Copyright (c) 2012-2014, Leinad4Mind
 All rights reserved®.
 
 Agradecimento especial ao MagNatsu pela sua contribuição e ajuda.
 
 Um grande agradecimento a todos os meus amigos
 que sempre me apoiaram, e a toda a comunidade
 de anime portuguesa.
--]]

script_name = "Corrigir SRT"
script_description = "Adiciona espaço onde existe reticências no início da frase. Corrige os hífens. Corrige as aspas. Corrige I por l. Corrige á por à. Corrige a quando é há. Corrige concerteza para Com certeza. Corrige Porfavor para Por Favor. Aplica estilo 'Música' com todas as suas regras. E corrige problema de linhas sobrepostas existentes nos SRTs."
script_author = "Leinad4Mind"
script_version = "9.0"

include("karaskel.lua")

function corrigir(subs,sel)
	for i = 1,#subs do
		local line = subs[i]
		if line.class == "dialogue" then
			line.i = i + 1
			-- Reticências com .. ficar ... - FUNCIONA
			line.text = line.text:gsub("(%.%.)([^ .\\]?)","%1.%2")
			line.text = line.text:gsub("(%.%.)([%.]+)","%1.")
			-- '' por " - FUNCIONA
			line.text = line.text:gsub("''","\"")
			-- Espaços após reticências - FUNCIONA
			line.text = line.text:gsub("(%.%.%.)([^% ^\\{^\\^\"])","%1 %2")
			-- Espaços após pontuação . ! ? - FUNCIONA
			line.text = line.text:gsub("([%.%!%?])([^% ^%d^\\^\"^\\{])","%1 %2")
			-- Apaga Duplo Espaço! - FUNCIONA
			line.text = line.text:gsub("([^ ])([% ])([% ]+)([^ ])","%1%2%4")
			-- Espaço antes da , e ; - FUNCIONA
			line.text = line.text:gsub("([% ]+)(%,)","%2")
			line.text = line.text:gsub("([% ]+)(%;)","%2")
			-- Espaço antes da ! e ? e . - FUNCIONA
			line.text = line.text:gsub("([% ]+)(%?)","%2")
			line.text = line.text:gsub("([% ]+)(%!)","%2")
			line.text = line.text:gsub("([% ]+)(%.)","%2")
			line.text = line.text:gsub("^([% ]+)([%-%–%—])","%2")
			line.text = line.text:gsub("(\\N[% ]+)([%-%–%—])","\\N%2")
			-- Espaço no meio de digitos passa a . - FUNCIONA
			line.text = line.text:gsub("(%d+)(% )(%d+)","%1%3")
			line.text = line.text:gsub("(%d+)(% )(%d+)","%1%3")
			line.text = line.text:gsub("(%d+)(% )(%d+)","%1%3")
			line.text = line.text:gsub("(%d+)(% )(%d+)","%1%3")
			line.text = line.text:gsub("(%d+)(%d%d%d)","%1.%2")
			line.text = line.text:gsub("(%d+)(%d%d%d)","%1.%2")
			line.text = line.text:gsub("(%d+)(%d%d%d)","%1.%2")
			line.text = line.text:gsub("(%d+)(%d%d%d)","%1.%2")
			line.text = line.text:gsub("(%d%d%d) (%d%d%d)","%1.%2")
			line.text = line.text:gsub("(%d%d%d) (%d%d%d)","%1.%2")
			line.text = line.text:gsub("(%d%d%d) (%d%d%d)","%1.%2")
			line.text = line.text:gsub("(%d%d%d) (%d%d%d)","%1.%2")
			-- Hífens para meia-risca removendo espaços - FUNCIONA
			line.text = line.text:gsub("^- ([^ ])","– %1")
			line.text = line.text:gsub("^-([^ ])","– %1")
			line.text = line.text:gsub("(\\[Nn])-[ ]?([^ ])","%1– %2")
			line.text = line.text:gsub("^({.-}+)-([^ ])","%1– %2")
			-- manter meia-risca removendo espaços - FUNCIONA
			line.text = line.text:gsub("^–([^ ])","– %1")
			line.text = line.text:gsub("(\\[Nn])–([^ ])","%1– %2")
			line.text = line.text:gsub("^({.-}+)–([^ ])","%1– %2")
			-- manter travessão removendo espaços - FUNCIONA
			line.text = line.text:gsub("^—([^ ])","— %1")
			line.text = line.text:gsub("(\\[Nn])—([^ ])","%1— %2")
			line.text = line.text:gsub("^({.-}+)—([^ ])","%1— %2")
			--Reticências no início da frase - FUNCIONA
			if i<#subs then
				local nextln = subs[i+1]
				if line.text:sub(-3, -1) == "..." and nextln.text:sub(1,3)~="..." --se linha termina com reticências e próxima não começa com reticências então
					and nextln.text:sub(1,3)~="♪" and nextln.text:sub(1,3)~="♫" -- verifica se não começa com simbolos musicais ♪ ♫
					and nextln.text:sub(1,1)~="\""  and nextln.text:sub(1,1)~="'" -- verifica se não começa com aspas ou plica " '
					and nextln.text:sub(1,1)~="-" and nextln.text:sub(1,3)~="–" and nextln.text:sub(1,3)~="—" -- se diferente de hífen, meia-risca – e travessão — 
					and nextln.text:sub(1, 1)==nextln.text:lower():sub(1,1) then --e se próxima começa com mínuscula então
						nextln.text = "..."..nextln.text
						subs[i+1] = nextln
				elseif line.text:sub(-3, -1) == "..."  -- senão se termina com reticências
						and (nextln.text:sub(1,1)=="-" or nextln.text:sub(1,3)=="–" or nextln.text:sub(1,3)=="—") then -- e se começa com hífen, meia-risca ou travessão então
							-- adicionar as reticências caso comece com lowercase ou digitos // remover %d se digitos estiverem a mais
							nextln.text = nextln.text:gsub("^- ?([%l%d])","- ... %1")
							nextln.text = nextln.text:gsub("^– ?([%l%d])","– ... %1")
							nextln.text = nextln.text:gsub("^— ?([%l%d])","— ... %1")
							subs[i+1] = nextln
				end
			end
			--depois de . ou ? ou ! ter maíscula - FUNCIONA
			function maiusPont( first, second, rest)
				return first..second..rest:upper()
			end
			line.text = line.text:gsub("([%w'\"][%.%?%!])([% ?])(%l)", maiusPont)
			line.text = line.text:gsub("([%w'\"]?!)([% ?])(%l)", maiusPont)
			--I por l - FUNCIONA
			line.text = line.text:gsub("-I([^ ])","-l%1")
			line.text = line.text:gsub("([AEIOUaeiouÁÉÍÓÚáéíóúà])It","%1lt")
			-- á por à e - FUNCIONA
			line.text = line.text:gsub("([ \"])á ([^ ])","%1à %2")
			line.text = line.text:gsub("^Á ([^ ])","À %1")
			line.text = line.text:gsub("([ ]) á ([^ ])","%1 à %2")
			line.text = line.text:gsub("([^ ]) Á ([^ ])","%1 À %2")
			line.text = line.text:gsub("(\\[Nn])á ([^ ])","%1à %2")
			line.text = line.text:gsub("(\\[Nn])Á ([^ ])","%1À %2")
			--ponto final antes do hífen, meia-risca ou travessão - FUNCIONA
			line.text = line.text:gsub("([^%.%?%!])(\\N)% ?(–) ","%1.%2%3 ")
			line.text = line.text:gsub("([^%.%?%!])(\\N)% ?(—) ","%1.%2%3 ")
			-- o por 0 e vicer-versa, problema de OCR - FALTA TESTAR
			line.text = line.text:gsub("(%d)O","%1 0")
			line.text = line.text:gsub("(%d)[,\\.]O","%1.0")
			line.text = line.text:gsub("([A-Z])0","%1O")
			line.text = line.text:gsub("%W0([A-Za-z])","O%1")
			--Correcção da mesóclise - FALTA TESTAR
			line.text = line.text:gsub("([fFdD])ar(%w+)%-(%w)", "%1ar-%3-%2") -- fariam-lhe -> far-lhe-iam
			line.text = line.text:gsub("(lhe% dar(%w+)", "dar-lhe-%1") -- lhe darei -> dar-lhe-ei
			line.text = line.text:gsub("(Lhe% dar(%w+)", "Dar-lhe-%1") -- Lhe darei -> Dar-lhe-ei
			line.text = line.text:gsub("(lhe% far(%w+)", "dar-lhe-%1") -- lhe farei -> far-lhe-ei
			line.text = line.text:gsub("(Lhe% far(%w+)", "Far-lhe-%1") -- Lhe farei -> Far-lhe-ei
			-- problema de hífens em palavras ("fizes-te", "lês-te", "pensas-te") - FALTA TESTAR
			line.text = line.text:gsub("([fF])izes%-te([s %p])","%1izeste%2")
			line.text = line.text:gsub("([lL])[êe]s%-te[[s ])","%1este%2")
			line.text = line.text:gsub("([pP])ensas%-te([s ])","%1ensaste%2")
			line.text = line.text:gsub("([eE])ngolis%-te([s ])","%1ngoliste%2")
			line.text = line.text:gsub("([fF])os%-te([s ])","%1oste%2")
			line.text = line.text:gsub("([hH])[aá]%-de([s ])","%1á%2-de") --há-des -> hás-de
			line.text = line.text:gsub("([a-zA-Z]*)arei%-te","%1ar-te-ei") --ex: amarei-te -> amar-te-ei | ajudarei-te -> ajudar-te-ei 
			line.text = line.text:gsub("([qQ])uer%-([ao])", "%1uere-%2") -- quer-o -> quere-o
			line.text = line.text:gsub("([qQ])uere%-([st])e", "%1uer-%2") -- quere-se -> quer-se
			--line.text = line.text:gsub("([rR])equer%-([ao])", "%1equere-%2") -- requer-o -> requere-o | aglutinado no de cima
			--line.text = line.text:gsub("([rR])equere%-([st])e", "%1equer-%2") -- requere-se -> requer-se | aglutinado no de cima
			line.text = line.text:gsub("([qQ])uises%-te(s?)", "%1uiseste%2") -- quises-te -> quiseste
			line.text = line.text:gsub("([qQ])uizer(e?s?s?e?a?m?)", "%1uiser%2") -- quizer -> quiser
			-- Corecção de erros mais comuns nas palavras - FALTA TESTAR
			line.text = line.text:gsub("([pP])ro[ií]b[ií]d([oa])","%1roibid%2") -- proíbido -> proibido
			line.text = line.text:gsub("([dD])isfrutar","%1esfrutar") -- disfrutar -> desfrutar
			line.text = line.text:gsub("([vV])uner[aá]ve(l?)","%1ulneráve%2") --vulnerável e vulneráveis
			line.text = line.text:gsub("([aA])piou(-?)","%1peou%2") --ex: apiou ou apiou-se -> apeou(-se)
			line.text = line.text:gsub("([aA])piadeir", "%1peadeir") --ex: apiadeiro -> apeadeiro
			line.text = line.text:gsub("([fF])an(s?)([ .,?!])","%1ã%2%3") -- fan(s) -> fã(s)
			line.text = line.text:gsub("([sS])émola(s?)([ .,?!])","%1êmola%2%3") -- sémola -> sêmola
			line.text = line.text:gsub("([sS])émea(s?)([ .,?!])","%1êmea%2%3") -- sémea -> sêmea
			line.text = line.text:gsub("([sS])asona([a-zA-Z]*)","%1azona%2") -- sasonal -> sazonal | sasonais -> sazonais
			line.text = line.text:gsub("([pP])romenor","%1ormenor") -- promenor -> pormenor | promenorizado -> pormenorizado
			line.text = line.text:gsub("([pP])[eé][sz]inho(s?)","%1ezinho%2") -- pesinho -> pezinho | pézinho -> pezinho
			line.text = line.text:gsub("([pP])anoramic([ao])","%1ânoramic%2") -- panoramico -> pânoramico
			line.text = line.text:gsub("([cC])am([ea])ra(s?)","%1âm%2ra%3") -- camara -> câmara | camera -> câmera
			line.text = line.text:gsub("([lL])ampada","%1âmpada") -- lampada -> lâmpada
			line.text = line.text:gsub("([sS])em exitar","%1em hesitar") -- sem exitar -> sem hesitar
			line.text = line.text:gsub("([eE])spontaniedade","%1spontaneidade") -- espontaniedade -> espontaneidade
			line.text = line.text:gsub("([eE])strépido","%1strépito") -- estrépido -> estrépito
			line.text = line.text:gsub("([aA])ster[íi]stico","%1sterisco") -- asterístico -> asterisco
			line.text = line.text:gsub("([iI]?)[eE]?mbu[ií]d([oa])","%1mbuíd%2") -- embuído -> imbuído
			line.text = line.text:gsub("([tT])u ([a-zA-Z]*)stes","%1u %2ste") --ex: tu cantastes -> tu cantaste
			line.text = line.text:gsub("([vV])ós ([a-zA-Z]*)ste ","%1u %2stes ") --ex: vós cantaste -> vós cantastes
			line.text = line.text:gsub("([bB])e[mn]vind([ao])(s?)", "%1em-vind%2%3") --ex: benvindo -> bem-vindo
			line.text = line.text:gsub("([bB])oasvindas", "%1oas-vindas") --ex: boasvindas -> boas-vindas
			line.text = line.text:gsub("([aA])je([ .,?!])", "%1ge%2") --ex: aje -> age
			line.text = line.text:gsub("([bB])el[eé]m([%s])", "%1elém%2") --ex: belem -> belém
			line.text = line.text:gsub("([bB])uss?ula([%s])", "%1ússola") --ex: bussula -> bússula
			line.text = line.text:gsub("([bB])[uúo]ss[uú]lar([%s])", "%1ussolar") --ex: busular -> busolar
			line.text = line.text:gsub("([cC])abo-verdeano([%s])", "%1abo-verdiano") --ex: cabo-verdeano -> cabo-verdiano
			line.text = line.text:gsub("([cC])aimbra(s?)([%s])", "%1ãibra%2") --ex: caimbra -> cãibra
			line.text = line.text:gsub("([sS])[oó]cio([ho])([a-zA-Z]*)", "%1ocio-%2%3") --ex: sociohistórico -> socio-histórico
			line.text = line.text:gsub("([sS])[oó]cio%-([a-gA-Gi-nI-Np-zP-Z])", "%1ocio%2") --ex: socio-biológico -> sociobiológico
			line.text = line.text:gsub("([iI])nter([hr])([a-zA-Z]*)", "%1nter-%2%3") --ex: interregional -> inter-regional
			line.text = line.text:gsub("([iI])nter%-([a-gA-Gi-qI-Qs-zS-Z])", "%1nter%2") --ex: inter-cidades -> intercidades
			line.text = line.text:gsub("([rR])ecém ([a-zA-Z]*)", "%1ecém-%2") --ex: recém casado -> recém-casado
			line.text = line.text:gsub("([aA])lém mar", "%1lém-mar")
			line.text = line.text:gsub("([aA])lém túmulo", "%1lém-túmulo")
			line.text = line.text:gsub("([aA])lém fronteiras", "%1lém-fronteiras")
			line.text = line.text:gsub("([aA])lém mundo", "%1lém-mundo")
			line.text = line.text:gsub("([aA])lém ", "%1lém-Pirenéus")
			line.text = line.text:gsub("([mM])ini%-([a-gA-Gj-zJ-Z])", "%1ini%2") --ex: mini-mercado -> minimercado
			line.text = line.text:gsub("([mM])ini([hi])", "%1ini-%2") --ex: minihotel-> mini-hotel | miniinvasão -> mini-invasão
			line.text = line.text:gsub("([bB])olos%-rei([%s%p])", "%1olos-reis%2") --ex: bolos-rei -> bolos-reis
			line.text = line.text:gsub("([aA])nti%-([aeou])", "%1nti%2") --ex: anti-áereo -> antiáereo | anti-inflamatório fica =
			line.text = line.text:gsub("([aA])ntii", "%1nti-i") --ex: antiinflamatório -> anti-inflamatório
			line.text = line.text:gsub("([aA])det([oa])", "%1dept%2") --ex: adeto -> adepto
			line.text = line.text:gsub("([eE])ncrita)", "%1ncripta") --ex: encrita -> encripta
			line.text = line.text:gsub("([rR])esidêncial", "%1esidencial") --ex: residêncial -> residencial
			line.text = line.text:gsub("([rR])ecorrer à sentença", "%1ecorrer da sentença") --ex: recorrer à sentença -> recorrer da sentença
			line.text = line.text:gsub("([pP])ref([ei])r([eaií])([^%s]*) ([^%s]*) do que", "%1ref%2r%3%4 %5 a") --ex: prefere futebol do que ténis -> prefere futebol a ténis
			line.text = line.text:gsub("([dD])issuad([^%s]*) a", "%1issuad%2 de") --ex: dissuadir a viajar -> dissuadir de viajar
			line.text = line.text:gsub("([pP])ersuad([^%s]*) de", "%1ersuad%2 a") --ex: persuadir de viajar -> persuadir a viajar
			line.text = line.text:gsub("([mM])assaroca de milho", "%1açaroca de milho") --ex: massaroca de milho -> maçaroca de milho
			line.text = line.text:gsub("([mM])assaroca de alfazema", "%1açaroca de alfazema") --ex: massaroca de alfazema -> maçaroca de alfazema
			line.text = line.text:gsub("([dD])escozid([oa])", "%1escosid%2") --ex: descozido -> descosido
			line.text = line.text:gsub("([eE])femer([oa])([%A]*)", "%1fémer%2%3") --ex: efemero -> efémero
			line.text = line.text:gsub("([eE])spiatóri([oa])", "%1xpiatóri%2") --ex: espiatório -> expiatório
			line.text = line.text:gsub("ính", "inh") --ex: graínha -> grainha e chuvínha - chuvinha
			line.text = line.text:gsub("(%s?[fF])ôr", "%1or") --ex: fôr -> for
			line.text = line.text:gsub("([dD])ia (%a* ?)solarengo", "%1ia %2soalheiro") --ex: dia solarengo -> dia soalheiro
			line.text = line.text:gsub("([rR])eptéis", "%1épteis") --ex: reptéis -> répteis
			line.text = line.text:gsub("([aA])mbos queixam-se", "%1mbos se queixam") --ex: ambos queixam-se -> ambos se queixam
			line.text = line.text:gsub("([bB])anho de emersão", "%1anho de imersão") --ex: banho de emersão -> banho de imersão
			line.text = line.text:gsub("([bB])iquini", "%1iquíni") --ex: biquini -> biquíni
			line.text = line.text:gsub("([qQ]ue nós )massagemos", "%1massajemos") --ex: que nós massagemos -> que nós massajemos
			line.text = line.text:gsub("([qQ]ue el[ea]s )massagem", "%1massajem") --ex: que eles massagem -> que eles massajem
			line.text = line.text:gsub("([qQ]ue )(%a* ou ?)(el[ea]s )massagem", "%1%2%3massajem") --ex: que algo ou eles massagem -> que algo ou eles massajem
			line.text = line.text:gsub("([qQ]ue vocês )massagem", "%1massajem") --ex: que vocês massagem -> que vocês massajem
			line.text = line.text:gsub("([eE])nvangelho", "%1vangelho") --ex: envagelho -> evangelho
			line.text = line.text:gsub("([cC])atadupla", "%1atadupa") --ex: catadupla -> catadupa
			line.text = line.text:gsub("([hH])omicída", "%1omicida") --ex: homicída -> homicida
			line.text = line.text:gsub("([eE])stejemos", "%1stejamos") --ex: estejemos -> estejamos
			line.text = line.text:gsub("([pP])ref([aie])([zçr])([^%s]*)", "%1erf%2%3%4") --ex: prefazer -> perfazer
			line.text = line.text:gsub("([cC])om alteres", "%1om halteres") --ex: com alteres -> com halteres
			line.text = line.text:gsub("(%w+ e %w+ )fazem( %w+)", "%1faz%2") --ex: nadar e correr fazem -> nadar e correm faz
			line.text = line.text:gsub("([gG])rãos-de-bicos", "%1rãos-de-bico") --ex: grãos-de-bicos -> grãos-de-bico
			line.text = line.text:gsub("([dD])egost([aáeo])", "%1egust%2") --ex: degostáreis -> degustáreis
			line.text = line.text:gsub("([cC])ontensios([ao])", "%1ontencios%2") --ex: contensioso -> contencioso
			line.text = line.text:gsub("([sS])ugidade", "%1ujidade") --ex: sugidade -> sujidade
			line.text = line.text:gsub("([pP])remi([^%s]*)", "%1ermi%2") --ex: premitir -> permitir e premissivo -> permissivo
			line.text = line.text:gsub("espólio do museu", "acervo do museu") --ex: espólio -> acervo
			line.text = line.text:gsub("([%s%p])ansia([%s%p])", "%1ânsia%2") --ex: ansia -> ânsia
			line.text = line.text:gsub("([%s%p])Ansia([%s%p])", "%1Ânsia%2") --ex: Ansia -> Ânsia
			line.text = line.text:gsub("([aA])midali", "%1migdali") --ex: amidalite -> amigdalite
			line.text = line.text:gsub("([mM])elância", "%1elancia") --ex: melância -> melancia
			line.text = line.text:gsub("([cC])asa para alugar", "%1asa para arrendar") --ex: alugar -> arrendar
			line.text = line.text:gsub("([aA])lugar uma casa", "%1rrendar uma casa") --ex: alugar -> arrendar
			line.text = line.text:gsub("([aA])lugar casa", "%1rrendar casa") --ex: alugar -> arrendar
			line.text = line.text:gsub("([cC])arro para arrendar", "%1arro para alugar") --ex: arrendar -> alugar
			line.text = line.text:gsub("([aA])rrendar um carro", "%1lugar um carro") --ex: arrendar -> alugar
			line.text = line.text:gsub("([aA])rrendar carro", "%1lugar carro") --ex: arrendar -> alugar
			line.text = line.text:gsub("([tT])ransmitido em ind[ei]f[ei]r[ei]do", "%1ransmitido em diferido") --ex: em indeferido -> em diferido
			line.text = line.text:gsub("([eE])stradita", "%1xtradita") --ex: estraditado -> extraditado
			line.text = line.text:gsub("([bB])eiçinho", "%1eicinho") --ex: beiçinho -> beicinho
			line.text = line.text:gsub("([cC])achemira", "%1axemira") --ex: cachemira -> caxemira
			line.text = line.text:gsub("([gG])orgeta", "%1orjeta") --ex: gorgeta -> gorjeta
			line.text = line.text:gsub("([%w%-]+) que (%w+)%-([oa])", "%1 que %3 %2") --ex: contou-nos que amava-o depois de tudo -> contou-nos que o amava depois de tudo | verbo que verbo-[oa]
			line.text = line.text:gsub("([pP])ára([^%s]*)", "%1ara%2") --ex: párar -> parar
			line.text = line.text:gsub("([mM])over acção em face de", "%1over acção contra") --ex: mover acção em face de -> mover acção contra 
			line.text = line.text:gsub("([cC])ontra([aeéhiors])", "%1ontra-%2") --ex: contra-arco, contra-édito, contra-haste, contra-indicar, contra-ordem, contra-regra, contra-selo
			line.text = line.text:gsub("([cC])ardial patriarc", "%1ardeal patriarc") --ex: cardial -> cardeal
			line.text = line.text:gsub("([mM])icro-onda", "%1icroonda") --ex: micro-onda -> microonda / Está correcto no posAO
			line.text = line.text:gsub("([aA])cupuntura", "%1cupunctura") --ex: acupuntura -> acupunctura / Está correcto no posAO
			line.text = line.text:gsub("([^%w])abitua", "%1habitua") -- abituar -> habituar
			line.text = line.text:gsub("([^%w])Abitua", "%1Habitua")
			line.text = line.text:gsub("([^%w])ácerca", "%1acerca") -- ácerca -> acerca
			line.text = line.text:gsub("([^%w])Ácerca", "%1Acerca")
			line.text = line.text:gsub("(%w*)ccao(%W*)", "%1cção%2") -- accao -> acção | redaccao -> redacção
			line.text = line.text:gsub("(%w*)ccoes(%W*)", "%1cções%2") -- accoes -> acções | redaccoes -> redacções
			line.text = line.text:gsub("([aA])dmnis(%w*)", "%1dminis%2") -- admnistração -> administração
			line.text = line.text:gsub("([cC])ançaco(s?)", "%1ansaço%2") -- cançacos -> cansaços
			line.text = line.text:gsub("([cC])ançad([oa])(s?)", "%1ansad%2%3") -- cançados -> cansados
			line.text = line.text:gsub("[cs]iclan([oa])(s?)", "sicran%2%3") -- cançados -> cansados
			line.text = line.text:gsub("[CS]ic[lr]an([oa])(s?)", "Sicran%2%3") -- ciclano -> sicranos | cicrano -> sicrano | siclano -> sicrano
			line.text = line.text:gsub("([cC])idad[õã]es", "%1idadãos") -- cidadões / cidadães -> cidadãos
			line.text = line.text:gsub("([eE])scriv[õã][oe]s", "%1scrivães") -- escrivões / escrivãos -> escrivães
			line.text = line.text:gsub("([tT])abeli[õã][oe]s", "%1abeliães") -- tabeliões / tabeliãos -> tabeliães
			line.text = line.text:gsub("([cC])oalizão", "%1olisão") -- coalizão -> colisão
			line.text = line.text:gsub("([cC])oalizões", "%1olisões") -- coalizões -> colisões
			line.text = line.text:gsub("([cC])orç[aá]rio(s?)", "%1orsário%2") -- corçario / corçário -> corsário
			line.text = line.text:gsub("([cC])or?[nm]primido[sz]in[bh]o(s?)", "%1omprimidozinho%2") -- cornprimidosinbo -> comprimidozinho
			line.text = line.text:gsub("([bB])éb[ée](s?)", "%1ebé%2") -- bébé / bébe -> bebé
			line.text = line.text:gsub("dE(%W?)", "de%1") -- dE -> de
			line.text = line.text:gsub("([dD])[eé]f[ií]c[ií]te(s?)", "%1éfice%2") -- deficite -> défice
			line.text = line.text:gsub("([dD])[eií]sp[êeé]nd[ieí]o(s?)", "%1ispêndio%2") -- dispêndeo / despêndio / dispendio -> dispêndio
			line.text = line.text:gsub("([eéêEÉÊ])cr[ãa]n?(s?)", "%1crã%2") -- écrã / ecran / écran -> ecrã
			line.text = line.text:gsub("[eéê]lice(s?)", "hélice%2") -- elice / élice -> hélice
			line.text = line.text:gsub("[EÉÊ]lice(s?)", "Hélice%2") -- Elice / Élice -> Hélice
			line.text = line.text:gsub("([eE])ntreti%-(%w+)(s?)", "%1ntretive-%2%3") -- entreti-me -> entretive-me
			line.text = line.text:gsub("intertid([oa])(s?)", "entretido%1%2") -- intertido -> entretido
			line.text = line.text:gsub("Intertid([oa])(s?)", "Entretido%1%2") -- Intertido -> Entretido
			line.text = line.text:gsub("([jJ])ustanz?ente", "%1ustamente") -- justanzente - justamente
			line.text = line.text:gsub("([mM])[ãáâa]gua(s?)", "%1ágoa%2") -- mãgua -> mágoa
			line.text = line.text:gsub("([mM])anteem%-(%w+)", "%1antêm-%2") -- manteem-se, mantêm-se
			line.text = line.text:gsub("([mM])ass?i[çs]s?o(s?)", "%1aciço%2") -- massisso / massiço / masisso / masiço -> maciço
			line.text = line.text:gsub("([mM])[ií]s[oó]g[eií]no(s?)", "%1isógino%2") -- misogeno / misógeno -> misógino
			line.text = line.text:gsub("([mM])orteIa(s?)", "%1ortela%2") -- morteIa -> mortela
			line.text = line.text:gsub("([nN])ivea(s?)(%W)", "%1ívea%2%3") -- Nivea -> Nívea
			line.text = line.text:gsub("([pP])[êé]ga(s?)(%W)", "%1ega%2%3") -- pêga -> pega
			line.text = line.text:gsub("pirinéu(s?)", "Pirenéu%1") -- pirinéus -> Pirenéus
			line.text = line.text:gsub("([pP])ob[lr]ema(s?)", "%1roblema%2%3") -- pobrema / poblema -> problema
			line.text = line.text:gsub("([pP])ra[zs]ei?ro[sz]([oa])(s?)", "%1razeros%2%3") -- prazeiroso -> prazeroso
			line.text = line.text:gsub("([pP])e?ri[oúu]do(s?)(%W)", "%1eríodo%2%3") -- priúdo / periodo -> período
			line.text = line.text:gsub("([oO])btem", "%1btém") -- obtem -> obtém
			line.text = line.text:gsub("([tT])[ãáâa][nm][vb][eé][nm](%W)", "%1ambém%2") -- tambem / também / tanbem / também / tanbém -> também
			line.text = line.text:gsub("([fF])orão(%W)", "%1oram%2") -- forão -> foram
			line.text = line.text:gsub("([fF])r([ae])squtnho(s?)", "%1r%2squinho%3") -- frasqutnho -> frasquinho e fresqutnho -> fresquinho
			line.text = line.text:gsub("([fF])ra(s?)qutnh([oa])(s?)", "%1ra%2quinh%3%4") -- frasqutnha -> frasquinha e fraqutnho -> fraquinho
			line.text = line.text:gsub("([gG])áz(%W)", "%1ás%2") -- gáz -> gás
			line.text = line.text:gsub("([gG])licémia(s?)", "%1licemia%2") -- glicémia -> glicemia
			line.text = line.text:gsub("igi[eé]nic([oa])(s?)", "higiénic%1%2") -- igienico / igiénico -> higiénico
			line.text = line.text:gsub("Igi[eé]nic([oa])(s?)", "Higiénic%1%2") -- Igienico / igiénico -> Higiénico
			line.text = line.text:gsub("([pP])r[óo]pi([oa])(s?)", "%1rópri%2%3") -- propio / própio -> próprio
			line.text = line.text:gsub("([qQ])uadricomia(s?)", "%1uadricromia%2") -- quadricomia -> quadricromia
			line.text = line.text:gsub("([rR])atat([oa])(s?)", "%1etrat%2%3") -- ratato -> retrato
			line.text = line.text:gsub("([xX])adrês", "%1adrez") -- xadrês -> xadrez
			line.text = line.text:gsub("x[ie]lindró(s?)", "chilindró%1") -- xilindró / xelindró / xelindró -> chilindró
			line.text = line.text:gsub("X[ie]lindró(s?)", "Chilindró%1") -- xilindró / xelindró / xelindró -> chilindró
			line.text = line.text:gsub("([sS])uI", "%1ul") -- suI -> sul
			line.text = line.text:gsub("(FARM[AÁ]C)l(AS?)", "%1I%2") -- FARMÁClA -> FARMÁCIA
			line.text = line.text:gsub("([fF]arm[áa]c)l(as?)", "%1i%2") -- farmácla -> farmácia
			line.text = line.text:gsub("([sS])u[ií]s?[sç]([ao])(s?)", "%1uíç%2%3") -- suiças, suiço, suiços, suissas, suíssas, suisso, suísso, suíssos, Suíssa...etc -> Suíça
			line.text = line.text:gsub("(%W)([tT])ava(%W)", "%1'%2ava%3") -- tava -> 'tava
			--line.text = line.text:gsub("(%W)tava(%W)", "%1estava%2") -- tava -> estava
			--line.text = line.text:gsub("(%W)Tava(%W)", "%1Estava%2") -- Tava -> Estava
			line.text = line.text:gsub("(%W)([tT])ou(%W)", "%1'%2ou%3") -- tou -> 'tou
			--line.text = line.text:gsub("(%W)tou(%W)", "%1estava%2") -- tou -> estou
			--line.text = line.text:gsub("(%W)Tou(%W)", "%1Estava%2") -- tou -> Estou
			--concerteza para com certeza - FUNCIONA
			line.text = line.text:gsub("concerteza","com certeza")
			line.text = line.text:gsub("Concerteza","Com certeza")
			--Porfavor para Por favor - FUNCIONA
			line.text = line.text:gsub("porfavor","por favor")
			line.text = line.text:gsub("Porfavor","Por favor")
			--trás para traz - FUNCIONA
			line.text = line.text:gsub("([tT])rás lá","%1raz lá")
			line.text = line.text:gsub("([eE])l([ea]) trás([ .,?!])","%1l%2 traz%3")
			line.text = line.text:gsub("([eE])l([ea]) ([oa]) trás([ .,?!])","%1l%2 %3 traz%4")
			line.text = line.text:gsub("([Tt])rás-([mnl])","%1rás-%2")
			line.text = line.text:gsub("([nN])ão trás([ .,?!])","%1ão traz%2")
			line.text = line.text:gsub("([nN])unca trás([ .,?!])","%1unca traz%2")
			--traz para trás - FUNCIONA
			line.text = line.text:gsub("([pP])or traz([ .,?!])","%1or trás%2")
			line.text = line.text:gsub("([pP])ara traz([ .,?!])","%1ara trás%2")
			line.text = line.text:gsub("([dD])e traz([ .,?!])","%1e trás%2")
			line.text = line.text:gsub("([aA])traz([ .,?!])","%1trás%2")
			line.text = line.text:gsub("([dD])e( ?)traz([ .,?!])","%1e%2trás%3")
			--policia para polícia - FUNCIONA
			line.text = line.text:gsub(" ([aAoO]) policia([ .,?!])"," %1 polícia%2")
			line.text = line.text:gsub("([uU])m policia([ .,?!])","%1m polícia%2")
			line.text = line.text:gsub("([uU])ma policia([ .,?!])","%1ma polícia%2")
			line.text = line.text:gsub("([dD])e policia([ .,?!])","%1e polícia%2")
			line.text = line.text:gsub("([qQ])uem polícia","%1uem policia")
			line.text = line.text:gsub("([eE])l([ea]) polícia","%1l%2 policia")
			--a muito tempo por há muito tempo - FUNCIONA
			--line.text = line.text:gsub("([aA])(muito%|bastante%|algum%|pouco%|um) tempo","%1há %2 tempo")
			--line.text = line.text:gsub("^(.*)À|A( [muito|bastante|algum|pouco|u[m|ns])( temp[o|os].*)$","%1Há%2%3")
			line.text = line.text:gsub("( )a muito tempo","%1há muito tempo")
			line.text = line.text:gsub("( )a bastante tempo","%1há bastante tempo")
			line.text = line.text:gsub("( )a algum tempo","%1há algum tempo")
			line.text = line.text:gsub("( )a pouco tempo","%1há pouco tempo")
			line.text = line.text:gsub("( )a um tempo","%1há um tempo")
			line.text = line.text:gsub("( )a uns tempos","%1há uns tempos")
			line.text = line.text:gsub("^(.*)A muito tempo","%1Há muito tempo")
			line.text = line.text:gsub("^(.*)A bastante tempo","%1Há bastante tempo")
			line.text = line.text:gsub("^(.*)A algum tempo","%1Há algum tempo")
			line.text = line.text:gsub("^(.*)A pouco tempo","%1Há pouco tempo")
			line.text = line.text:gsub("^(.*)A um tempo","%1Há um tempo")
			line.text = line.text:gsub("^(.*)A uns tempos","%1Há uns tempos")
			line.text = line.text:gsub("( )à muito tempo","%1há muito tempo")
			line.text = line.text:gsub("( )à bastante tempo","%1há bastante tempo")
			line.text = line.text:gsub("( )à algum tempo","%1há algum tempo")
			line.text = line.text:gsub("( )à pouco tempo","%1há pouco tempo")
			line.text = line.text:gsub("( )à um tempo","%1há um tempo")
			line.text = line.text:gsub("( )à uns tempos","%1há uns tempos")
			line.text = line.text:gsub("^(.*)À muito tempo","%1Há muito tempo")
			line.text = line.text:gsub("^(.*)À bastante tempo","%1Há bastante tempo")
			line.text = line.text:gsub("^(.*)À algum tempo","%1Há algum tempo")
			line.text = line.text:gsub("^(.*)À pouco tempo","%1Há pouco tempo")
			line.text = line.text:gsub("^(.*)À um tempo","%1Há um tempo")
			line.text = line.text:gsub("^(.*)À uns tempos","%1Há uns tempos")
			--dias
			line.text = line.text:gsub("( )a um dia","%1há um dia")
			line.text = line.text:gsub("( )a uns dias","%1há uns dias")
			line.text = line.text:gsub("( )a poucos dias","%1há poucos dias")
			line.text = line.text:gsub("( )a alguns dias","%1há alguns dias")
			line.text = line.text:gsub("( )a bastantes dias","%1há bastantes dias")
			line.text = line.text:gsub("( )a muitos dias","%1há muitos dias")
			line.text = line.text:gsub("^(.*)A um dia","%1Há um dia")
			line.text = line.text:gsub("^(.*)A uns dias","%1Há uns dias")
			line.text = line.text:gsub("^(.*)A poucos dias","%1Há poucos dias")
			line.text = line.text:gsub("^(.*)A alguns dias","%1Há alguns dias")
			line.text = line.text:gsub("^(.*)A bastantes dias","%1Há bastantes dias")
			line.text = line.text:gsub("^(.*)A muitos dias","%1Há muitos dias")
			line.text = line.text:gsub("( )à um dia","%1há um dia")
			line.text = line.text:gsub("( )à uns dias","%1há uns dias")
			line.text = line.text:gsub("( )à poucos dias","%1há poucos dias")
			line.text = line.text:gsub("( )à alguns dias","%1há alguns dias")
			line.text = line.text:gsub("( )à bastantes dias","%1há bastantes dias")
			line.text = line.text:gsub("( )à muitos dias","%1há muitos dias")
			line.text = line.text:gsub("^(.*)À um dia","%1Há um dia")
			line.text = line.text:gsub("^(.*)À uns dias","%1Há uns dias")
			line.text = line.text:gsub("^(.*)À poucos dias","%1Há poucos dias")
			line.text = line.text:gsub("^(.*)À alguns dias","%1Há alguns dias")
			line.text = line.text:gsub("^(.*)À bastantes dias","%1Há bastantes dias")
			line.text = line.text:gsub("^(.*)À muitos dias","%1Há muitos dias")
			--horas
			line.text = line.text:gsub("( )a uma hora","%1há uma hora")
			line.text = line.text:gsub("( )a umas horas","%1há umas horas")
			line.text = line.text:gsub("( )a poucas horas","%1há poucas horas")
			line.text = line.text:gsub("( )a algumas horas","%1há algumas horas")
			line.text = line.text:gsub("( )a bastantes horas","%1há bastantes horas")
			line.text = line.text:gsub("( )a muitas horas","%1há muitas horas")
			line.text = line.text:gsub("^(.*)A uma hora","%1Há uma hora")
			line.text = line.text:gsub("^(.*)A umas horas","%1Há umas horas")
			line.text = line.text:gsub("^(.*)A poucas horas","%1Há poucas horas")
			line.text = line.text:gsub("^(.*)A algumas horas","%1Há algumas horas")
			line.text = line.text:gsub("^(.*)A bastantes horas","%1Há bastantes horas")
			line.text = line.text:gsub("^(.*)A muitas horas","%1Há muitas horas")
			line.text = line.text:gsub("( )à uma hora","%1há uma hora")
			line.text = line.text:gsub("( )à umas horas","%1há umas horas")
			line.text = line.text:gsub("( )à poucas horas","%1há poucas horas")
			line.text = line.text:gsub("( )à algumas horas","%1há algumas horas")
			line.text = line.text:gsub("( )à bastantes horas","%1há bastantes horas")
			line.text = line.text:gsub("( )à muitas horas","%1há muitas horas")
			line.text = line.text:gsub("^(.*)À uma hora","%1Há uma hora")
			line.text = line.text:gsub("^(.*)À umas horas","%1Há umas horas")
			line.text = line.text:gsub("^(.*)À poucas horas","%1Há poucas horas")
			line.text = line.text:gsub("^(.*)À algumas horas","%1Há algumas horas")
			line.text = line.text:gsub("^(.*)À bastantes horas","%1Há bastantes horas")
			line.text = line.text:gsub("^(.*)À muitas horas","%1Há muitas horas")
			--minutos
			line.text = line.text:gsub("( )a um minuto","%1há um minuto")
			line.text = line.text:gsub("( )a uns minutos","%1há uns minutos")
			line.text = line.text:gsub("( )a poucos minutos","%1há poucos minutos")
			line.text = line.text:gsub("( )a alguns minutos","%1há alguns minutos")
			line.text = line.text:gsub("( )a bastantes minutos","%1há bastantes minutos")
			line.text = line.text:gsub("( )a muitos minutos","%1há muitos minutos")
			line.text = line.text:gsub("^(.*)A um minuto","%1Há um minuto")
			line.text = line.text:gsub("^(.*)A uns minutos","%1Há uns minutos")
			line.text = line.text:gsub("^(.*)A poucos minutos","%1Há poucos minutos")
			line.text = line.text:gsub("^(.*)A alguns minutos","%1Há alguns minutos")
			line.text = line.text:gsub("^(.*)A bastantes minutos","%1Há bastantes minutos")
			line.text = line.text:gsub("^(.*)A muitos minutos","%1Há muitos minutos")
			line.text = line.text:gsub("( )à um minuto","%1há um minuto")
			line.text = line.text:gsub("( )à uns minutos","%1há uns minutos")
			line.text = line.text:gsub("( )à poucos minutos","%1há poucos minutos")
			line.text = line.text:gsub("( )à alguns minutos","%1há alguns minutos")
			line.text = line.text:gsub("( )à bastantes minutos","%1há bastantes minutos")
			line.text = line.text:gsub("( )à muitos minutos","%1há muitos minutos")
			line.text = line.text:gsub("^(.*)À um minuto","%1Há um minuto")
			line.text = line.text:gsub("^(.*)À uns minutos","%1Há uns minutos")
			line.text = line.text:gsub("^(.*)À poucos minutos","%1Há poucos minutos")
			line.text = line.text:gsub("^(.*)À alguns minutos","%1Há alguns minutos")
			line.text = line.text:gsub("^(.*)À bastantes minutos","%1Há bastantes minutos")
			line.text = line.text:gsub("^(.*)À muitos minutos","%1Há muitos minutos")
			--segundos
			line.text = line.text:gsub("( )a um segundo","%1há um segundo")
			line.text = line.text:gsub("( )a uns segundos","%1há uns segundos")
			line.text = line.text:gsub("( )a poucos segundos","%1há poucos segundos")
			line.text = line.text:gsub("( )a alguns segundos","%1há alguns segundos")
			line.text = line.text:gsub("( )a bastantes segundos","%1há bastantes segundos")
			line.text = line.text:gsub("( )a muitos segundos","%1há muitos segundos")
			line.text = line.text:gsub("^(.*)A um segundo","%1Há um segundo")
			line.text = line.text:gsub("^(.*)A uns segundos","%1Há uns segundos")
			line.text = line.text:gsub("^(.*)A poucos segundos","%1Há poucos segundos")
			line.text = line.text:gsub("^(.*)A alguns segundos","%1Há alguns segundos")
			line.text = line.text:gsub("^(.*)A bastantes segundos","%1Há bastantes segundos")
			line.text = line.text:gsub("^(.*)A muitos segundos","%1Há muitos segundos")
			line.text = line.text:gsub("( )à um segundo","%1há um segundo")
			line.text = line.text:gsub("( )à uns segundos","%1há uns segundos")
			line.text = line.text:gsub("( )à poucos segundos","%1há poucos segundos")
			line.text = line.text:gsub("( )à alguns segundos","%1há alguns segundos")
			line.text = line.text:gsub("( )à bastantes segundos","%1há bastantes segundos")
			line.text = line.text:gsub("( )à muitos segundos","%1há muitos segundos")
			line.text = line.text:gsub("^(.*)À um segundo","%1Há um segundo")
			line.text = line.text:gsub("^(.*)À uns segundos","%1Há uns segundos")
			line.text = line.text:gsub("^(.*)À poucos segundos","%1Há poucos segundos")
			line.text = line.text:gsub("^(.*)À alguns segundos","%1Há alguns segundos")
			line.text = line.text:gsub("^(.*)À bastantes segundos","%1Há bastantes segundos")
			line.text = line.text:gsub("^(.*)À muitos segundos","%1Há muitos segundos")
			--Onomatopeias - FUNCIONA
			line.text = line.text:gsub("[H][Ee]+[Yy]+([ .,?!])","Ei%1")
			line.text = line.text:gsub("([ ])h[e]+[y]+([ .,?!])","%1ei%2")
			line.text = line.text:gsub("[H]+[Uu]+[Hh]+([ .,?!])","Hum%1")
			line.text = line.text:gsub("[h]+[u]+[h]+([ .,?!])","hum%1")
			line.text = line.text:gsub("[W]+[Oo]+[Ww]+([ .,?!])","Uau%1")
			line.text = line.text:gsub("[w]+[o]+[w]+([ .,?!])","uau%1")
			line.text = line.text:gsub("[H]+[Mm]+([ .,?!])","Hmm%1")
			line.text = line.text:gsub("[h]+[m]+([ .,?!])","hmm%1")
			line.text = line.text:gsub("[O]+[Ww]+([ .,?!])","Au%1")
			line.text = line.text:gsub("([ ])[o]+[w]+([ .,?!])","%1au%2")
			line.text = line.text:gsub("[W]+[Aa]+[Hh]+","Buá")
			line.text = line.text:gsub("[w]+[a]+[h]+","buá")
			--Colocar estilo musica em todas linhas com ? e caso exista \N alinha a 2º linha correctamente.
			local b = string.find(line.text,"♪")
			local bb = string.find(line.text,"♫")
			local c = string.find(line.text,"\\N")
			local d = string.find(line.text,"\\i1")
			local z = string.find(line.text,"\\alpha")
			if b or bb then --se tiver simbolo musical faz
				if c and not z then -- se tiver 2 linhas e ainda n tiver sido aplicado entao
					if d then -- aplica com italico
						line.text = line.text:gsub("^({.-}*)♪ ({.-})(.-)\\N(.-)","%1♪ %2%3\\N{\\alpha&HFF&}♪ {\\r}%1%2%4")
					else -- senao aplica sem italico
						line.text = line.text:gsub("^({.-}*)♪ (.-)\\N(.-)","%1♪ %2%3\\N{\\alpha&HFF&}♪ {\\r}%1%3")
					end
				end
				line.style = "Música"
			end
			-- * por ♪ - FUNCIONA
			line.text = line.text:gsub("([^*]?)*([^*]?)","%1♪%2")
		end
		subs[i] = line
	end

--[[
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
					linha = line.text:gsub("^(.*)$","%1")
					confirmar = linha == depois.text.."\\N"..antes.text	--comparar se a linha actual (line.text) contém ambas as linhas.
					--aegisub.debug.out(2, "Debug: '%s' \n", confirmar)
					--{\be1\blur1}? {\i1}O amor distante vou buscar{\i} ?
					music_antes = antes.text:gsub("^({.-}+)? ({.-})(.-)({.-}) ?$","%3")
					music_depois = depois.text:gsub("^({.-}+)? ({.-})(.-)({.-}) ?$","%3")
					--{\be1\blur1}? {\i1}Está numa estrela para nos guiar\N{\alpha&HFF&}? {\r\i1\be1\blur1}O amor distante vou buscar{\i} ?
					music_actual = line.text:gsub("^({.-}+)? ({.-})(.-)\\N({.-})? ({.-}+)(.-)({.-}) ?$","%3\\N%6")
					musicas = music_actual == music_depois.."\\N"..music_antes --comparar se a linha actual (line.text) contém ambas as linhas.				
					if confirmar or musicas then --se realmente contiver então
						depois.start_time = antes.end_time -- torna os tempos continuos
						subs[i+1] = depois --insere o tempo alterado na legenda
						subs.delete(del) --apaga a linha que mete nojo
					end
				end 
			end
			
		end
	end
]]--
end

aegisub.register_macro(script_name, script_description, corrigir)
aegisub.register_filter(script_name, script_description, 0, corrigir)
