--[Lê o arquivo e passa seu conteúdo para uma string, então chama a função normalize passando essa nova string]--
function read_file(path_to_file, func)
    local f = assert(io.open(arg[1], 'r'))
    local data = f:read('*all')
    f:close()
    func(data, normalize)
end

--[Recebe uma string e substitui todos seus caracters não alfanumericos por um espaço em branco, então chama a função scan passando a nova string sem esses caracteres]--
function filter_chars(str_data, func)
    local symbols = "[^%w/_]+"
    func(str_data:gsub(symbols, ' '), scan)
end

--[Separa a string em um array de palavras utilizando um símbolo como referência]--
function string:separa(sym)
    local campos = {}
    local symbols = string.format("[^%s/_]+", sym)
    self:gsub(symbols, function(c) campos[#campos+1] = c end)
    return campos
end

--[Busca por palavras na string e cria uma tabela com as palavras encontradas e chama a função frequencies passando a nova tabela]--
function scan(str_data, func)
    func(str_data:separa(' '), frequencies)
end


--[Transforma todos os caracteres de uma string em seus respectivos caracteres minúsculos, então chama a função remove_stop_words passando a nova string normalizada]--
function normalize(str_data, func)
    func(str_data:lower(), remove_stop_words)
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

--[Cria uma cópia da tabela sem as stop words e chama a função sort, passando a nova tabela]--
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

--[Recebe a tabela de palavras com suas frequências, ordena em relação à frequência e chama a função final no_op]--
function sort(word_freq, func)
    table.sort(word_freq, function(a, b) return a.freq > b.freq end)
    func(word_freq, no_op)
end

--[Cria uma tabela associando cada palavra à sua determinada frequência]--
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

--[Imprime a tabela final de palavras/frequências no console]--
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
