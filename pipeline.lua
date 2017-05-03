--[Retorna o conteúdo do arquivo de entrada como uma string]--
function read_file(path_to_file)
    local f = assert(io.open(path_to_file, 'r'))
    local data = f:read('*all')
    f:close()
    return data
end

--[Recebe uma string e retorna uma cópia com todos os caracteres não alfanuméricos substituídos por um espaço em branco]--
function filter_chars_and_normalize(str_data)
    local symbols = "[^%w/_]+"
    return str_data:gsub(symbols, ' '):lower()
end

--[Separa a string em um array de palavras utilizando um símbolo de referencia]--
function string:separa(sym)
    local symbols = string.format("[^%s/_]+", sym)
    local campos = {}

    self:gsub(symbols, function(c) campos[#campos+1] = c end)
    return campos
end

--[Busca por palavras na string e retorna uma table com as palavras que foram encontradas]--
function scan(str_data)
    return str_data:separa(' ')
end

--[Verifica se uma palavra se encontra na tabela]--
function isOnList(word, list)
    for _, wordInList in pairs(list) do
        if wordInList == word then
            return true
        end
    end

    return false
end

--[Cria uma cópia da tabela sem as stop words]--
function remove_stop_words(word_list)
    local stop = assert(io.open("stop_words.txt", 'r')):read('*all'):lower():separa(',')
    local copy = {}
    
    for _, word in pairs(word_list) do
        if isOnList(word, stop) == false then
            table.insert(copy, word)
        end
    end
    return copy
end

--[Retorna uma tabela associando cada palavra à sua respectiva frequência]--
function frequencies(word_list)
    local word_freqs = {}
    local frequencies_table = {}    

    for _, word in pairs(word_list) do
        if word_freqs[word] then
            word_freqs[word] = word_freqs[word] + 1
        else
            word_freqs[word] = 1
        end
    end

    for word, freq in pairs(word_freqs) do
        local tuple = {word = word, freq = freq}
        table.insert(frequencies_table, tuple)
    end

    return frequencies_table
end

--[Recebe a tabela de palavras com suas frequências e retorna a tabela ordenada em relação à frequência]--
function sort(word_freq)
    table.sort(word_freq, function(a, b) return a.freq > b.freq end)
    return word_freq
end


--[Recebe o dicionário ordenado e o imprime]--
function print_all(word_freqs)
    local i = 1
    
    for _, w in ipairs(word_freqs) do
        if i == 25 then
            break
        end
        print(w.word .. " - " .. w.freq)
        i = i + 1
    end
end

--[Main]--
print_all(sort(frequencies(remove_stop_words(scan(filter_chars_and_normalize(read_file(arg[1])))))))