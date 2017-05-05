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
	data = f:read("*all")
	f:close()
end

--filter_chars_and_normalize: Funcao que substitui todos os simbolos nao alfanumericos por espaco na string data
--e m
--AE: data é uma string nao nula
--AS: data possui espaco nas posicoes originalmente ocupadas por simbolos alfa-numericos e letras maiusculas por minusculas
function filter_chars_and_normalize()
    data = data:gsub('%W',' '):lower()
end

--scan: Funcao que preenche a tabela words com palavras encontradas na string do arquivo
--AE: data é uma string nao nula
--AS: words foi preenchido com as palavras capturadas
function scan()
	local i = data:gmatch("%S+")

	for elem in i do
	   table.insert(words, elem)
	end
end

--Função que verifica se uma palavra se encontra na tabela
--AE:O valor deve ser válido e a tabela não vazia
--AS:Retorna true se a palavra se encontra na tabela e falso se não se encontra
function isOnList(word, list)
    for _, wordInList in pairs(list) do
        if wordInList == word then
            return true
        end
    end

    return false
end

--remove_stop_words: Funcao que retira as palavras ignoradas da tabela words
--AE: words nao e nulo e o path para o arquivo stop_words.txt vale
--AS: As palavras ignoradas foram removidas da tabela words
function remove_stop_words()
    local stop = assert(io.open("stop_words.txt", 'r')):read('*all'):lower():separa(',')
    local copy = {}
    
    for _, word in pairs(words) do
        if isOnList(word, stop) == false then
            table.insert(copy, word)
        end
    end
    words = copy
end

--frequencies:Funcao que associa numa tabela cada palavra com sua devida frequencia
--AE:words e uma tabela valida
--AS:word_freqs e uma tabela que associa cada palavra a sua frequencia
function frequencies()
    word_freqs = {}

    for i, word in ipairs(words) do
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
    frequencies = {}

	for word,freq in pairs(word_freqs) do table.insert(frequencies, freq) end

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
print_prefered_words()
