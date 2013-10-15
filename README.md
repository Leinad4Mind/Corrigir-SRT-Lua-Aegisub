Corrigir-SRT-Lua-Aegisub
========================

Corrige imensos problemas existentes nas legendas SRT:
- Adiciona espaço onde existe reticências no início da frase.
- Corrige os hífens.
- Corrige as plicas por aspas. (Erro comum em OCR)
- Corrige I por l. (Erro comum em OCR)
- Corrige á por à.
- Corrige a quando é há.
- Corrige concerteza para com certeza.
- Corrige porfavor para por Favor.
- Aplica estilo 'Música' às linhas que contém o símbolo musical e aplica-o com todas as suas regras.
- Corrige problema de linhas sobrepostas existentes nos SRTs.
-	v5: Corrige espaço antes da "," ou ";".
-	v5: Corrige problema de reticências. Caso haja 2 pontos ou mais que 3 pontos.
-	v5: Corrige problema de duplo espaço. Mais que 2 espaços ele ignora. (Visto poder ser typesetting)
-	v5: Corrige diversas onomatopeias, de inglês para português, caso o tradutor tenha deixado alguma em inglês.

Por fazer
-----------------
* Creio que já está tudo feito, mas estarei disposto a melhorar se houver dicas para tal.


Como instalar
--------------

Load Automático

1. Transferir corrigir_srt.lua
2. Colocar esse ficheiro na pasta _autoload_ situada dentro da pasta _automation_ que por sua vez está presenta na sua pasta de instalação do aegisub


Load Manual

1. Transferir corrigir_srt.lua e guarde-o onde bem desejar
2. Com o Aegisub aberto, quando desejar usá-lo terá de clicar em Automatização -> Automatização...
3. Clicar de seguida em _Adicionar_ e ir ao local onde se encontra o corrigir_srt.lua


Como usar
---------

Basta clicar, o processo é totalmente automatico.
