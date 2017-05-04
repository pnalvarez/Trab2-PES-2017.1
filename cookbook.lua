--[[Estilo cookbook--]]
--[[Autor: Pedro N. Alvarez--]]
--[[Legenda: AE: Assertiva de entrada, AS: Assertiva de saida--]]

--[[Parte 1: Declaracao das variaveis globais--]]

data,word_freqs=nil
words,stop_words,filter={}
--[[Parte 2: Declaracao das funcoes auxiliares--]]

--read_file: Funcao que recebe um "path" de um arquivo texto e o armazena como string na variavel global data
--AE: path_to_file é uma string valida de um path
--AS: o conteudo do arquivo do path foi salvo na variavel data
function read_file(path_to_file)
	f = io.open(path_to_file,"r")
	data = f:read("*all")
	f = io.close()
end

--filter_chars_and_normalize: Funcao que substitui todos os simbolos nao alfanumericos por espaco na string data
--e m
--AE: data é uma string nao nula
--AS: data possui espaco nas posicoes originalmente ocupadas por simbolos alfa-numericos e letras maiusculas por minusculas
function filter_chars_and_normalize()
	data = data:gsub('%W',''):lower()
end

--scan: Funcao que preenche a tabela words com palavras encontradas na string do arquivo
--AE: data é uma string nao nula
--AS: words foi preenchido com as palavras capturadas
function scan()
	new_table = data:gmatch("%S+")
	for i in new_table do table.insert(words,i) end
end

--remove_stop_words: Funcao que retira as palavras ignoradas da tabela words
--AE: words nao e nulo e o path para o arquivo stop_words.txt vale
--AS: As palavras ignoradas foram removidas da tabela words
function remove_stop_words()
	f = io.open("../stop_words.txt","r")
	table = f:read("*all"):gmatch("([^,]+)")

   for i in table do table.insert(stop_words,i) end
   for asc_ii = 97,122 do table.insert(stop_words,string.char(asc_ii)) end
   for j = #words,1,-1 do
   	for k,stopwords in pairs(stop_words) do 
   		if(words[i]==stopword) then table.remove(words,i) end
   	end
   end
end

--frequencies:Funcao que associa numa tabela cada palavra com sua devida frequencia
--AE:words e uma tabela valida
--AS:word_freqs e uma tabela que associa cada palavra a sua frequencia
function frequencies()

	for k,w in pairs(words) do 
		if word_freqs[word] ~= nil then word_freqs[word][frequency] = word+freqs[word][frequency]+1 
		else word_freqs[word] = {word = word, frequency = 1}
    end
end
end

--sort:Funcao que ordena a tabela de palavras por ondem de frequencia
--AE:word_freqs nao e nula
--AS:word_freqs esta ordenado segundo a frequencia
function sort()
	table.sort(word_freqs,function(a, b) return a.frequency > b.frequency end)
end

--[[Parte 3: Programa principal--]]

read_file(arg[1])
filter_chars_and_normalize()
scan()
remove_stop_words()
frequencies()
sort()

for i =0,25 do table.insert(filter,word_freqs[i]) end
for k,v in pairs(word_freqs) do io.write(v.word.."-"..v.frequency) end






