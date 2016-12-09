if Administrator.count.zero?
  puts '==> Criando administrador principal'
  Administrator.create! name: 'Administrador Principal', main: true, email: 'admin@votweb.com.br', password: 'votweb123'
end

unless Role.full_control.exists?
  puts '==> Criando função principal'
  Role.create!(description: 'Controle Total', full_control: true, administrators: Administrator.where(main: true))
end

############## PARTIES - BEGIN #################

[
  { abbreviation: 'PMDB', name: 'Partido do Movimento Democrático Brasileiro' },
  { abbreviation: 'PTB', name: 'Partido Trabalhista Brasileiro' },
  { abbreviation: 'PDT', name: 'Partido Democrático Trabalhista' },
  { abbreviation: 'PT', name: 'Partido dos Trabalhadores' },
  { abbreviation: 'DEM', name: 'Democratas' },
  { abbreviation: 'PCdoB', name: 'Partido Comunista do Brasil' },
  { abbreviation: 'PSB', name: 'Partido Socialista Brasileiro' },
  { abbreviation: 'PSDB', name: 'Partido da Social Democracia Brasileira' },
  { abbreviation: 'PTC', name: 'Partido Trabalhista Cristão' },
  { abbreviation: 'PSC', name: 'Partido Social Cristão' },
  { abbreviation: 'PMN', name: 'Partido da Mobilização Nacional' },
  { abbreviation: 'PRP', name: 'Partido Republicano Progressista' },
  { abbreviation: 'PPS', name: 'Partido Popular Socialista' },
  { abbreviation: 'PV', name: 'Partido Verde' },
  { abbreviation: 'PTdoB', name: 'Partido Trabalhista do Brasil' },
  { abbreviation: 'PP', name: 'Partido Progressista' },
  { abbreviation: 'PSTU', name: 'Partido Socialista dos Trabalhadores Unificado' },
  { abbreviation: 'PCB', name: 'Partido Comunista Brasileiro' },
  { abbreviation: 'PRTB', name: 'Partido Renovador Trabalhista Brasileiro' },
  { abbreviation: 'PHS', name: 'Partido Humanista da Solidariedade' },
  { abbreviation: 'PSDC', name: 'Partido Social Democrata Cristão' },
  { abbreviation: 'PCO', name: 'Partido da Causa Operária' },
  { abbreviation: 'PTN', name: 'Partido Trabalhista Nacional' },
  { abbreviation: 'PSL', name: 'Partido Social Liberal' },
  { abbreviation: 'PRB', name: 'Partido Republicano Brasileiro' },
  { abbreviation: 'PSOL', name: 'Partido Socialismo e Liberdade' },
  { abbreviation: 'PR', name: 'Partido da República' },
  { abbreviation: 'PSD', name: 'Partido Social Democrático' },
  { abbreviation: 'PPL', name: 'Partido Pátria Livre' },
  { abbreviation: 'PEN', name: 'Partido Ecológico Nacional' },
  { abbreviation: 'PROS', name: 'Partido Republicano da Ordem Social' },
  { abbreviation: 'SD', name: 'Solidariedade' },
  { abbreviation: 'NOVO', name: 'Partido Novo' },
  { abbreviation: 'REDE', name: 'Rede Sustentabilidade' },
  { abbreviation: 'PMB', name: 'Partido da Mulher Brasileira' }
].each do |party|
  unless Party.where(abbreviation: party[:abbreviation]).exists?
    puts "==> Criando partido #{party[:abbreviation]}"
    Party.create! party
  end
end

############## PARTIES - END #################


############## COUNCILLOR - BEGIN #################

[
  { name: 'Fernando Augusto Barp', party: 'PCdoB', is_active: false },
  { name: 'Claudemir de Araújo', party: 'PTB', is_active: true },
  { name: 'Eni Maria Scandolara', party: 'PP', is_active: true },
  { name: 'Ernani Mario Coelho Mello', party: 'PDT', is_active: false },
  { name: 'Jorge Valdair Psidonik', party: 'PT', is_active: false },
  { name: 'José da Cruz', party: 'PMDB', is_active: false },
  { name: 'Leandro Augusto Basso', party: 'PRB', is_active: true },
  { name: 'Lucas Roberto Farina', party: 'PT', is_active: true },
  { name: 'Luiz Deonísio Silva de Brito', party: 'PSD', is_active: false },
  { name: 'Marcos Antônio Lando', party: 'PDT', is_active: false },
  { name: 'Nadir Antônio Barbosa', party: 'PMDB', is_active: true },
  { name: 'Alderi Antônio Oldra', party: 'PT', is_active: true },
  { name: 'Sérgio Alves Bento', party: 'PT', is_active: false },
  { name: 'Silvio Ambrózio', party: 'PT', is_active: false },
  { name: 'Anacleto Zanella', party: 'PT', is_active: false },
  { name: 'Vânia Isabel Smaniotto Miola', party: 'PMDB', is_active: false },
  { name: 'Edgar Paulo Marmentini', party: 'PMDB', is_active: false },
  { name: 'Mário Rogério Rossi', party: 'PMDB', is_active: true },
  { name: 'Rafael Martins Ayub', party: 'PMDB', is_active: true },
  { name: 'Renan Augusto Soccol', party: 'PSDB', is_active: true },
  { name: 'André Luiz Jucoski', party: 'PDT', is_active: true },
  { name: 'Emerson Ricardo Schelski', party: 'PSDB', is_active: true },
  { name: 'Sérgio Alves Bento', party: 'PT', is_active: true },
  { name: 'Ilgue Antônio Rossetto', party: 'PV', is_active: true },
  { name: 'Alessandro Dal Zotto', party: 'PSB', is_active: true },
  { name: 'Flávio de Barcellos', party: 'PDT', is_active: true },
  { name: 'Gilson Roberto Serafin', party: 'PSD', is_active: true },
  { name: 'Sandra Regina Picoli Ostrovski', party: 'PC do B', is_active: true }
].each do |councillor|
  unless Councillor.where(name: councillor[:name]).exists?
    puts "==> Criando vereador(a) #{councillor[:name]}"

    attributes = councillor.dup
    names = councillor[:name].split(' ')
    attributes[:party] = Party.find_by!(abbreviation: attributes[:party])

    Councillor.create! attributes.merge({
      username: names[0] + names[-1],
      password: 'votweb123'
    })
  end
end

############## COUNCILLOR - END #################
