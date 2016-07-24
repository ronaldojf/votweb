if Administrator.count.zero?
  puts '==> Criando administrador principal'
  Administrator.create! name: 'Administrador Principal', main: true, email: 'admin@votweb.com.br', password: 'votweb123'
end

unless Role.full_control.exists?
  puts '==> Criando função principal'
  Role.create!(description: 'Controle Total', full_control: true, administrators: Administrator.where(main: true))
end
