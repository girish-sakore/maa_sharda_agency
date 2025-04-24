if FinancialEntity.count <= 0 then
  puts 'Creating sample fianancial entity - '
  fe = FinancialEntity.create(name: 'bank1', code: 'ABCD')
  p 'name = ' + fe.name + ' code = ' + fe.code
end

