--[[Estilo cookbook--]]
--[[Autor: Pedro N. Alvarez--]]
--[[Legenda: AE: Assertiva de entrada, AS: Assertiva de saida--]]

--[[Parte 1: Declaracao das variaveis globais--]]

data , word_freqs= nil
words,stop_words,filter={}
--[[Parte 2: Declaracao das funcoes auxiliares--]]

--read_file: Funcao que recebe um "path" de um arquivo texto e o armazena como string na variavel global data
--AE: path_to_file é uma string valida de um path
--AS: o conteudo do arquivo do path foi salvo na variavel data
function read_file(path_to_file)
	local f = io.open(path_to_file, "r")
	assert(f ~= nil, "Path nao vale")
	data = f:read("*all")
	f:close()
end

--filter_chars_and_normalize: Funcao que substitui todos os simbolos nao alfanumericos por espaco na string data
--e m
--AE: data é uma string nao nula
--AS: data possui espaco nas posicoes originalmente ocupadas por simbolos alfa-numericos e letras maiusculas por minusculas
function filter_chars_and_normalize()
	assert(data ~= nil, "String nula")
    data = data:gsub('%W',' '):lower()
end

--scan: Funcao que preenche a tabela words com palavras encontradas na string do arquivo
--AE: data é uma string nao nula
--AS: words foi preenchido com as palavras capturadas
function scan()
	assert(data ~= nil, "String nula")
	local i = data:gmatch("%S+")

	for elem in i do
	   table.insert(words, elem)
	end
end

--remove_stop_words: Funcao que retira as palavras ignoradas da tabela words
--AE: words nao e nulo e o path para o arquivo stop_words.txt vale
--AS: As palavras ignoradas foram removidas da tabela words
function remove_stop_words()
	assert(words ~= nil, "Tabela words nula")
	local f = io.open("stop_words.txt", "r")
	local i = f:read("*all"):gmatch("([^,]+)")
    stop_words={}

	for elem in i do table.insert(stop_words, elem) end
	for ascii = 97, 122 do table.insert(stop_words, string.char(ascii)) end

	for index = #words, 1, -1 do
		for k, stop_word in ipairs(stop_words) do
			local word = words[index]

			if(word == stop_word) then
				table.remove(words, index)
			end
		end
	end
end

--frequencies:Funcao que associa numa tabela cada palavra com sua devida frequencia
--AE:words e uma tabela valida
--AS:word_freqs e uma tabela que associa cada palavra a sua frequencia
function frequencies()
	assert(words ~= nil, "words nulo")
    word_freqs = {}

    for k, word in ipairs(words) do
        if word_freqs[word] ~= nil then
            word_freqs[word].frequency = word_freqs[word].frequency + 1
        else
            word_freqs[word] = {word = word, frequency = 1}
		end
	end
end

--sort:Funcao que ordena a tabela de palavras por ondem de frequencia
--AE:word_freqs nao e nula
--AS:word_freqs esta ordenado segundo a frequencia
function sort()
	assert(word_freqs ~= nil, "tabela nula")
    frequencies = {}

	for key,elem in pairs(word_freqs) do table.insert(frequencies, elem) end

	table.sort(frequencies, function(a, b) return a.frequency > b.frequency end)

	word_freqs = frequencies
end

function print_prefered_words()
	for i =0,25 do table.insert(filter,word_freqs[i]) end
	for k,v in pairs(word_freqs) do io.write(v.word.."-"..v.frequency) end
end

--[[Parte 3: Programa principal--]]

read_file(arg[1])
filter_chars_and_normalize()
scan()
remove_stop_words()
frequencies()
sort()
print_prefered_words

