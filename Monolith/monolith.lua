--[[Estilo cookbook--]]
--[[Autor: Pedro N. Alvarez--]]

--[[Parte 1: Declaracao das variaveis globais--]]

data , word_freq,file= nil
words,stop_words,filter={}
OnList=false

--Parte 2: Leitura do arquivo parametro e manipulacao interna
--AE: O arquivo existe e seu path vale
--AS:O arquivo stop-words.txt foi gerado com as palavras mais frequentes e cada uma mapeada a seu numero de ocorrencias
file= io.open("../pride-and-prejudice.txt", "r")
    data = file:read("*all")
    file:close()
    data = data:gsub('%W',' '):lower()

    i = data:gmatch("%S+")

    for elem in i do
       table.insert(words, elem)
    end

    stop = assert(io.open("stop_words.txt", 'r')):read('*all'):lower():separa(',')
    local copy = {}
    
    for _, word in pairs(words) do
         for _, wordInList in pairs(list) do
        if wordInList == word then
            onList=true
        end
    end

    onList =  false
        if isOnList == false then
            table.insert(copy, word)
        end
    end
    words = copy

    word_freqs = {}

    for i, word in ipairs(words) do
        if word_freqs[word] ~= nil then
            word_freqs[word].frequency = word_freqs[word].frequency + 1
        else
            word_freqs[word] = {word = word, frequency = 1}
        end
    end

    frequencies = {}

    for word,freq in pairs(word_freqs) do table.insert(frequencies, freq) end

    table.sort(frequencies, function(a, b) return a.frequency > b.frequency end)

    word_freqs = frequencies

  --Parte 3: Imprimir a saida do programa(output)

    for i =0,25 do table.insert(filter,word_freqs[i]) end
    for k,v in pairs(word_freqs) do io.write(v.word.."-"..v.frequency) end

-- ver comentarios no pull-request (Roxana)
