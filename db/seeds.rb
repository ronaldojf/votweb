no_photo = File.open(Rails.root.join('public', 'no-photo.png'))

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
    Party.create! party.merge({logo: no_photo})
  end
end

############## PARTIES - END #################


############## COUNCILLOR - BEGIN #################

[
  { name: 'Fernando Augusto Barp', avatar: '/uploads/councillors/3/councillor_c176e04ec4f7cd435186350f4ba3b233.jpg', party: 'PCdoB', voter_registration: '043824130973' },
  { name: 'Claudemir de Araújo', avatar: '/uploads/councillors/9/councillor_9d1fe9e64dd79e527c496f278b0251c4.jpg', party: 'PTB', voter_registration: '057995110477' },
  { name: 'Eni Maria Scandolara', avatar: '/uploads/councillors/10/councillor_4d8f1ea3a8070812d2461a2afae89076.jpg', party: 'PP', voter_registration: '15377220493' },
  { name: 'Ernani Mario Coelho Mello', avatar: '/uploads/councillors/11/councillor_efd28b9ea313563129f8e7d7c1fb756c.jpg', party: 'PDT', voter_registration: '025790700469' },
  { name: 'Jorge Valdair Psidonik', avatar: '/uploads/councillors/12/councillor_e9d873be7932ff9495a68945534331c1.jpg', party: 'PT', voter_registration: '059816150450' },
  { name: 'José da Cruz', avatar: '/uploads/councillors/13/councillor_853aa3b3d1f56b2c794ab4d62a3bd33a.jpg', party: 'PMDB', voter_registration: '025741870400' },
  { name: 'Leandro Augusto Basso', avatar: '/uploads/councillors/14/councillor_4ef64f65a6f12602848a434f1ba14965.jpg', party: 'PRB', voter_registration: '062722440418' },
  { name: 'Lucas Roberto Farina', avatar: '/uploads/councillors/15/councillor_85738567d9de732a3f937c674e093eae.jpg', party: 'PT', voter_registration: '082414870442' },
  { name: 'Luiz Deonísio Silva de Brito', avatar: '/uploads/councillors/16/councillor_9f5b8b4fb459a4c65c82b2afa638e737.jpg', party: 'PSD', voter_registration: '54468550485' },
  { name: 'Marcos Antônio Lando', avatar: '/uploads/councillors/17/councillor_2f32dd0e6996d0862e9e182ffa1327e7.jpg', party: 'PDT', voter_registration: '019551170477' },
  { name: 'Nadir Antônio Barbosa', avatar: '/uploads/councillors/18/councillor_1a66513c37574629ed3bb4c55da5f6ab.jpg', party: 'PMDB', voter_registration: '004197750450' },
  { name: 'Alderi Antônio Oldra', avatar: '/uploads/councillors/19/councillor_2fb078f1ea6acc6cfb0072197ae90c2f.jpg', party: 'PT', voter_registration: '004604330442' },
  { name: 'Sérgio Alves Bento', avatar: '/uploads/councillors/20/councillor_513445bfdcbdbbcf1c20f38af46ff8c0.jpg', party: 'PT', voter_registration: '031596040450' },
  { name: 'Silvio Ambrózio', avatar: '/uploads/councillors/21/councillor_2c9865a0ebe29efbc3bb2a08021ff57f.jpg', party: 'PT', voter_registration: '51382720450' },
  { name: 'Anacleto Zanella', avatar: '/uploads/councillors/22/councillor_a15fd219464cabd127b442ffbef131e1.jpg', party: 'PT', voter_registration: '32944040477' },
  { name: 'Vânia Isabel Smaniotto Miola', avatar: '/uploads/councillors/23/councillor_517ddd0816d56b2d2fea113270fb8917.jpg', party: 'PMDB', voter_registration: '025760750400' },
  { name: 'Edgar Paulo Marmentini', avatar: '/uploads/councillors/24/councillor_2dba627721ac3a33d45545322957d8e1.jpg', party: 'PMDB', voter_registration: '43242010442' }
].each do |councillor|
  unless Councillor.where(voter_registration: councillor[:voter_registration]).exists?
    puts "==> Criando vereador(a) #{councillor[:name]}"

    attributes = councillor.dup
    attributes[:party] = Party.find_by!(abbreviation: attributes[:party])
    attributes[:avatar] = open('http://www.camaraerechim.rs.gov.br' + attributes[:avatar]) rescue no_photo

    Councillor.create! attributes
  end
end

############## COUNCILLOR - END #################
