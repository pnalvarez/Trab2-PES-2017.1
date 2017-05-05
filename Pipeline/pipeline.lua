--Função que le um arquivo, passa para uma string e retorna essa string
--AE:O arquivo deve ser válido e estar presente no mesmo diretório que kick_forward.lua
--AS:O arquivo é lido sem erros e a string é retornada
function read_file(path_to_file)
    local f = assert(io.open(path_to_file, 'r'))
    local data = f:read('*all')
    f:close()
    return data
end

--Função que substitui todos os caracteres não alfa numéricos da string por um espaço em branco
--AE:A string não é vazia
--AS:Retorna uma cópia da string onde os caracteres não alfa numéricos foram retirados sem erros
function filter_chars_and_normalize(str_data)
    local symbols = "[^%w/_]+"
    return str_data:gsub(symbols, ' '):lower()
end

--Função que separa a string em um array de palavras, usando como base um símbolo passado por paramêtro
--AE:O paramêtro deve ser um símbolo válido
--AS:Retorna um array com as palavras da string, cada uma em uma posição de índice
function string:separa(sym)
    local symbols = string.format("[^%s/_]+", sym)
    local campos = {}

    self:gsub(symbols, function(c) campos[#campos+1] = c end)
    return campos
end

--Função que busca palavras em uma string e retorna uma tabela com as palavras que foram encontradas
--AE:A string deve estar sem os caracteres alfanumericos e separada por espaços em branco
--AS:Retorna uma tabela com as palavras que foram encontradas
function scan(str_data)
    return str_data:separa(' ')
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

--Função que cria uma tabela de palavras sem as stop words
--AE:Recebe uma tabela de palavras não vazia
--AS:Retorna uma cópia da tabela, sem as stop words
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

--Função que recebe uma tabela de palavras e cria uma de palavras/frequências
--AE:A tabela recebida não pode ser nula
--AS:Retorna uma tabela que possui uma tupla relacionando uma palavra à sua correspondente frequência
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

--Função que recebe uma tabela de palavras/frequências e a ordena em relação à frequẽncia
--AE:Recebe uma tabela de palavras/frequências desordenada
--AS:Retorna uma tabela ordenada em relação à frequência
function sort(word_freq)
    table.sort(word_freq, function(a, b) return a.freq > b.freq end)
    return word_freq
end


--Função que recebe uma tabela de palavras/frequências ordenada e relação a frequência e a imprime na tela
--AE:A tabela é não vazia e ordenada
--AS:As palavras e suas respectivas frequências são impressas na tela
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