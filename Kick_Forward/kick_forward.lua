--Função que le um arquivo, passa para uma string
--AE:O arquivo deve ser válido e estar presente no mesmo diretório que kick_forward.lua
--AS:O arquivo é lido sem erros
function read_file(path_to_file, func)
    local f = assert(io.open(path_to_file, 'r'))
    local data = f:read('*all')
    f:close()
    func(data, normalize)
end

--Função que substitui todos os caracteres não alfa numéricos da string por um espaço em branco
--AE:A string não é vazia
--AS:Todos os caracteres não alfa numéricos foram retirados da string sem erros
function filter_chars(str_data, func)
    local symbols = "[^%w/_]+"
    func(str_data:gsub(symbols, ' '), scan)
end

--Função que separa a string em um array de palavras, usando como base um símbolo passado por paramêtro
--AE:O paramêtro deve ser um símbolo válido
--AS:Retorna um array com as palavras da string, cada uma em uma posição de índice
function string:separa(sym)
    local campos = {}
    local symbols = string.format("[^%s/_]+", sym)
    self:gsub(symbols, function(c) campos[#campos+1] = c end)
    return campos
end

--Função que busca palavras em uma string e retorna uma tabela com as palavras que foram encontradas
--AE:A string deve estar sem os caracteres alfanumericos
--AS:A tabela é criada sem erros
function scan(str_data, func)
    func(str_data:separa(' '), frequencies)
end


--Função que substitui todas as letras maiúsculas por sua referente minúscula
--AE:O paramêtro é a string que se quer formatar
--AS:Retorna a string no formato de letras minúsculas
function normalize(str_data, func)
    func(str_data:lower(), remove_stop_words)
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
--AE:Recebe uma tabela de palavras
--AS:Cria uma cópia da tabela, śem as stop words
function remove_stop_words(word_list, func)
    local stop = assert(io.open("stop_words.txt", 'r')):read('*all'):lower():separa(',')
    local copy = {}
    
    for _, word in pairs(word_list) do
        if isOnList(word, stop) == false then
            table.insert(copy, word)
        end
    end
    func(copy, sort)
end

--Função que recebe uma tabela de palavras/frequências e a ordena em relação à frequẽncia
--AE:Recebe uma tabela de palavras/frequências desordenada
--AS:A tabela agora é ordenada em relação À frequência
function sort(word_freq, func)
    table.sort(word_freq, function(a, b) return a.freq > b.freq end)
    func(word_freq, no_op)
end

--Função que recebe uma tabela de palavras e cria uma de palavras/frequências
--AE:A tabela recebida não pode ser nula
--AS:A tabela agora possui uma tupla relacionando uma palavra a sua correspondente frequência
function frequencies(word_list, func)
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
        local pair = {word = word, freq = freq}
        table.insert(frequencies_table, pair)
    end

    func(frequencies_table, print_text)
end

--Função que recebe uma tabela de palavras/frequências ordenada e relação a frequência e a imprime na tela
--AE:A tabela é não vazia e ordenada
--AS:As palavras e suas respectivas frequências são impressas na tela
function print_text(word_freqs, func)
    local i = 1
    
    for _, w in ipairs(word_freqs) do
        if i == 25 then
            break
        end
        print(w.word .. " - " .. w.freq)
        i = i + 1
    end
end

--[Função final]--
function no_op(func)
    return
end

--[Main]--
read_file(arg[1], filter_chars)
