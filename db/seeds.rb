
UserBlock::Admin.create(name: "admin", email: "admin@ezallocations.com", password: "Admin@123", mobile_number: "1234567891", status:"active", verified: true) if UserBlock::Admin.count <= 0

puts 'Creating sample financial entities - '

# Create a sample financial entity if none exist
if FinancialEntity.count <= 0 then
  puts 'Creating sample fianancial entity - '
  fe = FinancialEntity.create(name: 'bank1', code: 'ABCD')
  p 'name = ' + fe.name + ' code = ' + fe.code
end

