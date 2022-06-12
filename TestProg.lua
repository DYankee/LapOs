PasteId = "MqegTrzh"

A = {}

for i = 1, 400, 1 do
    A[i] = keys.getName(i)
end

for i = 1, 19, 1 do
    if A[i] ~= nil then
        print(i .. " = " .. A[i])
    end
end
